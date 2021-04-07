enum PreferenceQuestionType { CHECKBOX, MULTIPLE_CHOICE, SLIDER, IMAGE_CHOICE }

class PreferenceQuestionTypeHelper {
  static String getValue(PreferenceQuestionType role) {
    switch (role) {
      case PreferenceQuestionType.CHECKBOX:
        return "checkbox";
        break;
      case PreferenceQuestionType.MULTIPLE_CHOICE:
        return "multiple_choice";
        break;
      case PreferenceQuestionType.SLIDER:
        return "slider";
        break;
      case PreferenceQuestionType.IMAGE_CHOICE:
        return "image_choice";
        break;
      default:
        return null;
    }
  }

  static PreferenceQuestionType fromString(String role) {
    switch (role) {
      case "checkbox":
        return PreferenceQuestionType.CHECKBOX;
        break;
      case "multiple_choice":
        return PreferenceQuestionType.MULTIPLE_CHOICE;
        break;
      case "slider":
        return PreferenceQuestionType.SLIDER;
        break;
      case "image_choice":
        return PreferenceQuestionType.IMAGE_CHOICE;
        break;
      default:
        return null;
    }
  }
}
