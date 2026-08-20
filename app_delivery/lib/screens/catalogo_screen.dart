import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/produto_service.dart';
import 'produto_detalhe_screen.dart';

const kPrimary = Color(0xFF3C0731);
const kBackground = Color(0xFFFAFAFA);
const kTextPrimary = Color(0xFF212121);
const kTextSecondary = Color(0xFF757575);

const Map<String, String> _categoriaLabels = {
  'VINHO_TINTO': 'Tinto',
  'VINHO_BRANCO': 'Branco',
  'VINHO_ROSE': 'Rosé',
  'VINHO_ESPUMANTE': 'Espumante',
  'VINHO_SOBREMESA': 'Sobremesa',
  'VINHO_ORGANICO': 'Orgânico',
  'VINHO_IMPORTADO': 'Importado',
};

String labelCategoria(String? categoria) =>
    _categoriaLabels[categoria] ?? categoria ?? '-';

String labelTipo(String tipo) => tipo == 'ACESSORIO' ? 'Acessório' : 'Vinho';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final service = ProdutoService();
  final _buscaCtrl = TextEditingController();

  List<Produto> _produtos = [];
  bool _carregando = true;
  String _termoBusca = '';
  String? _categoriaSelecionada; // null = "Todas"

  @override
  void initState() {
    super.initState();
    _carregar();
    _buscaCtrl.addListener(() {
      setState(() => _termoBusca = _buscaCtrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _buscaCtrl.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    try {
      final produtos = _categoriaSelecionada == null
          ? await service.listarAtivos()
          : await service.listarPorCategoria(_categoriaSelecionada!);
      if (!mounted) return;
      setState(() {
        _produtos = produtos;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregando = false);
      final mensagem = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem),
          backgroundColor: Colors.red.shade700,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _selecionarCategoria(String? categoria) async {
    if (categoria == _categoriaSelecionada) return;
    setState(() => _categoriaSelecionada = categoria);
    await _carregar();
  }

  List<Produto> get _produtosFiltrados {
    if (_termoBusca.isEmpty) return _produtos;
    return _produtos
        .where((p) => p.nome.toLowerCase().contains(_termoBusca))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final produtos = _produtosFiltrados;
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(title: const Text('CATÁLOGO')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: TextField(
              controller: _buscaCtrl,
              style: const TextStyle(color: kTextPrimary),
              cursorColor: kPrimary,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Buscar produto pelo nome',
                prefixIcon: const Icon(Icons.search, color: kTextSecondary),
                suffixIcon: _termoBusca.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close, color: kTextSecondary),
                        onPressed: () => _buscaCtrl.clear(),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _CategoriaChip(
                  label: 'Todas',
                  selecionada: _categoriaSelecionada == null,
                  onTap: () => _selecionarCategoria(null),
                ),
                for (final entry in _categoriaLabels.entries)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _CategoriaChip(
                      label: entry.value,
                      selecionada: _categoriaSelecionada == entry.key,
                      onTap: () => _selecionarCategoria(entry.key),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator(color: kPrimary))
                : produtos.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Nenhum produto encontrado para esta categoria',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kTextSecondary, fontSize: 16),
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        color: kPrimary,
                        onRefresh: _carregar,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          itemCount: produtos.length,
                          itemBuilder: (_, i) {
                            final p = produtos[i];
                            return _ProdutoCard(
                              produto: p,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProdutoDetalheScreen(id: p.id!),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _CategoriaChip extends StatelessWidget {
  final String label;
  final bool selecionada;
  final VoidCallback onTap;

  const _CategoriaChip({
    required this.label,
    required this.selecionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selecionada,
      onSelected: (_) => onTap(),
      selectedColor: kPrimary,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: selecionada ? Colors.white : kTextPrimary,
        fontWeight: FontWeight.w500,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: selecionada ? kPrimary : Colors.black12),
      ),
    );
  }
}

class _ProdutoCard extends StatelessWidget {
  final Produto produto;
  final VoidCallback onTap;

  const _ProdutoCard({required this.produto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: kPrimary.withValues(alpha: 0.1),
                child: Icon(
                  produto.isAcessorio ? Icons.local_mall_outlined : Icons.wine_bar_outlined,
                  color: kPrimary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produto.nome,
                      style: const TextStyle(
                          color: kTextPrimary, fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      labelTipo(produto.tipo),
                      style: const TextStyle(color: kPrimary, fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'R\$ ${produto.preco.toStringAsFixed(2)}',
                      style: const TextStyle(color: kTextSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: kTextSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
