import '../../models/expense.dart';
import '../../models/trip_budget.dart';

abstract class BudgetRepository {
  Future<TripBudget?> getBudget(String tripId);

  Future<TripBudget> upsertBudget(TripBudget budget);

  Future<void> deleteBudget(String tripId);

  Future<List<Expense>> getExpenses(
    String tripId, {
    DateTime? from,
    DateTime? to,
  });

  Future<Expense> addExpense(Expense expense);

  Future<Expense> updateExpense(Expense expense);

  Future<void> deleteExpense(String expenseId);

  Future<int> getTotalExpensesPaise(String tripId);

  Future<Map<String, int>> getExpensesByCategoryPaise(String tripId);
}

class BudgetRepositoryException implements Exception {
  const BudgetRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
