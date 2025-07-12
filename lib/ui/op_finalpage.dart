// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/op_feedback_data_model.dart';
import 'op_thankyoupage.dart';

Future<String> getDomainFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('domain') ?? '';
}

class YourNextScreenFinal extends StatefulWidget {
  final FeedbackData feedbackData;

  const YourNextScreenFinal({Key? key, required this.feedbackData})
      : super(key: key);

  @override
  _YourNextScreenFinalState createState() => _YourNextScreenFinalState();
}

class _YourNextScreenFinalState extends State<YourNextScreenFinal> {
  int rating = 0;
  List<bool> selectedReasons = List.generate(8, (_) => false);
  TextEditingController suggestionController = TextEditingController();

  final List<String> generalReasons = [
    'Location/Proximity',
    'Specific services offered',
    'Referred by doctor',
    'Friend/Family recommendation',
    'Previous experience',
    'Insurance facilities',
    'Company recommendation',
    'Print/Online media',
  ];

  @override
  void dispose() {
    suggestionController.dispose();
    super.dispose();
  }

  Color getColor(int value) {
    if (value <= 6) return Colors.redAccent;
    if (value <= 8) return Colors.orangeAccent;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final feedbackData = widget.feedbackData;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Feedback')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SECTION 1: NPS RATING
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Net Promoter Score (NPS)',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'On a scale from 0–10, how likely are you to recommend this hospital to your friends or family?',
                            ),
                            const SizedBox(height: 16),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(11, (index) {
                                  bool isHighlighted = index <= rating;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          rating = index;
                                        });
                                      },
                                      child: Container(
                                        width: 21,
                                        height: 21,
                                        decoration: BoxDecoration(
                                          color: isHighlighted
                                              ? getColor(index)
                                              : Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: isHighlighted
                                              ? Border.all(
                                                  color: Colors.black, width: 2)
                                              : null,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '$index',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text('Selected Rating: $rating',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black54)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // SECTION 2: REASONS
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Reason for Choosing Our Hospital',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children:
                                  List.generate(generalReasons.length, (index) {
                                return FilterChip(
                                  label: Text(generalReasons[index]),
                                  selected: selectedReasons[index],
                                  onSelected: (bool value) {
                                    setState(() {
                                      selectedReasons[index] = value;
                                    });
                                  },
                                  selectedColor: Colors.blue.shade100,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // SECTION 3: COMMENT
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Suggestions or Concerns',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Please describe reasons for low rating or share suggestions for improvement:',
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: suggestionController,
                              decoration: const InputDecoration(
                                hintText: 'Enter your suggestions here',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label:
                      const Text('Back', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (rating < 0 || rating > 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "Please select a rating between 0 and 10")),
                      );
                      return;
                    }

                    final List<String> selectedGeneralReasons = [];
                    for (int i = 0; i < selectedReasons.length; i++) {
                      if (selectedReasons[i]) {
                        selectedGeneralReasons.add(generalReasons[i]);
                      }
                    }

                    final feedbackPayload = {
                      'recommend1Score': rating / 2,
                      'source': 'WLink',
                      'name': feedbackData.name,
                      'patientid': feedbackData.uhid,
                      'ward': feedbackData.department,
                      'contactnumber': feedbackData.mobileNumber,
                      'patientType': 'Out-Patient',
                      'consultant_cat': 'General',
                      'administratorId': 'admin001',
                      'wardid': 'ward001',
                      'reasons': selectedGeneralReasons.join(', '),
                      'suggestions': suggestionController.text,
                      'feedback': feedbackData.feedbackValues,
                      'reasonsPerQuestion': feedbackData.selectedReasons,
                      'comments': feedbackData.comments,
                    };

                    final uri = Uri.parse(
                      'https://dev.efeedor.com/api/saveoutpatientfeedback.php?patient_id=${feedbackData.uhid}&administratorId=admin001',
                    );

                    try {
                      final response = await http.post(
                        uri,
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode(feedbackPayload),
                      );

                      final responseData = jsonDecode(response.body);
                      if (responseData['status'] == 'success') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ThankYouScreen()),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Feedback Already Submitted"),
                            content: const Text(
                                "Feedback has already been submitted."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Network Error"),
                          content: const Text(
                              "Please check your internet connection."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text('Submit',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 30, 78, 174),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
