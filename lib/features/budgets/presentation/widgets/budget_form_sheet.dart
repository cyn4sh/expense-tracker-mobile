import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/budget_model.dart';
import '../../providers/budgets_provider.dart';
import '../../../categories/providers/categories_provider.dart';
import '../../../../core/theme/app_spacing.dart';

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

class BudgetFormSheet extends ConsumerStatefulWidget {
  final BudgetModel? budget;

  const BudgetFormSheet({super.key, this.budget});

  @override
  ConsumerState<BudgetFormSheet> createState() => _BudgetFormSheetState();
}

class _BudgetFormSheetState extends ConsumerState<BudgetFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  int? _selectedCategoryId;
  late int _selectedMonth;
  late int _selectedYear;
  bool _isSubmitting = false;

  bool get _isEditing => widget.budget != null;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.budget?.amount ?? '');
    _selectedCategoryId = widget.budget?.categoryDetail.id;
    _selectedMonth = widget.budget?.month ?? DateTime.now().month;
    _selectedYear = widget.budget?.year ?? DateTime.now().year;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  List<int> get _yearOptions {
    final currentYear = DateTime.now().year;
    return List.generate(5, (index) => currentYear - 2 + index);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final amount = _amountController.text.trim();
      final category = _selectedCategoryId!;

      if (_isEditing) {
        await ref.read(budgetsProvider.notifier).updateBudget(
              widget.budget!.id,
              UpdateBudgetDto(
                category: category,
                amount: amount,
                month: _selectedMonth,
                year: _selectedYear,
              ),
            );
      } else {
        await ref.read(budgetsProvider.notifier).createBudget(
              CreateBudgetDto(
                category: category,
                amount: amount,
                month: _selectedMonth,
                year: _selectedYear,
              ),
            );
      }

      if (!mounted) return;
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Budget updated' : 'Budget added')),
      );
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save budget: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final categories = categoriesAsync.value ?? [];

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isEditing ? 'Edit Budget' : 'New Budget',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppSpacing.md + 4),
            DropdownButtonFormField<int>(
              initialValue: _selectedCategoryId,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: categories
                  .map(
                    (category) => DropdownMenuItem<int>(
                      value: category.id,
                      child: Text(category.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedCategoryId = value),
              validator: (value) {
                if (value == null) {
                  return 'Please select a category';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md + 4),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Amount cannot be empty';
                }
                final parsed = double.tryParse(value.trim());
                if (parsed == null || parsed <= 0) {
                  return 'Enter a valid amount greater than 0';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md + 4),
            DropdownButtonFormField<int>(
              initialValue: _selectedMonth,
              decoration: const InputDecoration(
                labelText: 'Month',
                border: OutlineInputBorder(),
              ),
              items: List.generate(
                12,
                (index) => DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text(_monthNames[index]),
                ),
              ),
              onChanged: (value) => setState(() => _selectedMonth = value!),
            ),
            const SizedBox(height: AppSpacing.md + 4),
            DropdownButtonFormField<int>(
              initialValue: _selectedYear,
              decoration: const InputDecoration(
                labelText: 'Year',
                border: OutlineInputBorder(),
              ),
              items: _yearOptions
                  .map(
                    (year) => DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedYear = value!),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isEditing ? 'Save Changes' : 'Add Budget'),
            ),
          ],
        ),
      ),
    );
  }
}
