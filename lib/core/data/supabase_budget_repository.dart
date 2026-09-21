import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/expense.dart';
import '../../models/trip_budget.dart';
import 'budget_repository.dart';

class SupabaseBudgetRepository implements BudgetRepository {
  SupabaseBudgetRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<TripBudget?> getBudget(String tripId) async {
    _requireNonEmpty(tripId, 'Trip id');
    _requireAuthenticatedUser();

    try {
      final row = await _client
          .from('trip_budgets')
          .select()
          .eq('trip_id', tripId.trim())
          .maybeSingle();

      if (row == null) {
        return null;
      }

      return _budgetFromRow(Map<String, dynamic>.from(row));
    } on PostgrestException catch (error) {
      _logPostgrestError('GET trip_budgets', error);
      throw BudgetRepositoryException(
        'Unable to load the trip budget: ${error.message}',
      );
    } catch (error, stackTrace) {
      _logUnexpected('GET trip_budgets', error, stackTrace);
      if (error is BudgetRepositoryException) {
        rethrow;
      }
      throw const BudgetRepositoryException(
        'Unable to load the trip budget. Please try again.',
      );
    }
  }

  @override
  Future<TripBudget> upsertBudget(TripBudget budget) async {
    _validateBudget(budget, requireId: false);
    _requireAuthenticatedUser();

    final payload = budget.toMap();
    if (budget.id.trim().isEmpty) {
      payload.remove('id');
    }

    try {
      final row = await _client
          .from('trip_budgets')
          .upsert(
            payload,
            onConflict: 'trip_id',
          )
          .select()
          .single();

      return _budgetFromRow(Map<String, dynamic>.from(row));
    } on PostgrestException catch (error) {
      _logPostgrestError('UPSERT trip_budgets', error);
      throw BudgetRepositoryException(
        'Unable to save the trip budget: ${error.message}',
      );
    } catch (error, stackTrace) {
      _logUnexpected('UPSERT trip_budgets', error, stackTrace);
      if (error is BudgetRepositoryException) {
        rethrow;
      }
      throw const BudgetRepositoryException(
        'Unable to save the trip budget. Please try again.',
      );
    }
  }

  @override
  Future<void> deleteBudget(String tripId) async {
    _requireNonEmpty(tripId, 'Trip id');
    _requireAuthenticatedUser();

    try {
      await _client.from('trip_budgets').delete().eq('trip_id', tripId.trim());
    } on PostgrestException catch (error) {
      _logPostgrestError('DELETE trip_budgets', error);
      throw BudgetRepositoryException(
        'Unable to delete the trip budget: ${error.message}',
      );
    } catch (error, stackTrace) {
      _logUnexpected('DELETE trip_budgets', error, stackTrace);
      if (error is BudgetRepositoryException) {
        rethrow;
      }
      throw const BudgetRepositoryException(
        'Unable to delete the trip budget. Please try again.',
      );
    }
  }

  @override
  Future<List<Expense>> getExpenses(
    String tripId, {
    DateTime? from,
    DateTime? to,
  }) async {
    _requireNonEmpty(tripId, 'Trip id');
    _requireAuthenticatedUser();

    try {
      var query =
          _client.from('trip_expenses').select().eq('trip_id', tripId.trim());

      if (from != null) {
        query.gte('spent_at', from.toUtc().toIso8601String());
      }
      if (to != null) {
        query.lte('spent_at', to.toUtc().toIso8601String());
      }

      query
        ..order('spent_at', ascending: false)
        ..order('created_at', ascending: false);

      final rows = await query;
      return rows
          .map(
            (row) => _expenseFromRow(Map<String, dynamic>.from(row)),
          )
          .toList();
    } on PostgrestException catch (error) {
      _logPostgrestError('GET trip_expenses', error);
      throw BudgetRepositoryException(
        'Unable to load trip expenses: ${error.message}',
      );
    } catch (error, stackTrace) {
      _logUnexpected('GET trip_expenses', error, stackTrace);
      if (error is BudgetRepositoryException) {
        rethrow;
      }
      throw const BudgetRepositoryException(
        'Unable to load trip expenses. Please try again.',
      );
    }
  }

  @override
  Future<Expense> addExpense(Expense expense) async {
    _validateExpense(expense, requireId: false);
    _requireAuthenticatedUser();

    final payload = expense.toMap();
    if (expense.id.trim().isEmpty) {
      payload.remove('id');
    }

    try {
      final row =
          await _client.from('trip_expenses').insert(payload).select().single();

      return _expenseFromRow(Map<String, dynamic>.from(row));
    } on PostgrestException catch (error) {
      _logPostgrestError('INSERT trip_expenses', error);
      throw BudgetRepositoryException(
        'Unable to add the expense: ${error.message}',
      );
    } catch (error, stackTrace) {
      _logUnexpected('INSERT trip_expenses', error, stackTrace);
      if (error is BudgetRepositoryException) {
        rethrow;
      }
      throw const BudgetRepositoryException(
        'Unable to add the expense. Please try again.',
      );
    }
  }

