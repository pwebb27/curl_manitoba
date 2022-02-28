import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeFeedScreen extends StatefulWidget {
  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

List<int> list = [1, 2, 3, 4, 5];
final List<String> imgList = [
  'assets/images/carousel-image-1.png',
  'assets/images/carousel-image-2.png',
  'assets/images/carousel-image-3.png',
  'assets/images/carousel-image-4.png'
];

List<Widget> itemss = imgList
    .map((item) => Container(
          child: Center(child: Image.asset(item)),
        ))
    .toList();

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Stack(alignment: Alignment.center, children: [
          CarouselSlider(
            items: itemss,
            options: CarouselOptions(
                height: 233,
                autoPlay: true,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
          Positioned(
            bottom: 6,
            child: Row(
              children: itemss.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                      
                      width: 9.0,
                      height: 9.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      
                      decoration:  _current != entry.key ?BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          
                         border:Border.all(width: 1, color: Colors.white),
                          
                  ):BoxDecoration(
                          borderRadius: BorderRadius.circular(100),color: Colors.white),
                ));
              }).toList(),
            ),
          )
        ])
      ]),
    );
  }
}
