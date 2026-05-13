import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produto.dart';

class ProdutoService {
  final String baseUrl = 'http://localhost:8080/produtos';

  Future<List<Produto>> listarTodos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode != 200) {
      throw Exception('Erro ao listar produtos: ${response.statusCode}');
    }
    final List data = jsonDecode(response.body);
    return data.map((e) => Produto.fromJson(e)).toList();
  }

  Future<void> criar(Produto produto) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produto.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao criar produto: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> atualizar(int id, Produto produto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produto.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar produto: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> deletar(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro ao deletar produto: ${response.statusCode}');
    }
  }
}
