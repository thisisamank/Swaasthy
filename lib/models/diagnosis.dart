import 'package:flutter/cupertino.dart';

class DiagnosisResult with ChangeNotifier{
  final List<Diagnosis> diagnosisResult;

  DiagnosisResult({this.diagnosisResult});

  factory DiagnosisResult.fromJSON(List<dynamic> parsedJson) {
    print(parsedJson);
    return DiagnosisResult(
        diagnosisResult: parsedJson.map((e) => Diagnosis.fromJSON(e)).toList());
  }
}

class Diagnosis {
  final double accuracy;
  final String name;
  final String specialist;
  final String alsoKnownAs;

  Diagnosis({this.accuracy, this.name, this.specialist, this.alsoKnownAs});

  factory Diagnosis.fromJSON(Map<dynamic, dynamic> parsedJson) {
    return Diagnosis(
      name: parsedJson['Issue']['Name'],
      accuracy: parsedJson["Issue"]['Accuracy'],
      alsoKnownAs: parsedJson['Issue']['ProfName'],
      specialist: parsedJson['Specialisation'][1]['Name'],
    );
  }
}
