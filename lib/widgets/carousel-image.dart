import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarouselImage extends StatelessWidget {
  String name;
  String subtext;

  CarouselImage(this.name, this.subtext);

  @override
  Widget build(BuildContext context) {
    return (
     Stack(
       children: [
         for (int index = 1; index < 4; index++)
           buildInsetImage(
               'assets/images/carouselImages/' +
                   name.toLowerCase().replaceAll(' ', '-') +
                   '-carousel-image-' +
                   index.toString() +
                   '.jpg',
               index),
         Padding(
           padding: const EdgeInsets.only(bottom:14.0),
           child: Container(
               alignment: Alignment.bottomCenter,
               child: Column( mainAxisAlignment: MainAxisAlignment.end, children: [
                 Padding(
                   padding: const EdgeInsets.only(bottom:2.0),
                   child: Text(
                     name,
                     style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.secondary),
                   ),
                 ),
                 Text(subtext, style: TextStyle(color:Colors.white, fontSize:15))
               ])),
         )
       ],
     ))
    ;
  }

  buildInsetImage(String imagePath, int index) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
          alignment: index == 1
              ? Alignment.topLeft
              : index == 2
                  ? Alignment.topCenter
                  : Alignment.topRight,
          child: SizedBox(
            height: 105,
            width: 120,
            child: ClipRRect(
              
                child: Image.asset(
                  imagePath,fit: BoxFit.cover,
                ),
                
                borderRadius: BorderRadius.circular(5)),
          )),
    );
  }
}
