import 'dart:async';
import 'package:expenso/core/constants/default_categories.dart';
import 'package:expenso/data/models/budget.dart';
import 'package:flutter/material.dart';
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

  /// Notifier to alert listeners when the DB changes
  final ValueNotifier<int> expenseCountNotifier = ValueNotifier(0);

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

    // Budget table
    await db.execute('''
      CREATE TABLE budgets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL,
        month INTEGER,
        year INTEGER,
        type TEXT DEFAULT 'monthly'
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

  // Budget
  Future<int> insertBudget(Budget budget) async {
    final db = await database;
    await db.delete('budgets');
    return await db.insert('budgets', budget.toMap());
  }

  Future<List<Budget>> getAllBudgets() async {
    final db = await database;
    final res = await db.query('budgets', orderBy: "year DESC, month DESC");
    return res.map((b) => Budget.fromMap(b)).toList();
  }

  Future<int> deleteBudget(int id) async {
    final db = await database;
    return db.delete('budgets', where: "id = ?", whereArgs: [id]);
  }

  // CATEGORY METHODS
  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert(
      'categories',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    final res = await db.query('categories');
    return res.map((c) => Category.fromMap(c)).toList();
  }

  // EXPENSE METHODS
  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    final id = await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Notify listeners
    await _notifyExpenseCount();
    return id;
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    final result = await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );

    await _notifyExpenseCount();
    return result;
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    final result = await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );

    await _notifyExpenseCount();
    return result;
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    final res = await db.query('expenses');
    return res.map((e) => Expense.fromMap(e)).toList();
  }

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

  // STRUCTURED DATA
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

  // PRIVATE: NOTIFY
  Future<void> _notifyExpenseCount() async {
    final count = (await getAllExpenses()).length;
    expenseCountNotifier.value = count;
  }
}
