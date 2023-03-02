import 'dart:math';

import 'package:flutter/cupertino.dart';

class SliverAppBarArrow with ChangeNotifier {

  double _opacity = 0;

  double get opacity => _opacity;

  void calculateOpacity(double offset, double maxExtent) {
    print(offset);
    // fading in
    if (offset <= (maxExtent * .6))
      _opacity = .5;
    else if (offset >= maxExtent)
      _opacity = 0;
    else
      _opacity =  ((maxExtent - offset) / (maxExtent * .4)/2);
    notifyListeners();
  }

}
