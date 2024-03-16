import 'package:flutter/material.dart';

class RegisterPageView extends StatefulWidget {
  const RegisterPageView({super.key});

  static const routeName = '/register';

  @override
  State<RegisterPageView> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPageView> {
  void submitButton() {}

  Widget fieldDecoration(icon, text) {
    return TextField(
      decoration: InputDecoration(
          hintText: text,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none),
          fillColor: Colors.purple.withOpacity(0.1),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              fieldDecoration(Icons.person, "Username"),
              const SizedBox(height: 20),
              fieldDecoration(Icons.email, "Email"),
              const SizedBox(height: 20),
              fieldDecoration(Icons.password, "Password"),
              const SizedBox(height: 20),
              fieldDecoration(Icons.password, "Confirm Password"),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: submitButton, child: Text('Login'))
            ],
          ),
        ),
      ),
    );
  }
}
