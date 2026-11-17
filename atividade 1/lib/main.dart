import 'package:flutter/material.dart';

void main() {
  runApp(const MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Menu());
  }
}

enum Pagina {
  home('Home'),
  primeiro('Primeiro período', [
    'Lógica de Programação',
    'Matemática Aplicada',
    'Introdução à Computação',
  ]),
  segundo('Segundo período', [
    'Programação Orientada a Objetos',
    'Banco de Dados',
    'Redes de Computadores',
  ]),
  terceiro('Terceiro período', [
    'Estruturas de Dados',
    'Desenvolvimento Mobile',
    'Engenharia de Software',
  ]);

  const Pagina(this.titulo, [this.disciplinas = const []]);

  final String titulo;
  final List<String> disciplinas;
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Pagina _pagina = Pagina.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pagina == Pagina.home
              ? 'AppBar with hamburger button'
              : _pagina.titulo,
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('João Silva'),
              accountEmail: Text('joao@email.com'),
              currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
            ),
            for (final pagina in Pagina.values)
              ListTile(
                title: Text(pagina.titulo),
                onTap: () {
                  setState(() => _pagina = pagina);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
      body: _pagina == Pagina.home
          ? const Center(child: Text('Hello world!'))
          : ListView(
              children: [
                for (final disciplina in _pagina.disciplinas)
                  ListTile(title: Text(disciplina)),
              ],
            ),
    );
  }
}
