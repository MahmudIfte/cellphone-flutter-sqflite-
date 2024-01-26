import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'cellphone.db';

  // Singleton instance of DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  // Getter for the database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  // Create the tables in the database
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        pid TEXT
      )
    ''');
  }

  // Insert a product into the database
  Future<int> insertProduct(Product product) async {
    final Database db = await instance.database;
    return await db.insert('products', product.toMap());
  }

  // Update a product in the database
  Future<int> updateProduct(Product product) async {
    final Database db = await instance.database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Delete a product from the database
  Future<int> deleteProduct(int id) async {
    final Database db = await instance.database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get all products from the database
  Future<List<Product>> getProducts() async {
    final Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (index) => Product.fromMap(maps[index]));
  }
}

class Product {
  int? id;
  String name;
  String pid;

  Product({this.id, required this.name, required this.pid});

  // Convert a Product object into a Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pid': pid,
    };
  }

  // Convert a Map object from the database into a Product object
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      pid: map['pid'],
    );
  }
}