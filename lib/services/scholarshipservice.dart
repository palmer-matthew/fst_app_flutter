import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:fst_app_flutter/models/scholarship.dart';
import 'package:fst_app_flutter/models/scholarshiplist.dart';

class ScholarshipService{

  static String api = "http://192.168.0.7:8000/scholarship/";
  static String url = "https://www.mona.uwi.edu/osf/scholarships-bursaries";

  static Future<List<Scholarship>> getAllScholarships() async {
    try {
      var response = await http.get(api);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return Future(() => ScholarshipList.fromJson(jsonResponse).scholarList);
      } else {
        throw Exception('Failed to Load List from Server');
      }
    } catch (e) {
      print(e);
      throw Exception();
    }
  }
}