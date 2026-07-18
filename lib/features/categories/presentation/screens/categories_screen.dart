import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker_mobile/core/widgets/app_bottom_sheet.dart';
import '../../providers/categories_provider.dart';
import '../../data/models/category_model.dart';
import '../widgets/category_form_sheet.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading_state.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Categories',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: categoriesAsync.when(
          data: (categories) => _CategoriesList(categories: categories),
          loading: () => const AppLoadingState(),
          error: (error, stackTrace) => AppEmptyState(
            icon: Icons.error_outline,
            message: 'Couldn\'t load categories.\nPull down to try again.',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAppBottomSheet(
            context: context,
            child: const CategoryFormSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CategoriesList extends ConsumerWidget {
  final List<CategoryModel> categories;
  const _CategoriesList({required this.categories});

  Future<bool> _confirmDelete(BuildContext context, CategoryModel category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete category?'),
        content: Text('This will permanently delete "${category.name}".'),
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
    if (categories.isEmpty) {
      return const AppEmptyState(
        icon: Icons.category_outlined,
        message: 'No categories yet.\nTap + to create one.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        100,
        AppSpacing.md,
        AppSpacing.md,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Dismissible(
          key: ValueKey(category.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) => _confirmDelete(context, category),
          onDismissed: (_) async {
            try {
              await ref.read(categoriesProvider.notifier).deleteCategory(category.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Category deleted')),
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
                  category.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: () {
                  showAppBottomSheet(
                    context: context,
                    child: CategoryFormSheet(category: category),
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