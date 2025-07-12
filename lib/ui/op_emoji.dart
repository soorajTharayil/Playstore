import 'package:flutter/material.dart';
import '../model/op_question_model.dart';
import '../model/op_feedback_data_model.dart';
import 'op_finalpage.dart';

class FeedbackScreen extends StatefulWidget {
  final List<QuestionSet> questionSets;
  final FeedbackData feedbackData;
  final String language;

  FeedbackScreen({
    required this.questionSets,
    required this.feedbackData,
    this.language = 'lang1',
  });

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  Map<String, int> feedbackValues = {};
  Map<String, Map<String, bool>> selectedReasons = {};
  Map<String, String> comments = {};

  void setFeedback(int value, String questionId) {
    setState(() {
      feedbackValues[questionId] = value;
      if (value == 1 || value == 2) {
        selectedReasons[questionId] = {};
        comments[questionId] = '';
      } else {
        selectedReasons.remove(questionId);
        comments.remove(questionId);
      }
    });
  }

  Widget buildEmojiWithLabel(
      String emoji, int value, String questionId, String label) {
    bool selected = feedbackValues[questionId] == value;

    return GestureDetector(
      onTap: () => setFeedback(value, questionId),
      child: Column(
        children: [
          AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: selected ? 1.0 : 0.4,
            child: AnimatedScale(
              scale: selected ? 1.2 : 1.0,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Text(emoji, style: TextStyle(fontSize: 28)),
            ),
          ),
          SizedBox(height: 4),
          Text(label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Feedback Form")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.questionSets.length,
              itemBuilder: (context, i) {
                final set = widget.questionSets[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 6.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              set.category,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...set.questions.map((q) {
                            final currentVal = feedbackValues[q.id];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),
                                Text(
                                  q.question,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildEmojiWithLabel('😡', 1, q.id, 'Worst'),
                                    buildEmojiWithLabel('🙁', 2, q.id, 'Poor'),
                                    buildEmojiWithLabel(
                                        '😐', 3, q.id, 'Average'),
                                    buildEmojiWithLabel('🙂', 4, q.id, 'Good'),
                                    buildEmojiWithLabel(
                                        '😁', 5, q.id, 'Excellent'),
                                  ],
                                ),
                                if (currentVal == 1 || currentVal == 2)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Tell us what went wrong:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                        ...q.negative.map((sub) {
                                          return CheckboxListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(sub.question),
                                            value: selectedReasons[q.id]
                                                    ?[sub.id] ??
                                                false,
                                            onChanged: (val) {
                                              setState(() {
                                                selectedReasons[q.id] ??= {};
                                                selectedReasons[q.id]![sub.id] =
                                                    val ?? false;
                                              });
                                            },
                                          );
                                        }),
                                        const SizedBox(height: 10),
                                        TextField(
                                          decoration: const InputDecoration(
                                            hintText: 'Optional Comment',
                                            border: OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8),
                                          ),
                                          onChanged: (val) {
                                            comments[q.id] = val;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                const Divider(height: 24),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label:
                      const Text('Back', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 16, 15, 15),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    widget.feedbackData.feedbackValues = feedbackValues;
                    widget.feedbackData.selectedReasons = selectedReasons;
                    widget.feedbackData.comments = comments;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => YourNextScreenFinal(
                          feedbackData: widget.feedbackData,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  label:
                      const Text('Next', style: TextStyle(color: Colors.white)),
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
