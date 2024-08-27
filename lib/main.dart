import 'package:easy_authenticator/page/totp_page.dart';
import 'package:easy_authenticator/provider/totp_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TOTPProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TOTPProvider>(
      builder: (context, provider, child) {
        final colorScheme = provider.getColorScheme();
        return MaterialApp(
          title: 'Easy Authenticator',
          theme: ThemeData.from(
            colorScheme: colorScheme,
            useMaterial3: true,
          ),
          home: const TOTPPage(),
        );
      },
    );
  }
}
