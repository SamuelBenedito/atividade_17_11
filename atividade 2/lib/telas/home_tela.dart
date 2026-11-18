import 'package:flutter/material.dart';

import '../modelos.dart';
import '../sessao.dart';
import 'amigos_tela.dart';
import 'busca_tela.dart';
import 'feed_tela.dart';
import 'login_tela.dart';
import 'nova_postagem_tela.dart';

class HomeTela extends StatefulWidget {
  const HomeTela({super.key, required this.usuario});

  final Usuario usuario;

  @override
  State<HomeTela> createState() => _HomeTelaState();
}

class _HomeTelaState extends State<HomeTela> {
  int _tela = 0;
  int _versaoFeed = 0;

  static const _titulos = [
    'Página inicial',
    'Minhas postagens',
    'Buscar',
    'Amigos'
  ];

  void _selecionar(int indice) {
    setState(() => _tela = indice);
    Navigator.pop(context);
  }

  Future<void> _novaPostagem() async {
    final publicou = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
          builder: (_) => NovaPostagemTela(usuario: widget.usuario)),
    );
    if (publicou == true) setState(() => _versaoFeed++);
  }

  Future<void> _sair() async {
    await Sessao.sair();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginTela()),
      (_) => false,
    );
  }

  Widget _corpo() {
    switch (_tela) {
      case 1:
        return FeedTela(
          key: ValueKey('meus$_versaoFeed'),
          usuario: widget.usuario,
          autorId: widget.usuario.id,
        );
      case 2:
        return BuscaTela(usuario: widget.usuario);
      case 3:
        return AmigosTela(usuario: widget.usuario);
      default:
        return FeedTela(
            key: ValueKey('feed$_versaoFeed'), usuario: widget.usuario);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_titulos[_tela]),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: cores.surface,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                widget.usuario.nome,
                style: TextStyle(
                  color: cores.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
              accountEmail: Text(
                widget.usuario.email,
                style: TextStyle(color: cores.onPrimaryContainer),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: cores.primary,
                foregroundColor: cores.onPrimary,
                child: Text(
                  widget.usuario.inicial,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              decoration: BoxDecoration(color: cores.primaryContainer),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Página inicial'),
              selected: _tela == 0,
              onTap: () => _selecionar(0),
            ),
            ListTile(
              leading: const Icon(Icons.article_outlined),
              title: const Text('Minhas postagens'),
              selected: _tela == 1,
              onTap: () => _selecionar(1),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Buscar'),
              selected: _tela == 2,
              onTap: () => _selecionar(2),
            ),
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('Amigos'),
              selected: _tela == 3,
              onTap: () => _selecionar(3),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Nova postagem'),
              onTap: () {
                Navigator.pop(context);
                _novaPostagem();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: _sair,
            ),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: _corpo(),
        ),
      ),
      floatingActionButton: _tela <= 1
          ? FloatingActionButton(
              onPressed: _novaPostagem,
              tooltip: 'Nova postagem',
              child: const Icon(Icons.edit_outlined),
            )
          : null,
    );
  }
}
