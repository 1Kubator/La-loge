import 'package:flutter/material.dart';
import 'package:la_loge/error_handling/network_error.dart';

class DialogBox {
  static showSuccessDialog(context, msg) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Success'),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Ok'))
        ],
      ),
    );
  }

  static showErrorDialog(context, e) {
    final errorMsg = NetworkErrorMessage.getValue(context, e);
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error'),
        content: Text(errorMsg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Ok'))
        ],
      ),
    );
  }
}
