import 'package:flutter/material.dart';
import 'package:la_loge/models/option.dart';
import 'package:la_loge/models/preference_question_type.dart';
import 'package:la_loge/models/size_preference.dart';
import 'package:la_loge/models/size_preference_response.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/widgets/dialog_box.dart';
import 'package:la_loge/widgets/error_box.dart';
import 'package:la_loge/widgets/loading_animation.dart';
import 'package:la_loge/widgets/progress_dialog.dart';
import 'package:la_loge/widgets/slider_with_indicator_box.dart';

class EditSizePreferences extends StatefulWidget {
  @override
  _EditSizePreferencesState createState() => _EditSizePreferencesState();
}

class _EditSizePreferencesState extends State<EditSizePreferences>
    with AutomaticKeepAliveClientMixin {
  final db = locator<DatabaseService>();
  final progressDialog = ProgressDialog();
  List<bool> isExpanded;
  List<dynamic> selectedItems;
  Stream<Map<SizePreference, dynamic>> stream;
  List<SizePreference> sortedPrefs;

  @override
  void initState() {
    super.initState();
    stream = db.getSizePreferencesQA();
    stream.first.then((value) {
      isExpanded = List.generate(value.keys.length, (index) => false);
      selectedItems = List.generate(value.keys.length, (index) => null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    super.build(context);
    return StreamBuilder<Map<SizePreference, SizePreferenceResponse>>(
        stream: stream,
        builder: (context, snap) {
          final preferences = snap.data;
          if (snap.hasError) return ErrorBox(error: snap.error);
          if (!snap.hasData) return LoadingAnimation();

          return ExpansionPanelList(
              elevation: 0,
              dividerColor: theme.accentColor,
              expansionCallback: (index, val) {
                isExpanded[index] = !val;
                setState(() {});
              },
              children: getExpansionPanelList(preferences));
        });
  }

  List<ExpansionPanel> getExpansionPanelList(
    Map<SizePreference, SizePreferenceResponse> preferences,
  ) {
    final theme = Theme.of(context);
    sortedPrefs = preferences.keys.toList()
      ..sort((a, b) => b.type.index.compareTo(a.type.index));

    return sortedPrefs.map((pref) {
      final sizePrefsResponse = preferences[pref];
      final answer = sizePrefsResponse.optionValue ??
          pref.options.firstWhere((element) {
            return element.docReference == sizePrefsResponse.optionsRef;
          }).option;

      final index = sortedPrefs.indexOf(pref);

      return ExpansionPanel(
        backgroundColor: theme.scaffoldBackgroundColor,
        isExpanded: isExpanded[index],
        headerBuilder: (_context, isOpen) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(pref.statement)),
                SizedBox(width: 8),
                Text('${selectedItems[index] ?? answer}'),
              ],
            ),
          );
        },
        body: pref.type == PreferenceQuestionType.SLIDER
            ? SliderWithIndicatorBox(
                min: pref.options.first.option.toDouble(),
                max: pref.options.last.option.toDouble(),
                currentVal:
                    selectedItems[index]?.toDouble() ?? answer.toDouble(),
                onChangedFinished: (val) {
                  _updatePrefs(sizePrefsResponse.id, index, value: val);
                },
              )
            : Column(
                children: pref.options.map((option) {
                  return InkWell(
                    onTap: () async {
                      if (option.option == answer) return;
                      _updatePrefs(sizePrefsResponse.id, index, option: option);
                    },
                    child: (option.option) == (selectedItems[index] ?? answer)
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
    }).toList();
  }

  _updatePrefs(
    String sizePrefsId,
    int index, {
    Option option,
    dynamic value,
  }) async {
    progressDialog.show(context);
    try {
      await db.updateSizePreference(
        sizePrefsId,
        value ?? option.docReference,
      );

      isExpanded[index] = false;
      selectedItems[index] = value ?? option.option;
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
