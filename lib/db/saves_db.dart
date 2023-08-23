import 'package:path/path.dart';
import 'package:plant_recognition/model/info_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:plant_recognition/model/saves_model.dart';

class SavesDatabase {
  static final SavesDatabase instance = SavesDatabase._init();

  static Database? _database;

  SavesDatabase._init();

  // перевіряємо існування БД
  Future<Database> get database async {

    if (_database != null){
      return _database!;
    };

    _database = await _initDB('saves.db');
    return _database!;
  }

  // створюємо БД, при умові, що вона не створена
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Прописуємо створення таблиці
  Future _createDB(Database db, int version) async {
    // різні типи данних для БД
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    // створюємо першу таблицю із збереженнями
    await db.execute('''
CREATE TABLE $tableSaves ( 
  ${SaveFields.id} $idType, 
  ${SaveFields.isImportant} $boolType,
  ${SaveFields.clas} $textType,
  ${SaveFields.title} $textType,
  ${SaveFields.path} $textType,
  ${SaveFields.time} $textType
  )
''');

    // вторюємо другу таблицю із інформацією про рослини
    await db.execute('''
CREATE TABLE $tableInfo (
  ${InfoFields.id} $idType,
  ${InfoFields.isImportant} $boolType,
  ${InfoFields.clas} $textType,
  ${InfoFields.description} $textType,
  ${InfoFields.infection} $textType,
  ${InfoFields.symptoms} $textType,
  ${InfoFields.prevention} $textType
  )
''');
    for(var info in infos) {
      info.copy(
          id: info.id,
          isImportant: info.isImportant,
          clas: info.clas,
          description: info.description,
          infection: info.infection,
          symptoms: info.symptoms,
          prevention: info.prevention
      );
    }
  }

  // створюємо прописану таблицю у БД
  Future<Save> create(Save note) async {
    final db = await instance.database;

    final id = await db.insert(tableSaves, note.toJson());
    return note.copy(id: id);
  }

  // функція для зчитування даних з таблиці по id
  Future<Save> readSave(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableSaves,
      columns: SaveFields.values,
      where: '${SaveFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Save.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<Info> readInfo(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableInfo,
      columns: InfoFields.values,
      where: '${InfoFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Info.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  // зчитування усіх даних з таблиці
  Future<List<Save>> readAllSaves() async {
    final db = await instance.database;

    final orderBy = '${SaveFields.time} ASC';

    final result = await db.query(tableSaves, orderBy: orderBy);

    return result.map((json) => Save.fromJson(json)).toList();
  }

  Future<List<Info>> readAllInfo() async {
    final db = await instance.database;

    final orderBy = '${InfoFields.clas} ASC';

    final result = await db.query(tableInfo, orderBy: orderBy);

    return result.map((json) => Info.fromJson(json)).toList();
  }

  //оновлення даних
  Future<int> update(Save note) async {
    final db = await instance.database;

    return db.update(
      tableSaves,
      note.toJson(),
      where: '${SaveFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  //видалення даних
  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableSaves,
      where: '${SaveFields.id} = ?',
      whereArgs: [id],
    );
  }

  //завершення роботи БД
  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
