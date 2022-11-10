import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokemon/core/model/favourite_model.dart';

class ReorderableFavouritesList extends StatefulWidget {
  ReorderableFavouritesList(this.favourites, this.functionForReorder);

  final List<Favourite>? favourites;
  final Function functionForReorder;

  @override
  State<ReorderableFavouritesList> createState() => _ReorderableFavouritesListState();
}

class _ReorderableFavouritesListState extends State<ReorderableFavouritesList> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color evenItemColor = colorScheme.secondary.withOpacity(0.15);
    final Color draggableItemColor = colorScheme.secondary;

    Widget proxyDecorator(
        Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double elevation = lerpDouble(0, 6, animValue)!;
          return Material(
            elevation: elevation,
            color: draggableItemColor,
            shadowColor: draggableItemColor,
            child: child,
          );
        },
        child: child,
      );
    }

    return ReorderableListView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      proxyDecorator: proxyDecorator,
      children: <Widget>[
        for (int index = 0; index < widget.favourites!.length; index += 1)
          ListTile(
            key: Key('$index'),
            tileColor: evenItemColor,
            title: Text('${widget.favourites?[index].name}'),
          ),
      ],
      onReorder: reorderList,// reorderList,
    );
  }

  void reorderList(int oldIndex, int newIndex) {
      setState(() {
        widget.functionForReorder(oldIndex, newIndex);
      });
  }
}