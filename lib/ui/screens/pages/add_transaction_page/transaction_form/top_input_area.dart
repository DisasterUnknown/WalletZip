import 'package:expenso/ui/screens/pages/add_transaction_page/transaction_form/widgets/expense_text_field.dart';
import 'package:expenso/ui/screens/pages/add_transaction_page/transaction_form/widgets/transaction_type_toggle.dart';
import 'package:flutter/material.dart';
import 'widgets/date_time_picker_row.dart';

class TopInputArea extends StatelessWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String transactionType;
  final Color accentColor;
  final TextEditingController amountController;
  final TextEditingController descriptionController;
  final Function(DateTime) onPickDate;
  final Function(TimeOfDay) onPickTime;
  final Function(String) onTransactionTypeChanged;

  const TopInputArea({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.transactionType,
    required this.accentColor,
    required this.amountController,
    required this.descriptionController,
    required this.onPickDate,
    required this.onPickTime,
    required this.onTransactionTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transaction Form',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),

          // Date + Time Picker
          DateTimePickerRow(
            selectedDate: selectedDate,
            selectedTime: selectedTime,
            accentColor: accentColor,
            onPickDate: onPickDate,
            onPickTime: onPickTime,
          ),
          const SizedBox(height: 16),

          // Amount
          ExpenseTextField(
            controller: amountController,
            label: 'Amount',
            accentColor: accentColor,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) => v == null || v.isEmpty ? 'Enter amount' : null,
            enableThousandsFormatter: true,
          ),
          const SizedBox(height: 10),

          // Description
          ExpenseTextField(
            controller: descriptionController,
            label: 'Description',
            accentColor: accentColor,
            keyboardType: TextInputType.text,
            enableThousandsFormatter: false,
          ),
          const SizedBox(height: 16),

          // Transaction Type Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transaction Type:',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TransactionTypeToggle(
                  transactionType: transactionType,
                  accentColor: accentColor,
                  onTypeChange: onTransactionTypeChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
