import 'package:flutter/material.dart';
import 'package:fusionclock/src/backend_interface/backend.dart';

import 'decorated_field.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  static const routeName = '/login';

  @override
  State<LoginPageView> createState() => RegisterPageState();
}

class RegisterPageState extends State<LoginPageView> with BackEnd {
  final MaterialColor themeColor = Colors.pink;
  TextEditingController emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Column(
                children: [
                  SizedBox(height: 60),
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                  )
                ],
              ),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.55),
              Container(
                padding: const EdgeInsets.only(top: 3, left: 3),
                child: ElevatedButton(
                  onPressed: () {
                    login(
                        emailTextController.text, passwordTextController.text);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: themeColor),
                  child: const Text('Login',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
