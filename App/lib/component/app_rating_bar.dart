import 'package:flutter/Material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

//レーティングのバー
class AppRatingBar extends StatelessWidget {
  const AppRatingBar({
    super.key,
    this.initialRating = 3.0,
    this.itemSize = 40.0,
    required this.onRatingUpdate,
  });

  final double initialRating;
  final double itemSize;
  final Function(double) onRatingUpdate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RatingBar(
        initialRating: initialRating,
        minRating: 1,
        maxRating: 5,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemSize: itemSize,
        glowColor: Colors.white,
        onRatingUpdate: onRatingUpdate,
        ratingWidget: RatingWidget(
          full: Container(
            width: 300,
            height: 300,
            margin: const EdgeInsets.only(top: 20, bottom: 12),
            child: SvgPicture.asset(
              'images/stars/all.svg',
              fit: BoxFit.contain,
            ),
          ),
          half: Container(
            width: 300,
            height: 300,
            margin: const EdgeInsets.only(top: 20, bottom: 12),
            child: SvgPicture.asset(
              'images/stars/half.svg',
              fit: BoxFit.contain,
            ),
          ),
          empty: Container(
            width: 300,
            height: 300,
            margin: const EdgeInsets.only(top: 20, bottom: 12),
            child: SvgPicture.asset(
              'images/stars/none.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
