import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:universal_io/io.dart';
import 'package:http/http.dart' as http;
import 'package:devkitflutter/config/constant.dart'; // adjust this import path
import 'package:devkitflutter/ui/home_module_button.dart';


class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;

  final Color _gradientTop = const Color(0xFF039be6);
  final Color _gradientBottom = const Color(0xFF0299e2);
  final Color _mainColor = const Color(0xFF0181cc);
  final Color _underlineColor = const Color(0xFFCCCCCC);

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      _iconVisible =
          _obscureText ? Icons.visibility_off : Icons.visibility;
    });
  }

  Future<void> _loginUser() async {
  try {
  final loginUrl = await getLoginEndpoint(); // await the Future<String>
  
  final response = await http.post(
    Uri.parse(loginUrl), // pass the actual String URL, not the function
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "userid": _emailController.text,
      "password": _passwordController.text,
    }),
  );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        Fluttertoast.showToast(msg: "Login successful");

        // TODO: Navigate to DashboardPage
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
      } else {
        Fluttertoast.showToast(msg: responseData['message'] ?? "Invalid credentials");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Platform.isIOS
              ? SystemUiOverlayStyle.light
              : const SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.light),
          child: Stack(
            children: <Widget>[
              // Top gradient background
              Container(
                height: MediaQuery.of(context).size.height / 3.5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [_gradientTop, _gradientBottom],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
              ),

              // Logo
              Container(
                margin: EdgeInsets.fromLTRB(
                    0, MediaQuery.of(context).size.height / 20, 0, 0),
                alignment: Alignment.topCenter,
                child: Image.asset('assets/images/efeedor_square_logo.png',
                    height: 60),
              ),

              // Login card
              ListView(
                children: <Widget>[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.fromLTRB(32,
                        MediaQuery.of(context).size.height / 3.5 - 72, 32, 0),
                    color: Colors.white,
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 40),
                            Center(
                              child: Text(
                                'SIGN IN',
                                style: TextStyle(
                                    color: _mainColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey[600]!)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: _underlineColor),
                                  ),
                                  labelText: 'Email',
                                  labelStyle:
                                      TextStyle(color: Colors.grey[700])),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[600]!)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: _underlineColor),
                                ),
                                labelText: 'Password',
                                labelStyle:
                                    TextStyle(color: Colors.grey[700]),
                                suffixIcon: IconButton(
                                    icon: Icon(_iconVisible,
                                        color: Colors.grey[700], size: 20),
                                    onPressed: _toggleObscureText),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Fluttertoast.showToast(
                                      msg: 'Click forgot password',
                                      toastLength: Toast.LENGTH_SHORT);
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              width: double.maxFinite,
                              child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith<
                                            Color>((_) => _mainColor),
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                  ),
                                  onPressed: _loginUser,
                                  
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(height: 50),
                ],
              )
            ],
          ),
        ));
  }
}
