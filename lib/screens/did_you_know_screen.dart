import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DidYouKnowScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return WebView(initialUrl: 'https://curlmanitoba.org/news-2/did-you-know/',);
}}