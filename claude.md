# Juan Delivery — Contexto do Projeto

## Visão Geral
Marketplace mobile de vinhos e acessórios de vinho, modelo iFood.
Vendedores cadastram produtos na plataforma, usuários compram pelo app.
Escopo do estágio: apenas a experiência do usuário/cliente.

## Stack
- **Backend:** Java 21, Spring Boot 3.4.5, Maven
- **Frontend:** Flutter 3.5 (Dart)
- **Banco:** PostgreSQL 18, porta 5433, banco: api_delivery
- **IDE:** VS Code + IntelliJ IDEA Ultimate
- **Versionamento:** GitHub

## Identidade Visual
- Cor primária: `#3C0731` (vinho escuro)
- Fundo: `#FAFAFA`
- Cards: branco com sombra suave
- Cantos arredondados: 12-16px
- Botões principais: fundo `#3C0731`, texto branco
- Erros inline: vermelho `#FF6B6B`
- SnackBar de erro: vermelho `Colors.red.shade700`, 5 segundos

## Arquitetura Backend
- Padrão 3 camadas: Controller → Service → Repository
- Herança SINGLE_TABLE na tabela `produtos` com discriminador `tipo_produto`
- Soft delete: nunca usar DELETE físico em `Usuario` e `Produto`, setar `ativo = false`
- Produtos com estoque zero são desativados automaticamente (`ativo = false`)
- `DataInitializer` cria admin padrão ao subir o backend

## Padrões de Erro
- `GlobalExceptionHandler` intercepta todas as exceções
- `MethodArgumentNotValidException` → `{"erros": ["msg1", "msg2"]}`
- `IllegalArgumentException` / `RuntimeException` → `{"erro": "mensagem"}`
- Sempre usar `@Valid` no `@RequestBody` nos controllers
- Flutter trata via `_parseErro()` já implementado nos services

## Padrões Flutter
- Pacote `http` puro — nunca usar Dio ou Retrofit
- Sessão: classe estática `SessaoUsuario` com campos `id`, `nome`, `email`, `perfil`
- Persistência de sessão: `shared_preferences`
- Navegação por perfil:
  - CLIENTE: Início, Busca, Pedidos, Perfil
  - ADMIN: Usuários, Produtos
- Erros de API exibidos inline embaixo do campo via `String? _xApiError`
- Sempre usar `Form` + `GlobalKey<FormState>` + `validator` nos formulários
- Carrinho: `CarrinhoController` com `ChangeNotifier` via `provider`

## Entidades Principais
- `Usuario`: id, nome, email, senha, telefone, cpf, dataCadastro, ativo, perfil
- `Produto` (abstract): id, nome, preco, descricao, imagemUrl, estoque, ativo
- `Vinho` extends Produto: categoria, paisOrigem, safra, teorAlcool, harmonizacao
- `Acessorio` extends Produto: tipoAcessorio, marca, material
- `Pedido`: id, usuario, status, dataPedido, valorTotal
- `ItemPedido`: id, quantidade, precoUnit, pedido, produto
- `Endereco`: id, rua, numero, bairro, cidade, estado, cep, usuario

## Enums
- `PerfilUsuario`: ADMIN, CLIENTE
- `StatusPedido`: PENDENTE, CONFIRMADO, EM_PREPARO, EM_ENTREGA, ENTREGUE, CANCELADO
- `CategoriaProduto`: VINHO_TINTO, VINHO_BRANCO, VINHO_ROSE, VINHO_ESPUMANTE, VINHO_SOBREMESA, VINHO_ORGANICO, VINHO_IMPORTADO
- `TipoProduto`: VINHO, ACESSORIO

## Endpoints Principais
- `POST /auth/login` → autenticação
- `GET/POST/PUT/DELETE /usuarios`
- `GET/POST/PUT/DELETE /produtos`
- `GET /produtos/admin` → todos incluindo inativos (só admin)
- `GET /produtos?categoria={}` → filtro por categoria
- `GET/POST/DELETE /usuarios/{id}/enderecos`
- `GET/POST/PATCH/DELETE /pedidos`
- `GET /pedidos/usuario/{usuarioId}`
- `GET/POST/DELETE /pedidos/{pedidoId}/itens`

## Regras de Negócio Importantes
- Produto com estoque 0 → `ativo = false` automaticamente
- Produto com estoque > 0 e inativo → reativar automaticamente
- Estoque > 0 obrigatório na criação, permitido 0 na edição
- CPF: exatamente 11 dígitos numéricos
- Telefone: 10 ou 11 dígitos numéricos
- CEP: exatamente 8 dígitos numéricos
- Safra: entre 1800 e 2025
- Teor alcoólico: entre 0.0 e 100.0
- Email único por usuário
- Todos os novos usuários criados via cadastro recebem perfil CLIENTE
- Admin padrão: email `admin@juan.com`, senha `admin`