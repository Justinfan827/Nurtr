import 'package:flutter/material.dart';

import 'LoadingContainer.dart';


class StreamItemBuilder<T> extends StatelessWidget {
  final Widget Function(T data) itemBuilder;
  final AsyncSnapshot snapshot;

  StreamItemBuilder({Key key, this.snapshot, this.itemBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      return itemBuilder(snapshot.data);
    } else if (snapshot.hasError) {
      return Container(
        child: Text("Something went wrong"),
      );
    }
    return LoadingContainer();
  }
}
