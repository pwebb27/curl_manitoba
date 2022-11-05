import 'package:flutter/material.dart'; 
class MainColorPallette { 
  static const MaterialColor kToDark = const MaterialColor( 
    0xff6f1200, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch. 
    const <int, Color>{ 
      50: const Color(0xffb78980),//10% 
      100: const Color(0xffa97166),//20% 
      200: const Color(0xff9a594d),//30% 
      300: const Color(0xff8c4133),//40% 
      400: const Color(0xff7d2a1a),//50% 
      500: const Color(0xff6f1200),//60% 
      600: const Color(0xff641000),//70% 
      700: const Color(0xff590e00),//80% 
      800: const Color(0xff4e0d00),//90% 
      900: const Color(0xff430b00),//100% 
    }, 
  ); 
} 