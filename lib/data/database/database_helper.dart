import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/app_logger.dart';

const int _currentDbVersion = 6;

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: _currentDbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    AppLogger.i('Creating database v$version...');
    await db.execute('''
      CREATE TABLE ${AppConstants.gymTable} (
        ${AppConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppConstants.colName} TEXT NOT NULL,
        ${AppConstants.colAddress} TEXT NOT NULL,
        ${AppConstants.colPhoneNumber} TEXT NOT NULL,
        ${AppConstants.colEmail} TEXT NOT NULL,
        ${AppConstants.colDescription} TEXT NOT NULL,
        ${AppConstants.colImageUrl} TEXT NOT NULL,
        ${AppConstants.colRating} REAL NOT NULL,
        ${AppConstants.colLatitude} REAL NOT NULL,
        ${AppConstants.colLongitude} REAL NOT NULL,
        ${AppConstants.colOpeningHours} TEXT NOT NULL,
        ${AppConstants.colFacilities} TEXT NOT NULL,
        ${AppConstants.colCreatedBy} TEXT,
        ${AppConstants.colCreatedAt} TEXT NOT NULL,
        ${AppConstants.colUpdatedAt} TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        gym_id INTEGER NOT NULL UNIQUE,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE sync_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entity_type TEXT NOT NULL,
        entity_id INTEGER NOT NULL,
        action TEXT NOT NULL,
        data TEXT,
        created_at TEXT NOT NULL,
        retry_count INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE reviews (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        gym_id INTEGER NOT NULL,
        user_id TEXT NOT NULL,
        user_name TEXT NOT NULL,
        rating REAL NOT NULL,
        comment TEXT NOT NULL,
        photo_urls TEXT DEFAULT '',
        created_at TEXT NOT NULL
      )
    ''');

    await _insertSampleData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    AppLogger.i('Upgrading database from v$oldVersion to v$newVersion...');
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS favorites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          gym_id INTEGER NOT NULL UNIQUE,
          created_at TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS sync_queue (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          entity_type TEXT NOT NULL,
          entity_id INTEGER NOT NULL,
          action TEXT NOT NULL,
          data TEXT,
          created_at TEXT NOT NULL,
          retry_count INTEGER DEFAULT 0
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS reviews (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          gym_id INTEGER NOT NULL,
          user_id TEXT NOT NULL,
          user_name TEXT NOT NULL,
          rating REAL NOT NULL,
          comment TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 4) {
      await db.execute(
        "ALTER TABLE reviews ADD COLUMN photo_urls TEXT DEFAULT ''",
      );
    }
    if (oldVersion < 5) {
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_gyms_name ON ${AppConstants.gymTable}(${AppConstants.colName})',
      );
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_gyms_rating ON ${AppConstants.gymTable}(${AppConstants.colRating})',
      );
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_reviews_gym_id ON reviews(gym_id)',
      );
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_sync_queue_created ON sync_queue(created_at)',
      );
    }
    if (oldVersion < 6) {
      await db.execute(
        "ALTER TABLE ${AppConstants.gymTable} ADD COLUMN ${AppConstants.colCreatedBy} TEXT",
      );
    }
  }

  Future<void> _insertSampleData(Database db) async {
    final sampleGyms = [
      {
        'name': 'FitLife Gym',
        'address': '123 Main Street, Downtown',
        'phone_number': '+1234567890',
        'email': 'contact@fitlife.com',
        'description':
            'A modern fitness center with state-of-the-art equipment and professional trainers. We offer a wide range of classes including yoga, HIIT, spinning, and strength training.',
        'image_url':
            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800',
        'rating': 4.5,
        'latitude': 10.762622,
        'longitude': 106.660172,
        'opening_hours': '6:00 AM - 10:00 PM',
        'facilities': 'Pool,Sauna,Parking,WiFi,Lockers',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'PowerHouse Fitness',
        'address': '456 Oak Avenue, Midtown',
        'phone_number': '+1987654321',
        'email': 'info@powerhouse.com',
        'description':
            'Dedicated to helping you achieve your fitness goals with personalized training programs and nutrition guidance. Join our community of fitness enthusiasts!',
        'image_url':
            'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=800',
        'rating': 4.8,
        'latitude': 10.775622,
        'longitude': 106.670172,
        'opening_hours': '5:00 AM - 11:00 PM',
        'facilities': 'CrossFit,Boxing,Personal Training,Juice Bar',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Zen Yoga Studio',
        'address': '789 Peace Lane, Uptown',
        'phone_number': '+1122334455',
        'email': 'namaste@zenyoga.com',
        'description':
            'Find your inner peace with our yoga and meditation classes. Suitable for all levels from beginners to advanced practitioners.',
        'image_url':
            'https://images.unsplash.com/photo-1545205597-3d9d02c29597?w=800',
        'rating': 4.9,
        'latitude': 10.788622,
        'longitude': 106.680172,
        'opening_hours': '6:00 AM - 9:00 PM',
        'facilities': 'Yoga,Meditation,Spa,Wellness Center',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Iron Paradise',
        'address': '321 Steel Road, Industrial District',
        'phone_number': '+1555666777',
        'email': 'lift@ironparadise.com',
        'description':
            'The ultimate destination for serious lifters. Equipped with Olympic platforms, power racks, and a full range of free weights.',
        'image_url':
            'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=800',
        'rating': 4.6,
        'latitude': 10.752622,
        'longitude': 106.650172,
        'opening_hours': '24 Hours',
        'facilities': 'Weightlifting,Powerlifting,Supplements Store,Coaching',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Aqua Sports Center',
        'address': '567 River Boulevard, Waterfront',
        'phone_number': '+1888999000',
        'email': 'swim@aquasports.com',
        'description':
            'Premium aquatic facility featuring Olympic-size pools, water aerobics classes, and swimming lessons for all ages.',
        'image_url':
            'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?w=800',
        'rating': 4.7,
        'latitude': 10.742622,
        'longitude': 106.640172,
        'opening_hours': '5:30 AM - 9:30 PM',
        'facilities': 'Swimming Pool,Water Aerobics,Diving,Kids Area',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
    ];

    for (final gym in sampleGyms) {
      await db.insert(AppConstants.gymTable, gym);
    }
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<Map<String, dynamic>?> queryById(String table, int id) async {
    final db = await database;
    final results = await db.query(
      table,
      where: '${AppConstants.colId} = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> queryBySearch(
    String table,
    String searchColumn,
    String query,
  ) async {
    final db = await database;
    return await db.query(
      table,
      where: '$searchColumn LIKE ?',
      whereArgs: ['%$query%'],
    );
  }

  Future<List<Map<String, dynamic>>> queryWithFilter(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.query(table, where: where, whereArgs: whereArgs);
  }

  Future<int> update(String table, Map<String, dynamic> data, int id) async {
    final db = await database;
    return await db.update(
      table,
      data,
      where: '${AppConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: '${AppConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
