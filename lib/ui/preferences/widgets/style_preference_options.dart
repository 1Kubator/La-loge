import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:la_loge/models/style_preference.dart';
import 'package:la_loge/widgets/fill_box.dart';
import 'package:la_loge/widgets/image_from_net.dart';

class StylePreferenceOption extends StatefulWidget {
  final StylePreference preference;
  final Function(bool val) onChanged;

  const StylePreferenceOption({Key key, this.preference, this.onChanged})
      : super(key: key);

  @override
  _StylePreferenceOptionState createState() => _StylePreferenceOptionState();
}

class _StylePreferenceOptionState extends State<StylePreferenceOption> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Row(
            children: [
              FillBox(
                onChanged: (val) {
                  widget.onChanged(val);
                },
              ),
              Text(
                '${widget.preference.option}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: size.height / 4,
          child: Swiper(
            itemCount: widget.preference.images.length,
            viewportFraction: 0.42,
            scale: 0.8,
            itemBuilder: (context, index) {
              return ImageFromNet(
                imageUrl: widget.preference.images[index],
              );
            },
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
