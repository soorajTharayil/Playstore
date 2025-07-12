import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/department_model.dart'; // adjust the path based on your folder structure
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getDomainFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('domain') ?? ''; // default to empty string if not set
}

Future<List<Department>> fetchDepartments(String patientId) async {
  final domain = await getDomainFromPrefs();

  final response = await http.get(Uri.parse(
    'https://$domain.efeedor.com/api/department.php?patientid=$patientId'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> wards = data['ward'] ?? [];
    return wards
        .where((item) => item['title'] != 'ALL')
        .map((json) => Department.fromJson(json))
        .toList();
  } else {
    throw Exception('Failed to load departments');
  }
}

