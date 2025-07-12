import 'package:flutter/material.dart';
import 'package:devkitflutter/ui/all_six_modules.dart'; // Adjust if needed
import 'package:fluttertoast/fluttertoast.dart';
import 'package:devkitflutter/ui/op_feedback_page.dart'; // Adjust if needed


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> modules = [
    {
      'title': 'IP Feedback',
      'icon': Icons.local_hospital,
      'color': Colors.blue,
      'page': const IpFeedbackPage(),
    },
    {
      'title': 'OP Feedback',
      'icon': Icons.people_alt,
      'color': Colors.green,
      'page': const OpFeedbackPage(),
    },
    {
      'title': 'PCF Feedback',
      'icon': Icons.feedback,
      'color': Colors.pinkAccent,
      'page': const PcfFeedbackPage(),
    },
    {
      'title': 'ISR Feedback',
      'icon': Icons.security,
      'color': Colors.orange,
      'page': const IsrFeedbackPage(),
    },
    {
      'title': 'Incident Report',
      'icon': Icons.report_problem,
      'color': Colors.purple,
      'page': const IncidentReportPage(),
    },
    {
      'title': 'Grievance Feedback',
      'icon': Icons.support_agent,
      'color': Colors.teal,
      'page': const GrievanceFeedbackPage(),
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Fluttertoast.showToast(msg: "Tapped: $index");
    // TODO: Navigate to respective bottom tab pages if needed
  }

  void _logout() {
    // Add logout logic here
    Fluttertoast.showToast(msg: "Logged out");
    // Example: Navigator.pushReplacement to LoginPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => module['page']),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: module['color'],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  Icon(module['icon'], size: 30, color: Colors.white),
                  const SizedBox(width: 16),
                  Text(
                    module['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
