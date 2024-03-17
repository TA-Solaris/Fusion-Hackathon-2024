import 'package:flutter/material.dart';
import 'package:fusionclock/src/backend_interface/backend.dart';
import 'package:fusionclock/src/home_page/home_page_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ErrorBar/error_bar.dart';

import 'decorated_field.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  static const routeName = '/login';

  @override
  State<LoginPageView> createState() => RegisterPageState();
}

class RegisterPageState extends State<LoginPageView> with BackEnd {
  final MaterialColor themeColor = Colors.pink;
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  Future<String?> submitButton() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var result =
        await login(emailTextController.text, passwordTextController.text);
    if (result == null) {
      return null;
    }
    await prefs.setString("auth", result);
    return result;
  }

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Login'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        height: MediaQuery.of(context).size.height - 50,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40),
              Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              DecoratedField(
                icon: Icons.email,
                text: "Email",
                controller: emailTextController,
              ),
              const SizedBox(height: 20),
              DecoratedField(
                icon: Icons.password,
                text: "Password",
                obscureText: true,
                controller: passwordTextController,
              ),
              const Expanded(child: SizedBox()),
              Container(
                padding: const EdgeInsets.only(top: 3, left: 3),
                child: ElevatedButton(
                  onPressed: () => {
                    submitButton().then((value) => {
                          if (value == null)
                            {
                              // Error notification
                              showFlashError(
                                  context, "Invalid username or password")
                            }
                          else
                            {
                              Navigator.pushNamed(
                                  context, HomePageView.routeName)
                            }
                        })
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: themeColor),
                  child: const Text('Login',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
