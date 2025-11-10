import 'package:expenso/core/constants/app_constants.dart';
import 'package:expenso/services/log_service.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:expenso/ui/screens/pages/add_transaction_page/category_or_linked_transactions/category_or_linked_transactions.dart';
import 'package:expenso/ui/screens/pages/add_transaction_page/toggle_area/toggle_area.dart';
import 'package:expenso/ui/screens/pages/add_transaction_page/transaction_form/top_input_area.dart';
import 'package:flutter/material.dart';
import 'package:expenso/ui/widgets/main/custom_app_bar.dart';
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

  bool superSetting = false;
  bool isTemporary = false;

  List<Category> userCategories = [];
  int? selectedCategoryId;

  List<Expense> matchedTransactions = [];
  Expense? selectedMatchedTransaction;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;

  Color get accentColor =>
      transactionType == 'Expense' ? CustomColors.getThemeColor(context, AppColorData.expenseColor) : CustomColors.getThemeColor(context, AppColorData.incomeColor);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String?>?;
    month = args?['month'] ?? DateFormat('MMMM').format(DateTime.now());
    year = args?['year'] ?? DateTime.now().year.toString();

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
      final ids = saved.split(',').map(int.tryParse).whereType<int>().toSet();
      setState(() {
        userCategories = categories.where((c) => ids.contains(c.id)).toList();
      });
    } else {
      setState(() => userCategories = categories);
    }
  }

  Future<void> _loadMatchedTransactions() async {
    final all = await DBHelper().getAllExpenses();
    setState(() {
      matchedTransactions = all
          .where(
            (e) =>
                e.isTemporary &&
                e.type.toLowerCase() != transactionType.toLowerCase(),
          )
          .toList();
      selectedMatchedTransaction = null;
    });
  }

  void _onSuperSettingChanged(bool value) {
    setState(() {
      superSetting = value;
      if (superSetting) _loadMatchedTransactions();
    });
  }

  void _onTransactionTypeChanged(String type) {
    setState(() {
      transactionType = type;
      if (superSetting) _loadMatchedTransactions();
    });
  }

  void _selectCategory(Category category) {
    setState(() {
      selectedCategoryId = selectedCategoryId == category.id
          ? null
          : category.id;
    });
  }

  void _submitTransaction() async {
    setState(() => errorMessage = null);

    if (!_formKey.currentState!.validate()) return;

    // Validate category or linked transaction
    if (!superSetting && selectedCategoryId == null) {
      setState(() => errorMessage = 'Please select a category!');
      return;
    }

    if (superSetting && selectedMatchedTransaction == null) {
      setState(() => errorMessage = 'Please select a linked transaction!');
      return;
    }

    // Validate amount
    final amount = double.tryParse(amountController.text.replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      setState(() => errorMessage = 'Please enter a valid amount!');
      return;
    }

    // Determine transaction status & temp flag
    bool finalIsTemporary = isTemporary;
    String finalStatus = 'completed';

    if (superSetting && selectedMatchedTransaction != null) {
      // If linked, both transactions become completed and permanent
      finalIsTemporary = false;
      finalStatus = 'completed';
    } else if (!superSetting) {
      finalStatus = isTemporary ? 'open' : 'completed';
    }

    // Create Expense object (new or updated)
    final newExpense = Expense(
      id: selectedMatchedTransaction?.id, // if you're editing existing expense
      type: transactionType.toLowerCase(),
      price: amount,
      categoryIds: superSetting
          ? selectedMatchedTransaction!.categoryIds
          : [selectedCategoryId!],
      note: descriptionController.text,
      dateTime: DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      ),
      linkedTransactionId: superSetting ? selectedMatchedTransaction!.id : null,
      isTemporary: finalIsTemporary,
      expectedDate: superSetting ? selectedMatchedTransaction?.dateTime : null,
      status: finalStatus,
    );

    final db = DBHelper();

    // If editing existing transaction, update it
    if (selectedMatchedTransaction != null) {
      await db.updateExpense(newExpense);
      LogService.log("Updated transaction ID: ${newExpense.id}");
    } else {
      // otherwise insert a new one
      await db.insertExpense(newExpense);
      LogService.log("Inserted new transaction ID: ${newExpense.id}");
    }

    // If linked transaction, also update the matched one
    if (superSetting && selectedMatchedTransaction != null) {
      final updatedLinked = selectedMatchedTransaction!.copyWith(
        linkedTransactionId: newExpense.id,
        status: 'completed',
        isTemporary: false,
      );
      await db.updateExpense(updatedLinked);
      LogService.log("Updated linked transaction ID: ${updatedLinked.id}");
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.getThemeColor(context, AppColorData.primary),
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
              TopInputArea(
                selectedDate: selectedDate,
                selectedTime: selectedTime,
                transactionType: transactionType,
                accentColor: accentColor,
                amountController: amountController,
                descriptionController: descriptionController,
                onPickDate: (date) => setState(() => selectedDate = date),
                onPickTime: (time) => setState(() => selectedTime = time),
                onTransactionTypeChanged: _onTransactionTypeChanged,
              ),
              const SizedBox(height: 20),
              ToggleArea(
                superSetting: superSetting,
                isTemporary: isTemporary,
                accentColor: accentColor,
                onSuperSettingChanged: _onSuperSettingChanged,
                onTemporaryChanged: (v) => setState(() => isTemporary = v),
              ),
              const SizedBox(height: 20),
              CategoryOrLinkedTransactions(
                superSetting: superSetting,
                userCategories: userCategories,
                selectedCategoryId: selectedCategoryId,
                onCategoryTap: _selectCategory,
                matchedTransactions: matchedTransactions,
                selectedMatchedTransaction: selectedMatchedTransaction,
                onSelectMatchedTransaction: (e) =>
                    setState(() => selectedMatchedTransaction = e),
                accentColor: accentColor,
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  errorMessage!,
                  style: TextStyle(
                    color: CustomColors.getThemeColor(context, AppColorData.expenseColor),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submitTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.getThemeColor(context, AppColorData.primary),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: accentColor, width: 2),
                  ),
                ),
                child: Text(
                  'Save Record',
                  style: TextStyle(color: accentColor),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
