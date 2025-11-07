import 'package:expenso/data/models/expense.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:expenso/ui/widgets/sub/confirm_delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget transactionRecordCard(
  Expense e,
  BuildContext context, {
  double marginH = 16,
  double marginV = 6,
  double paddingH = 10,
  double paddingV = 8,
  bool showDelete = false,
  void Function(int)? onDeletePress,
}) {
  final date = e.dateTime;
  final day = DateFormat('dd').format(date);
  final weekday = DateFormat('E').format(date);
  final time = DateFormat('hh:mm a').format(date);

  final isExpense = e.type.toLowerCase() == 'expense';
  final borderColor = isExpense ? CustomColors.getThemeColor(context, 'expenseColor') : CustomColors.getThemeColor(context, 'incomeColor');

  return Container(
    margin: EdgeInsets.symmetric(horizontal: marginH, vertical: marginV),
    padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
    decoration: BoxDecoration(
      color: CustomColors.getThemeColor(context, 'secondary').withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16),
      border: Border(left: BorderSide(color: borderColor, width: 4)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side: date + details
        Row(
          children: [
            // Date block
            Container(
              width: 30,
              margin: const EdgeInsets.only(right: 6),
              child: Column(
                children: [
                  Text(
                    weekday,
                    style: TextStyle(color: CustomColors.getThemeColor(context, 'secondary3'), fontSize: 12),
                  ),
                  Text(
                    day,
                    style: TextStyle(
                      color: CustomColors.getThemeColor(context, 'secondary'),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Description + time
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.note != null && e.note!.isNotEmpty
                      ? (e.note!.length > 20
                            ? '${e.note!.substring(0, 20)}...'
                            : e.note!)
                      : '(No description)',
                  style: TextStyle(color: CustomColors.getThemeColor(context, 'secondary'), fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(color: CustomColors.getThemeColor(context, 'secondary1'), fontSize: 12),
                ),
              ],
            ),
          ],
        ),

        // Right side: amount + delete
        Row(
          children: [
            Text(
              e.price
                  .toStringAsFixed(2)
                  .replaceAllMapped(
                    RegExp(r'\B(?=(\d{3})+(?!\d))'),
                    (match) => ',',
                  ),
              style: TextStyle(
                color: isExpense ? CustomColors.getThemeColor(context, 'expenseColor') : CustomColors.getThemeColor(context, 'incomeColor'),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            if (showDelete)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => ConfirmDeleteDialog(
                      message:
                          "Delete this ${isExpense ? 'expense' : 'income'} permanently?",
                      onConfirm: () => onDeletePress!(e.id!),
                    ),
                  );
                },
                child: Icon(
                  Icons.delete_forever_rounded,
                  color: CustomColors.getThemeColor(context, 'secondary1'),
                  size: 22,
                ),
              ),
          ],
        ),
      ],
    ),
  );
}
