import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widgets/circular_progress_bar.dart';



class eEntryScreen extends StatefulWidget {
  @override
  State<eEntryScreen> createState() => _eEntryScreenState();
}

class _eEntryScreenState extends State<eEntryScreen> {
  WebViewController? _myController;

  bool _loadedPage = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        WebView(
          initialUrl: 'https://curlmanitoba.org/electronic-entry',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _myController = controller;
          },
          onPageFinished: (url) {
            print('Page finished loading: $url');

            _myController!.runJavascript(
                "document.getElementById('footer').style.display='none'; document.getElementsByClassName('masthead inline-header center widgets full-height full-width shadow-decoration shadow-mobile-header-decoration small-mobile-menu-icon dt-parent-menu-clickable show-sub-menu-on-hover show-device-logo show-mobile-logo masthead-mobile masthead-mobile-header')[0].style.display='none'; document.getElementsByClassName('mobile-header-space')[0].style.display='none'; document.getElementsByClassName('shortcode-banner-bg wf-table')[0].style.display='flex'; document.getElementsByClassName('page-title title-center solid-bg breadcrumbs-off breadcrumbs-mobile-off page-title-responsive-enabled')[0].style.display='none'; document.getElementsByClassName('masthead inline-header center widgets full-height full-width shadow-decoration shadow-mobile-header-decoration small-mobile-menu-icon dt-parent-menu-clickable show-sub-menu-on-hover show-device-logo show-mobile-logo masthead-mobile masthead-mobile-header')[0].style.display='none'; document.getElementsByClassName('mobile-header-space')[0].style.display='none'; document.getElementsByClassName('shortcode-banner-bg wf-table')[0].style.display='flex'; document.getElementsByClassName('sidebar-none sidebar-divider-vertical')[0].style.paddingTop ='15px';document.getElementsByClassName('shortcode-banner-inside wf-table text-big')[0].style.height ='auto';");

            setState(() {
              _loadedPage = true;
            });
          },
        ),
        _loadedPage == false
            ? CircularProgressBar()
            : Container(),
      ],
    );
  }
}