import 'package:flutter/material.dart';
import 'package:pokemon/core/enum/view_state.dart';
import 'package:pokemon/core/helpers/extension.dart';
import 'package:pokemon/core/model/pokemon_model.dart';
import 'package:pokemon/core/vm/home/home_view_model.dart';
import 'package:pokemon/ui/base_widget.dart';
import 'package:pokemon/ui/helpers/ui_helpers.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController patternCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseWidget<HomeViewModel>(
      viewModel: HomeViewModel(
        apiClient: Provider.of(context),
        sqliteService: Provider.of(context),
        navigationService: Provider.of(context),
      ),
      onViewModelReady: (vm) async {
        await vm.init();
      },
      builder: (context, vm, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Pokemon'),
          backgroundColor: Colors.blueAccent,
        ),
        floatingActionButton: FloatingActionButton.extended(
          foregroundColor: Colors.white,
          onPressed: () async {
            await vm.navigateToFavourites();
          },
          icon: const Icon(Icons.list),
          label: const Text('Favourites'),
        ),
        body: WillPopScope(
          onWillPop: () async {
            return vm.backAction();
          },
          child: Column(
            children: <Widget>[
              _getSearchInput(vm),
              vm.state == ViewState.busy
                  ? UIHelper.getCircularProgressIndicator()
                  : const SizedBox(),
              _getPokemonHeaderInfo(vm),
              _getPokemonDetailList(vm)
            ],
          ),
        ),
      ),
    );
  }

  Padding _getSearchInput(HomeViewModel vm) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: patternCtrl,
        decoration: InputDecoration(
            labelText: "Search",
            hintText: "Type pokemon name",
            suffixIcon: IconButton(
              onPressed: () async => {
                  FocusScope.of(context).unfocus(),
                  await vm.searchPokemonByName(patternCtrl.text)
              },
              icon: const Icon(Icons.search),
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _getPokemonHeaderInfo(HomeViewModel vm) {
    switch (vm.state) {
      case ViewState.idle:
        if (vm.pokemon == null) {
          return ListTile(
              contentPadding: const EdgeInsets.only(left: 24, right: 8),
              title: Text('Can\'t find pokemon ${patternCtrl.text} :('));
        } else {
          return _getDetailsInfo(vm, vm.pokemon);
        }
      default:
        return const SizedBox();
    }
  }

  Widget _getPokemonDetailList(HomeViewModel vm) {
    if(vm.state == ViewState.idle && vm.pokemon != null) {
      final Map<String, String>? pokemonList = vm.pokemon?.toDetailsList();
      final List<String>? pokemonListKeys = pokemonList?.keys.toList();
      final List<String>? pokemonListValues = pokemonList?.values.toList();

      return Expanded(
        child: ListView.builder(
          itemCount: pokemonList?.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(pokemonListKeys![index]), trailing:
            Text(pokemonListValues![index]),
            );
          },
        ),
      );
    }
    return const SizedBox();
  }

  Widget _getDetailsInfo(HomeViewModel vm, Pokemon? pokemon) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Center(child: _getImageSection(pokemon)),
          ),
          Flexible(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.only(left: 12, right: 16),
                      tileColor: Colors.blueAccent,
                      title: const Text('Name:',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      subtitle: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text(
                            pokemon!.name.toDashIfEmpty(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          )),
                      trailing: IconButton(
                        onPressed: () async {
                          await vm.addRemoveFromFavourite();
                          setState(() {});
                        },
                        icon: Icon(
                            pokemon.isFavourite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )),
        ]);
  }

  Container _getImageSection(Pokemon? pokemon) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blueAccent,
            width: 1,
          ),
        ),
        constraints:
            const BoxConstraints.tightForFinite(height: double.infinity),
        child: pokemon?.sprites.frontDefault != null
            ? Image.network(
                pokemon!.sprites.frontDefault,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          const AlwaysStoppedAnimation(Colors.blueAccent),
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              )
            : const SizedBox());
  }

  @override
  void dispose() {
    patternCtrl.dispose();
    super.dispose();
  }
}
