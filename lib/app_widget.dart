import 'package:flutter/material.dart';
import 'package:safe_lopes_family/modules/auth/auth_page.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AuthPage(),
    );
  }
}
