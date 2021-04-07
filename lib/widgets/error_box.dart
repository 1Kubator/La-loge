import 'package:flutter/material.dart';
import 'package:la_loge/error_handling/network_error.dart';

class ErrorBox extends StatelessWidget {
  final error;

  const ErrorBox({Key key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMsg = NetworkErrorMessage.getValue(context, error);
    return Text(errorMsg);
  }
}
