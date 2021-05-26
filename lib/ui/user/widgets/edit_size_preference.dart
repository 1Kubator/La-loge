import 'package:flutter/material.dart';
import 'package:la_loge/models/size_preference.dart';
import 'package:la_loge/models/size_preference_response.dart';
import 'package:la_loge/service/collection_path.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/widgets/dialog_box.dart';
import 'package:la_loge/widgets/error_box.dart';
import 'package:la_loge/widgets/loading_animation.dart';
import 'package:la_loge/widgets/progress_dialog.dart';

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
            children: preferences.keys.map((pref) {
              final sizePrefsResponse = preferences[pref];
              final answer = sizePrefsResponse.optionValue ??
                  pref.options.firstWhere((element) {
                    return element.docReference == sizePrefsResponse.optionsRef;
                  }).option;

              final index = preferences.keys.toList().indexOf(pref);

              return ExpansionPanel(
                backgroundColor: theme.scaffoldBackgroundColor,
                isExpanded: isExpanded[index],
                headerBuilder: (_context, isOpen) => Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 32.0, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text(pref.statement)),
                      SizedBox(width: 8),
                      Text('${selectedItems[index] ?? answer}'),
                    ],
                  ),
                ),
                body: Column(
                  children: pref.options.map((option) {
                    return InkWell(
                      onTap: () async {
                        if (option.option == answer) return;
                        progressDialog.show(context);
                        try {
                          await db.updatePreference(
                            sizePrefsResponse.id,
                            CollectionPath.sizePreferences,
                            option.docReference,
                          );

                          isExpanded[index] = false;
                          selectedItems[index] = option.option;
                          setState(() {});
                        } catch (e) {
                          DialogBox.parseAndShowExceptionDialog(context, e);
                        } finally {
                          progressDialog.hide();
                        }
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
            }).toList(),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
