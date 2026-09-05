import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'main_wrapper.dart';
import 'auth/login_screen.dart';
import 'auth/reset_password_screen.dart';
import '../main.dart'; // for navigatorKey

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Session? _session = Supabase.instance.client.auth.currentSession;

  @override
  void initState() {
    super.initState();
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;

      if (event == AuthChangeEvent.passwordRecovery) {
        // Deep link opened — push the reset screen on top of whatever's showing.
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
        );
        return;
      }

      if (mounted) {
        setState(() => _session = data.session);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _session != null ? const MainWrapper() : const LoginScreen();
  }
}