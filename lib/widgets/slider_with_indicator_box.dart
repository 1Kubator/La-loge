import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class SliderWithIndicatorBox extends StatefulWidget {
  final double min;
  final double max;
  final Function(int val) onChanged;

  const SliderWithIndicatorBox({Key key, this.min, this.max, this.onChanged})
      : super(key: key);

  @override
  _SliderWithIndicatorBoxState createState() => _SliderWithIndicatorBoxState();
}

class _SliderWithIndicatorBoxState extends State<SliderWithIndicatorBox> {
  double currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.min;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSlider(
      values: [currentValue],
      min: widget.min,
      max: widget.max,
      tooltip: FlutterSliderTooltip(disabled: true),
      trackBar: FlutterSliderTrackBar(
        activeTrackBar: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 4,
            color: Colors.white,
          ),
        ),
        inactiveTrackBar: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1),
        ),
      ),
      onDragging: (int handlerIndex, lowerVal, upperVal) {
        if (currentValue == lowerVal) return;
        currentValue = lowerVal;
        widget.onChanged(currentValue.toInt());
        setState(() {});
      },
      handler: FlutterSliderHandler(
        child: Text(
          '${currentValue.toInt()}',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
