import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';
import 'usuario_form_screen.dart';

const kPrimary = Color(0xFF3C0731);
const kBackground = Color(0xFFFAFAFA);
const kTextPrimary = Color(0xFF212121);
const kTextSecondary = Color(0xFF757575);

class UsuarioListScreen extends StatefulWidget {
  const UsuarioListScreen({super.key});

  @override
  State<UsuarioListScreen> createState() => _UsuarioListScreenState();
}

class _UsuarioListScreenState extends State<UsuarioListScreen> {
  final service = UsuarioService();
  late Future<List<Usuario>> _usuarios;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  void _carregar() {
    _usuarios = service.listarTodos();
    setState(() {});
  }

  Future<void> _deletar(int id, String nome) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Confirmar exclusão',
          style: TextStyle(color: kPrimary, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Tem certeza que deseja excluir o usuário "$nome"?',
          style: const TextStyle(color: kTextPrimary),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: kTextSecondary),
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (confirmar == true) {
      await service.deletar(id);
      _carregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JUAN DELIVERY')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UsuarioFormScreen()),
          );
          _carregar();
        },
      ),
      body: FutureBuilder<List<Usuario>>(
        future: _usuarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: kPrimary),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}',
                  style: const TextStyle(color: kTextPrimary)),
            );
          }
          final usuarios = snapshot.data!;
          if (usuarios.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: kPrimary),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum usuário cadastrado.',
                    style: TextStyle(
                      color: kTextSecondary,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            itemCount: usuarios.length,
            itemBuilder: (_, i) {
              final u = usuarios[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                color: Colors.white,
                elevation: 2,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: kPrimary.withOpacity(0.1),
                      child: const Icon(Icons.person_outline, color: kPrimary, size: 22),
                    ),
                    title: Text(
                      u.nome,
                      style: const TextStyle(
                        color: kTextPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        u.email,
                        style: const TextStyle(
                          color: kTextSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: kPrimary, size: 20),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UsuarioFormScreen(usuario: u),
                              ),
                            );
                            _carregar();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline,
                              color: Colors.red.shade300, size: 20),
                          onPressed: () => _deletar(u.id!, u.nome),
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