import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:ui' as ui;

class TwitterFeedScreen extends StatefulWidget {
  @override
  _TwitterFeedScreenState createState() => _TwitterFeedScreenState();
}

class _TwitterFeedScreenState extends State<TwitterFeedScreen> {
  String htmlData =
      '<!DOCTYPE html><html><body><a class="twitter-timeline" href="https://twitter.com/curlmanitoba?ref_src=twsrc%5Etfw">Tweets by curlmanitoba</a><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script></body></html>';
  @override
  Widget build(BuildContext context) {
    return Container(
        child: WebView(
      initialUrl: Uri.dataFromString(
              '<html><body><iframe src="https://twitter.com/curlmanitoba?ref_src=twsrc%5Etfw"></iframe></body></html>',
              mimeType: 'text/html')
          .toString(),
      javascriptMode: JavascriptMode.unrestricted,
    ));
  }
}