  @override
  Future<Expense> updateExpense(Expense expense) async {
    _validateExpense(expense);
    _requireAuthenticatedUser();

    try {
      final row = await _client
          .from('trip_expenses')
          .update({
            'title': expense.title.trim(),
            'amount_paise': expense.amountPaise,
            'currency': expense.currency,
            'category': expense.category,
            'note': expense.note,
            'spent_at': expense.spentAt.toUtc().toIso8601String(),
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', expense.id.trim())
          .select()
          .single();

      return _expenseFromRow(Map<String, dynamic>.from(row));
    } on PostgrestException catch (error) {
      _logPostgrestError('UPDATE trip_expenses', error);
      throw BudgetRepositoryException(
        'Unable to update the expense: ${error.message}',
      );
    } catch (error, stackTrace) {
      _logUnexpected('UPDATE trip_expenses', error, stackTrace);
      if (error is BudgetRepositoryException) {
        rethrow;
      }
      throw const BudgetRepositoryException(
        'Unable to update the expense. Please try again.',
      );
    }
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    _requireNonEmpty(expenseId, 'Expense id');
    _requireAuthenticatedUser();

    try {
      await _client.from('trip_expenses').delete().eq('id', expenseId.trim());
    } on PostgrestException catch (error) {
      _logPostgrestError('DELETE trip_expenses', error);
      throw BudgetRepositoryException(
        'Unable to delete the expense: ${error.message}',
      );
    } catch (error, stackTrace) {
      _logUnexpected('DELETE trip_expenses', error, stackTrace);
      if (error is BudgetRepositoryException) {
        rethrow;
      }
      throw const BudgetRepositoryException(
        'Unable to delete the expense. Please try again.',
      );
    }
  }

  @override
  Future<int> getTotalExpensesPaise(String tripId) async {
    _requireNonEmpty(tripId, 'Trip id');
    _requireAuthenticatedUser();

    try {
      final rows = await _client
          .from('trip_expenses')
          .select('amount_paise')
          .eq('trip_id', tripId.trim());

      return rows.fold<int>(
        0,
        (total, row) =>
            total + _parseInteger(row['amount_paise'], 'amount_paise'),
      );
    } on PostgrestException catch (error) {
      _logPostgrestError('SUM trip_expenses', error);
      throw BudgetRepositoryException(
        'Unable to calculate total expenses: ${error.message}',
      );
    } catch (error, stackTrace) {
      _logUnexpected('SUM trip_expenses', error, stackTrace);
      if (error is BudgetRepositoryException) {
        rethrow;
      }
      throw const BudgetRepositoryException(
        'Unable to calculate total expenses. Please try again.',
      );
    }
  }

  @override
  Future<Map<String, int>> getExpensesByCategoryPaise(String tripId) async {
    _requireNonEmpty(tripId, 'Trip id');
    _requireAuthenticatedUser();

    try {
      final totals = <String, int>{
        for (final category in Expense.categories) category: 0,
      };
      final rows = await _client
          .from('trip_expenses')
          .select('category, amount_paise')
          .eq('trip_id', tripId.trim());

      for (final row in rows) {
        final category = row['category']?.toString();
        if (category == null || !totals.containsKey(category)) {
          throw const BudgetRepositoryException(
            'An expense returned by Supabase has an invalid category.',
          );
        }
        totals[category] = totals[category]! +
            _parseInteger(row['amount_paise'], 'amount_paise');
      }

      return totals;
    } on PostgrestException catch (error) {
      _logPostgrestError('GROUP trip_expenses', error);
      throw BudgetRepositoryException(
        'Unable to calculate category expenses: ${error.message}',
      );
    } catch (error, stackTrace) {
      _logUnexpected('GROUP trip_expenses', error, stackTrace);
      if (error is BudgetRepositoryException) {
        rethrow;
      }
      throw const BudgetRepositoryException(
        'Unable to calculate category expenses. Please try again.',
      );
    }
  }

  User _requireAuthenticatedUser() {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const BudgetRepositoryException(
        'You must be signed in to access your budget data.',
      );
    }
    return user;
  }

  static TripBudget _budgetFromRow(Map<String, dynamic> row) {
    try {
      return TripBudget.fromMap(row);
    } on FormatException catch (error) {
      throw BudgetRepositoryException(
        'A budget returned by Supabase is invalid: ${error.message}',
      );
    }
  }

  static Expense _expenseFromRow(Map<String, dynamic> row) {
    try {
      return Expense.fromMap(row);
    } on FormatException catch (error) {
      throw BudgetRepositoryException(
        'An expense returned by Supabase is invalid: ${error.message}',
      );
    }
  }

  static void _validateBudget(
    TripBudget budget, {
    bool requireId = true,
  }) {
    try {
      budget.validate(requireId: requireId);
    } on FormatException catch (error) {
      throw BudgetRepositoryException(error.message);
    }
  }

  static void _validateExpense(
    Expense expense, {
    bool requireId = true,
  }) {
    try {
      expense.validate(requireId: requireId);
    } on FormatException catch (error) {
      throw BudgetRepositoryException(error.message);
    }
  }

  static int _parseInteger(dynamic value, String fieldName) {
    if (value is int) {
      return value;
    }
    if (value is num && value == value.roundToDouble()) {
      return value.toInt();
    }
    final parsed = int.tryParse(value?.toString() ?? '');
    if (parsed == null) {
      throw BudgetRepositoryException(
        'A budget response contains an invalid $fieldName value.',
      );
    }
    return parsed;
  }

  static void _requireNonEmpty(String value, String fieldName) {
    if (value.trim().isEmpty) {
      throw BudgetRepositoryException('$fieldName must not be empty.');
    }
  }

  static void _logPostgrestError(
    String operation,
    PostgrestException error,
  ) {
    debugPrint('[TravelBuddy][BUDGET] $operation failed: ${error.message}');
    debugPrint('[TravelBuddy][BUDGET] Code: ${error.code}');
  }

  static void _logUnexpected(
    String operation,
    Object error,
    StackTrace stackTrace,
  ) {
    debugPrint('[TravelBuddy][BUDGET] $operation unexpected error: $error');
    debugPrint('[TravelBuddy][BUDGET] STACK TRACE: $stackTrace');
  }
}
