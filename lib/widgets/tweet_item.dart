import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';

import '../models/tweet.dart';

import 'package:flutter/material.dart';

class TweetItem extends StatelessWidget {
  final Tweet tweet;

  TweetItem(this.tweet);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(fontFamily: 'NeuzeitOffice'),
      child: InkWell(
          child: Container(
        color: Colors.grey.shade400,
        child: Card(
            margin: EdgeInsets.only(bottom: 1.3),
            child: Container(
              padding:
                  const EdgeInsets.only(left: 7, right: 7, bottom: 16, top: 12),
              child: Column(children: [
                if (tweet.retweet)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomePro.retweet, size: 15, color: Colors.grey.shade700),
                      Text('   Curl Manitoba retweeted',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade700)),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 6),
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 7),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              tweet.profilePicURL,
                              height: 38,
                            ),
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tweet.userName,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(tweet.timePassed)
                        ],
                      )
                    ],
                  ),
                ),
                if (tweet.text != null) RichText(text:TextSpan(children: tweet.spans)),
                if (tweet.mediaURL != "")
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Image.network(tweet.mediaURL),
                  )
              ]),
            )),
      )),
    );
  }
}
