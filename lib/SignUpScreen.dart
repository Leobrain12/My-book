// sign_up_screen.dart
import 'package:flutter/material.dart';
import 'AuthenticationRepository.dart';

class SignUpScreen extends StatefulWidget {
  final AuthenticationRepository authenticationRepository;

  SignUpScreen({required this.authenticationRepository});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _signUp();
              },
              child: Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }

  void _signUp() async {
    try {
      await widget.authenticationRepository.signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // После успешной регистрации можно например перейти на главный экран
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      // В случае ошибки при регистрации, обработайте её здесь (например, выведите сообщение об ошибке)
      print('Ошибка при регистрации: $e');
    }
  }
}
