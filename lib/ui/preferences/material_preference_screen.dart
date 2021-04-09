import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_loge/models/all_preferences.dart';
import 'package:la_loge/models/material_preference.dart';
import 'package:la_loge/models/material_preference_response.dart';
import 'package:la_loge/resources/images.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/ui/preferences/preferences_complete_screen.dart';
import 'package:la_loge/ui/preferences/widgets/material_preference_question.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:la_loge/widgets/error_box.dart';
import 'package:la_loge/widgets/loading_widget.dart';
import 'package:la_loge/widgets/submit_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MaterialPreferenceScreen extends StatefulWidget {
  static const id = 'material_preference_screen';

  final AllPreferences allPreferences;

  const MaterialPreferenceScreen({Key key, this.allPreferences})
      : super(key: key);

  @override
  _MaterialPreferenceScreenState createState() =>
      _MaterialPreferenceScreenState();
}

class _MaterialPreferenceScreenState extends State<MaterialPreferenceScreen> {
  final DatabaseService db = locator<DatabaseService>();
  List<MaterialPreferenceResponse> userPreferences;

  Future<List<MaterialPreference>> future;

  @override
  void initState() {
    super.initState();
    future = db.getMaterialPreferenceQuestions();
    future.then((value) {
      userPreferences =
          List.generate(value.length, (index) => MaterialPreferenceResponse());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<MaterialPreference>>(
          future: future,
          builder: (context, snap) {
            if (snap.hasError) return ErrorBox(error: snap.error);
            if (!snap.hasData) return LoadingWidget();

            return ListView(
              children: [
                Center(child: AppTitle()),
                SizedBox(height: 32),
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Image.asset(Images.materialPreferenceStep),
                ),
                SizedBox(height: 48),
                Center(
                  child: Text(
                    AppLocalizations.of(context).materialPreference,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: GoogleFonts.inter().fontFamily,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ListView.builder(
                    itemCount: snap.data.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return MaterialPreferenceQuestion(
                        preferenceQuestion: snap.data[index],
                        onOptionChanged: (val) {
                          bool alreadyAdded = userPreferences[index]
                                  .optionsRef
                                  ?.contains(val) ??
                              false;

                          if (alreadyAdded) {
                            removeOptionReference(index, val);

                            if (userPreferences[index].optionsRef.isEmpty)
                              disposeOptionReference(index);
                          } else {
                            if (userPreferences[index].optionsRef == null)
                              initializeOptionReference(index);

                            addPreference(
                              index,
                              val,
                              snap.data[index].docReference,
                            );
                          }
                        },
                      );
                    }),
                SubmitButton(
                  AppLocalizations.of(context).next,
                  onTap: () async {
                    if (!validate()) return;
                    final response = widget.allPreferences.copyWith(
                      materialPreferenceResponse: userPreferences,
                    );

                    await db.uploadPreferences(response);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      PreferencesCompleteScreen.id,
                      (route) => false,
                    );
                  },
                )
              ],
            );
          }),
    );
  }

  addPreference(
      int index, DocumentReference val, DocumentReference statementRef) {
    userPreferences[index] = userPreferences[index].copyWith(
      statementRef: statementRef,
    );
    userPreferences[index].optionsRef.add(val);
  }

  removeOptionReference(int index, DocumentReference val) {
    userPreferences[index].optionsRef.remove(val);
  }

  initializeOptionReference(int index) {
    userPreferences[index].optionsRef = [];
  }

  disposeOptionReference(int index) {
    userPreferences[index] = MaterialPreferenceResponse();
  }

  bool validate() {
    return !userPreferences.any((element) => element.optionsRef == null);
  }
}
