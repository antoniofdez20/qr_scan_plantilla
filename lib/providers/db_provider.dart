import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/* La clase DBProvider está diseñada para gestionar operaciones de base de datos en esta aplicación que 
* utiliza SQLite. Se implementa como un singleton, lo que significa que solo existirá 
* una instancia de esta clase durante el ciclo de vida de la aplicación, 
* asegurando un único punto de acceso a la base de datos.  */
class DBProvider {
  static Database? _database;

  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database == null) _database = await initDB();

    return _database!;
  }

  Future<Database> initDB() async {
    //Obtenir el path
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'Scans.db');
    //print(path);

    //Creacio de la BBDD
    return await openDatabase(
      path,
      version: 1,
      onOpen: ((db) {}),
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE Scans(
          id INTEGER PRIMARY KEY,
          tipus TEXT,
          valor TEXT
        )
      ''');
      },
    );
  }

  Future<int> insertRawScan(ScanModel nouScan) async {
    final id = nouScan.id;
    final tipus = nouScan.tipus;
    final valor = nouScan.valor;

    final db = await database;
    final res = await db.rawInsert('''
      INSERT INTO Scans(id, tipus, valor)
        VALUES ($id, $tipus, $valor)
    ''');
    return res;
  }

  Future<int> insertScan(ScanModel nouScan) async {
    final db = await database;
    final res = await db.insert('Scans', nouScan.toMap());
    //print(res);
    return res;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db = await database;

    final res = await db.query('Scans');

    return res.isNotEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

  Future<ScanModel?> getScanById(int id) async {
    final db = await database;

    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    if (res.isNotEmpty) {
      return ScanModel.fromMap(res.first);
    }
    return null;
  }

  Future<List<ScanModel>> getScanByTipus(String tipus) async {
    final db = await database;

    final res = await db.query('Scans', where: 'tipus = ?', whereArgs: [tipus]);

    return res.isNotEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

  Future<int> updateScan(ScanModel nouScan) async {
    final db = await database;
    final res = await db.update('Scans', nouScan.toMap(),
        where: 'id = ?', whereArgs: [nouScan.id]);

    return res;
  }

  Future<int> deleteAllScans() async {
    final db = await database;

    final res = await db.rawDelete('''
      DELETE FROM Scans
    ''');

    return res;
  }

  Future<int> deleteScansbyId(int id) async {
    final db = await database;

    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return res;
  }

  Future<int> countByTipus(String tipus) async {
    final db = await database;

    final res = await db.rawQuery('''
      SELECT COUNT(*) as count FROM Scans WHERE tipus = '$tipus'
    ''');

    return res[0]['count'] as int;
  }
}
