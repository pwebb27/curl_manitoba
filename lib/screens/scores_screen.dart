import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ScoresScreen extends StatefulWidget {
  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen> {
  WebViewController? _myController;

  bool _loadedPage = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        WebView(
          initialUrl: 'https://curlmanitoba.org/about-company/scoreboard/#!/',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _myController = controller;
          },
          onPageFinished: (url) {
            print('Page finished loading: $url');

            _myController!.runJavascript(
                "document.getElementById('footer').style.display='none'; document.getElementsByClassName('masthead inline-header center widgets full-height full-width shadow-decoration shadow-mobile-header-decoration small-mobile-menu-icon dt-parent-menu-clickable show-sub-menu-on-hover show-device-logo show-mobile-logo masthead-mobile masthead-mobile-header')[0].style.display='none'; document.getElementsByClassName('mobile-header-space')[0].style.display='none'; document.getElementsByClassName('page-title title-center solid-bg breadcrumbs-off breadcrumbs-mobile-off page-title-responsive-enabled')[0].style.display='none'; document.getElementsByClassName('sidebar-none sidebar-divider-vertical')[0].style.paddingTop ='15px'; var buttons = document.getElementsByClassName('curlcast-index__button-tag-link curlcast-index__button-tag-link'); for (var i = 0;i<buttons.length;i++){ buttons[i].style.margin='12px 8px 8px'; } var competitions = document.getElementsByClassName('curlcast-index__competition-body'); for (var i = 0;i<competitions.length;i++){ competitions[i].style.padding='20px 20px'; }");

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
