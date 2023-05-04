import 'package:curl_manitoba/data/repositories/word_press_repository.dart';
import 'package:curl_manitoba/domain/useCases/wordpress_repository_use_cases.dart';
import 'package:curl_manitoba/presentation/widgets/circular_progress_bar.dart';
import 'package:curl_manitoba/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class GridViewContentScreen extends StatefulWidget {
  final String pageTitle;

  GridViewContentScreen(this.pageTitle);

  @override
  State<GridViewContentScreen> createState() => _GridViewContentScreenState();
}

class _GridViewContentScreenState extends State<GridViewContentScreen> {
  String? pageContent;
  late final String pageTitle;

  @override
  void initState() {
    super.initState();
    pageTitle = widget.pageTitle;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: CustomAppBar(
        context,
        pageTitle,
      ),
      body: FutureBuilder(
          future: GetPageContent(WordPressRepositoryImp())('1996'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return SliverFillRemaining(
                  child: Center(child: CircularProgressBar()));
            return Text(snapshot.data as String);
          }));
}
