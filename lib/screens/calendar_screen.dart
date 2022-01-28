import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  WebViewController? _myController;

  bool _loadedPage = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        WebView(
          initialUrl: 'https://curlmanitoba.org/events/',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _myController = controller;
          },
          onPageFinished: (url) {
            print('Page finished loading: $url');

            _myController!.runJavascript(
                "document.getElementById('footer').style.display='none'; document.getElementsByClassName('masthead inline-header center widgets full-height full-width shadow-decoration shadow-mobile-header-decoration small-mobile-menu-icon dt-parent-menu-clickable show-sub-menu-on-hover show-device-logo show-mobile-logo masthead-mobile masthead-mobile-header')[0].style.display='none'; document.getElementsByClassName('mobile-header-space')[0].style.display='none'; document.getElementById('tribe-events').style.paddingTop = '0';");

            setState(() {
              _loadedPage = true;
            });
          },
        ),
        _loadedPage == false
            ? Center(
                child: CircularProgressIndicator(backgroundColor: Colors.green),
              )
            : Container(),
      ],
    );
  }
}