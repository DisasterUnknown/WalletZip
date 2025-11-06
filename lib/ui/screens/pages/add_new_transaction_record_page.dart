import 'package:expenso/ui/widgets/main/custom_app_bar.dart';
import 'package:expenso/ui/widgets/sub/add_expense_income/widgets/category_selector.dart';
import 'package:expenso/ui/widgets/sub/add_expense_income/widgets/date_time_picker_row.dart';
import 'package:expenso/ui/widgets/sub/add_expense_income/widgets/expense_text_field.dart';
import 'package:expenso/ui/widgets/sub/add_expense_income/widgets/submit_button.dart';
import 'package:expenso/ui/widgets/sub/add_expense_income/widgets/transaction_type_toggle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expenso/core/constants/default_categories.dart';
import 'package:expenso/core/shared_prefs/shared_pref_service.dart';
import 'package:expenso/data/db/db_helper.dart';
import 'package:expenso/data/models/expense.dart';
import 'package:expenso/data/models/category.dart';

class AddNewTransactionRecordPage extends StatefulWidget {
  const AddNewTransactionRecordPage({super.key});

  @override
  State<AddNewTransactionRecordPage> createState() =>
      _AddNewTransactionRecordPageState();
}

class _AddNewTransactionRecordPageState
    extends State<AddNewTransactionRecordPage> {
  late String month;
  late String year;

  String selectedYear = DateTime.now().year.toString();
  String selectedMonth = DateFormat('MMMM').format(DateTime.now());
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String transactionType = 'Expense';
  List<Category> userCategories = [];
  int? selectedCategoryId;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;

  Color get accentColor =>
      transactionType == 'Expense' ? Colors.redAccent : Colors.greenAccent;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get arguments from ModalRoute
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String?>?;

    month = args?['month'] ?? DateFormat('MMMM').format(DateTime.now());
    year = args?['year'] ?? DateTime.now().year.toString();

    // Set initial date based on month/year
    try {
      final monthIndex = DateFormat('MMMM').parse(month).month;
      final yearInt = int.parse(year);
      selectedDate = DateTime(yearInt, monthIndex, selectedDate.day);
      selectedYear = yearInt.toString();
      selectedMonth = month;
    } catch (_) {
      selectedDate = DateTime.now();
      selectedYear = selectedDate.year.toString();
      selectedMonth = DateFormat('MMMM').format(selectedDate);
    }

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

  void _selectCategory(Category category) {
    setState(() {
      if (selectedCategoryId == category.id) {
        selectedCategoryId = null;
      } else {
        selectedCategoryId = category.id;
      }
    });
  }

  void _submitExpense() async {
    setState(() => errorMessage = null);

    if (!_formKey.currentState!.validate()) return;

    if (selectedCategoryId == null) {
      setState(() => errorMessage = 'Please select a category!');
      return;
    }

    final amount = double.tryParse(amountController.text.replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      setState(() => errorMessage = 'Please enter a valid amount!');
      return;
    }

    final expense = Expense(
      type: transactionType.toLowerCase(),
      price: amount,
      categoryIds: [selectedCategoryId!],
      note: descriptionController.text,
      dateTime: DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      ),
    );

    await DBHelper().insertExpense(expense);

    if (!mounted) return;
    Navigator.of(context).pop(true); // return true to calling page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: transactionType == 'Expense'
            ? 'Add Expense Record'
            : 'Add Income Record',
        showBackButton: true,
        showHomeButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
              const SizedBox(height: 16),

              /// Amount
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

              /// Description
              ExpenseTextField(
                controller: descriptionController,
                label: 'Description',
                accentColor: accentColor,
                keyboardType: TextInputType.text,
                enableThousandsFormatter: false,
              ),
              const SizedBox(height: 16),

              /// Expense/Income toggle
              TransactionTypeToggle(
                transactionType: transactionType,
                accentColor: accentColor,
                onTypeChange: (type) => setState(() => transactionType = type),
              ),
              const SizedBox(height: 16),

              /// Category selector
              CategorySelector(
                userCategories: userCategories,
                selectedCategoryId: selectedCategoryId,
                accentColor: accentColor,
                onCategoryTap: _selectCategory,
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
              const SizedBox(height: 12),

              /// Submit button
              SubmitButton(
                label: 'Save Record',
                accentColor: accentColor,
                onPressed: _submitExpense,
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
