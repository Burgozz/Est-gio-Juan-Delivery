import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/produto.dart';
import '../services/produto_service.dart';

const kPrimary = Color(0xFF3C0731);
const kTextPrimary = Color(0xFF212121);
const kTextSecondary = Color(0xFF757575);

class ProdutoFormScreen extends StatefulWidget {
  final Produto? produto;
  const ProdutoFormScreen({super.key, this.produto});

  @override
  State<ProdutoFormScreen> createState() => _ProdutoFormScreenState();
}

class _ProdutoFormScreenState extends State<ProdutoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _precoCtrl = TextEditingController();
  final _descricaoCtrl = TextEditingController();
  final _paisCtrl = TextEditingController();
  final _safraCtrl = TextEditingController();
  final _estoqueCtrl = TextEditingController();
  final service = ProdutoService();

  String? _categoriaSelecionada;

  final List<Map<String, String>> _categorias = [
    {'value': 'VINHO_TINTO', 'label': 'Vinho Tinto'},
    {'value': 'VINHO_BRANCO', 'label': 'Vinho Branco'},
    {'value': 'VINHO_ROSE', 'label': 'Vinho Rosé'},
    {'value': 'VINHO_ESPUMANTE', 'label': 'Espumante'},
    {'value': 'VINHO_SOBREMESA', 'label': 'Vinho de Sobremesa'},
    {'value': 'VINHO_ORGANICO', 'label': 'Vinho Orgânico'},
    {'value': 'VINHO_IMPORTADO', 'label': 'Vinho Importado'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.produto != null) {
      final p = widget.produto!;
      _nomeCtrl.text = p.nome;
      _precoCtrl.text = p.preco.toString();
      _descricaoCtrl.text = p.descricao ?? '';
      _paisCtrl.text = p.paisOrigem ?? '';
      _safraCtrl.text = p.safra?.toString() ?? '';
      _estoqueCtrl.text = p.estoque.toString();
      _categoriaSelecionada = p.categoria;
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    final p = Produto(
      nome: _nomeCtrl.text.trim(),
      preco: double.parse(_precoCtrl.text.trim()),
      descricao: _descricaoCtrl.text.trim(),
      categoria: _categoriaSelecionada,
      paisOrigem: _paisCtrl.text.trim(),
      safra: int.tryParse(_safraCtrl.text.trim()),
      estoque: int.parse(_estoqueCtrl.text.trim()),
    );
    try {
      if (widget.produto == null) {
        await service.criar(p);
      } else {
        await service.atualizar(widget.produto!.id!, p);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
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
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.produto != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'EDITAR PRODUTO' : 'NOVO PRODUTO'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeCtrl,
                style: const TextStyle(color: kTextPrimary),
                cursorColor: kPrimary,
                decoration: const InputDecoration(
                  labelText: 'Nome do Vinho *',
                  prefixIcon: Icon(Icons.wine_bar_outlined, color: kTextSecondary, size: 20),
                ),
                validator: (v) => v!.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                initialValue: _categoriaSelecionada,
                decoration: const InputDecoration(
                  labelText: 'Categoria *',
                  prefixIcon: Icon(Icons.category_outlined, color: kTextSecondary, size: 20),
                ),
                dropdownColor: Colors.white,
                style: const TextStyle(color: kTextPrimary),
                items: _categorias.map((c) => DropdownMenuItem(
                  value: c['value'],
                  child: Text(c['label']!),
                )).toList(),
                onChanged: (val) => setState(() => _categoriaSelecionada = val),
                validator: (v) => v == null ? 'Selecione a categoria' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _precoCtrl,
                style: const TextStyle(color: kTextPrimary),
                cursorColor: kPrimary,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Preço (R\$) *',
                  prefixIcon: Icon(Icons.attach_money, color: kTextSecondary, size: 20),
                ),
                validator: (v) {
                  if (v!.isEmpty) return 'Informe o preço';
                  final preco = double.tryParse(v.trim());
                  if (preco == null) return 'Valor inválido';
                  if (preco < 0) return 'O preço não pode ser negativo';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descricaoCtrl,
                style: const TextStyle(color: kTextPrimary),
                cursorColor: kPrimary,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: Icon(Icons.notes, color: kTextSecondary, size: 20),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _paisCtrl,
                      style: const TextStyle(color: kTextPrimary),
                      cursorColor: kPrimary,
                      decoration: const InputDecoration(
                        labelText: 'País de Origem',
                        prefixIcon: Icon(Icons.flag_outlined, color: kTextSecondary, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _safraCtrl,
                      style: const TextStyle(color: kTextPrimary),
                      cursorColor: kPrimary,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Safra',
                        hintText: 'Ex: 2021',
                        prefixIcon: Icon(Icons.calendar_today_outlined, color: kTextSecondary, size: 20),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return null;
                        final ano = int.tryParse(v);
                        if (ano == null) return 'Ano inválido';
                        if (ano < 1900 || ano > 2026) {
                          return 'Safra deve ser entre 1900 e 2026';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _estoqueCtrl,
                style: const TextStyle(color: kTextPrimary),
                cursorColor: kPrimary,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Estoque (unidades) *',
                  prefixIcon: Icon(Icons.inventory_2_outlined, color: kTextSecondary, size: 20),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe o estoque';
                  final qtd = int.tryParse(v);
                  if (qtd == null) return 'Valor inválido';
                  if (!isEditing && qtd <= 0) {
                    return 'Estoque inicial deve ser maior que zero';
                  }
                  if (qtd < 0) return 'Estoque não pode ser negativo';
                  return null;
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvar,
                  child: Text(isEditing ? 'ATUALIZAR' : 'CADASTRAR'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}