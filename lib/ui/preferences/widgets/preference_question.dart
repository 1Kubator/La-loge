import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_loge/models/preference_question_type.dart';
import 'package:la_loge/models/size_preference.dart';
import 'package:la_loge/widgets/slider_with_indicator_box.dart';

class PreferenceQuestion extends StatelessWidget {
  final SizePreference preferenceQuestion;
  final Function(DocumentReference val) onOptionChanged;
  final Function(int val) onSliderDragCompleted;
  final selectedVal;

  const PreferenceQuestion(
      {Key key,
      this.preferenceQuestion,
      this.onOptionChanged,
      this.selectedVal,
      this.onSliderDragCompleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            '${preferenceQuestion.statement}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: GoogleFonts.inter().fontFamily,
            ),
          ),
        ),
        SizedBox(height: 20),
        if (preferenceQuestion.type == PreferenceQuestionType.SLIDER)
          FractionallySizedBox(
            widthFactor: 0.8,
            child: SliderWithIndicatorBox(
              min: preferenceQuestion.options.first.option.toDouble(),
              max: preferenceQuestion.options.last.option.toDouble(),
              onChanged: (int val) {
                onSliderDragCompleted(val);
              },
            ),
          )
        else if (preferenceQuestion.type ==
            PreferenceQuestionType.MULTIPLE_CHOICE) ...[
          FractionallySizedBox(
            widthFactor: 1,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: preferenceQuestion.options
                  .map(
                    (option) => InkWell(
                      onTap: () {
                        onOptionChanged(option.docReference);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedVal == option.docReference
                              ? Colors.white
                              : null,
                          border: Border.all(color: Colors.white),
                        ),
                        child: Center(
                          child: Text(
                            '${option.option}',
                            style: selectedVal == option.docReference
                                ? TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: 40)
        ]
      ],
    );
  }
}
