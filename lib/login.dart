import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_ui/in_game.dart';
import 'package:game_ui/view_models/user.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key, required this.title});

  final String title;
  static const String path = '/login';

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _listenBackendMessage(ref, context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            Consumer(
              builder: (context, ref, child) {
                final userState = ref.watch(userProvider);

                return ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(userProvider.notifier)
                        .setUser(username: 'root', password: 'admin');
                  },
                  child:
                      userState is AsyncLoading
                          ? const CircularProgressIndicator()
                          : const Text('Login'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _listenBackendMessage(WidgetRef ref, BuildContext context) {
    ref.listen(userProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login successful!')));

        Navigator.pushReplacementNamed(context, InGamePage.path);
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${next.error}')));
      }
    });
  }
}
