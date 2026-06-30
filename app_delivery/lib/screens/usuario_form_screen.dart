import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';

const kPrimary = Color(0xFF3C0731);
const kTextPrimary = Color(0xFF212121);
const kTextSecondary = Color(0xFF757575);

class UsuarioFormScreen extends StatefulWidget {
  final Usuario? usuario;
  const UsuarioFormScreen({super.key, this.usuario});

  @override
  State<UsuarioFormScreen> createState() => _UsuarioFormScreenState();
}

class _UsuarioFormScreenState extends State<UsuarioFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _telefoneCtrl = TextEditingController();
  final service = UsuarioService();

  @override
  void initState() {
    super.initState();
    if (widget.usuario != null) {
      _nomeCtrl.text = widget.usuario!.nome;
      _emailCtrl.text = widget.usuario!.email;
      _senhaCtrl.text = widget.usuario!.senha;
      _telefoneCtrl.text = widget.usuario!.telefone ?? '';
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    final u = Usuario(
      nome: _nomeCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      senha: _senhaCtrl.text.trim(),
      telefone: _telefoneCtrl.text.trim().isEmpty ? null : _telefoneCtrl.text.trim(),
      dataCadastro: widget.usuario?.dataCadastro,
    );
    try {
      if (widget.usuario == null) {
        await service.criar(u);
      } else {
        await service.atualizar(widget.usuario!.id!, u);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.usuario != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'EDITAR USUÁRIO' : 'NOVO USUÁRIO'),
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
                  labelText: 'Nome *',
                  prefixIcon: Icon(Icons.person_outline, color: kTextSecondary, size: 20),
                ),
                validator: (v) => v!.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailCtrl,
                style: const TextStyle(color: kTextPrimary),
                cursorColor: kPrimary,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  prefixIcon: Icon(Icons.email_outlined, color: kTextSecondary, size: 20),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v!.isEmpty) return 'Informe o email';
                  final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                  if (!regex.hasMatch(v.trim())) return 'Email inválido (ex: nome@dominio.com)';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _senhaCtrl,
                style: const TextStyle(color: kTextPrimary),
                cursorColor: kPrimary,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha *',
                  prefixIcon: Icon(Icons.lock_outline, color: kTextSecondary, size: 20),
                ),
                validator: (v) => v!.isEmpty ? 'Informe a senha' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _telefoneCtrl,
                style: const TextStyle(color: kTextPrimary),
                cursorColor: kPrimary,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  hintText: 'Ex: 11987654321',
                  prefixIcon: Icon(Icons.phone_outlined, color: kTextSecondary, size: 20),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  if (v.length < 10 || v.length > 11) {
                    return 'Telefone deve ter 10 ou 11 dígitos (com DDD)';
                  }
                  if (v[0] == '0') return 'DDD inválido (não pode começar com 0)';
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