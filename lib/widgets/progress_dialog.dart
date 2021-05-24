import 'package:flutter/material.dart';

class ProgressDialog {
  OverlayEntry _progressOverlay;

  void show(BuildContext context) {
    _progressOverlay = _showProgress(context);
    Overlay.of(context).insert(_progressOverlay);
  }

  void hide() {
    if (_progressOverlay != null) {
      _progressOverlay.remove();
      _progressOverlay = null;
    }
  }

  OverlayEntry _showProgress(BuildContext context) => OverlayEntry(
        builder: (BuildContext context) => Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColorLight.withOpacity(0.5),
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColorDark,
              ),
              backgroundColor: Theme.of(context).primaryColorLight,
            ),
          ],
        ),
      );
}
