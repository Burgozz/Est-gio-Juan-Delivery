class Produto {
  final int? id;
  final String nome;
  final double preco;
  final String? descricao;
  final String? categoria;
  final String? paisOrigem;
  final int? safra;
  final int estoque;

  Produto({
    this.id,
    required this.nome,
    required this.preco,
    this.descricao,
    this.categoria,
    this.paisOrigem,
    this.safra,
    required this.estoque,
  });

  factory Produto.fromJson(Map<String, dynamic> json) => Produto(
        id: json['id'],
        nome: json['nome'],
        preco: (json['preco'] as num).toDouble(),
        descricao: json['descricao'],
        categoria: json['categoria'],
        paisOrigem: json['paisOrigem'],
        safra: json['safra'],
        estoque: json['estoque'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'preco': preco,
        'descricao': descricao,
        'categoria': categoria,
        'paisOrigem': paisOrigem,
        'safra': safra,
        'estoque': estoque,
      };
}