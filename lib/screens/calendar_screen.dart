import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CalendarScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return WebView(initialUrl: 'https://curlmanitoba.org/events/',);
}}