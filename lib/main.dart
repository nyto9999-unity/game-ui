import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_ui/in_game.dart';
import 'package:game_ui/login.dart';

Future main() async {
  await dotenv.load(fileName: "assets/.env");

  runApp(ProviderScope(child: const Main()));
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game UI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: LoginPage.path,
      routes: {
        LoginPage.path: (context) => LoginPage(title: 'Login Page'),
        InGamePage.path: (context) => const InGamePage(),
      },
    );
  }
}
