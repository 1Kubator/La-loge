import 'package:flutter/material.dart';

class FillBox extends StatefulWidget {
  final Function(bool) onChanged;

  const FillBox({Key key, this.onChanged}) : super(key: key);

  @override
  _FillBoxState createState() => _FillBoxState();
}

class _FillBoxState extends State<FillBox> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        isSelected = !isSelected;
        setState(() {});
        widget.onChanged(isSelected);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 18,
          width: 18,
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Container(
            color: isSelected ? Colors.white : null,
          ),
        ),
      ),
    );
  }
}
