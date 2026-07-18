import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker_mobile/core/widgets/app_bottom_sheet.dart';
import '../../providers/expenses_provider.dart';
import '../../data/models/expense_model.dart';
import '../widgets/expense_form_sheet.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading_state.dart';

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Expenses',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: expensesAsync.when(
          data: (expenses) => _ExpensesList(expenses: expenses),
          loading: () => const AppLoadingState(),
          error: (error, stackTrace) => AppEmptyState(
            icon: Icons.error_outline,
            message: 'Couldn\'t load expenses.\nPull down to try again.',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAppBottomSheet(
            context: context,
            child: const ExpenseFormSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ExpensesList extends ConsumerWidget {
  final List<ExpenseModel> expenses;
  const _ExpensesList({required this.expenses});

  Future<bool> _confirmDelete(BuildContext context, ExpenseModel expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete expense?'),
        content: Text('This will permanently delete "${expense.description}".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (expenses.isEmpty) {
      return const AppEmptyState(
        icon: Icons.receipt_long_outlined,
        message: 'No expenses yet.\nTap + to create one.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        100,
        AppSpacing.md,
        AppSpacing.md,
      ),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return Dismissible(
          key: ValueKey(expense.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) => _confirmDelete(context, expense),
          onDismissed: (_) async {
            try {
              await ref.read(expensesProvider.notifier).deleteExpense(expense.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Expense deleted')),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete: $e')),
                );
              }
            }
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            margin: const EdgeInsets.only(bottom: AppSpacing.sm + 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
          child: AnimatedContainer(
            duration: AppMotion.standard,
            curve: AppMotion.standardCurve,
            margin: const EdgeInsets.only(bottom: AppSpacing.sm + 4),
            child: Card(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: AppSpacing.sm + 4,
                ),
                title: Text(
                  expense.description,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  '${expense.amount} · ${expense.date} · ${expense.categoryDetail.name}',
                ),
                onTap: () {
                  showAppBottomSheet(
                    context: context,
                    child: ExpenseFormSheet(expense: expense),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
