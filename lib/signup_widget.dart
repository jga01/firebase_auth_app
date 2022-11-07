import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/main.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth_app/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpWidget extends StatefulWidget {
  final Function onClickedSignup;

  const SignUpWidget({
    Key? key,
    required this.onClickedSignup,
  }) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
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
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              FlutterLogo(size: 120),
              SizedBox(height: 20),
              Text(
                'Bem-vindo(a)!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Email'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Insira um email válido'
                        : null,
              ),
              SizedBox(height: 4),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'A senha deve ter pelo menos 6 caracteres'
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
                icon: Icon(Icons.arrow_forward, size: 32),
                label: Text(
                  'Registrar',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: signUp,
              ),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  text: 'Já possui uma conta?  ',
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignup as GestureTapCallback?,
                      text: 'Entrar',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }

    //Nagivator.of(context) not working!
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
