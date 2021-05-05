import 'package:cloud_firestore/cloud_firestore.dart';

enum AppointmentQuestionType { dropdown, textfield }

class AppointmentQuestionTypeHelper {
  static AppointmentQuestionType fromString(String type) {
    switch (type) {
      case 'dropdown':
        return AppointmentQuestionType.dropdown;
      case 'textfield':
        return AppointmentQuestionType.textfield;
      default:
        return null;
    }
  }

  static String getValue(AppointmentQuestionType type) {
    switch (type) {
      case AppointmentQuestionType.dropdown:
        return 'dropdown';
      case AppointmentQuestionType.textfield:
        return 'textfield';
      default:
        return null;
    }
  }
}

class AppointmentQuestion {
  final String statement;
  final AppointmentQuestionType type;
  final List<AppointmentQuestionOption> options;
  final String id;

  AppointmentQuestion({this.statement, this.type, this.options, this.id});

  factory AppointmentQuestion.fromMap(
          Map<String, dynamic> json, String id, List options) =>
      AppointmentQuestion(
        statement: json["statement"] == null ? null : json["statement"],
        type: json["type"] == null
            ? null
            : AppointmentQuestionTypeHelper.fromString(json["type"]),
        id: id,
        options: options,
      );

  Map<String, dynamic> toMap() => {
        "statement": statement == null ? null : statement,
        "options": options == null ? null : options,
        "type":
            type == null ? null : AppointmentQuestionTypeHelper.getValue(type),
        "id": id == null ? null : id,
      };

  static AppointmentQuestion fromDocuments(QueryDocumentSnapshot statementDocs,
      List<QueryDocumentSnapshot> optionDocs) {
    var options = optionDocs
        .map((e) => AppointmentQuestionOption.fromMap(e.data(), e.reference))
        .toList();
    return AppointmentQuestion.fromMap(
        statementDocs.data(), statementDocs.id, options);
  }
}

class AppointmentQuestionOption {
  AppointmentQuestionOption({
    this.option,
    this.documentReference,
  });

  final String option;
  final DocumentReference documentReference;

  AppointmentQuestionOption copyWith({
    String option,
    DocumentReference documentReference,
  }) =>
      AppointmentQuestionOption(
        option: option ?? this.option,
        documentReference: documentReference ?? this.documentReference,
      );

  factory AppointmentQuestionOption.fromMap(
          Map<String, dynamic> json, DocumentReference documentReference) =>
      AppointmentQuestionOption(
        option: json["option"] == null ? null : json["option"],
        documentReference: documentReference,
      );

  Map<String, dynamic> toMap() => {
        "option": option == null ? null : option,
        "document_reference":
            documentReference == null ? null : documentReference,
      };
}
