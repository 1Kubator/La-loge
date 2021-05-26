import 'package:flutter/material.dart';
import 'package:la_loge/models/material_preference.dart';
import 'package:la_loge/models/material_preference_response.dart';
import 'package:la_loge/models/option.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/widgets/dialog_box.dart';
import 'package:la_loge/widgets/error_box.dart';
import 'package:la_loge/widgets/loading_animation.dart';
import 'package:la_loge/widgets/progress_dialog.dart';

class EditMaterialPreferences extends StatefulWidget {
  @override
  _EditMaterialPreferencesState createState() =>
      _EditMaterialPreferencesState();
}

class _EditMaterialPreferencesState extends State<EditMaterialPreferences>
    with AutomaticKeepAliveClientMixin {
  final db = locator<DatabaseService>();
  final progressDialog = ProgressDialog();

  Map<MaterialPreference, MaterialPreferenceResponse> data;
  Stream<Map<MaterialPreference, MaterialPreferenceResponse>> stream;
  List<bool> isExpanded;

  @override
  void initState() {
    super.initState();
    stream = db.getMaterialPreferencesQA();
    stream.first.then((value) {
      isExpanded = List.generate(value.keys.length, (index) => false);
      data = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    super.build(context);
    return StreamBuilder<Map<MaterialPreference, MaterialPreferenceResponse>>(
        stream: stream,
        builder: (context, snap) {
          if (snap.hasError) return ErrorBox(error: snap.error);
          if (!snap.hasData) return LoadingAnimation();

          return ExpansionPanelList(
            elevation: 0,
            dividerColor: theme.accentColor,
            expansionCallback: (index, val) {
              isExpanded[index] = !val;
              setState(() {});
            },
            children: data.keys.map((pref) {
              final materialPrefResponse = data[pref];
              final options = pref.options
                  .where((element) {
                    return materialPrefResponse.optionsRef
                        .contains(element.docReference);
                  })
                  .map((e) => e.option)
                  .toList();

              final index = data.keys.toList().indexOf(pref);

              return ExpansionPanel(
                backgroundColor: theme.scaffoldBackgroundColor,
                isExpanded: isExpanded[index],
                headerBuilder: (_context, isOpen) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32.0,
                    horizontal: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 2, child: Text(pref.statement)),
                      SizedBox(width: 8),
                      Flexible(child: Text(options.join(', '))),
                    ],
                  ),
                ),
                body: Column(
                  children: pref.options.map((option) {
                    return InkWell(
                      onTap: () async {
                        _updatePreference(pref, option);
                      },
                      child: options.contains(option.option)
                          ? Container(
                              width: double.infinity,
                              color: theme.accentColor,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  '${option.option}',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              color: Color(0xFF555454),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text('${option.option}'),
                              ),
                            ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          );
        });
  }

  _updatePreference(MaterialPreference pref, Option option) async {
    progressDialog.show(context);
    try {
      if (data[pref].optionsRef.contains(option.docReference)) {
        if (data[pref].optionsRef.length == 1) return;
        await db.deleteMaterialPreference(data[pref].id, option.docReference);
        data[pref].optionsRef.remove(option.docReference);
      } else {
        await db.addMaterialPreference(
          data[pref].id,
          option.docReference,
        );
        data[pref].optionsRef.add(option.docReference);
      }
      progressDialog.hide();
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
