import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rook_flutter/database/gamemapper.dart';
import 'package:rook_flutter/database/matchmapper.dart';
import 'package:sqflite/sqflite.dart';
// database table and column names

// data model class

abstract class DTOMapper {
  DTOMapper fromMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap();

  String getTable();

  DTOMapper createInstance();
}

// singleton class to manage the database
class DatabaseControl {
  // Saved in the docs directory.
  static final String dbFile = "RookGameState.db";

  // Increment this version when you need to change the schema.
  static final databaseVersion = 4;

  // Make this a singleton class.
  DatabaseControl.privateConstructor();

  static final DatabaseControl instance = DatabaseControl.privateConstructor();

  // Keep it simple 1 connection.
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  // open the database
  initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbFile);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: databaseVersion, onCreate: onCreate, onUpgrade: onUpgrade);
  }

  Future onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('''
              DROP TABLE IF EXISTS $MatchTable;''');
    await db.execute('''
              DROP TABLE IF EXISTS $GameTable;''');
    await onCreate(db, newVersion);
  }

  // SQL string to create the database
  Future onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $MatchTable (
                $MatchColumnId INTEGER PRIMARY KEY,
                $MatchColumnGameId INTEGER NOT NULL,
                $MatchColumnBidder INTEGER NOT NULL,
                $MatchColumnBid INTEGER NOT NULL,
                $MatchColumnPartnerOne INTEGER NOT NULL,
                $MatchColumnPartnerTwo INTEGER,
                $MatchColumnMade INTEGER NOT NULL)
              ''');
    await db.execute('''      
               CREATE TABLE $GameTable (
                $GameColumnId INTEGER PRIMARY KEY,
                $GameColumnPlayerOne INTEGER NOT NULL,
                $GameColumnPlayerTwo INTEGER NOT NULL,
                $GameColumnPlayerThree INTEGER NOT NULL,
                $GameColumnPlayerFour INTEGER NOT NULL,
                $GameColumnPlayerFive INTEGER,
                $GameColumnPlayerSix INTEGER)
              ''');
//                $GameColumnCreatedDate TEXT NOT NULL,
  }

  Future<int> insert<T extends DTOMapper>(T mapper) async {
    Database db = await database;
    int id = await db.insert(mapper.getTable(), mapper.toMap());
    return id;
  }

  Future<List> loadAll<T extends DTOMapper>(T mapper) async {
    Database db = await database;
    List<Map> maps = await db.query(mapper.getTable());
    if (maps == null || maps.isEmpty) {
      return List();
    }
    return maps.map((m) => mapper.createInstance().fromMap(m)).toList();
  }

  Future<int> deleteAll<T extends DTOMapper>(T mapper) async {
    Database db = await database;
    int id = await db.delete(mapper.getTable());
    return id;
  }
}
