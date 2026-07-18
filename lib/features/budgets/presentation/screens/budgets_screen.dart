import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker_mobile/core/widgets/app_bottom_sheet.dart';
import '../../providers/budgets_provider.dart';
import '../../data/models/budget_model.dart';
import '../widgets/budget_form_sheet.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading_state.dart';

const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(budgetsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Budgets',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: budgetsAsync.when(
          data: (budgets) => _BudgetsList(budgets: budgets),
          loading: () => const AppLoadingState(),
          error: (error, stackTrace) => AppEmptyState(
            icon: Icons.error_outline,
            message: 'Couldn\'t load budgets.\nPull down to try again.',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAppBottomSheet(
            context: context,
            child: const BudgetFormSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _BudgetsList extends ConsumerWidget {
  final List<BudgetModel> budgets;
  const _BudgetsList({required this.budgets});

  Future<bool> _confirmDelete(BuildContext context, BudgetModel budget) async {
    final monthName = _monthNames[budget.month - 1];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete budget?'),
        content: Text(
          'This will permanently delete the ${budget.categoryDetail.name} budget for $monthName ${budget.year}.',
        ),
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
    if (budgets.isEmpty) {
      return const AppEmptyState(
        icon: Icons.account_balance_wallet_outlined,
        message: 'No budgets yet.\nTap + to create one.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        100,
        AppSpacing.md,
        AppSpacing.md,
      ),
      itemCount: budgets.length,
      itemBuilder: (context, index) {
        final budget = budgets[index];
        final monthName = _monthNames[budget.month - 1];
        return Dismissible(
          key: ValueKey(budget.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) => _confirmDelete(context, budget),
          onDismissed: (_) async {
            try {
              await ref.read(budgetsProvider.notifier).deleteBudget(budget.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Budget deleted')),
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
                  budget.categoryDetail.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text('${budget.amount} · $monthName ${budget.year}'),
                onTap: () {
                  showAppBottomSheet(
                    context: context,
                    child: BudgetFormSheet(budget: budget),
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
