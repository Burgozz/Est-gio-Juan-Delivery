class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String senha;
  final String? telefone;
  final dynamic dataCadastro;
  final bool ativo;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.telefone,
    this.dataCadastro,
    this.ativo = true,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json['id'],
        nome: json['nome'],
        email: json['email'],
        senha: json['senha'],
        telefone: json['telefone'],
        dataCadastro: json['dataCadastro'],
        ativo: json['ativo'] ?? true,
      );

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'email': email,
        'senha': senha,
        if (telefone != null) 'telefone': telefone,
        if (dataCadastro != null) 'dataCadastro': dataCadastro,
      };
}
