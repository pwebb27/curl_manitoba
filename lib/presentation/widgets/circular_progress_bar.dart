import 'package:flutter/material.dart';

class CircularProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      );
}
