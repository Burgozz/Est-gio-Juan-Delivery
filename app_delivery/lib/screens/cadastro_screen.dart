import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';
import '../utils/auth_theme.dart';
import '../utils/cpf_formatter.dart';
import 'login_screen.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  final _telefoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _service = UsuarioService();
  bool _carregando = false;
  String? _emailApiError;

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _cpfCtrl.dispose();
    _telefoneCtrl.dispose();
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    setState(() => _emailApiError = null);
    if (!_formKey.currentState!.validate()) return;
    setState(() => _carregando = true);
    final usuario = Usuario(
      nome: _nomeCtrl.text.trim(),
      cpf: _cpfCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''),
      email: _emailCtrl.text.trim(),
      senha: _senhaCtrl.text.trim(),
      telefone: _telefoneCtrl.text.trim(),
    );
    try {
      await _service.criar(usuario);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
      final mensagem = e.toString().replaceFirst('Exception: ', '');
      if (mounted) {
        if (mensagem.toLowerCase().contains('email') ||
            mensagem.toLowerCase().contains('e-mail')) {
          setState(() => _emailApiError = mensagem);
          _formKey.currentState!.validate();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(mensagem),
              backgroundColor: Colors.red.shade700,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAuthBackground,
      appBar: AppBar(
        title: const Text('CADASTRO'),
        backgroundColor: kAuthBackground,
        foregroundColor: kAuthTitle,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kAuthCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nomeCtrl,
                  style: const TextStyle(color: kAuthFieldText),
                  cursorColor: kAuthFieldBorderFocused,
                  decoration: authInputDecoration(
                    label: 'Nome completo',
                    icon: Icons.person_outline,
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Informe o nome' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _cpfCtrl,
                  style: const TextStyle(color: kAuthFieldText),
                  cursorColor: kAuthFieldBorderFocused,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CpfInputFormatter(),
                  ],
                  decoration: authInputDecoration(
                    label: 'CPF',
                    hint: 'XXX.XXX.XXX-XX',
                    icon: Icons.badge_outlined,
                  ),
                  validator: (v) {
                    final digits = (v ?? '').replaceAll(RegExp(r'[^0-9]'), '');
                    if (digits.isEmpty) return 'Informe o CPF';
                    if (digits.length != 11) {
                      return 'CPF deve ter exatamente 11 dígitos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _telefoneCtrl,
                  style: const TextStyle(color: kAuthFieldText),
                  cursorColor: kAuthFieldBorderFocused,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: authInputDecoration(
                    label: 'Telefone',
                    hint: 'Ex: 11987654321',
                    icon: Icons.phone_outlined,
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Informe o telefone' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailCtrl,
                  style: const TextStyle(color: kAuthFieldText),
                  cursorColor: kAuthFieldBorderFocused,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) {
                    if (_emailApiError != null) {
                      setState(() => _emailApiError = null);
                    }
                  },
                  decoration: authInputDecoration(
                    label: 'E-mail',
                    icon: Icons.email_outlined,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Informe o e-mail';
                    }
                    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    if (!regex.hasMatch(v.trim())) return 'E-mail inválido';
                    if (_emailApiError != null) return _emailApiError;
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _senhaCtrl,
                  style: const TextStyle(color: kAuthFieldText),
                  cursorColor: kAuthFieldBorderFocused,
                  obscureText: true,
                  decoration: authInputDecoration(
                    label: 'Senha',
                    icon: Icons.lock_outline,
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Informe a senha' : null,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: authButtonStyle,
                    onPressed: _carregando ? null : _cadastrar,
                    child: _carregando
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('CADASTRAR'),
                  ),
                ),
                const SizedBox(height: 12),
                AuthLinkButton(
                  texto: 'Já tem conta? ',
                  trechoDestaque: 'Entrar',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
