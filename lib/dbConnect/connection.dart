import 'dart:async';
import 'package:calculator/models/ingredient.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:calculator/models/model.dart';

class Connection {
  static final Connection instance = Connection._init();

  static Database? _database;

  Connection._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('kcal.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  FutureOr<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const stringType = 'STRING NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
    CREATE TABLE $tableIngredients (
    ${IngredientFields.id} $idType,
    ${IngredientFields.nomIngredient} $stringType,
    ${IngredientFields.kcal} $realType,
    ${IngredientFields.lipides} $realType,
    ${IngredientFields.glucides} $realType,
    ${IngredientFields.proteines} $realType
    )
    ''');
  }

  Future<Ingredient> create(Ingredient ingredient) async {
    final db = await instance.database;

    //final json = ingredient.toJson();
    //final columns =
    //    '${IngredientFields.id}, ${IngredientFields.nomIngredient}, ${IngredientFields.kcal}, ${IngredientFields.lipides}, ${IngredientFields.glucides}, ${IngredientFields.proteines}';
    //final values =
    //    '${json[IngredientFields.id]}, ${json[IngredientFields.nomIngredient]},  ${json[IngredientFields.kcal]}, ${json[IngredientFields.lipides]},${json[IngredientFields.glucides]},${json[IngredientFields.proteines]},';
    //final id = await db
    //.rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableIngredients, ingredient.toJson());
    return ingredient.copy(id: id);
  }

  Future<Ingredient> readIngredient(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableIngredients,
      columns: IngredientFields.values,
      where: '${IngredientFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Ingredient.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Ingredient>> readAllIngredients() async {
    final db = await instance.database;
    const orderBy = '${IngredientFields.nomIngredient} ASC';
    //final result =
    //    await db.rawQuery('SELECT * FROM $tableIngredients ORDERBY $orderBy');
    final result = await db.query(tableIngredients, orderBy: orderBy);

    return result.map((json) => Ingredient.fromJson(json)).toList();
  }

  Future<int> update(Ingredient ingredient) async {
    final db = await instance.database;

    return db.update(
      tableIngredients,
      ingredient.toJson(),
      where: '${IngredientFields.id} = ?',
        whereArgs: [ingredient.id],
    );
  }
  
  Future<int> delete(int id) async{
    final db = await instance.database;
    
    return await db.delete(
      tableIngredients,
      where: '${IngredientFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

/*
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'ingredient.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE "ingredients" ( "id" INTEGER, "nomIngredient" REAL, "kcal" REAL,"lipides" REAL,"glucides" REAL,"proteines" REAL,PRIMARY KEY("id" AUTOINCREMENT));',
        );
      },
      version: 1,
    );
  }



  static Future<List<Map<String, dynamic>>> query(String table) async =>
      _db.query(table);

  static Future<int> insert(String table, Model model) async =>
      await _db.insert(table, model.toMap());

  static Future<int> update(String table, Model model) async => await _db
      .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(String table, Model model) async =>
      await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);

  Future<Database> initializeDB() async {
    if(_database != null) return _database;

    _database = await _initDB('kcal.db');
  }
*/
