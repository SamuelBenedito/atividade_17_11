import 'package:flutter/material.dart';

import 'modelos.dart';
import 'sessao.dart';
import 'telas/home_tela.dart';
import 'telas/login_tela.dart';

void main() {
  runApp(const X2App());
}

class X2App extends StatelessWidget {
  const X2App({super.key});

  @override
  Widget build(BuildContext context) {
    final cores = ColorScheme.fromSeed(seedColor: const Color(0xFF3358B8));
    final bordaCampo = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    );

    return MaterialApp(
      title: 'X2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: cores,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F5FA),
        appBarTheme: AppBarTheme(
          backgroundColor: cores.surface,
          foregroundColor: cores.onSurface,
          titleTextStyle: TextStyle(
            color: cores.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardTheme(
          color: cores.surface,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: cores.outlineVariant),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cores.surface,
          border: bordaCampo,
        ),
      ),
      home: const Inicio(),
    );
  }
}

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Usuario?>(
      future: Sessao.carregar(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        final usuario = snapshot.data;
        return usuario == null ? const LoginTela() : HomeTela(usuario: usuario);
      },
    );
  }
}
