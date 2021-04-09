import 'package:la_loge/models/material_preference_response.dart';
import 'package:la_loge/models/size_preference_response.dart';
import 'package:la_loge/models/style_preference_response.dart';

class AllPreferences {
  final List<SizePreferenceResponse> sizePreferenceResponse;
  final List<StylePreferenceResponse> stylePreferenceResponse;
  final List<MaterialPreferenceResponse> materialPreferenceResponse;

  AllPreferences({
    this.materialPreferenceResponse,
    this.sizePreferenceResponse,
    this.stylePreferenceResponse,
  });

  AllPreferences copyWith({
    List<SizePreferenceResponse> sizePreferenceResponse,
    List<StylePreferenceResponse> stylePreferenceResponse,
    List<MaterialPreferenceResponse> materialPreferenceResponse,
  }) =>
      AllPreferences(
        sizePreferenceResponse:
            sizePreferenceResponse ?? this.sizePreferenceResponse,
        stylePreferenceResponse:
            stylePreferenceResponse ?? this.stylePreferenceResponse,
        materialPreferenceResponse:
            materialPreferenceResponse ?? this.materialPreferenceResponse,
      );
}
