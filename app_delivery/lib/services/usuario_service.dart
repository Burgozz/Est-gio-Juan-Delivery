import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class UsuarioService {
  final String baseUrl = 'http://localhost:8080/usuarios';

  Future<List<Usuario>> listarTodos() async {
    final response = await http.get(Uri.parse(baseUrl));
    final List data = jsonDecode(response.body);
    return data.map((e) => Usuario.fromJson(e)).toList();
  }

  Future<void> criar(Usuario usuario) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );
  }

  Future<void> atualizar(int id, Usuario usuario) async {
    await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );
  }

  Future<void> deletar(int id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}