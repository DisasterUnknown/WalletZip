import 'dart:ui';
import 'package:expenso/core/constants/app_constants.dart';
import 'package:expenso/services/startup_service.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:expenso/ui/screens/pages/add_transaction_page/transaction_form/widgets/expense_text_field.dart';
import 'package:expenso/ui/screens/pages/add_transaction_page/helpers/thousands_formatter.dart';
import 'package:flutter/material.dart';
import 'package:expenso/data/db/db_helper.dart';
import 'package:expenso/data/models/budget.dart';

class AddBudgetCard extends StatefulWidget {
  final VoidCallback? onSaved;
  const AddBudgetCard({super.key, this.onSaved});

  @override
  State<AddBudgetCard> createState() => _AddBudgetCardState();
}

class _AddBudgetCardState extends State<AddBudgetCard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  String _selectedType = 'Monthly';
  bool _isSaving = false;
  String? errorMessage;

  Color get accentColor => CustomColors.getThemeColor(context, AppColorData.expenseColor);

  @override
  void initState() {
    super.initState();
    _loadExistingBudget();
  }

  /// Load budget for current month/year, if exists
  Future<void> _loadExistingBudget() async {
    final budgets = await DBHelper().getAllBudgets();
    final now = DateTime.now();

    final currentBudget = budgets.firstWhere(
      (b) => b.month == now.month && b.year == now.year,
      orElse: () =>
          Budget(amount: 0, month: now.month, year: now.year, type: 'Monthly'),
    );

    // Format the initial amount with commas and two decimal places
    String formattedAmount = '';
    if (currentBudget.amount > 0) {
      final numericValue = currentBudget.amount.toStringAsFixed(2);
      formattedAmount = ThousandsFormatter()
          .formatEditUpdate(
            TextEditingValue.empty,
            TextEditingValue(text: numericValue),
          )
          .text;
    }

    setState(() {
      _amountController.text = formattedAmount;
      _selectedType = currentBudget.type;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveBudget() async {
    setState(() => errorMessage = null);

    if (!_formKey.currentState!.validate()) return;

    final double amount =
        double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
    if (amount <= 0) {
      setState(() => errorMessage = "Enter a valid amount!");
      return;
    }

    setState(() => _isSaving = true);
    final now = DateTime.now();

    final budget = Budget(
      amount: amount,
      month: now.month,
      year: now.year,
      type: _selectedType,
    );

    await DBHelper().insertBudget(budget);

    // This only call the add the budget to the db in the startupService nothing else
    StartupService.checkAndAddBudgetIncome();

    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.of(context).pop(true);
    widget.onSaved?.call();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: CustomColors.getThemeColor(context, AppColorData.primary).withValues(alpha: 0.6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: CustomColors.getThemeColor(context, AppColorData.transparent),
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
                      "Add Budget",
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// Amount field
                    ExpenseTextField(
                      controller: _amountController,
                      label: 'Amount',
                      accentColor: accentColor,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter amount";
                        }
                        if (double.tryParse(value.replaceAll(',', '')) ==
                            null) {
                          return "Enter a valid number";
                        }
                        return null;
                      },
                      enableThousandsFormatter: true,
                    ),
                    const SizedBox(height: 12),

                    /// Type selector with equal width
                    Row(
                      children: ['Yearly', 'Monthly', 'Daily'].map((type) {
                        final selected = _selectedType == type;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedType = type),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: CustomColors.getThemeColor(context, AppColorData.transparent),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selected
                                      ? accentColor
                                      : CustomColors.getThemeColor(context, AppColorData.secondary1),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    color: selected
                                        ? accentColor
                                        : CustomColors.getThemeColor(context, AppColorData.secondary1),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    /// Error message
                    if (errorMessage != null)
                      Text(
                        errorMessage!,
                        style: TextStyle(
                          color: CustomColors.getThemeColor(context, AppColorData.expenseColor),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    /// Submit button
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isSaving ? null : _saveBudget,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.getThemeColor(context, AppColorData.transparent),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: accentColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 14,
                        ),
                      ),
                      child: Text(
                        _isSaving ? "Saving..." : "Save",
                        style: TextStyle(color: accentColor),
                      ),
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
