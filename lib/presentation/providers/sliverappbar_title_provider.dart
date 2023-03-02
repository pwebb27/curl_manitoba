import 'package:flutter/cupertino.dart';

class SliverAppBarTitle with ChangeNotifier {
  SliverAppBarTitle();

  double _opacity = 0;

  double get opacity => _opacity;

  void calculateOpacity(double offset, double maxExtent) {
    // fading in
    if (offset <= (maxExtent * .9))
      _opacity = 0;
    else if (offset >= maxExtent)
      _opacity = 1;
    else
      _opacity =  (1 - (maxExtent - offset) / (maxExtent * .1));
    notifyListeners();
  }

}
