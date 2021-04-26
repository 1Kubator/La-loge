import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:la_loge/models/gallery.dart';
import 'package:la_loge/resources/images.dart';
import 'package:la_loge/widgets/image_from_net.dart';
import 'package:tcard/tcard.dart';

enum SwipeIcon { LIKE, DISLIKE }

class GallerySwiper extends StatefulWidget {
  final List<Gallery> galleries;
  final Function(int index, SwipInfo swipInfo) onSwiped;

  GallerySwiper({Key key, this.galleries, this.onSwiped}) : super(key: key);

  @override
  _GallerySwiperState createState() => _GallerySwiperState();
}

class _GallerySwiperState extends State<GallerySwiper> {
  final swiperCtrl = SwiperController();

  final swipedIndexList = <int>[];

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemCount: widget.galleries.length,
      viewportFraction: 0.85,
      controller: swiperCtrl,
      loop: false,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final gallery = widget.galleries[index];
        return AbsorbPointer(
          absorbing: index == 0
              ? false
              : swipedIndexList.isNotEmpty && swipedIndexList.last + 1 == index
                  ? false
                  : true,
          child: TCard(
            lockYAxis: true,
            onForward: (i, swipeInfo) async {
              swipedIndexList.add(index);
              if (swipeInfo.direction == SwipDirection.Left)
                _showSwipedIcon(context, SwipeIcon.DISLIKE);
              else
                _showSwipedIcon(context, SwipeIcon.LIKE);

              widget.onSwiped(index, swipeInfo);
              if (widget.galleries.length == index + 1) {
                return;
              }
              await swiperCtrl.next();
            },
            cards: [
              ImageFromNet(imageUrl: gallery.imageUrl),
            ],
          ),
        );
      },
    );
  }

  _showSwipedIcon(BuildContext context, SwipeIcon swipeIcon) async {
    BuildContext outerContext;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          outerContext = context;
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: Image.asset(
              swipeIcon == SwipeIcon.DISLIKE ? Images.dislike : Images.like,
            ),
          );
        });
    await Future.delayed(Duration(seconds: 1));
    Navigator.pop(outerContext);
  }
}
