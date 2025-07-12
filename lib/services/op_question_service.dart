import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/op_question_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getDomainFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('domain') ?? ''; // default to empty string if not set
}

Future<List<QuestionSet>> fetchQuestionSets(String patientId, String department) async {
    final domain = await getDomainFromPrefs();

  final response = await http.get(Uri.parse(
    'https://$domain.efeedor.com/api/department.php?patientid=$patientId',
  ));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final questionSets = data['question_set'] as List<dynamic>;
    return questionSets.map((json) => QuestionSet.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load questions');
  }
}
