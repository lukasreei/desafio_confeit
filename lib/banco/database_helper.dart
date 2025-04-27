import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();
  DatabaseHelper();

  static final _databaseName = "marketplace.db";
  static final _databaseVersion = 7;

  static final tableConfeitaria = 'confeitaria';
  static final tableProduto = 'produto';

  static final columnIdConfeitaria = 'id';
  static final columnNomeConfeitaria = 'nome';
  static final columnEnderecoConfeitaria = 'endereco';
  static final columnEmailConfeitaria = 'email';
  static final columnDescricaoConfeitaria = 'descricao';
  static final columnImagemConfeitaria = 'imagem';
  static final columnTelefoneConfeitaria = 'telefone';
  static final columnAvaliacaoConfeitaria = 'avaliacao';
  static final columnCepConfeitaria = 'cep';
  static final columnRuaConfeitaria = 'rua';
  static final columnNumeroConfeitaria = 'numero';
  static final columnBairroConfeitaria = 'bairro';
  static final columnEstadoConfeitaria = 'estado';
  static final columnCidadeConfeitaria = 'cidade';
  static final columnSenhaConfeitaria = 'senha';

  static final columnIdProduto = 'id';
  static final columnNomeProduto = 'nome';
  static final columnDescricaoProduto = 'descricao';
  static final columnValorProduto = 'valor';
  static final columnImagemProduto = 'imagem';
  static final columnConfeitariaIdProduto = 'confeitariaId';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, _databaseName);

    await deleteDatabase(path);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Função de consulta com email e senha
  Future<Map<String, dynamic>?> getConfeitariaByEmailSenha(String email, String senha) async {
    final db = await database;
    final result = await db.query(
      'confeitaria',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  // Criação da tabela com a coluna de senha
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE $tableConfeitaria (
        $columnIdConfeitaria INTEGER PRIMARY KEY,
        $columnNomeConfeitaria TEXT NOT NULL,
        $columnEnderecoConfeitaria TEXT,
        $columnEmailConfeitaria TEXT,
        $columnDescricaoConfeitaria TEXT,
        $columnImagemConfeitaria TEXT,
        $columnTelefoneConfeitaria TEXT,
        $columnAvaliacaoConfeitaria REAL,
        $columnCepConfeitaria TEXT,
        $columnRuaConfeitaria TEXT,
        $columnNumeroConfeitaria TEXT,
        $columnBairroConfeitaria TEXT,
        $columnEstadoConfeitaria TEXT,
        $columnCidadeConfeitaria TEXT,
        $columnSenhaConfeitaria TEXT NOT NULL  -- Adicionando o campo de senha
      )
    ''');

    await db.execute(''' 
      CREATE TABLE $tableProduto (
        $columnIdProduto INTEGER PRIMARY KEY,
        $columnNomeProduto TEXT NOT NULL,
        $columnDescricaoProduto TEXT,
        $columnValorProduto REAL NOT NULL,
        $columnImagemProduto TEXT,
        $columnConfeitariaIdProduto INTEGER,
        FOREIGN KEY ($columnConfeitariaIdProduto) REFERENCES $tableConfeitaria($columnIdConfeitaria)
      )
    ''');
  }

  // Alteração para incluir a senha no upgrade do banco de dados
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 7) {  // Atualização para versão 7 (onde a senha será adicionada)
      await db.execute('''
        ALTER TABLE $tableConfeitaria ADD COLUMN $columnSenhaConfeitaria TEXT NOT NULL
      ''');
    }
    // Outras verificações de versão podem ser adicionadas aqui
  }

  // Inserção da confeitaria com senha
  Future<int> insertConfeitaria(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(tableConfeitaria, row);
  }

  // Inserção de produtos
  Future<int> insertProduto(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(tableProduto, row);
  }

  // Atualização de confeitaria
  Future<int> updateConfeitaria(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[columnIdConfeitaria];
    return await db.update(tableConfeitaria, row, where: '$columnIdConfeitaria = ?', whereArgs: [id]);
  }

  // Atualização de produtos
  Future<int> updateProduto(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[columnIdProduto];
    return await db.update(tableProduto, row, where: '$columnIdProduto = ?', whereArgs: [id]);
  }

  // Consultar todas as confeitarias
  Future<List<Map<String, dynamic>>> getConfeitarias() async {
    Database db = await database;
    return await db.query(tableConfeitaria);
  }

  // Consultar uma confeitaria por id
  Future<Map<String, dynamic>?> getConfeitaria(int id) async {
    Database db = await database;
    var result = await db.query(tableConfeitaria, where: '$columnIdConfeitaria = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // Consultar produtos de uma confeitaria
  Future<List<Map<String, dynamic>>> getProdutos(int confeitariaId) async {
    Database db = await database;
    return await db.query(tableProduto, where: '$columnConfeitariaIdProduto = ?', whereArgs: [confeitariaId]);
  }

  // Consultar um produto por id
  Future<Map<String, dynamic>?> getProduto(int id) async {
    Database db = await database;
    var result = await db.query(tableProduto, where: '$columnIdProduto = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // Deletar confeitaria por id
  Future<int> deleteConfeitaria(int id) async {
    Database db = await database;
    return await db.delete(tableConfeitaria, where: '$columnIdConfeitaria = ?', whereArgs: [id]);
  }

  // Deletar produto por id
  Future<int> deleteProduto(int id) async {
    Database db = await database;
    return await db.delete(tableProduto, where: '$columnIdProduto = ?', whereArgs: [id]);
  }

  // Deletar todas as entradas
  Future<void> deleteAll() async {
    Database db = await database;
    await db.delete(tableConfeitaria);
    await db.delete(tableProduto);
  }
}
