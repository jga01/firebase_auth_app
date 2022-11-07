import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/main.dart';
import 'package:firebase_auth_app/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  final Function onClickedSignup;

  const LoginWidget({
    Key? key,
    required this.onClickedSignup,
  }) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            TextField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.lock_open, size: 32),
              label: const Text(
                'Entrar',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: signIn,
            ),
            SizedBox(height: 24),
            RichText(
                text: TextSpan(
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    text: 'Não possui uma conta?  ',
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignup as GestureTapCallback?,
                      text: 'Registrar-se',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary,
                      ))
                ]))
          ],
        ),
      );

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    //Nagivator.of(context) not working!
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
