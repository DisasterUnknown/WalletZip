import 'dart:ui';
import 'package:expenso/core/constants/app_constants.dart';
import 'package:expenso/data/db/db_helper.dart';
import 'package:expenso/data/models/category.dart';
import 'package:expenso/data/models/transaction.dart';
import 'package:expenso/services/theme_service.dart';
import 'package:expenso/utils/number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// NOTE: This function is preserved as provided by the user (asynchronous).
Future<String> getCategoryNamesFromIds(List<int> ids) async {
  final db = DBHelper();
  final allCategories = await db.getCategories();
  if (ids.isEmpty) return 'No Categories';

  final cat = allCategories.firstWhere(
    (c) => c.id == ids[0],
    orElse: () => Category(
      id: 0,
      name: 'Uncategorized',
      state: 'active',
      icon: Icons.category,
    ),
  );

  return cat.name;
}

/// Shows a detailed view of a TransactionRecord using the glass/blur style.
Future<void> showTransactionDetailsPopup(
  BuildContext context,
  TransactionRecord transaction,
) async {
  final isExpense = transaction.type.toLowerCase() == 'expense';
  final primaryColor = isExpense
      ? CustomColors.getThemeColor(context, AppColorData.expenseColor)
      : CustomColors.getThemeColor(context, AppColorData.incomeColor);
  final secondaryColor = CustomColors.getThemeColor(
    context,
    AppColorData.secondary,
  );
  final secondary3Color = CustomColors.getThemeColor(
    context,
    AppColorData.secondary3,
  );
  final pendingColor = CustomColors.getThemeColor(
    context,
    AppColorData.pendingColor,
  );
  final incomeColor = CustomColors.getThemeColor(
    context,
    AppColorData.incomeColor,
  );
  final expenseColor = CustomColors.getThemeColor(
    context,
    AppColorData.expenseColor,
  );

  // --- Category Logic Update ---
  final String categoryDisplay;
  if (transaction.isBudgetEntry) {
    categoryDisplay = 'Budget'; // Show 'Budget' if it's a budget entry
  } else {
    categoryDisplay = await getCategoryNamesFromIds(transaction.categoryIds);
  }
  // -----------------------------

  // --- Transaction Type Logic ---
  final String transactionType = transaction.isTemporary
      ? 'Temporary'
      : 'Permanent';
  final Color transactionTypeColor = transaction.isTemporary
      ? pendingColor
      : secondaryColor;
  // ----------------------------------

  if (!context.mounted) return;
  showDialog(
    context: context,
    builder: (ctx) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: CustomColors.getThemeColor(
          context,
          AppColorData.primary,
        ).withAlpha(200),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: CustomColors.getThemeColor(
                context,
                AppColorData.primary,
              ).withAlpha(180),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primaryColor.withAlpha(180),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ----------------------------------------------------
                // 1. HEADER & AMOUNT (UNIFIED ROW)
                // ----------------------------------------------------
                Text(
                  isExpense ? "Expense Details" : "Income Details",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Amount Row (Highlighted)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
                  ),
                  child: _buildAlignedRow(
                    ctx,
                    Icons.money_outlined,
                    'Amount',
                    formatNumber(
                      transaction.price,
                      showTrailingZeros: true,
                      convertFromLength: 7,
                    ),
                    primaryColor,
                    isPrimary: true,
                  ),
                ),
                const SizedBox(height: 20),

                // ----------------------------------------------------
                // 2. PRIMARY INFO SECTION (ID, Type, Category)
                // ----------------------------------------------------
                _buildSectionHeader(ctx, 'Transaction Info', secondary3Color),
                const SizedBox(height: 8),

                // Row: ID
                _buildAlignedRow(
                  ctx,
                  Icons.fingerprint,
                  'ID',
                  transaction.id?.toString() ?? 'N/A',
                  secondary3Color,
                ),
                const Divider(height: 12),

                // Row: Type
                _buildAlignedRow(
                  ctx,
                  Icons.autorenew,
                  'Type',
                  transactionType,
                  transactionTypeColor,
                ),
                const Divider(height: 12),

                // Full Row: Category
                _buildAlignedRow(
                  ctx,
                  Icons.category_outlined,
                  'Category',
                  categoryDisplay,
                  secondaryColor,
                ),
                const Divider(height: 12),


                // ----------------------------------------------------
                // 3. DATE AND TIME SECTION
                // ----------------------------------------------------
                SizedBox(height: 12),
                _buildSectionHeader(ctx, 'Timeline', secondary3Color),
                const SizedBox(height: 8),

                // Row: Date
                _buildAlignedRow(
                  ctx,
                  Icons.calendar_today_outlined,
                  'Date',
                  DateFormat('MMM d, yyyy').format(transaction.dateTime),
                  secondaryColor,
                ),
                const Divider(height: 12),

                // Row: Time
                _buildAlignedRow(
                  ctx,
                  Icons.access_time,
                  'Time',
                  DateFormat('hh:mm a').format(transaction.dateTime),
                  secondary3Color,
                ),
                const Divider(height: 12),


                // ----------------------------------------------------
                // 4. NOTE/DESCRIPTION SECTION
                // ----------------------------------------------------
                if (transaction.note != null && transaction.note!.isNotEmpty) ...[
                  _buildNoteRow(ctx, transaction.note!),
                  const Divider(height: 12),
                ],


                // ----------------------------------------------------
                // 5. TEMPORARY DETAILS SECTION (if applicable)
                // ----------------------------------------------------
                if (transaction.isTemporary) ...[
                  SizedBox(height: 12),
                  _buildSectionHeader(ctx, 'Temporary/Tracking Details', pendingColor),
                  const SizedBox(height: 8),

                  // Status
                  _buildAlignedRow(
                    ctx,
                    Icons.warning_amber_rounded,
                    'Status',
                    transaction.status == 'open' ? "Pending" : "Completed",
                    transaction.status == 'open'
                        ? pendingColor
                        : (isExpense ? expenseColor : incomeColor),
                  ),

                  // Expected Date
                  if (transaction.expectedDate != null)
                    _buildAlignedRow(
                      ctx,
                      Icons.date_range,
                      'Expected Date',
                      DateFormat(
                        'MMM d, yyyy',
                      ).format(transaction.expectedDate!),
                      pendingColor,
                    ),

                  // Linked ID
                  if (transaction.linkedTransactionId != null)
                    _buildAlignedRow(
                      ctx,
                      Icons.link,
                      'Linked ID',
                      '#${transaction.linkedTransactionId}',
                      secondary3Color,
                    ),
                ],

                const SizedBox(height: 24),
                // ----------------------------------------------------
                // 6. CLOSE BUTTON
                // ----------------------------------------------------
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: primaryColor),
                      ),
                    ),
                    child: Text(
                      'CLOSE',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// -----------------------------------------------------------------------------
// HELPER WIDGETS
// -----------------------------------------------------------------------------

// Helper to define clear sections
Widget _buildSectionHeader(BuildContext context, String title, Color color) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
    child: Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: color.withValues(alpha: 0.7),
        letterSpacing: 1.0,
      ),
    ),
  );
}

