import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_loge/models/material_preference.dart';
import 'package:la_loge/widgets/fill_box.dart';

class MaterialPreferenceQuestion extends StatelessWidget {
  final MaterialPreference preferenceQuestion;
  final Function(DocumentReference) onOptionChanged;

  const MaterialPreferenceQuestion(
      {Key key, this.preferenceQuestion, this.onOptionChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FractionallySizedBox(
        widthFactor: 0.9,
        child: Column(
          children: [
            Text(
              '${preferenceQuestion.statement}',
              style: GoogleFonts.inter().copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: size.width / 8,
              runSpacing: 12,
              runAlignment: WrapAlignment.spaceBetween,
              children: preferenceQuestion.options.map(
                (options) {
                  return SizedBox(
                    width: size.width / 2.8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FillBox(
                          onChanged: (val) {
                            onOptionChanged(options.docReference);
                          },
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            '${options.option}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
            SizedBox(height: 40)
          ],
        ));
  }
}
