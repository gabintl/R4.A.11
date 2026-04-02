import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/auth_state.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, this.child});

  final Widget? child;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String username = '';
  String password = '';
  String confirmPassword = '';
  String? error;
  final _formKey = GlobalKey<FormState>();

  String? _validateRequired(String? value) {
    return value == null || value.isEmpty ? 'Ce champ est obligatoire.' : null;
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final success = await context.read<AuthState>().signup(username, password);
    if (success.isSuccess) {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      }
    } else {
      setState(() { error = success.failure; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Identifiant'),
            onChanged: (value) => username = value,
            validator: _validateRequired,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Mot de passe'),
            obscureText: true,
            onChanged: (value) => password = value,
            validator: _validateRequired,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Confirmer le mot de passe'),
            obscureText: true,
            onChanged: (value) => confirmPassword = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ce champ est obligatoire.';
              }
              if (value != password) {
                return 'Les mots de passe ne correspondent pas.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          if (error != null)
            Text(error!, style: theme.textTheme.labelMedium!.copyWith(color: theme.colorScheme.error)),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('S\'inscrire'),
          ),
        ],
      ),
    );
  }
}