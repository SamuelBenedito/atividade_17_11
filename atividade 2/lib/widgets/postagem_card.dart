import 'package:flutter/material.dart';

import '../api.dart';
import '../modelos.dart';
import '../telas/comentarios_tela.dart';

class PostagemCard extends StatefulWidget {
  const PostagemCard({
    super.key,
    required this.usuario,
    required this.postagem,
    this.aoMudarAmizade,
  });

  final Usuario usuario;
  final Postagem postagem;
  final VoidCallback? aoMudarAmizade;

  @override
  State<PostagemCard> createState() => _PostagemCardState();
}

class _PostagemCardState extends State<PostagemCard> {
  bool _ocupado = false;

  Postagem get p => widget.postagem;

  void _aviso(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _curtir() async {
    try {
      final (curti, total) = await Api.curtir(widget.usuario.id, p.id);
      setState(() {
        p.curti = curti;
        p.curtidas = total;
      });
    } on ApiException catch (e) {
      _aviso(e.mensagem);
    }
  }

  Future<void> _solicitarAmizade() async {
    setState(() => _ocupado = true);
    try {
      final status = await Api.solicitarAmizade(widget.usuario.id, p.autorId);
      setState(() => p.amizade = status);
      _aviso(status == 'amigos'
          ? 'Agora vocês são amigos!'
          : 'Solicitação enviada para ${p.autorNome}');
      widget.aoMudarAmizade?.call();
    } on ApiException catch (e) {
      _aviso(e.mensagem);
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  Future<void> _abrirComentarios() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) =>
              ComentariosTela(usuario: widget.usuario, postagem: p)),
    );
    if (mounted) setState(() {});
  }

  Widget? _botaoAmizade() {
    switch (p.amizade) {
      case 'nenhuma':
        return TextButton.icon(
          onPressed: _ocupado ? null : _solicitarAmizade,
          icon: const Icon(Icons.person_add, size: 18),
          label: const Text('Adicionar'),
        );
      case 'recebida':
        return TextButton.icon(
          onPressed: _ocupado ? null : _solicitarAmizade,
          icon: const Icon(Icons.how_to_reg, size: 18),
          label: const Text('Aceitar'),
        );
      case 'enviada':
        return const Chip(
            label: Text('Pendente'), visualDensity: VisualDensity.compact);
      case 'amigos':
        return const Chip(
          avatar: Icon(Icons.check, size: 16),
          label: Text('Amigos'),
          visualDensity: VisualDensity.compact,
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    final corCurtida = p.curti ? Colors.pink.shade700 : cores.onSurfaceVariant;
    final botao = _botaoAmizade();
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: cores.primaryContainer,
                  foregroundColor: cores.onPrimaryContainer,
                  child: Text(
                    p.autorNome.isEmpty ? '?' : p.autorNome[0].toUpperCase(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.autorNome,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tema.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        tempoRelativo(p.criadoEm),
                        style: tema.textTheme.bodySmall?.copyWith(
                          color: cores.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(p.texto, style: tema.textTheme.bodyLarge),
            if (p.foto != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: Image.network(
                    Api.urlFoto(p.foto!),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 120,
                      color: cores.surfaceVariant,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: _abrirComentarios,
                  style: TextButton.styleFrom(
                    foregroundColor: cores.onSurfaceVariant,
                  ),
                  icon: Icon(
                    p.podeComentar
                        ? Icons.chat_bubble_outline
                        : Icons.lock_outline,
                    size: 18,
                  ),
                  label: Text('${p.comentarios}'),
                ),
                TextButton.icon(
                  onPressed: _curtir,
                  style: TextButton.styleFrom(foregroundColor: corCurtida),
                  icon: Icon(
                    p.curti ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                  ),
                  label: Text('${p.curtidas}'),
                ),
                if (botao != null) botao,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
