import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/produto_service.dart';
import 'produto_form_screen.dart';

const kPrimary = Color(0xFF3C0731);
const kTextPrimary = Color(0xFF212121);
const kTextSecondary = Color(0xFF757575);

class ProdutoListScreen extends StatefulWidget {
  const ProdutoListScreen({super.key});

  @override
  State<ProdutoListScreen> createState() => _ProdutoListScreenState();
}

class _ProdutoListScreenState extends State<ProdutoListScreen> {
  final service = ProdutoService();
  late Future<List<Produto>> _produtos;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  void _carregar() {
    _produtos = service.listarTodos();
    setState(() {});
  }

  Future<void> _deletar(int id, String nome) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Tem certeza que deseja excluir o produto "$nome"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmar == true) {
      await service.deletar(id);
      _carregar();
    }
  }

  String _labelCategoria(String? cat) {
    const map = {
      'VINHO_TINTO': '🍷 Tinto',
      'VINHO_BRANCO': '🥂 Branco',
      'VINHO_ROSE': '🌸 Rosé',
      'VINHO_ESPUMANTE': '✨ Espumante',
      'VINHO_SOBREMESA': '🍯 Sobremesa',
      'VINHO_ORGANICO': '🌿 Orgânico',
      'VINHO_IMPORTADO': '🌍 Importado',
    };
    return map[cat] ?? cat ?? '-';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PRODUTOS')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ProdutoFormScreen()));
          _carregar();
        },
      ),
      body: FutureBuilder<List<Produto>>(
        future: _produtos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: kPrimary));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final produtos = snapshot.data!;
          if (produtos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wine_bar_outlined, size: 64, color: kPrimary),
                  SizedBox(height: 16),
                  Text('Nenhum produto cadastrado.',
                      style: TextStyle(color: kTextSecondary, fontSize: 16)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            itemCount: produtos.length,
            itemBuilder: (_, i) {
              final p = produtos[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                color: Colors.white,
                elevation: 2,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: kPrimary.withOpacity(0.1),
                      child: const Icon(Icons.wine_bar_outlined, color: kPrimary, size: 22),
                    ),
                    title: Text(p.nome,
                        style: const TextStyle(
                            color: kTextPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_labelCategoria(p.categoria),
                              style: const TextStyle(color: kPrimary, fontSize: 12)),
                          Text(
                            'R\$ ${p.preco.toStringAsFixed(2)}  •  Estoque: ${p.estoque}',
                            style: const TextStyle(color: kTextSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: kPrimary, size: 20),
                          onPressed: () async {
                            await Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (_) => ProdutoFormScreen(produto: p)));
                            _carregar();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline,
                              color: Colors.red.shade300, size: 20),
                          onPressed: () => _deletar(p.id!, p.nome),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}