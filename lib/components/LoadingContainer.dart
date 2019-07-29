import 'package:flutter/material.dart';

import '../constants.dart';

class LoadingContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CircularProgressIndicator(
          backgroundColor: mainGreen,
        ),
      ),
    );
  }
}
