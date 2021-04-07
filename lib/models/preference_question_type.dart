enum PreferenceQuestionType {
  CHECKBOX,
  MULTIPLE_CHOICE,
  SLIDER,
  IMAGE_BASED_SELECTION
}

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
      case PreferenceQuestionType.IMAGE_BASED_SELECTION:
        return "image_based_selection";
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
      case "image_based_selection":
        return PreferenceQuestionType.IMAGE_BASED_SELECTION;
        break;
      default:
        return null;
    }
  }
}
