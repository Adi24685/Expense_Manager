import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Database? _database;

Future<Database> initializeDatabase() async {
  if (_database != null) return _database!;

  _database = await openDatabase(
    join(await getDatabasesPath(), 'transactions.db'),
    version: 2, // Increment the version number
    onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion < 2) {
        db.execute('ALTER TABLE transactions ADD COLUMN timestamp TEXT');
      }
    },
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE transactions('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'receiver TEXT NOT NULL,'
        'amount REAL NOT NULL,'
        'category TEXT NOT NULL,'
        'timestamp TEXT NOT NULL)',
      );
    },
  );

  return _database!;
}


Future<void> sendData(String receiver, double amount, String category) async {
  final db = await initializeDatabase();

  if (receiver.isEmpty || category.isEmpty || amount <= 0) {
    throw Exception('Invalid transaction data');
  }

  await db.insert(
    'transactions',
    {
      'receiver': receiver,
      'amount': amount,
      'category': category,
      'timestamp': DateTime.now().toIso8601String(),
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Map<String, dynamic>>> fetchTransactions() async {
  final db = await initializeDatabase();
  return await db.query('transactions', orderBy: 'id DESC');
}