import 'dart:async';
import 'package:expenso/core/constants/default_categories.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/category.dart';
import '../models/expense.dart';
import '../models/day_data.dart';
import '../models/month_data.dart';
import '../models/year_data.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'expenses.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // Category table
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY,
        name TEXT,
        iconCodePoint INTEGER,
        fontFamily TEXT,
        state TEXT
      )
    ''');

    // Expense table
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        price REAL,
        categoryIds TEXT,
        note TEXT,
        dateTime TEXT
      )
    ''');

    // Insert default categories
    for (var category in categories) {
      await db.insert('categories', {
        'id': category.id,
        'name': category.name,
        'iconCodePoint': category.icon.codePoint,
        'fontFamily': category.icon.fontFamily,
        'state': category.state,
      });
    }
  }

  // Insert a category
  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert(
      'categories',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Insert an expense
  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all categories
  Future<List<Category>> getCategories() async {
    final db = await database;
    final res = await db.query('categories');
    return res.map((c) => Category.fromMap(c)).toList();
  }

  // Fetch expenses by date
  Future<List<Expense>> getExpensesByDate(DateTime date) async {
    final db = await database;
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(Duration(days: 1));

    final res = await db.query(
      'expenses',
      where: 'dateTime >= ? AND dateTime < ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );

    return res.map((e) => Expense.fromMap(e)).toList();
  }

  // Fetch all expenses
  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    final res = await db.query('expenses');
    return res.map((e) => Expense.fromMap(e)).toList();
  }

  // Update an expense
  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  // Delete an expense
  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  // Optional: Build YearData from all expenses
  Future<List<YearData>> getAllDataStructured() async {
    final expenses = await getAllExpenses();
    Map<String, YearData> yearsMap = {};

    for (var e in expenses) {
      final y = e.dateTime.year.toString();
      final m = e.dateTime.month.toString().padLeft(2, '0');
      final d = e.dateTime.day.toString().padLeft(2, '0');

      if (!yearsMap.containsKey(y)) yearsMap[y] = YearData(year: y, months: []);
      var yearData = yearsMap[y]!;

      var monthData = yearData.months.firstWhere(
        (month) => month.month == m,
        orElse: () {
          final md = MonthData(month: m, days: []);
          yearData.months.add(md);
          return md;
        },
      );

      var dayData = monthData.days.firstWhere(
        (day) => day.day == d,
        orElse: () {
          final dd = DayData(day: d, expenses: []);
          monthData.days.add(dd);
          return dd;
        },
      );

      dayData.expenses.add(e);
    }

    return yearsMap.values.toList();
  }
}
