import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:orange_shopping/assets/product.dart';

class DatabaseHelper {
  static Future<Database> openMyDatabase() async {
    return openDatabase(
      p.join(await getDatabasesPath(), 'my_database.db'),
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE Product(
            id INTEGER PRIMARY KEY,
            name TEXT,
            image_url TEXT,
            price INTEGER,
            category TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE Store(
            id INTEGER PRIMARY KEY,
            name TEXT,
            image_url TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE StoreProduct(
            store_id INTEGER,
            product_id INTEGER,
            FOREIGN KEY(store_id) REFERENCES Store(id),
            FOREIGN KEY(product_id) REFERENCES Product(id)
          )
        ''');
      },
      version: 1,
    );
  }

  // Add functions to insert, retrieve, update, or delete data here
  Future<void> addToCart(int userId, int productId) async {
    final db = await openMyDatabase();
    await db.insert(
      'UserCart',
      {
        'user_id': userId,
        'product_id': productId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

   Future<List<Product>> getCartProducts(int userId) async {
    final db = await openMyDatabase();
    final results = await db.rawQuery('''
      SELECT p.*
      FROM Product p
      JOIN UserCart uc ON p.id = uc.product_id
      WHERE uc.user_id = ?
    ''', [userId]);

    return results.map((row) {
      return Product(
        row['id'] as int,
        row['name'] as String,
        row['image_url'] as String,
        row['price'] as int,
        row['category'] as String,
      );
    }).toList();
  }
}
