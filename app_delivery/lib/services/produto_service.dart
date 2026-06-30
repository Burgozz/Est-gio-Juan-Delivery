import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produto.dart';

class ProdutoService {
  final String baseUrl = 'http://localhost:8080/produtos';

  String _parseErro(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map) {
        if (body['erros'] is List) {
          return (body['erros'] as List).join('\n');
        }
        if (body['erro'] != null) return body['erro'].toString();
      }
    } catch (_) {}
    return 'Erro ${response.statusCode}';
  }

  Future<List<Produto>> listarTodos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode != 200) {
      throw Exception(_parseErro(response));
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
      throw Exception(_parseErro(response));
    }
  }

  Future<void> atualizar(int id, Produto produto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produto.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception(_parseErro(response));
    }
  }

  Future<void> deletar(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(_parseErro(response));
    }
  }
}
