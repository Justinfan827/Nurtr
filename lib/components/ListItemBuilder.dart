import 'package:flutter/material.dart';

import 'LoadingContainer.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemBuilder<T> extends StatelessWidget {
  final itemBuilder;
  final AsyncSnapshot snapshot;

  ListItemBuilder({Key key, this.snapshot, this.itemBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return _buildListItem(items);
      } else {
        return Container();
      }
    } else if (snapshot.hasError) {
      return Container(
        child: Text("Something went wrong"),
      );
    }
    return LoadingContainer();
  }

  Widget _buildListItem(List<T> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index]),
    );
  }
}
