import 'package:flutter/material.dart';
import 'package:devkitflutter/ui/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DomainLoginPage extends StatefulWidget {
  const DomainLoginPage({Key? key}) : super(key: key);

  @override
  _DomainLoginPageState createState() => _DomainLoginPageState();
}

class _DomainLoginPageState extends State<DomainLoginPage> {
  final TextEditingController domainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 26, 141, 42), // Deep Blue background
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40),
            // Logo + Title
            Column(
              children: [
                Image.asset(
                  'assets/images/efeedor_square_logo.png',
                  width: 40, // set your desired width
                  height: 40, // set your desired height
                  fit: BoxFit
                      .contain, // make sure it fits nicely without distortion
                ),
                SizedBox(height: 10),
                Text(
                  'Efeedor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            // White Card
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter your domain name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: domainController,
                            decoration: InputDecoration(
                              hintText: 'eg : kademo',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                '.efeedor.com',
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            String domain = domainController.text.trim();
                            if (domain.isNotEmpty) {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString('domain',
                                  domain); // store domain like 'kademo'

                              // print('Domain entered: $domain.efeedor.com');

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignIn()),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1A4D8F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child:
                              Text('Proceed', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                contentPadding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                content: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Image.asset(
                                    'assets/images/domain_help.png', // <-- Your image path
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          'What is my domain name?',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Handle custom domain login
                        },
                        child: Text(
                          '',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
