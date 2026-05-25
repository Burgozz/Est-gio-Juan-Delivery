class Produto {
  final int? id;
  final String nome;
  final double preco;
  final String? descricao;
  final String? categoria;
  final String? paisOrigem;
  final int? safra;
  final int estoque;
  final bool ativo;

  Produto({
    this.id,
    required this.nome,
    required this.preco,
    this.descricao,
    this.categoria,
    this.paisOrigem,
    this.safra,
    required this.estoque,
    this.ativo = true,
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
        ativo: json['ativo'] ?? true,
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