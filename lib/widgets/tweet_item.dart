import 'dart:ffi';
import '../models/tweet.dart';

import 'package:flutter/material.dart';

class TweetItem extends StatelessWidget {
  final Tweet tweet;

  TweetItem(this.tweet);
  

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(fontFamily: 'BeVietnamPro' ),
      child: InkWell(
        
          child: Card(

            elevation: 7,
              margin: EdgeInsets.only(bottom: 6, top: 6),
              child: Container(
                padding: const EdgeInsets.all(7),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 7),

                          child: 
                          Image.network(tweet.profilePicURL,
                            height: 45,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text(tweet.userName, style: TextStyle(fontWeight: FontWeight.bold)), Text(tweet.timePassed)],
                        )
                      ],
                    ),
                  ),
                  if (tweet.text != null) Text(tweet.text),
                  if(tweet.mediaURL != "")Image.network(tweet.mediaURL)
                ]),
              ))),
    );
  }
}
