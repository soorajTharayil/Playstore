import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:universal_io/io.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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

  // Efeedor themed colors (UI only)
  final Color _mainColor = efeedorBrandGreen; // primary action color
  final Color _underlineColor = const Color(0xFFDDDDDD);

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      _iconVisible = _obscureText ? Icons.visibility_off : Icons.visibility;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: _mainColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.error_outline,
                      color: Colors.redAccent, size: 34),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Sign in failed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14, color: Colors.black87, height: 1.3),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        foregroundColor: Colors.white,
                        backgroundColor: _mainColor,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('OK'),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
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
        // Save permissions to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        // Convert the response data to JSON string and save it
        // We'll save all permission flags from the response
        final permissions = <String, dynamic>{};
        responseData.forEach((key, value) {
          if (key != 'status' && key != 'userid' && key != 'email') {
            permissions[key] = value;
          }
        });
        await prefs.setString('user_permissions', jsonEncode(permissions));
        await prefs.setString(
            'userid', responseData['userid']?.toString() ?? '');
        await prefs.setString('email', responseData['email']?.toString() ?? '');

        Fluttertoast.showToast(msg: "Login successful");

        // Navigate to DashboardPage
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomePage()));
      } else {
        _showErrorDialog(responseData['message'] ?? "Invalid credentials");
      }
    } catch (e) {
      _showErrorDialog("Error: ${e.toString()}");
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
              // Top header gradient with wave bottom and white branding
              ClipPath(
                clipper: _WaveClipperLogin(),
                child: Container(
                  height: MediaQuery.of(context).size.height / 3.2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _mainColor.withOpacity(0.95),
                        _mainColor,
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.2,
                width: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/efeedor_square_logo.png',
                        height: 48,
                        color: Colors.white,
                        colorBlendMode: BlendMode.srcIn,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Efeedor',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Login card
              ListView(
                children: <Widget>[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                    margin: EdgeInsets.fromLTRB(24,
                        MediaQuery.of(context).size.height / 3.2 - 48, 24, 0),
                    color: Colors.white,
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 16),
                            Text(
                              'Sign in',
                              style: TextStyle(
                                  color: black21,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Access your Efeedor account',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 13),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: _underlineColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: _underlineColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: _mainColor),
                                  ),
                                  hintText: 'Username or email'),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: _underlineColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: _underlineColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: _mainColor),
                                ),
                                hintText: 'Password',
                                suffixIcon: IconButton(
                                    icon: Icon(_iconVisible,
                                        color: Colors.grey[700], size: 20),
                                    onPressed: _toggleObscureText),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.maxFinite,
                              child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>((_) => _mainColor),
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    )),
                                  ),
                                  onPressed: _loginUser,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Text(
                                      'Sign in',
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

// Wave clipper for login header
class _WaveClipperLogin extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height - 40);
    final firstControlPoint = Offset(size.width * 0.25, size.height);
    final firstEndPoint = Offset(size.width * 0.5, size.height - 28);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    final secondControlPoint = Offset(size.width * 0.75, size.height - 56);
    final secondEndPoint = Offset(size.width, size.height - 28);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
