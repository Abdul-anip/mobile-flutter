import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> register() async {
    String url = "http:/10.70.247.208/server_shop_hanif/register.php";
    
    try {
      var response = await http.post(Uri.parse(url), body: {
        "name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
      });

      var data = jsonDecode(response.body);
      if (data['value'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registrasi Berhasil, Silahkan Login")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Akun"), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Username")),
              const SizedBox(height: 10),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
              const SizedBox(height: 10),
              TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("DAFTAR SEKARANG", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}