import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produto.dart';

class ProdutoService {
  final String baseUrl = 'http://localhost:8080/produtos';

  Future<List<Produto>> listarTodos() async {
    final response = await http.get(Uri.parse(baseUrl));
    final List data = jsonDecode(response.body);
    return data.map((e) => Produto.fromJson(e)).toList();
  }

  Future<void> criar(Produto produto) async {
    await http.post(Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(produto.toJson()));
  }

  Future<void> atualizar(int id, Produto produto) async {
    await http.put(Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(produto.toJson()));
  }

  Future<void> deletar(int id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}