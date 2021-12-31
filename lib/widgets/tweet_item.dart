import 'dart:ffi';

import 'package:flutter/material.dart';

class TweetItem extends StatelessWidget {
  final String id;
  final String creationTime;
  final List<String> attachments;


  TweetItem({required this.id, required this.creationTime, required this.attachments});


  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      margin: EdgeInsets.all(10),
      child: Column(children: [Text(id)],)
    ));
  }
}
