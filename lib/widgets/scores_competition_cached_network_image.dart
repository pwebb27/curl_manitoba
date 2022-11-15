import 'package:cached_network_image/cached_network_image.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:flutter/material.dart';

class scoresCompetitionCachedNetworkImage extends StatelessWidget {
  const scoresCompetitionCachedNetworkImage({required this.competition, required this.height,});
  final double height;
  final scoresCompetition competition;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      maxHeightDiskCache: 60,
      cacheKey: competition.sponsorImageUrl,
      height: height,
      fadeInDuration: Duration(milliseconds: 150),
      imageUrl: competition.sponsorImageUrl!,
      placeholder: (_, __) => SizedBox.shrink(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
