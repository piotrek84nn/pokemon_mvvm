import 'package:flutter/material.dart';
import 'package:pokemon/core/enum/view_state.dart';
import 'package:pokemon/core/vm/favourite/favourite_view_model.dart';
import 'package:pokemon/ui/base_widget.dart';
import 'package:pokemon/ui/favourite/reorderable_davourites_list.dart';
import 'package:pokemon/ui/helpers/ui_helpers.dart';
import 'package:provider/provider.dart';

class FavouriteView extends StatefulWidget {
  const FavouriteView({Key? key}) : super(key: key);

  @override
  _FavouriteViewState createState() => _FavouriteViewState();
}

class _FavouriteViewState extends State<FavouriteView> {

  @override
  Widget build(BuildContext context) {
    return BaseWidget<FavouriteViewModel>(
      viewModel: FavouriteViewModel(
        sqliteService: Provider.of(context),
      ),
      onViewModelReady: (vm) async {
        await vm.init();
      },
      builder: (context, vm, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Pokemon'),
          backgroundColor: Colors.blueAccent,
        ),
        body: WillPopScope(
          onWillPop: () async {
            return vm.backAction();
          },
          child: Column(
            children: <Widget>[
              vm.state == ViewState.busy
                  ? UIHelper.getCircularProgressIndicator()
                  : Expanded(
                    child: ReorderableFavouritesList(vm.favourites, vm.reorderList)
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