// **REVISED CORE HELPER**: Creates a perfectly aligned, compact row with icon, label, and right-aligned value.
Widget _buildAlignedRow(
  BuildContext context,
  IconData icon,
  String label,
  String value,
  Color valueColor, {
  bool isPrimary = false,
}) {
  final secondaryColor = CustomColors.getThemeColor(context, AppColorData.secondary);
  final labelStyle = TextStyle(
    fontWeight: FontWeight.w500,
    color: secondaryColor,
    fontSize: isPrimary ? 16 : 15,
  );
  final valueStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: valueColor,
    fontSize: isPrimary ? 18 : 15,
  );

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Side: Icon + Label (Fixed group)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isPrimary ? 22 : 18,
              color: secondaryColor.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 8),
            Text('$label:', style: labelStyle),
          ],
        ),
        // Right Side: Value (Flexible, right-aligned)
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            softWrap: true,
            style: valueStyle,
          ),
        ),
      ],
    ),
  );
}

// Helper specifically for the note, allowing multi-line display
Widget _buildNoteRow(BuildContext context, String value) {
  final color = CustomColors.getThemeColor(context, AppColorData.secondary);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Note/Description:',
        style: TextStyle(fontWeight: FontWeight.w500, color: color, fontSize: 15),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: color.withValues(alpha: 0.8),
          fontSize: 15,
        ),
      ),
    ],
  );
}