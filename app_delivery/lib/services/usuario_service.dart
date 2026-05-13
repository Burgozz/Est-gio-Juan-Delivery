import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class UsuarioService {
  final String baseUrl = 'http://localhost:8080/usuarios';

  Future<List<Usuario>> listarTodos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode != 200) {
      throw Exception('Erro ao listar usuários: ${response.statusCode}');
    }
    final List data = jsonDecode(response.body);
    return data.map((e) => Usuario.fromJson(e)).toList();
  }

  Future<void> criar(Usuario usuario) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao criar usuário: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> atualizar(int id, Usuario usuario) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar usuário: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> deletar(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro ao deletar usuário: ${response.statusCode}');
    }
  }
}
