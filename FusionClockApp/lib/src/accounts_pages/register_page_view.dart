import 'package:flutter/material.dart';
import 'package:fusionclock/src/accounts_pages/signin_page_view.dart';
import 'package:fusionclock/src/backend_interface/backend.dart';

import 'decorated_field.dart';

class RegisterPageView extends StatefulWidget {
  const RegisterPageView({super.key});

  static const routeName = '/register';

  @override
  State<RegisterPageView> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPageView> with BackEnd {
  MaterialColor themeColor = Colors.pink;
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final password2TextController = TextEditingController();

  void submitButton() {
    register(emailTextController.text, passwordTextController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Register'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        height: MediaQuery.of(context).size.height - 50,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Column(
                children: [
                  SizedBox(height: 60),
                  Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              DecoratedField(
                icon: Icons.password,
                text: "Confirm Password",
                obscureText: true,
                controller: password2TextController,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              Container(
                padding: const EdgeInsets.only(top: 3, left: 3),
                child: ElevatedButton(
                  onPressed: submitButton,
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: themeColor),
                  child: const Text('Sign Up',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
              const Center(
                child: Text(
                  "OR",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 3, left: 3),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, LoginPageView.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: themeColor.shade100),
                  child: const Text('Login', style: TextStyle(fontSize: 20)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
