import 'package:la_loge/models/size_preference_response.dart';
import 'package:la_loge/models/style_preference_response.dart';

class AllPreferences {
  final List<SizePreferenceResponse> sizePreferenceResponse;
  final List<StylePreferenceResponse> stylePreferenceResponse;

  AllPreferences({this.sizePreferenceResponse, this.stylePreferenceResponse});
}
