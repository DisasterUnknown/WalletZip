import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expenso/core/constants/default_categories.dart';
import 'package:expenso/core/shared_prefs/shared_pref_service.dart';
import 'package:expenso/data/db/db_helper.dart';
import 'package:expenso/data/models/expense.dart';
import 'package:expenso/data/models/category.dart';
import 'widgets/date_time_picker_row.dart';
import 'widgets/transaction_type_toggle.dart';
import 'widgets/category_selector.dart';
import 'widgets/expense_text_field.dart';
import 'widgets/submit_button.dart';

class AddExpenseOverlay extends StatefulWidget {
  const AddExpenseOverlay({super.key});

  @override
  State<AddExpenseOverlay> createState() => _AddExpenseOverlayState();
}

class _AddExpenseOverlayState extends State<AddExpenseOverlay> {
  String selectedYear = DateTime.now().year.toString();
  String selectedMonth = DateFormat('MMMM').format(DateTime.now());
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String transactionType = 'Expense';
  List<Category> userCategories = [];
  List<int> selectedCategoryIds = [];

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;

  Color get accentColor =>
      transactionType == 'Expense' ? Colors.redAccent : Colors.greenAccent;

  @override
  void initState() {
    super.initState();
    _loadUserCategories();
  }

  Future<void> _loadUserCategories() async {
    final saved = await LocalSharedPreferences.getString('selected_categories');
    if (saved != null && saved.isNotEmpty) {
      final ids = saved
          .split(',')
          .map((e) => int.tryParse(e))
          .whereType<int>()
          .toSet();
      setState(() {
        userCategories = categories
            .where((cat) => ids.contains(cat.id))
            .toList();
      });
    } else {
      setState(() => userCategories = categories);
    }
  }

  void _toggleCategory(Category category) {
    setState(() {
      if (selectedCategoryIds.contains(category.id)) {
        selectedCategoryIds.remove(category.id);
      } else {
        selectedCategoryIds.add(category.id);
      }
    });
  }

  void _submitExpense() async {
    setState(() => errorMessage = null);

    if (!_formKey.currentState!.validate()) return;

    if (selectedCategoryIds.isEmpty) {
      setState(() => errorMessage = 'Please select at least one category!');
      return;
    }

    final amount = double.tryParse((amountController.text).replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      setState(() => errorMessage = 'Please enter a valid amount!');
      return;
    }

    final expense = Expense(
      type: transactionType.toLowerCase(),
      price: amount,
      categoryIds: selectedCategoryIds,
      note: descriptionController.text,
      dateTime: DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      ),
    );

    // Save to DB
    await DBHelper().insertExpense(expense);

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accentColor.withAlpha(180), width: 1.5),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      transactionType == 'Expense'
                          ? 'Add Expense'
                          : 'Add Income',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// Date + Time pickers
                    DateTimePickerRow(
                      selectedDate: selectedDate,
                      selectedTime: selectedTime,
                      accentColor: accentColor,
                      onPickDate: (date) => setState(() {
                        selectedDate = date;
                        selectedYear = date.year.toString();
                        selectedMonth = DateFormat('MMMM').format(date);
                      }),
                      onPickTime: (time) => setState(() => selectedTime = time),
                    ),
                    const SizedBox(height: 10),

                    /// Amount & Description fields
                    ExpenseTextField(
                      controller: amountController,
                      label: 'Amount',
                      accentColor: accentColor,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Enter amount' : null,
                      enableThousandsFormatter: true,
                    ),
                    const SizedBox(height: 10),
                    ExpenseTextField(
                      controller: descriptionController,
                      label: 'Description',
                      accentColor: accentColor,
                      keyboardType: TextInputType.text,
                      enableThousandsFormatter: false,
                    ),
                    const SizedBox(height: 12),

                    /// Expense/Income toggle
                    TransactionTypeToggle(
                      transactionType: transactionType,
                      accentColor: accentColor,
                      onTypeChange: (type) =>
                          setState(() => transactionType = type),
                    ),
                    const SizedBox(height: 16),

                    /// Category selector
                    CategorySelector(
                      userCategories: userCategories,
                      selectedCategoryIds: selectedCategoryIds,
                      accentColor: accentColor,
                      onCategoryTap: _toggleCategory,
                    ),
                    const SizedBox(height: 16),

                    /// Error message
                    if (errorMessage != null)
                      Text(
                        errorMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    /// Submit button
                    SubmitButton(
                      label: 'Add Record',
                      accentColor: accentColor,
                      onPressed: _submitExpense,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
