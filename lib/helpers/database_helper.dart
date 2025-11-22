import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/book.dart';
import '../models/borrowing.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('perpustakaan.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT NOT NULL,
        nik TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        address TEXT NOT NULL,
        phone TEXT NOT NULL,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        genre TEXT NOT NULL,
        pricePerDay REAL NOT NULL,
        coverUrl TEXT NOT NULL,
        synopsis TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE borrowings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        bookId INTEGER NOT NULL,
        bookTitle TEXT NOT NULL,
        bookCover TEXT NOT NULL,
        bookGenre TEXT NOT NULL,
        bookPricePerDay REAL NOT NULL,
        borrowerName TEXT NOT NULL,
        durationDays INTEGER NOT NULL,
        startDate TEXT NOT NULL,
        totalCost REAL NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id),
        FOREIGN KEY (bookId) REFERENCES books (id)
      )
    ''');

    await _insertDummyBooks(db);
  }

  Future<void> _insertDummyBooks(Database db) async {
    final books = [
      {
        'title': 'Clean Code',
        'genre': 'Programming',
        'pricePerDay': 8000.0,
        'coverUrl':
            'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=400',
        'synopsis':
            'A handbook of agile software craftsmanship teaching principles and best practices for writing clean, maintainable code.',
      },
      {
        'title': 'Artificial Intelligence: A Modern Approach',
        'genre': 'AI & Machine Learning',
        'pricePerDay': 9000.0,
        'coverUrl':
            'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=400',
        'synopsis':
            'Comprehensive introduction to AI covering intelligent agents, problem-solving, knowledge reasoning, and machine learning.',
      },
      {
        'title': 'The Pragmatic Programmer',
        'genre': 'Software Development',
        'pricePerDay': 7500.0,
        'coverUrl':
            'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400',
        'synopsis':
            'Essential wisdom and practical techniques for software developers to craft better software and rediscover the joy of coding.',
      },
      {
        'title': 'Designing Data-Intensive Applications',
        'genre': 'Database & Systems',
        'pricePerDay': 8500.0,
        'coverUrl':
            'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=400',
        'synopsis':
            'Navigate the diverse landscape of technologies for processing and storing data in modern applications.',
      },
      {
        'title': 'Introduction to Algorithms',
        'genre': 'Computer Science',
        'pricePerDay': 9500.0,
        'coverUrl':
            'https://images.unsplash.com/photo-1509228627152-72ae9ae6848d?w=400',
        'synopsis':
            'Comprehensive text on algorithms covering design, analysis, and implementation with mathematical rigor.',
      },
      {
        'title': 'Deep Learning',
        'genre': 'AI & Machine Learning',
        'pricePerDay': 10000.0,
        'coverUrl':
            'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?w=400',
        'synopsis':
            'Comprehensive introduction to deep learning, covering neural networks, optimization, and advanced architectures.',
      },
      {
        'title': 'Cybersecurity Essentials',
        'genre': 'Security',
        'pricePerDay': 7000.0,
        'coverUrl':
            'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=400',
        'synopsis':
            'Learn fundamental principles of cybersecurity, threat detection, and protection strategies for modern systems.',
      },
      {
        'title': 'Cloud Computing Architecture',
        'genre': 'Cloud & DevOps',
        'pricePerDay': 8000.0,
        'coverUrl':
            'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=400',
        'synopsis':
            'Master cloud computing concepts, architecture patterns, and deployment strategies for scalable applications.',
      },
      {
        'title': 'Mobile App Development Guide',
        'genre': 'Mobile Development',
        'pricePerDay': 7500.0,
        'coverUrl':
            'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=400',
        'synopsis':
            'Complete guide to building native and cross-platform mobile applications with modern frameworks and tools.',
      },
      {
        'title': 'Blockchain Technology Fundamentals',
        'genre': 'Emerging Tech',
        'pricePerDay': 8500.0,
        'coverUrl':
            'https://images.unsplash.com/photo-1639762681485-074b7f938ba0?w=400',
        'synopsis':
            'Understanding blockchain architecture, cryptocurrency, smart contracts, and decentralized applications.',
      },
    ];

    for (var book in books) {
      await db.insert('books', book);
    }
  }

  Future<int> createUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByEmailOrNik(String emailOrNik) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ? OR nik = ?',
      whereArgs: [emailOrNik, emailOrNik],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> isEmailExists(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return maps.isNotEmpty;
  }

  Future<bool> isUsernameExists(String username) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return maps.isNotEmpty;
  }

  Future<List<Book>> getAllBooks() async {
    final db = await database;
    final maps = await db.query('books');
    return maps.map((map) => Book.fromMap(map)).toList();
  }

  Future<Book?> getBookById(int id) async {
    final db = await database;
    final maps = await db.query('books', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Book.fromMap(maps.first);
    }
    return null;
  }

  Future<int> createBorrowing(Borrowing borrowing) async {
    final db = await database;
    return await db.insert('borrowings', borrowing.toMap());
  }

  Future<List<Borrowing>> getBorrowingsByUserId(int userId) async {
    final db = await database;
    final maps = await db.query(
      'borrowings',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
    return maps.map((map) => Borrowing.fromMap(map)).toList();
  }

  Future<Borrowing?> getBorrowingById(int id) async {
    final db = await database;
    final maps = await db.query('borrowings', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Borrowing.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateBorrowing(Borrowing borrowing) async {
    final db = await database;
    return await db.update(
      'borrowings',
      borrowing.toMap(),
      where: 'id = ?',
      whereArgs: [borrowing.id],
    );
  }

  Future<int> updateBorrowingStatus(int id, String status) async {
    final db = await database;
    return await db.update(
      'borrowings',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
