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
          child: Container(
              margin: EdgeInsets.all(10),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: Image(
                          image: AssetImage(
                              'assets/images/Curl_Manitoba_Twitter_Logo.jpg'),
                          height: 45,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text('CurlManitoba'), Text(tweet.text)],
                      )
                    ],
                  ),
                ),
                if (tweet.text != null) Text(tweet.text),
                if(tweet.mediaUrl != null)Image.network(tweet.mediaUrl)
              ]))),
    );
  }
}
