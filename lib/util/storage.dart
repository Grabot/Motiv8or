import 'package:motivator/objects/bro_bros.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class Storage {
  static const _dbName = "brocast.db";

  static final Storage _instance = Storage._internal();

  var based;

  factory Storage() {
    return _instance;
  }

  Storage._internal();

  Future<Database> get database async {
    if (based != null) return based;
    // Instantiate the database only when it's not been initialized yet.
    based = await _initDatabase();
    return based;
  }

  // Creates and opens the database.
  _initDatabase() async {
    print("initializing the database");
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Creates the database structure (unless database has already been created)
  Future _onCreate(
      Database db,
      int version,
      ) async {
    print("executing query");
    await db.execute('''
          CREATE TABLE BroBros (
            id INTEGER PRIMARY KEY,
            lastActivity TEXT,
            chatName TEXT NOT NULL,
            chatDescription TEXT,
            alias TEXT,
            chatColor TEXT,
            roomName TEXT,
            unreadMessages INTEGER,
            blocked INTEGER,
            mute INTEGER,
            isBroup INTEGER
          )
          ''');
  }

  Future<int> addBroBros(BroBros broBros) async {
    Database database = await this.database;
    return database.insert(
      'BroBros',
      broBros.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BroBros>> fetchAllBroBros() async {
    Database database = await this.database;
    List<Map<String, dynamic>> maps = await database.query('BroBros');
    if (maps.isNotEmpty) {
      return maps.map((map) => BroBros.fromDbMap(map)).toList();
    }
    return List.empty();
  }

  Future<BroBros?> selectBroBros(int id) async {
    print("selecting bro");
    Database database = await this.database;
    String query = "SELECT * FROM BroBros where id = " + id.toString();
    print(query);
    List<Map<String, dynamic>> bro = await database.rawQuery(query);
    print(bro);
    if (bro.length != 1) {
      return null;
    } else {
      return BroBros.fromDbMap(bro[0]);
    }
  }

  Future<int> updateBroBros(BroBros broBros) async {
    Database database = await this.database;
    return database.update(
      'BroBros',
      broBros.toDbMap(),
      where: 'id = ?',
      whereArgs: [broBros.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteBroBros(int id) async {
    Database database = await this.database;
    return database.delete(
      'BroBros',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}