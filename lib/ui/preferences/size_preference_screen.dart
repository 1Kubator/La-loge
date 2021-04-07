import 'package:flutter/material.dart';
import 'package:la_loge/models/preference_question_type.dart';
import 'package:la_loge/models/size_preference.dart';
import 'package:la_loge/models/size_preference_response.dart';
import 'package:la_loge/resources/images.dart';
import 'package:la_loge/service/database_service.dart';
import 'package:la_loge/service_locator.dart';
import 'package:la_loge/ui/preferences/widgets/preference_question.dart';
import 'package:la_loge/widgets/app_title.dart';
import 'package:la_loge/widgets/error_box.dart';
import 'package:la_loge/widgets/loading_widget.dart';
import 'package:la_loge/widgets/submit_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SizePreferenceScreen extends StatefulWidget {
  static const id = 'size_preference_screen';

  @override
  _SizePreferenceScreenState createState() => _SizePreferenceScreenState();
}

class _SizePreferenceScreenState extends State<SizePreferenceScreen> {
  final DatabaseService db = locator<DatabaseService>();
  List<SizePreferenceResponse> userPreferences;

  Future<List<SizePreference>> future;

  @override
  void initState() {
    super.initState();
    future = db.getSizePreferenceQuestions();
    future.then((value) {
      userPreferences =
          List.generate(value.length, (index) => SizePreferenceResponse());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<SizePreference>>(
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
                  child: Image.asset(Images.sizePreferenceStep),
                ),
                SizedBox(height: 48),
                ListView.builder(
                    itemCount: snap.data.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return PreferenceQuestion(
                        preferenceQuestion: snap.data[index],
                        selectedVal: userPreferences[index].optionsRef,
                        onSliderDragCompleted: (val) {
                          userPreferences[index] = userPreferences[index]
                              .copyWith(
                                  statementRef: snap.data[index].docReference,
                                  optionValue: val);
                        },
                        onOptionChanged: (val) {
                          userPreferences[index] = userPreferences[index]
                              .copyWith(
                                  statementRef: snap.data[index].docReference,
                                  optionsRef: val);

                          if (snap.data[index].type !=
                              PreferenceQuestionType.SLIDER) setState(() {});
                        },
                      );
                    }),
                SubmitButton(
                  AppLocalizations.of(context).next,
                  onTap: () {},
                )
              ],
            );
          }),
    );
  }
}
