import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String title;
  final Function onTap;

  const SubmitButton(this.title, {Key key, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: RaisedButton(
          onPressed: onTap,
          child: Text(
            title,
          ),
        ),
      ),
    );
  }
}
