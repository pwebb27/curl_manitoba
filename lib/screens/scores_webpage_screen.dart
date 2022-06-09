import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widgets/circular_progress_bar.dart';
import '../widgets/custom_app_bar.dart';

class ScoresWebpageScreen extends StatefulWidget {
  String? id;
  ScoresWebpageScreen(this.id);

  @override
  State<ScoresWebpageScreen> createState() => _ScoresWebpageScreenState(id as String);
}
class _ScoresWebpageScreenState extends State<ScoresWebpageScreen> {
  static const routeName = '/scores';

  WebViewController? _myController;

  bool _loadedPage = false;

  String id;
  _ScoresWebpageScreenState(this.id);


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: (id!=null)?CustomAppBar(
             context, 'Live Scores & Results'):null,
        body: Stack(
          children: <Widget>[
            WebView(
              initialUrl: (id==null)?'https://curlmanitoba.org/about-company/scoreboard/#!/':'https://curlmanitoba.org/about-company/scoreboard/#!/competitions/' +
                  id,
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
            ? CircularProgressBar()
            : Container(),
      ],
    ));
  }
}
