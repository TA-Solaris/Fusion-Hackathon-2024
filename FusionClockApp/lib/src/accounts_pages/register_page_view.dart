import 'package:flutter/material.dart';

class RegisterPageView extends StatefulWidget {
  const RegisterPageView({super.key});

  static const routeName = '/register';

  @override
  State<RegisterPageView> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPageView> {
  void submitButton() {}

  MaterialColor themeColor = Colors.blue;

  Widget fieldDecoration(icon, text) {
    return TextField(
      decoration: InputDecoration(
          hintText: text,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none),
          fillColor: themeColor.withOpacity(0.1),
          filled: true,
          prefixIcon: Icon(icon)),
    );
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
              fieldDecoration(Icons.person, "Username"),
              const SizedBox(height: 20),
              fieldDecoration(Icons.email, "Email"),
              const SizedBox(height: 20),
              fieldDecoration(Icons.password, "Password"),
              const SizedBox(height: 20),
              fieldDecoration(Icons.password, "Confirm Password"),
              const SizedBox(height: 20),
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
                  onPressed: submitButton,
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
