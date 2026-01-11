import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hanifstore/homepage.dart';
import 'package:hanifstore/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    String url = "http://10.70.247.208/server_shop_hanif/login.php";
    
    try {
      var response = await http.post(Uri.parse(url), body: {
        "email": emailController.text,
        "password": passwordController.text,
      });

      var data = jsonDecode(response.body);
      if (data['value'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Login hanifstore",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("LOGIN", style: TextStyle(color: Colors.white)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                  },
                  child: const Text("Belum punya akun? Daftar di sini"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}