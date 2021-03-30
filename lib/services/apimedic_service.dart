import 'dart:convert';

import './daignosis_notifier.dart';
import 'package:codered/screens/indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiMedicService with ChangeNotifier {
  final String BEARER = 'Bearer Cw8r3_OUTLOOK_COM_AUT:Z7752hnnH+kJ+NGGLH/SAw==';
  static String TOKEN;
  final String authURI = 'https://authservice.priaid.ch/login';

  Future<void> auth() async {
    await http.post(Uri.parse(authURI),
        headers: {'Authorization': BEARER}).then((response) {
      if (response.statusCode == 200) {
        TOKEN = json.decode(response.body)['Token'];
        print(TOKEN);
        notifyListeners();
      }
    });
  }

  Future<void> getInfo(List<int> symptoms) async {
    uriUpdate(symptoms).then((value) async => await http
            .get(
          Uri.parse(value),
        )
            .then((response) {
          print(response.body);
          if (response.statusCode == 200) {
            DiagnosisResultNotifier()
                .onNewDiagnosis(json.decode(response.body));
            notifyListeners();
          }
        }));
  }

  Future<String> uriUpdate(List<int> symptoms) async {
    return 'https://healthservice.priaid.ch/diagnosis?token=$TOKEN&language=en-gb&gender=${user.gender}&year_of_birth=${2021-int.parse(user.age)}&symptoms=$symptoms';
  }
}
