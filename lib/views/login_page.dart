import 'package:flutter/material.dart';
import 'package:tugas_resep/service/auth_service.dart';
import 'package:tugas_resep/views/main_page.dart';
import 'package:tugas_resep/views/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordHidden = true;


  Future<void> _login() async {
    final username = _usernameController.text.trim(); 
    final password = _passwordController.text.trim(); 

    if(username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Username dan password wajib diisi'), 
          backgroundColor: Colors.red,
        )
      );
    }

    final sukses = await AuthService.login(username, password); 

    if(sukses) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => MainPage())
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Username atau password salah"), 
          backgroundColor: Colors.red,
        )
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 224, 140),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 224, 140),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login', style: TextStyle(fontSize: 24),),
            const SizedBox(height: 16,),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(), 
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10
                )
              ),
            ), 
            const SizedBox(height: 10), 
            TextField(
              controller: _passwordController,
              obscureText: _isPasswordHidden,
              decoration: InputDecoration(
                labelText: 'Password', 
                border: OutlineInputBorder(), 
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8, 
                  horizontal: 10
                ), 
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  }, 
                  icon: Icon(
                    _isPasswordHidden ? Icons.visibility_off : Icons.visibility
                  )
                )
              ),
            ), 
            const SizedBox(height: 16,), 
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _login,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 245, 161, 6))
                ), 
                child: Text('Login', style: TextStyle(color: Colors.white),)
              ),
            ), 
            const SizedBox(height: 10,), 
            TextButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterPage())), 
              child: const Text('Belum punya akun? Register', style: TextStyle(color: Colors.black),)
            )
          ],
        ),
      ),
    );
  }
}