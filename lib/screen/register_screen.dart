import 'package:catatan_harian/services/firebase_auth_services.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuthServices fbServices = FirebaseAuthServices();

  register() async {
    fbServices
        .registerAkun(
            email: emailController.text, password: passwordController.text)
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${value?.user?.email} success'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Register'),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Masukkan Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Masukkan Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                register();
              },
              child: Text('Register'),
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Sudah punya akun? Login disini'))
          ],
        ),
      ),
    );
  }
}
