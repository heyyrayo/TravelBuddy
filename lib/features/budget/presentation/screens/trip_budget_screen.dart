import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/data/app_states.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../models/expense.dart';

class TripBudgetScreen extends StatefulWidget {
  const TripBudgetScreen({
    required this.tripId,
    super.key,
  });

  final String tripId;

  @override
  State<TripBudgetScreen> createState() => _TripBudgetScreenState();
}

class _TripBudgetScreenState extends State<TripBudgetScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) {
      return;
    }

    _initialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context.read<TripBudgetState>().refresh(widget.tripId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TripBudgetState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        title: const Text('Trip Budget'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: state.isSavingExpense
            ? null
            : () => _showExpenseForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Expense'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return context.read<TripBudgetState>().refresh(widget.tripId);
        },
        child: _buildBody(context, state),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    TripBudgetState state,
  ) {
    if (state.isLoadingBudget && state.isLoadingExpenses) {
      return const _BudgetLoadingView();
    }

    if (state.errorMessage != null &&
        state.budget == null &&
        state.expenses.isEmpty) {
      return _ErrorView(
        message: state.errorMessage!,
        onRetry: () {
          context.read<TripBudgetState>().refresh(widget.tripId);
        },
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        110,
      ),
      children: [
        _buildHeader(context),
        const SizedBox(height: AppSpacing.md),
        _buildBudgetSummary(context, state),
        const SizedBox(height: AppSpacing.lg),
        _buildBudgetAction(context, state),
        const SizedBox(height: AppSpacing.lg),
        _buildCategorySection(context, state),
        const SizedBox(height: AppSpacing.lg),
        _buildExpensesSection(context, state),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manage your trip spending',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Track your budget and expenses in one place.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _buildBudgetSummary(
    BuildContext context,
    TripBudgetState state,
  ) {
    final hasBudget = state.hasBudget;
    final budget = state.budgetAmountPaise;
    final spent = state.totalSpentPaise;
    final remaining = state.remainingPaise;

    final progress = budget > 0
        ? (spent / budget).clamp(0.0, 1.0).toDouble()
        : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusBanner),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.16),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.onPrimary.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppColors.onPrimary,
                ),
              ),
              const Spacer(),
              if (hasBudget)
                IconButton(
                  tooltip: 'Edit Budget',
                  onPressed: state.isSavingBudget
                      ? null
                      : () => _showBudgetForm(context, state),
                  icon: const Icon(
                    Icons.edit_rounded,
                    color: AppColors.onPrimary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            hasBudget ? 'Total Budget' : 'No Budget Set',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.onPrimary.withOpacity(0.82),
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            hasBudget ? _formatPaise(budget) : 'Set a budget to get started',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (hasBudget) ...[
            Row(
              children: [
                Expanded(
                  child: _SummaryMetric(
                    label: 'Spent',
                    value: _formatPaise(spent),
                  ),
                ),
                Expanded(
                  child: _SummaryMetric(
                    label: state.isOverBudget ? 'Over Budget' : 'Remaining',
                    value: state.isOverBudget
                        ? _formatPaise(spent - budget)
                        : _formatPaise(remaining),
                    alignEnd: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.onPrimary.withOpacity(0.16),
                color: state.isOverBudget
                    ? AppColors.error
                    : AppColors.onPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              state.isOverBudget
                  ? 'Your expenses have exceeded the planned budget.'
                  : '${_formatPercent(progress)} of your budget spent',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onPrimary.withOpacity(0.78),
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBudgetAction(
    BuildContext context,
    TripBudgetState state,
  ) {
    if (state.hasBudget) {
      return const SizedBox.shrink();
    }

    return _ActionCard(
      icon: Icons.savings_rounded,
      title: 'Plan your spending',
      subtitle: 'Set a budget before you start tracking expenses.',
      actionLabel: 'Set Budget',
      onPressed: state.isSavingBudget
          ? null
          : () => _showBudgetForm(context, state),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    TripBudgetState state,
  ) {
    final totals = state.categoryTotalsPaise;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Category Breakdown',
          subtitle: 'Where your money is going',
        ),
        const SizedBox(height: AppSpacing.md),
        ...Expense.categories.map(
          (category) {
            final amount = totals[category] ?? 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _CategoryCard(
                category: category,
                amountPaise: amount,
                totalPaise: state.totalSpentPaise,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildExpensesSection(
    BuildContext context,
    TripBudgetState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Expenses',
          subtitle: state.expenses.isEmpty
              ? 'No expenses recorded yet'
              : '${state.expenses.length} expense${state.expenses.length == 1 ? '' : 's'}',
        ),
        const SizedBox(height: AppSpacing.md),
        if (state.expensesError != null)
          _InlineError(
            message: state.expensesError!,
            onRetry: () {
              context.read<TripBudgetState>().loadExpenses(widget.tripId);
            },
          )
        else if (state.isLoadingExpenses)
          const _ExpenseLoadingCard()
        else if (state.expenses.isEmpty)
          _EmptyExpensesCard(
            onAdd: () => _showExpenseForm(context),
          )
        else
          ...state.expenses.map(
            (expense) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _ExpenseCard(
                expense: expense,
                onEdit: () => _showExpenseForm(
                  context,
                  expense: expense,
                ),
                onDelete: () => _confirmDeleteExpense(
                  context,
                  expense,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _showBudgetForm(
    BuildContext context,
    TripBudgetState state,
  ) async {
    final controller = TextEditingController(
      text: state.hasBudget
          ? _paiseToInput(state.budgetAmountPaise)
          : '',
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLowest,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.lg,
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    AppSpacing.lg,
              ),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.hasBudget ? 'Edit Trip Budget' : 'Set Trip Budget',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Enter the amount you plan to spend on this trip.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: controller,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Budget amount',
                        prefixText: '₹ ',
                        hintText: '25000',
                      ),
                      validator: _validateAmount,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: Builder(
                        builder: (formContext) => FilledButton(
                          onPressed: state.isSavingBudget
                              ? null
                              : () async {
                                  if (!Form.of(formContext).validate()) {
                                    return;
                                  }

                                  final paise = _parseRupeesToPaise(
                                    controller.text,
                                  );

                                  if (paise == null || paise < 0) {
                                    setModalState(() {});
                                    return;
                                  }

                                  await context
                                      .read<TripBudgetState>()
                                      .saveBudget(
                                        tripId: widget.tripId,
                                        amountPaise: paise,
                                      );

                                  if (!context.mounted) {
                                    return;
                                  }

                                  if (context
                                          .read<TripBudgetState>()
                                          .savingError ==
                                      null) {
                                    Navigator.of(context).pop();
                                  } else {
                                    setModalState(() {});
                                  }
                                },
                          child: state.isSavingBudget
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  state.hasBudget
                                      ? 'Save Changes'
                                      : 'Set Budget',
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

  }

  Future<void> _showExpenseForm(
    BuildContext context, {
    Expense? expense,
  }) async {
    final titleController = TextEditingController(
      text: expense?.title ?? '',
    );
    final amountController = TextEditingController(
      text: expense == null ? '' : _paiseToInput(expense.amountPaise),
    );
    final noteController = TextEditingController(
      text: expense?.note ?? '',
    );
    var selectedCategory = expense?.category ?? Expense.categories.first;
    var selectedDate = expense?.spentAt ?? DateTime.now();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLowest,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final state = context.watch<TripBudgetState>();

            return Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.lg,
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    AppSpacing.lg,
              ),
              child: SingleChildScrollView(
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense == null
                            ? 'Add Expense'
                            : 'Edit Expense',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: titleController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Expense title',
                          hintText: 'Hotel stay',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter an expense title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: amountController,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          prefixText: '₹ ',
                          hintText: '1500',
                        ),
                        validator: _validatePositiveAmount,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                        items: Expense.categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ),
                            )
                            .toList(),
                        onChanged: state.isSavingExpense
                            ? null
                            : (value) {
                                if (value != null) {
                                  setModalState(() {
                                    selectedCategory = value;
                                  });
                                }
                              },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      InkWell(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusCard,
                        ),
                        onTap: state.isSavingExpense
                            ? null
                            : () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );

                                if (picked != null) {
                                  setModalState(() {
                                    selectedDate = DateTime(
                                      picked.year,
                                      picked.month,
                                      picked.day,
                                    );
                                  });
                                }
                              },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Date',
                            prefixIcon: Icon(Icons.calendar_today_rounded),
                          ),
                          child: Text(
                            DateFormat('dd MMM yyyy').format(selectedDate),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: noteController,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Note (optional)',
                          hintText: 'Add a short note',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (state.savingError != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.sm,
                          ),
                          child: Text(
                            state.savingError!,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppColors.error,
                                ),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: Builder(
                          builder: (formContext) => FilledButton(
                            onPressed: state.isSavingExpense
                                ? null
                                : () async {
                                    if (!Form.of(formContext).validate()) {
                                    return;
                                  }

                                  final paise = _parseRupeesToPaise(
                                    amountController.text,
                                  );

                                  if (paise == null || paise <= 0) {
                                    return;
                                  }

                                  final budgetState =
                                      context.read<TripBudgetState>();

                                  if (expense == null) {
                                    await budgetState.addExpense(
                                      tripId: widget.tripId,
                                      title: titleController.text,
                                      amountPaise: paise,
                                      category: selectedCategory,
                                      note: noteController.text,
                                      spentAt: selectedDate,
                                    );
                                  } else {
                                    await budgetState.updateExpense(
                                      expense.copyWith(
                                        title: titleController.text.trim(),
                                        amountPaise: paise,
                                        category: selectedCategory,
                                        note: noteController.text.trim().isEmpty
                                            ? null
                                            : noteController.text.trim(),
                                        spentAt: selectedDate,
                                      ),
                                    );
                                  }

                                  if (!context.mounted) {
                                    return;
                                  }

                                  if (context
                                          .read<TripBudgetState>()
                                          .savingError ==
                                      null) {
                                    Navigator.of(context).pop();
                                  }
                                },
                          child: state.isSavingExpense
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  expense == null
                                      ? 'Add Expense'
                                      : 'Save Changes',
                                ),
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

  }

  Future<void> _confirmDeleteExpense(
    BuildContext context,
    Expense expense,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete this expense?'),
          content: Text(
            'Remove "${expense.title}" from your trip budget?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    await context.read<TripBudgetState>().deleteExpense(expense.id);

    if (!context.mounted) {
      return;
    }

    final error = context.read<TripBudgetState>().deletingError;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  static String? _validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a budget amount';
    }

    final amount = _parseRupeesToPaise(value);
    if (amount == null || amount < 0) {
      return 'Enter a valid amount';
    }

    return null;
  }

  static String? _validatePositiveAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter an amount';
    }

    final amount = _parseRupeesToPaise(value);
    if (amount == null || amount <= 0) {
      return 'Amount must be greater than ₹0';
    }

    return null;
  }

  static int? _parseRupeesToPaise(String value) {
    final normalized = value.trim().replaceAll(',', '');

    if (normalized.isEmpty) {
      return null;
    }

    final parts = normalized.split('.');
    if (parts.length > 2) {
      return null;
    }

    if (!RegExp(r'^\d+$').hasMatch(parts.first)) {
      return null;
    }

    final rupees = int.tryParse(parts.first);
    if (rupees == null) {
      return null;
    }

    var paisePart = 0;

    if (parts.length == 2) {
      if (!RegExp(r'^\d{1,2}$').hasMatch(parts[1])) {
        return null;
      }

      final decimal = parts[1].padRight(2, '0');
      paisePart = int.parse(decimal);
    }

    return rupees * 100 + paisePart;
  }

  static String _paiseToInput(int paise) {
    final rupees = paise ~/ 100;
    final remainder = paise % 100;

    if (remainder == 0) {
      return rupees.toString();
    }

    return '$rupees.${remainder.toString().padLeft(2, '0')}';
  }

  static String _formatPaise(int paise) {
    final negative = paise < 0;
    final absolute = paise.abs();
    final rupees = absolute ~/ 100;
    final cents = absolute % 100;

    final formattedRupees = NumberFormat('#,##,##0').format(rupees);
    final value = cents == 0
        ? '₹$formattedRupees'
        : '₹$formattedRupees.${cents.toString().padLeft(2, '0')}';

    return negative ? '-$value' : value;
  }

  static String _formatPercent(double value) {
    return '${(value * 100).round()}%';
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onPrimary.withOpacity(0.72),
              ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.amountPaise,
    required this.totalPaise,
  });

  final String category;
  final int amountPaise;
  final int totalPaise;

  @override
  Widget build(BuildContext context) {
    final fraction = totalPaise > 0
        ? (amountPaise / totalPaise).clamp(0.0, 1.0).toDouble()
        : 0.0;

    final icon = switch (category) {
      'Accommodation' => Icons.hotel_rounded,
      'Transport' => Icons.directions_car_rounded,
      'Food' => Icons.restaurant_rounded,
      'Activities' => Icons.local_activity_rounded,
      'Shopping' => Icons.shopping_bag_rounded,
      _ => Icons.more_horiz_rounded,
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: AppColors.outlineVariant.withOpacity(0.45),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryFixed.withOpacity(0.45),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        category,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Text(
                      _TripBudgetScreenState._formatPaise(amountPaise),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 5,
                    backgroundColor: AppColors.surfaceContainerHigh,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  const _ExpenseCard({
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  final Expense expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: AppColors.outlineVariant.withOpacity(0.45),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryFixed.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        expense.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      _TripBudgetScreenState._formatPaise(
                        expense.amountPaise,
                      ),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${expense.category} • ${DateFormat('dd MMM yyyy').format(expense.spentAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
                if (expense.note != null) ...[
                  const SizedBox(height: 5),
                  Text(
                    expense.note!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Edit expense',
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 19),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Delete expense',
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline_rounded, size: 19),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryFixed.withOpacity(0.35),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.savings_rounded,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          TextButton(
            onPressed: onPressed,
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

class _EmptyExpensesCard extends StatelessWidget {
  const _EmptyExpensesCard({
    required this.onAdd,
  });

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: AppColors.outlineVariant.withOpacity(0.45),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_rounded,
            size: 42,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'No expenses yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Start recording your trip spending to keep your budget on track.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Expense'),
          ),
        ],
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.errorContainer.withOpacity(0.55),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const SizedBox(height: 100),
        const Icon(
          Icons.account_balance_wallet_outlined,
          size: 56,
          color: AppColors.error,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ),
      ],
    );
  }
}

class _BudgetLoadingView extends StatelessWidget {
  const _BudgetLoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        const SizedBox(height: AppSpacing.sm),
        _SkeletonBox(
          height: 250,
          radius: AppSpacing.radiusBanner,
        ),
        const SizedBox(height: AppSpacing.lg),
        _SkeletonBox(height: 70),
        const SizedBox(height: AppSpacing.sm),
        _SkeletonBox(height: 70),
        const SizedBox(height: AppSpacing.sm),
        _SkeletonBox(height: 70),
        const SizedBox(height: AppSpacing.lg),
        _SkeletonBox(height: 90),
        const SizedBox(height: AppSpacing.sm),
        _SkeletonBox(height: 90),
      ],
    );
  }
}

class _ExpenseLoadingCard extends StatelessWidget {
  const _ExpenseLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const _SkeletonBox(height: 100);
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.height,
    this.radius = AppSpacing.radiusCard,
  });

  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}






