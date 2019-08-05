import 'package:flutter/material.dart';

import 'LoadingContainer.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemBuilder<T> extends StatelessWidget {
  final itemBuilder;
  final AsyncSnapshot snapshot;
  final bool reverse;
  ListItemBuilder({Key key, this.snapshot, this.itemBuilder, this.reverse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData && snapshot.connectionState == ConnectionState.active && snapshot.data != null) {

      List<T> items = snapshot.data;
      if (reverse != null && reverse) {
        items = items.reversed.toList();
      }
      if (items.isNotEmpty) {
        return _buildListItem(items);
      } else {
        return Container();
      }
    } else if (snapshot.hasError) {
        return Text("Something went wrong: ${snapshot.error}");
    }
    return LoadingContainer();
  }

  Widget _buildListItem(List<T> items) {
    return ListView.builder(
      itemCount: items.length,
      reverse: reverse ?? false,
      itemBuilder: (context, index) => itemBuilder(context, items[index]),
    );
  }
}
