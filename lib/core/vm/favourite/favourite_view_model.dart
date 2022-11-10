import 'dart:async';
import 'package:pokemon/core/enum/view_state.dart';
import 'package:pokemon/core/model/favourite_model.dart';
import 'package:pokemon/core/vm/base_model.dart';
import 'package:pokemon/services/sql_service.dart';

class FavouriteViewModel extends BaseViewModel {
  late SqliteService _sqliteService;

  late List<Favourite> _favourites = <Favourite>[];
  List<Favourite> get favourites => _favourites;
  set favourites(List<Favourite> list) {
    _favourites = list;
    notifyListeners();
  }

  FavouriteViewModel({
    required SqliteService sqliteService,
  }) {
    _sqliteService = sqliteService;
    setState(ViewState.init);
  }

  Future init() async {
    await _getFavouriteList();
  }

  Future _getFavouriteList() async {
    List<Favourite>? result = await _sqliteService.getItems();
    if(result != null) {
      result.sort((a, b) => a.position.compareTo(b.position));
      favourites = result;
    }
  }

  void reorderList(int oldIndex, int newIndex) {
        setBusy(true);
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final item = favourites.removeAt(oldIndex);
        item.position = newIndex;
        favourites.insert(newIndex, item);
        for(int i = 0; i< favourites.length; i++) {
          favourites[i].position = i;
          _sqliteService.addOrUpdateItem(favourites[i]);
        }
        setBusy(false);
  }

  @override
  Future<bool> backAction() async {
    return true;
  }
}
