# Marketplace de Confeitarias

Este projeto é um aplicativo de marketplace desenvolvido com Flutter, onde os usuários podem visualizar e interagir com confeitarias e seus produtos. O sistema permite o cadastro de confeitarias e produtos, com funcionalidades de detalhamento e gerenciamento de dados.

## Regras de Negócio

- **Cadastro de Confeitarias**: O sistema permite que o usuário cadastre uma confeitaria, incluindo dados como nome, endereço, descrição, imagem, entre outros.
  
- **Cadastro de Produtos**: Um produto só pode ser criado a partir de uma confeitaria previamente cadastrada. Cada confeitaria pode possuir múltiplos produtos, como bolos, doces, entre outros.
  
- **Exclusão de Confeitarias**: Quando uma confeitaria é excluída, todos os produtos vinculados a ela também são removidos do sistema.

- **Validação de Dados**: O sistema valida os campos obrigatórios durante o cadastro de confeitarias e produtos para garantir a consistência dos dados.

## Funcionalidades

- **Listagem de Confeitarias**: Exibição das confeitarias cadastradas no sistema. O usuário pode visualizar informações como nome, avaliação e imagem da confeitaria.

- **Detalhamento da Confeitaria**: O usuário pode acessar os detalhes de uma confeitaria, visualizando mais informações, incluindo uma lista de produtos disponíveis.

- **Cadastro e Edição de Confeitarias e Produtos**: Permite o cadastro e a edição de confeitarias e produtos, com validação de campos obrigatórios.

## Tecnologias Utilizadas

- **Flutter**: Framework de desenvolvimento mobile utilizado para a criação da interface e lógica do aplicativo.
- **SQLite**: Banco de dados local utilizado para armazenar as informações de confeitarias e produtos.

## Estrutura do Banco de Dados

O banco de dados do projeto é composto por duas tabelas principais:

- **Confeitarias**: Armazena informações sobre as confeitarias, incluindo nome, endereço, email, telefone, descrição, avaliação, entre outros.
  
- **Produtos**: Armazena informações sobre os produtos disponíveis nas confeitarias, como nome, descrição, valor e imagem.

## Fluxo do Aplicativo

1. **Tela de Listagem de Confeitarias**: Exibe todas as confeitarias cadastradas. O usuário pode clicar em uma confeitaria para visualizar mais detalhes.

2. **Tela de Detalhes da Confeitaria**: Apresenta informações detalhadas sobre a confeitaria selecionada, como descrição, endereço e avaliação. Também exibe os produtos cadastrados para essa confeitaria.

3. **Cadastro de Confeitaria**: O usuário pode cadastrar uma nova confeitaria, informando dados como nome, endereço e descrição.

4. **Cadastro de Produto**: O usuário pode cadastrar produtos para uma confeitaria já cadastrada, incluindo nome, descrição e valor.

## Instalação

Para rodar o projeto localmente, siga as instruções abaixo:

### Pré-requisitos

- Flutter 2.0 ou superior
- SQLite para persistência de dados

### Passos para Instalação

1. Clone o repositório:
   ```bash
   git clone https://github.com/lukasreei/desafio_confeit.git
   ```

2. Navegue até o diretório do projeto:
   ```bash
   cd desafio_confeit
   ```

3. Instale as dependências:
   ```bash
   flutter pub get
   ```

4. Execute o projeto:
   ```bash
   flutter run
   ```
