import 'package:flutter/material.dart';
import '../services/department_service.dart';
import '../model/department_model.dart';
import 'op_emoji.dart';
import '../services/op_question_service.dart';
import '../model/op_feedback_data_model.dart';

class OpFeedbackPage extends StatefulWidget {
  const OpFeedbackPage({Key? key}) : super(key: key);

  @override
  State<OpFeedbackPage> createState() => _OpFeedbackPageState();
}

class _OpFeedbackPageState extends State<OpFeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController uhidController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  String? selectedDepartment;
  List<Department> departments = [];
  bool isLoadingDepartments = true;

  @override
  void initState() {
    super.initState();
    loadDepartments();
  }

  Future<void> loadDepartments() async {
    try {
      final fetchedDepartments = await fetchDepartments('123');
      setState(() {
        departments = fetchedDepartments;
        isLoadingDepartments = false;
      });
    } catch (e) {
      setState(() {
        isLoadingDepartments = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load departments')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Patient Details'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E4EAE),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildTextField(
                            label: 'Patient Name *',
                            controller: nameController,
                            hint: 'Enter patient name',
                            icon: Icons.person,
                            maxLength: 25,
                            validator: (val) => val == null || val.isEmpty
                                ? 'Name is required'
                                : null,
                          ),
                          buildTextField(
                            label: 'UHID *',
                            controller: uhidController,
                            hint: 'Enter UHID',
                            icon: Icons.badge,
                            maxLength: 20,
                            keyboardType: TextInputType.number,
                            validator: (val) => val == null || val.isEmpty
                                ? 'UHID is required'
                                : null,
                          ),
                          buildDropdown(),
                          const SizedBox(height: 20),
                          buildTextField(
                            label: 'Mobile Number *',
                            controller: mobileController,
                            hint: 'Enter mobile number',
                            icon: Icons.phone,
                            maxLength: 10,
                            keyboardType: TextInputType.phone,
                            validator: (val) => val == null || val.isEmpty
                                ? 'Mobile is required'
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Bottom fixed button bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final sets = await fetchQuestionSets(
                                '123', selectedDepartment!);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FeedbackScreen(
                                  questionSets: sets,
                                  feedbackData: FeedbackData(
                                    name: nameController.text,
                                    uhid: uhidController.text,
                                    department: selectedDepartment!,
                                    mobileNumber: mobileController.text,
                                  ),
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Failed to load questions')),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E4EAE),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: inputDecoration(hint).copyWith(prefixIcon: Icon(icon)),
          keyboardType: keyboardType,
          maxLength: maxLength,
          validator: validator,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Department *',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        isLoadingDepartments
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(child: CircularProgressIndicator()),
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  return DropdownButtonFormField<String>(
                    isExpanded: true, // ✅ This is key
                    value: selectedDepartment,
                    decoration: inputDecoration('Select Department')
                        .copyWith(prefixIcon: const Icon(Icons.local_hospital)),
                    items: departments
                        .map((dept) => DropdownMenuItem(
                              value: dept.title,
                              child: Text(
                                dept.title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDepartment = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a department' : null,
                  );
                },
              ),
        const SizedBox(height: 16),
      ],
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF1F3F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCBD1DC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1E4EAE), width: 1.8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
