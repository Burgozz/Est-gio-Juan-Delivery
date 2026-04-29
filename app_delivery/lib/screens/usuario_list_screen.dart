import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';
import 'usuario_form_screen.dart';

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

  Future<void> _deletar(int id) async {
    await service.deletar(id);
    _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuários')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
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
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final usuarios = snapshot.data!;
          if (usuarios.isEmpty) {
            return const Center(child: Text('Nenhum usuário cadastrado.'));
          }
          return ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (_, i) {
              final u = usuarios[i];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(u.nome),
                subtitle: Text(u.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
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
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deletar(u.id!),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}