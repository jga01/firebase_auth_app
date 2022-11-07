import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/auth_page.dart';
import 'package:firebase_auth_app/firebase_options.dart';
import 'package:firebase_auth_app/home_page.dart';
import 'package:firebase_auth_app/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String title = 'Tradeit Auth Prototype';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
              .copyWith(secondary: Colors.green),
        ),
        home: MainPage(),
      );
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Algo deu errado :('));
            } else if (snapshot.hasData) {
              return HomePage();
            } else {
              return AuthPage();
            }
          },
        ),
      );
}
