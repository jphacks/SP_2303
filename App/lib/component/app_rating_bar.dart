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
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(4),
            child: SvgPicture.asset(
              "images/stars/all.svg",
              height: 40,
              width: 40,
            ),
          ),
          half: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(4),
            child: SvgPicture.asset(
              "images/stars/half.svg",
              height: 40,
              width: 40,
            ),
          ),
          empty: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(4),
            child: SvgPicture.asset(
              "images/stars/none.svg",
              height: 40,
              width: 40,
            ),
          ),
          //
        ),
      ),
    );
  }
}
