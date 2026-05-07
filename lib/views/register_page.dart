import 'package:flutter/material.dart';
import 'package:tugas_resep/service/auth_service.dart';
import 'package:tugas_resep/views/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController(); 
  final _passwordController = TextEditingController();
  bool _isPasswordHidden = true; 
  
  Future<void> _register() async {
    final username = _usernameController.text.trim(); 
    final password = _passwordController.text.trim(); 

    if(username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Username dan password wajib diisi"),
          backgroundColor: Colors.red,
        )
      );
      return;
    }

    final sukses = await AuthService.register(username, password);

    if(sukses)
    {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage())
      );
    } else 
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Username sudah terdaftar"), 
          backgroundColor: Colors.red,
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 224, 140),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 224, 140),
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24), 
        child: Column(
          children: [
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
            const SizedBox(height: 10,),
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
                onPressed: _register,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 245, 161, 6))
                ), 
                child: Text('Register', style: TextStyle(color: Colors.white),)
              ),
            )
          ],
        ),
      ),
    );
  }
}