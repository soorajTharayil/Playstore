import 'package:flutter/material.dart';

class IpFeedbackPage extends StatelessWidget {
  const IpFeedbackPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IP Feedback')),
      body: const Center(child: Text('Welcome to IP Feedback')),
    );
  }
}


class PcfFeedbackPage extends StatelessWidget {
  const PcfFeedbackPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PCF Feedback')),
      body: const Center(child: Text('Welcome to PCF Feedback')),
    );
  }
}

class IsrFeedbackPage extends StatelessWidget {
  const IsrFeedbackPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ISR Feedback')),
      body: const Center(child: Text('Welcome to ISR Feedback')),
    );
  }
}

class IncidentReportPage extends StatelessWidget {
  const IncidentReportPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Incident Report')),
      body: const Center(child: Text('Welcome to Incident Report')),
    );
  }
}

class GrievanceFeedbackPage extends StatelessWidget {
  const GrievanceFeedbackPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grievance Feedback')),
      body: const Center(child: Text('Welcome to Grievance Feedback')),
    );
  }
}
