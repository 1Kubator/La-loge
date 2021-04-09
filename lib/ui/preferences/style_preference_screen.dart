import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_loge/models/all_preferences.dart';
import 'package:la_loge/models/style_preference.dart';
import 'package:la_loge/models/style_preference_response.dart';
import 'package:la_loge/resources/images.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/ui/preferences/material_preference_screen.dart';
import 'package:la_loge/ui/preferences/widgets/style_preference_options.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:la_loge/widgets/error_box.dart';
import 'package:la_loge/widgets/loading_widget.dart';
import 'package:la_loge/widgets/submit_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StylePreferenceScreen extends StatefulWidget {
  static const id = 'style_preference_screen';
  final AllPreferences allPreferences;

  const StylePreferenceScreen({Key key, this.allPreferences}) : super(key: key);

  @override
  _StylePreferenceScreenState createState() => _StylePreferenceScreenState();
}

class _StylePreferenceScreenState extends State<StylePreferenceScreen> {
  final DatabaseService db = locator<DatabaseService>();
  List<StylePreferenceResponse> userPreferences;

  Future<List<StylePreference>> future;

  @override
  void initState() {
    super.initState();
    future = db.getStylePreferenceQuestions();
    future.then((value) {
      userPreferences =
          List.generate(value.length, (index) => StylePreferenceResponse());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<StylePreference>>(
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
                  child: Image.asset(Images.stylePreferenceStep),
                ),
                SizedBox(height: 48),
                Center(
                  child: Text(
                    AppLocalizations.of(context).style,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: GoogleFonts.inter().fontFamily,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ListView.builder(
                    itemCount: snap.data.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final preference = snap.data[index];
                      return StylePreferenceOption(
                        preference: preference,
                        onChanged: (val) {
                          if (val == true)
                            userPreferences[index] =
                                userPreferences[index].copyWith(
                              optionsRef: preference.docReference,
                              statementRef: preference.docReference,
                            );
                          else
                            userPreferences[index] = StylePreferenceResponse();
                        },
                      );
                    }),
                SubmitButton(
                  AppLocalizations.of(context).next,
                  onTap: () {
                    if (!validate()) return;
                    userPreferences = normalizeUserResponse(userPreferences);
                    final allPreferences = widget.allPreferences.copyWith(
                      stylePreferenceResponse: userPreferences,
                    );

                    Navigator.pushNamed(
                      context,
                      MaterialPreferenceScreen.id,
                      arguments: allPreferences,
                    );
                  },
                )
              ],
            );
          }),
    );
  }

  List<StylePreferenceResponse> normalizeUserResponse(
      List<StylePreferenceResponse> list) {
    list.removeWhere((element) => element.statementRef == null);
    return list;
  }

  bool validate() {
    return userPreferences.any((element) => element.statementRef != null);
  }
}
