import 'package:flutter/material.dart';
import 'package:la_loge/models/style_preference.dart';
import 'package:la_loge/models/style_preference_response.dart';
import 'package:la_loge/service/collection_path.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/widgets/dialog_box.dart';
import 'package:la_loge/widgets/error_box.dart';
import 'package:la_loge/widgets/loading_animation.dart';
import 'package:la_loge/widgets/progress_dialog.dart';

class EditStylePreferences extends StatefulWidget {
  @override
  _EditStylePreferencesState createState() => _EditStylePreferencesState();
}

class _EditStylePreferencesState extends State<EditStylePreferences>
    with AutomaticKeepAliveClientMixin {
  final db = locator<DatabaseService>();
  final progressDialog = ProgressDialog();
  bool isExpanded = false;
  Map<StylePreference, StylePreferenceResponse> data;
  Stream<Map<StylePreference, StylePreferenceResponse>> stream;

  @override
  void initState() {
    super.initState();
    stream = db.getStylePreferencesQA();
    stream.first.then((value) {
      data = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    super.build(context);
    return StreamBuilder<Map<StylePreference, StylePreferenceResponse>>(
        stream: stream,
        builder: (context, snap) {
          if (snap.hasError) return ErrorBox(error: snap.error);
          if (!snap.hasData) return LoadingAnimation();

          var stylePrefList = data.keys;

          return ExpansionPanelList(
            elevation: 0,
            dividerColor: theme.accentColor,
            expansionCallback: (index, val) {
              isExpanded = !val;
              setState(() {});
            },
            children: [
              ExpansionPanel(
                backgroundColor: theme.scaffoldBackgroundColor,
                isExpanded: isExpanded,
                headerBuilder: (_context, isOpen) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32.0,
                    horizontal: 12,
                  ),
                  child: Text(userSelectedOptions),
                ),
                body: Column(
                  children: stylePrefList.map((stylePref) {
                    return InkWell(
                      onTap: () async {
                        _updatePreference(stylePref);
                      },
                      child: data[stylePref] != null
                          ? Container(
                              width: double.infinity,
                              color: theme.accentColor,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  '${stylePref.option}',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              color: Color(0xFF555454),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text('${stylePref.option}'),
                              ),
                            ),
                    );
                  }).toList(),
                ),
              )
            ],
          );
        });
  }

  String get userSelectedOptions {
    var userSelectedDocs = data.keys.where((key) {
      return data[key] != null;
    }).toList();
    var options = userSelectedDocs.map((e) => e.option).join(', ');
    if (options.isEmpty) return '--------';
    return options;
  }

  _updatePreference(StylePreference stylePref) async {
    progressDialog.show(context);
    try {
      if (data[stylePref] == null) {
        var res = await db.addPreference(
          CollectionPath.stylePreferences,
          stylePref.docReference,
          stylePref.docReference,
        );
        data[stylePref] = res;
      } else {
        if (data.values.where((e) => e != null).length == 1) return;
        await db.deletePreference(
          data[stylePref].id,
          CollectionPath.stylePreferences,
        );
        data[stylePref] = null;
      }

      setState(() {});
    } catch (e) {
      DialogBox.parseAndShowExceptionDialog(context, e);
    } finally {
      progressDialog.hide();
    }
  }

  @override
  bool get wantKeepAlive => true;
}
