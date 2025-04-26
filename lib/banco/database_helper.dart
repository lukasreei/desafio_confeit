import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();
  DatabaseHelper();

  // Nome do banco de dados e versão
  static final _databaseName = "marketplace.db";
  static final _databaseVersion = 6;

  // Nome das tabelas
  static final tableConfeitaria = 'confeitaria';
  static final tableProduto = 'produto';

  // Colunas da tabela Confeitaria
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

  // Colunas da tabela Produto
  static final columnIdProduto = 'id';
  static final columnNomeProduto = 'nome';
  static final columnDescricaoProduto = 'descricao';
  static final columnValorProduto = 'valor';
  static final columnImagemProduto = 'imagem';
  static final columnConfeitariaIdProduto = 'confeitariaId';

  // Instância do banco de dados
  static Database? _database;

  // Getter para o banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializa o banco de dados
  Future<Database> _initDatabase() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, _databaseName);

    // Apaga o banco de dados antigo para recriar
    await deleteDatabase(path);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Criação das tabelas
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
        $columnCidadeConfeitaria TEXT
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

  // Atualização da tabela caso a versão seja maior
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE $tableConfeitaria ADD COLUMN $columnAvaliacaoConfeitaria REAL
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        ALTER TABLE $tableConfeitaria ADD COLUMN $columnEnderecoConfeitaria TEXT
      ''');
    }
    if (oldVersion < 4) {
      await db.execute('''
        ALTER TABLE $tableConfeitaria ADD COLUMN $columnEmailConfeitaria TEXT
      ''');
    }
    if (oldVersion < 5) {
      await db.execute('''
        ALTER TABLE $tableConfeitaria ADD COLUMN $columnCepConfeitaria TEXT
      ''');
    }
    if (oldVersion < 6) {
      await db.execute('''
        ALTER TABLE $tableConfeitaria ADD COLUMN $columnRuaConfeitaria TEXT
      ''');
      await db.execute('''
        ALTER TABLE $tableConfeitaria ADD COLUMN $columnNumeroConfeitaria TEXT
      ''');
      await db.execute('''
        ALTER TABLE $tableConfeitaria ADD COLUMN $columnBairroConfeitaria TEXT
      ''');
      await db.execute('''
        ALTER TABLE $tableConfeitaria ADD COLUMN $columnEstadoConfeitaria TEXT
      ''');
      await db.execute('''
        ALTER TABLE $tableConfeitaria ADD COLUMN $columnCidadeConfeitaria TEXT
      ''');
    }
  }

  // Inserir Confeitaria
  Future<int> insertConfeitaria(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(tableConfeitaria, row);
  }

  // Inserir Produto
  Future<int> insertProduto(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(tableProduto, row);
  }

  // Atualizar Confeitaria
  Future<int> updateConfeitaria(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[columnIdConfeitaria];
    return await db.update(tableConfeitaria, row, where: '$columnIdConfeitaria = ?', whereArgs: [id]);
  }

  // Atualizar Produto
  Future<int> updateProduto(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[columnIdProduto];
    return await db.update(tableProduto, row, where: '$columnIdProduto = ?', whereArgs: [id]);
  }

  // Buscar todas as Confeitarias
  Future<List<Map<String, dynamic>>> getConfeitarias() async {
    Database db = await database;
    return await db.query(tableConfeitaria);
  }

  // Buscar confeitaria por ID
  Future<Map<String, dynamic>?> getConfeitaria(int id) async {
    Database db = await database;
    var result = await db.query(tableConfeitaria, where: '$columnIdConfeitaria = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // Buscar produtos por confeitaria
  Future<List<Map<String, dynamic>>> getProdutos(int confeitariaId) async {
    Database db = await database;
    return await db.query(tableProduto, where: '$columnConfeitariaIdProduto = ?', whereArgs: [confeitariaId]);
  }

  // Buscar produto por ID
  Future<Map<String, dynamic>?> getProduto(int id) async {
    Database db = await database;
    var result = await db.query(tableProduto, where: '$columnIdProduto = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // Deletar confeitaria
  Future<int> deleteConfeitaria(int id) async {
    Database db = await database;
    return await db.delete(tableConfeitaria, where: '$columnIdConfeitaria = ?', whereArgs: [id]);
  }

  // Deletar produto
  Future<int> deleteProduto(int id) async {
    Database db = await database;
    return await db.delete(tableProduto, where: '$columnIdProduto = ?', whereArgs: [id]);
  }

  // Limpar banco (teste)
  Future<void> deleteAll() async {
    Database db = await database;
    await db.delete(tableConfeitaria);
    await db.delete(tableProduto);
  }
}
