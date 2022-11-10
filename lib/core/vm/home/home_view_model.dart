import 'dart:async';
import 'package:pokemon/core/enum/view_state.dart';
import 'package:pokemon/core/helpers/extension.dart';
import 'package:pokemon/core/model/favourite_model.dart';
import 'package:pokemon/core/model/pokemon_model.dart';
import 'package:pokemon/core/vm/base_model.dart';
import 'package:pokemon/services/api.dart';
import 'package:pokemon/services/navigation_service.dart';
import 'package:pokemon/services/sql_service.dart';
import 'package:pokemon/ui/router.dart';

class HomeViewModel extends BaseViewModel {
  late Api _api;
  late SqliteService _sqliteService;
  late List<Favourite?>? _favourites;
  late NavigationService? _navigationService;

  Pokemon? _pokemon;
  Pokemon? get pokemon => _pokemon;
  set pokemon(Pokemon? list) {
    _pokemon = list;
    notifyListeners();
  }

  HomeViewModel({
    required Api apiClient,
    required SqliteService sqliteService,
    required NavigationService navigationService,
  }) {
    _sqliteService = sqliteService;
    _api = apiClient;
    _navigationService = navigationService;
    setState(ViewState.init);
  }

  Future init() async {
    await _getFavouriteList();
  }

  Future _getFavouriteList() async {
    _favourites = await _sqliteService.getItems();
  }

  Future<void> addRemoveFromFavourite() async {
    if(pokemon == null) return;
    pokemon!.isFavourite = !pokemon!.isFavourite;
    if(pokemon!.isFavourite) {
      await _sqliteService.addOrUpdateItem(Favourite(
          imgUrl: pokemon!.sprites.frontDefault, position: double.maxFinite.toInt(),
          name: pokemon!.name, id: pokemon!.id));
    } else {
      await _sqliteService.deleteItem(pokemon!.id);
    }
  }

  Future searchPokemonByName(String text) async {
    if (text.isNullOrEmpty()) {
      return;
    }
    setBusy(true);
    pokemon = await _api.searchPokemonByName(text);
    if(pokemon != null) {
      bool isFav = _favourites!.any((element) => element!.id == pokemon!.id);
      pokemon!.isFavourite = isFav;
    }
    setBusy(false);
  }

  @override
  Future<bool> backAction() async {
    return false;
  }

  Future<void> navigateToFavourites() async{
    await _navigationService?.navigateTo(RoutePaths.favourite);
  }
}
