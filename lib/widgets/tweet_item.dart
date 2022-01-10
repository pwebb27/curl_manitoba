import 'dart:ffi';

import 'package:flutter/material.dart';

class TweetItem extends StatelessWidget {
  final dynamic text;
  final dynamic creationTime;
  final dynamic mediaUrl;

  TweetItem(
      {required this.text, required this.creationTime, required this.mediaUrl});

  @override
  Widget build(BuildContext context) {
    print(mediaUrl);

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
                        children: [Text('CurlManitoba'), Text(creationTime)],
                      )
                    ],
                  ),
                ),
                if (text != null) Text(text),
                if(mediaUrl != null)Image.network(mediaUrl)
              ]))),
    );
  }
}
