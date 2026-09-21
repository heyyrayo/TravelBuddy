import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'destination_repository.dart';
import 'itinerary_item.dart';
import 'budget_repository.dart';
import 'trip_repository.dart';
import '../../models/expense.dart';
import '../../models/trip_budget.dart';
import '../../features/recommendations/domain/recommendation_presentation.dart';

// ---------------------------------------------------------------------------
// Async lifecycle enum
// ---------------------------------------------------------------------------

enum AsyncStatus {
  idle,
  loading,
  success,
  error,
}

// ---------------------------------------------------------------------------
// Destination state
// ---------------------------------------------------------------------------

class DestinationState extends ChangeNotifier {
  DestinationState(this._repo);

  final DestinationRepository _repo;

  List<Destination> _destinations = [];
  List<Destination> _searchResults = [];
  AsyncStatus _status = AsyncStatus.idle;

  List<Destination> get destinations => List.unmodifiable(_destinations);

  List<Destination> get searchResults => List.unmodifiable(_searchResults);

  AsyncStatus get status => _status;

  Future<void> loadAll() async {
    _status = AsyncStatus.loading;
    notifyListeners();

    try {
      _destinations = await _repo.getAll();
      _status = AsyncStatus.success;
    } catch (_) {
      _status = AsyncStatus.error;
    }

    notifyListeners();
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _searchResults = await _repo.search(query);
    notifyListeners();
  }
}

// ---------------------------------------------------------------------------
// Trip state
// ---------------------------------------------------------------------------

class TripState extends ChangeNotifier {
  TripState(this._repo);

  final TripRepository _repo;

  List<Trip> _trips = [];
  List<SavedPlace> _savedPlaces = [];
  final Map<String, List<ItineraryItem>> _itinerariesByTripId = {};
  final Set<String> _loadingItineraryTripIds = {};
  final Map<String, String> _itineraryErrorsByTripId = {};

  bool _isLoading = false;
  bool _isLoadingTrips = false;
  bool _isLoadingSavedPlaces = false;

  String? _errorMessage;
  String? _tripErrorMessage;
  String? _savedPlaceErrorMessage;

  // -------------------------------------------------------------------------
  // Getters
  // -------------------------------------------------------------------------

  List<Trip> get trips => List.unmodifiable(_trips);

  bool get hasTrips => _trips.isNotEmpty;

  List<SavedPlace> get savedPlaces => List.unmodifiable(_savedPlaces);

  bool get hasSavedPlaces => _savedPlaces.isNotEmpty;

  bool get isLoading => _isLoading;

  bool get isLoadingTrips => _isLoadingTrips;

  bool get isLoadingSavedPlaces => _isLoadingSavedPlaces;

  String? get errorMessage => _errorMessage;

  String? get tripErrorMessage => _tripErrorMessage;

  String? get savedPlaceErrorMessage => _savedPlaceErrorMessage;

  List<ItineraryItem> itineraryForTrip(String tripId) {
    return List.unmodifiable(
      _itinerariesByTripId[tripId] ?? const <ItineraryItem>[],
    );
  }

  bool isLoadingItinerary(String tripId) {
    return _loadingItineraryTripIds.contains(tripId);
  }

  String? itineraryErrorForTrip(String tripId) {
    return _itineraryErrorsByTripId[tripId];
  }

  // -------------------------------------------------------------------------
  // Load everything
  // -------------------------------------------------------------------------

  Future<void> load() async {
    _errorMessage = null;
    _tripErrorMessage = null;
    _savedPlaceErrorMessage = null;

    _isLoading = true;
    notifyListeners();

    try {
      await Future.wait([
        loadTrips(),
        loadSavedPlaces(),
      ]);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -------------------------------------------------------------------------
  // Load trips independently
  // -------------------------------------------------------------------------

  Future<void> loadTrips() async {
    _isLoadingTrips = true;
    _tripErrorMessage = null;

    notifyListeners();

    try {
      final loadedTrips = await _repo.getTrips();

      _trips = List<Trip>.from(loadedTrips);
    } on TripRepositoryException catch (error) {
      _tripErrorMessage = error.message;
      _errorMessage = error.message;
    } catch (_) {
      _tripErrorMessage = 'Unable to load your trips. Please try again.';

      _errorMessage = _tripErrorMessage;
    } finally {
      _isLoadingTrips = false;
      notifyListeners();
    }
  }

  // -------------------------------------------------------------------------
  // Load saved places independently
  // -------------------------------------------------------------------------

  Future<void> loadSavedPlaces() async {
    _isLoadingSavedPlaces = true;
    _savedPlaceErrorMessage = null;

    notifyListeners();

    try {
      final loadedPlaces = await _repo.getSavedPlaces();

      _savedPlaces = List<SavedPlace>.from(loadedPlaces);
    } on TripRepositoryException catch (error) {
      _savedPlaceErrorMessage = error.message;
      _errorMessage = error.message;
    } catch (_) {
      _savedPlaceErrorMessage =
          'Unable to load your saved places. Please try again.';

      _errorMessage = _savedPlaceErrorMessage;
    } finally {
      _isLoadingSavedPlaces = false;
      notifyListeners();
    }
  }

  // -------------------------------------------------------------------------
  // Itinerary
  // -------------------------------------------------------------------------

  Future<void> loadItinerary(
    String tripId,
  ) async {
    final normalizedTripId = tripId.trim();
    _validateTripId(normalizedTripId);

    if (_loadingItineraryTripIds.contains(normalizedTripId)) {
      return;
    }

    _loadingItineraryTripIds.add(normalizedTripId);
    _itineraryErrorsByTripId.remove(normalizedTripId);
    notifyListeners();

    try {
      final loadedItems = await _repo.getItinerary(normalizedTripId);

      _itinerariesByTripId[normalizedTripId] = _sortedItineraryItems(
        loadedItems,
      );
    } on TripRepositoryException catch (error) {
      _itineraryErrorsByTripId[normalizedTripId] = error.message;
    } catch (_) {
      _itineraryErrorsByTripId[normalizedTripId] =
          'Unable to load this itinerary. Please try again.';
    } finally {
      _loadingItineraryTripIds.remove(normalizedTripId);
      notifyListeners();
    }
  }

  Future<ItineraryItem?> addItineraryItem(
    ItineraryItem item,
  ) async {
    try {
      item.validate(requireId: false);
    } on FormatException catch (error) {
      _recordItineraryError(
        item.tripId,
        error,
      );
      return null;
    }

    final tripId = item.tripId.trim();
    _clearItineraryError(tripId);

    try {
      final createdItem = await _repo.addItineraryItem(item);
      final items = [
        ...(_itinerariesByTripId[tripId] ?? const <ItineraryItem>[]),
        createdItem,
      ];

      _itinerariesByTripId[tripId] = _sortedItineraryItems(items);
      notifyListeners();
      return createdItem;
    } on TripRepositoryException catch (error) {
      _itineraryErrorsByTripId[tripId] = error.message;
    } catch (_) {
      _itineraryErrorsByTripId[tripId] =
          'Unable to add this itinerary item. Please try again.';
    }

    notifyListeners();
    return null;
  }

  Future<ItineraryItem?> updateItineraryItem(
    ItineraryItem item,
  ) async {
    try {
      item.validate();
    } on FormatException catch (error) {
      _recordItineraryError(
        item.tripId,
        error,
      );
      return null;
    }

    final tripId = item.tripId.trim();
    _clearItineraryError(tripId);

    try {
      final updatedItem = await _repo.updateItineraryItem(item);
      final existingItems = [
        ...(_itinerariesByTripId[tripId] ?? const <ItineraryItem>[]),
      ];
      final itemIndex = existingItems.indexWhere(
        (currentItem) => currentItem.id == updatedItem.id,
      );

      if (itemIndex == -1) {
        existingItems.add(updatedItem);
      } else {
        existingItems[itemIndex] = updatedItem;
      }

      _itinerariesByTripId[tripId] = _sortedItineraryItems(existingItems);
      notifyListeners();
      return updatedItem;
    } on TripRepositoryException catch (error) {
      _itineraryErrorsByTripId[tripId] = error.message;
    } catch (_) {
      _itineraryErrorsByTripId[tripId] =
          'Unable to update this itinerary item. Please try again.';
    }

    notifyListeners();
    return null;
  }

  Future<bool> deleteItineraryItem(
    String tripId,
    String itemId,
  ) async {
    final normalizedTripId = tripId.trim();
    final normalizedItemId = itemId.trim();

    try {
      _validateTripId(normalizedTripId);
      _requireNonEmpty(
        normalizedItemId,
        'Itinerary item id',
      );
    } on TripRepositoryException catch (error) {
      _recordItineraryError(
        normalizedTripId,
        error,
      );
      return false;
    }

    _clearItineraryError(normalizedTripId);

    try {
      await _repo.deleteItineraryItem(normalizedItemId);
      final existingItems = _itinerariesByTripId[normalizedTripId];

      if (existingItems != null) {
        _itinerariesByTripId[normalizedTripId] =
            existingItems.where((item) => item.id != normalizedItemId).toList();
      }

      notifyListeners();
      return true;
    } on TripRepositoryException catch (error) {
      _itineraryErrorsByTripId[normalizedTripId] = error.message;
    } catch (_) {
      _itineraryErrorsByTripId[normalizedTripId] =
          'Unable to delete this itinerary item. Please try again.';
    }

    notifyListeners();
    return false;
  }

  // -------------------------------------------------------------------------
  // Create trip
  // -------------------------------------------------------------------------

  Future<Trip?> createTrip({
    required String name,
    required String destinationId,
    required DateTime startDate,
    required DateTime endDate,
    required int travelers,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _tripErrorMessage = null;

    notifyListeners();

    try {
      final trip = Trip(
        id: '',
        name: name.trim(),
        destinationId: destinationId,
        startDate: startDate,
        endDate: endDate,
        travelers: travelers,
        status: TripStatus.planning,
      );

      final createdTrip = await _repo.createTrip(trip);

      _trips = [
        ..._trips,
        createdTrip,
      ];

      return createdTrip;
    } on TripRepositoryException catch (error) {
      _errorMessage = error.message;
      _tripErrorMessage = error.message;

      return null;
    } catch (_) {
      const message = 'Unable to create your trip. Please try again.';

      _errorMessage = message;
      _tripErrorMessage = message;

      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -------------------------------------------------------------------------
  // Save place
  // -------------------------------------------------------------------------

  Future<void> savePlace(
    String destinationId,
    String name,
  ) async {
    _errorMessage = null;
    _savedPlaceErrorMessage = null;

    // Prevent duplicate local saves.
    final alreadySaved = _savedPlaces.any(
      (place) => place.destinationId == destinationId,
    );

    if (alreadySaved) {
      notifyListeners();
      return;
    }

    try {
      final place = SavedPlace(
        id: '',
        destinationId: destinationId,
        name: name.trim(),
      );

      await _repo.savePlace(place);

      // Generate a local fallback identifier because
      // Supabase generates the real database ID.
      final localPlace = SavedPlace(
        id: 'local_${DateTime.now().microsecondsSinceEpoch}',
        destinationId: destinationId,
        name: name.trim(),
      );

      _savedPlaces = [
        ..._savedPlaces,
        localPlace,
      ];

      notifyListeners();
    } on TripRepositoryException catch (error) {
      _errorMessage = error.message;
      _savedPlaceErrorMessage = error.message;

      notifyListeners();
    } catch (_) {
      const message = 'Unable to save this place. Please try again.';

      _errorMessage = message;
      _savedPlaceErrorMessage = message;

      notifyListeners();
    }
  }

  // -------------------------------------------------------------------------
  // Clear state when user changes account
  // -------------------------------------------------------------------------

  void clear() {
    _trips = [];
    _savedPlaces = [];
    _itinerariesByTripId.clear();
    _loadingItineraryTripIds.clear();
    _itineraryErrorsByTripId.clear();

    _errorMessage = null;
    _tripErrorMessage = null;
    _savedPlaceErrorMessage = null;

    _isLoading = false;
    _isLoadingTrips = false;
    _isLoadingSavedPlaces = false;

    notifyListeners();
  }

  static List<ItineraryItem> _sortedItineraryItems(
    Iterable<ItineraryItem> items,
  ) {
    final sortedItems = List<ItineraryItem>.from(items);

    sortedItems.sort((left, right) {
      final dayComparison = left.dayNumber.compareTo(right.dayNumber);
      if (dayComparison != 0) {
        return dayComparison;
      }

      return left.sortOrder.compareTo(right.sortOrder);
    });

    return sortedItems;
  }

  static void _validateTripId(String tripId) {
    _requireNonEmpty(tripId, 'Trip id');
  }

  static void _requireNonEmpty(
    String value,
    String fieldName,
  ) {
    if (value.isEmpty) {
      throw TripRepositoryException('$fieldName must not be empty.');
    }
  }

  void _clearItineraryError(String tripId) {
    _itineraryErrorsByTripId.remove(tripId);
  }

  void _recordItineraryError(
    String tripId,
    Object error,
  ) {
    final normalizedTripId = tripId.trim();
    if (normalizedTripId.isEmpty) {
      return;
    }

    _itineraryErrorsByTripId[normalizedTripId] = error is FormatException
        ? error.message
        : error is TripRepositoryException
            ? error.message
            : 'Unable to update this itinerary. Please try again.';
    notifyListeners();
  }
}

// ---------------------------------------------------------------------------
// Budget state
// ---------------------------------------------------------------------------

class TripBudgetState extends ChangeNotifier {
  TripBudgetState(this._repository);

  static const List<String> expenseCategories = Expense.categories;

  final BudgetRepository _repository;

  TripBudget? _budget;
  List<Expense> _expenses = [];
  Map<String, int> _expensesByCategoryPaise = {
    for (final category in expenseCategories) category: 0,
  };

  bool _isLoadingBudget = false;
  bool _isLoadingExpenses = false;
  bool _isSavingBudget = false;
  bool _isSavingExpense = false;
  bool _isDeletingExpense = false;

  String? _errorMessage;
  String? _budgetError;
  String? _expensesError;
  String? _savingError;
  String? _deletingError;

  TripBudget? get budget => _budget;

  List<Expense> get expenses => List.unmodifiable(_expenses);

  Map<String, int> get expensesByCategoryPaise =>
      Map.unmodifiable(_expensesByCategoryPaise);

  bool get isLoadingBudget => _isLoadingBudget;

  bool get isLoadingExpenses => _isLoadingExpenses;

  bool get isSavingBudget => _isSavingBudget;

  bool get isSavingExpense => _isSavingExpense;

  bool get isDeletingExpense => _isDeletingExpense;

  String? get errorMessage => _errorMessage;

  String? get budgetError => _budgetError;

  String? get expensesError => _expensesError;

  String? get savingError => _savingError;

  String? get deletingError => _deletingError;

  bool get hasBudget => _budget != null;

  int get budgetAmountPaise => _budget?.amountPaise ?? 0;

  int get totalSpentPaise => _expenses.fold(
        0,
        (total, expense) => total + expense.amountPaise,
      );

  int get remainingPaise => budgetAmountPaise - totalSpentPaise;

  bool get isOverBudget => hasBudget && remainingPaise < 0;

  double get budgetAmountRupees => budgetAmountPaise / 100;

  double get totalSpentRupees => totalSpentPaise / 100;

  double get remainingRupees => remainingPaise / 100;

  Map<String, int> get categoryTotalsPaise =>
      Map.unmodifiable(_expensesByCategoryPaise);

  Future<void> loadBudget(String tripId) async {
    final normalizedTripId = _validateTripId(tripId);
    _budgetError = null;
    _errorMessage = null;
    _isLoadingBudget = true;
    notifyListeners();

    try {
      _budget = await _repository.getBudget(normalizedTripId);
    } catch (_) {
      _budgetError = 'Unable to load your trip budget.';
      _errorMessage = _budgetError;
    } finally {
      _isLoadingBudget = false;
      notifyListeners();
    }
  }

  Future<void> saveBudget({
    required String tripId,
    required int amountPaise,
  }) async {
    final normalizedTripId = _validateTripId(tripId);
    _savingError = null;
    _budgetError = null;
    _errorMessage = null;

    if (amountPaise < 0) {
      _setSavingError('Budget amount cannot be negative.');
      return;
    }

    _isSavingBudget = true;
    notifyListeners();

    final now = DateTime.now();
    final existingBudget = _budget;
    final budget = TripBudget(
      id: existingBudget?.id ?? _newUuid(),
      tripId: normalizedTripId,
      amountPaise: amountPaise,
      currency: TripBudget.supportedCurrency,
      createdAt: existingBudget?.createdAt ?? now,
      updatedAt: now,
    );

    try {
      budget.validate();
      _budget = await _repository.upsertBudget(budget);
    } catch (_) {
      _setSavingError('Unable to save your budget.');
    } finally {
      _isSavingBudget = false;
      notifyListeners();
    }
  }

  Future<void> loadExpenses(
    String tripId, {
    DateTime? from,
    DateTime? to,
  }) async {
    final normalizedTripId = _validateTripId(tripId);
    _expensesError = null;
    _errorMessage = null;
    _isLoadingExpenses = true;
    notifyListeners();

    try {
      final loadedExpenses = await _repository.getExpenses(
        normalizedTripId,
        from: from,
        to: to,
      );
      _expenses = _sortExpenses(loadedExpenses);
      _recalculateCategoryTotals();
    } catch (_) {
      _expensesError = 'Unable to load your expenses.';
      _errorMessage = _expensesError;
    } finally {
      _isLoadingExpenses = false;
      notifyListeners();
    }
  }

  Future<void> addExpense({
    required String tripId,
    required String title,
    required int amountPaise,
    required String category,
    String? note,
    required DateTime spentAt,
  }) async {
    final normalizedTripId = _validateTripId(tripId);
    final normalizedTitle = title.trim();
    final normalizedNote = _nullableTrimmed(note);

    final validationError = _validateExpenseInput(
      title: normalizedTitle,
      amountPaise: amountPaise,
      category: category,
    );
    if (validationError != null) {
      _setSavingError(validationError);
      return;
    }

    _savingError = null;
    _expensesError = null;
    _errorMessage = null;
    _isSavingExpense = true;
    notifyListeners();

    final now = DateTime.now();
    final expense = Expense(
      id: _newUuid(),
      tripId: normalizedTripId,
      title: normalizedTitle,
      amountPaise: amountPaise,
      currency: Expense.supportedCurrency,
      category: category,
      note: normalizedNote,
      spentAt: spentAt,
      createdAt: now,
      updatedAt: now,
    );

    try {
      expense.validate();
      final createdExpense = await _repository.addExpense(expense);
      _expenses = _sortExpenses([..._expenses, createdExpense]);
      _recalculateCategoryTotals();
    } catch (_) {
      _setSavingError('Unable to save the expense.');
    } finally {
      _isSavingExpense = false;
      notifyListeners();
    }
  }

  Future<void> updateExpense(Expense expense) async {
    final validationError = _validateExpenseInput(
      title: expense.title.trim(),
      amountPaise: expense.amountPaise,
      category: expense.category,
    );
    if (validationError != null) {
      _setSavingError(validationError);
      return;
    }

    _savingError = null;
    _expensesError = null;
    _errorMessage = null;
    _isSavingExpense = true;
    notifyListeners();

    final normalizedExpense = expense.copyWith(
      title: expense.title.trim(),
      note: _nullableTrimmed(expense.note),
    );

    try {
      normalizedExpense.validate();
      final updatedExpense = await _repository.updateExpense(
        normalizedExpense,
      );
      final updatedExpenses = _expenses.map((currentExpense) {
        return currentExpense.id == updatedExpense.id
            ? updatedExpense
            : currentExpense;
      }).toList();
      _expenses = _sortExpenses(updatedExpenses);
      _recalculateCategoryTotals();
    } catch (_) {
      _setSavingError('Unable to save the expense.');
    } finally {
      _isSavingExpense = false;
      notifyListeners();
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    if (expenseId.trim().isEmpty) {
      _setDeletingError('Expense id cannot be empty.');
      return;
    }

    _deletingError = null;
    _expensesError = null;
    _errorMessage = null;
    _isDeletingExpense = true;
    notifyListeners();

    try {
      await _repository.deleteExpense(expenseId.trim());
      _expenses =
          _expenses.where((expense) => expense.id != expenseId.trim()).toList();
      _recalculateCategoryTotals();
    } catch (_) {
      _setDeletingError('Unable to delete the expense.');
    } finally {
      _isDeletingExpense = false;
      notifyListeners();
    }
  }

  Future<void> refresh(String tripId) async {
    await Future.wait([
      loadBudget(tripId),
      loadExpenses(tripId),
    ]);
  }

  void clear() {
    _budget = null;
    _expenses = [];
    _expensesByCategoryPaise = {
      for (final category in expenseCategories) category: 0,
    };

    _isLoadingBudget = false;
    _isLoadingExpenses = false;
    _isSavingBudget = false;
    _isSavingExpense = false;
    _isDeletingExpense = false;

    _errorMessage = null;
    _budgetError = null;
    _expensesError = null;
    _savingError = null;
    _deletingError = null;
    notifyListeners();
  }

  void _recalculateCategoryTotals() {
    final totals = <String, int>{
      for (final category in expenseCategories) category: 0,
    };

    for (final expense in _expenses) {
      if (totals.containsKey(expense.category)) {
        totals[expense.category] =
            totals[expense.category]! + expense.amountPaise;
      }
    }

    _expensesByCategoryPaise = totals;
  }

  void _setSavingError(String message) {
    _savingError = message;
    _errorMessage = message;
    notifyListeners();
  }

  void _setDeletingError(String message) {
    _deletingError = message;
    _errorMessage = message;
    notifyListeners();
  }

  static String _validateTripId(String tripId) {
    final normalizedTripId = tripId.trim();
    if (normalizedTripId.isEmpty) {
      throw const FormatException('Trip id cannot be empty.');
    }
    return normalizedTripId;
  }

  static String? _validateExpenseInput({
    required String title,
    required int amountPaise,
    required String category,
  }) {
    if (title.isEmpty) {
      return 'Expense title cannot be empty.';
    }
    if (amountPaise <= 0) {
      return 'Expense amount must be greater than zero.';
    }
    if (!expenseCategories.contains(category)) {
      return 'Choose a valid expense category.';
    }
    return null;
  }

  static List<Expense> _sortExpenses(Iterable<Expense> expenses) {
    final sortedExpenses = List<Expense>.from(expenses);
    sortedExpenses.sort((left, right) {
      final spentComparison = right.spentAt.compareTo(left.spentAt);
      if (spentComparison != 0) {
        return spentComparison;
      }
      return right.createdAt.compareTo(left.createdAt);
    });
    return sortedExpenses;
  }

  static String? _nullableTrimmed(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  static String _newUuid() {
    final random = math.Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    String hexByte(int value) => value.toRadixString(16).padLeft(2, '0');

    final hex = bytes.map(hexByte).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }
}

class BudgetState extends ChangeNotifier {
  AsyncStatus _status = AsyncStatus.idle;

  Map<String, int>? _breakdown;

  AsyncStatus get status => _status;

  Map<String, int>? get breakdown => _breakdown;

  Future<void> calculateBudget({
    required String destination,
    required int days,
    required int travelers,
  }) async {
    _status = AsyncStatus.loading;
    notifyListeners();

    await Future.delayed(
      const Duration(seconds: 2),
    );

    _breakdown = {
      'Accommodation': 15000 * travelers * days ~/ 5,
      'Transport': 12000,
      'Food': 8500 * travelers * days ~/ 5,
      'Activities': 6000,
      'Shopping': 2000,
      'Emergency Buffer': 2000,
    };

    _status = AsyncStatus.success;
    notifyListeners();
  }

  void reset() {
    _status = AsyncStatus.idle;
    _breakdown = null;
    notifyListeners();
  }

  void debugForceStatus(AsyncStatus status) {
    _status = status;
    notifyListeners();
  }
}

// ---------------------------------------------------------------------------
// Recommendation state
// ---------------------------------------------------------------------------

class RecommendationState extends ChangeNotifier {
  AsyncStatus _status = AsyncStatus.idle;

  List<RecommendationPresentation> _recommendations = [];

  AsyncStatus get status => _status;

  List<RecommendationPresentation> get recommendations =>
      List.unmodifiable(_recommendations);

  bool get hasRecommendations => _recommendations.isNotEmpty;

  Future<void> load() async {
    _status = AsyncStatus.loading;
    notifyListeners();

    // Real recommendation data is not connected yet.
    // Keep the production UI empty rather than presenting fabricated
    // destinations or unsupported recommendation claims.
    _recommendations = [];

    _status = AsyncStatus.success;
    notifyListeners();
  }

  void reset() {
    _status = AsyncStatus.idle;
    _recommendations = [];
    notifyListeners();
  }

  void debugForceStatus(AsyncStatus status) {
    _status = status;
    notifyListeners();
  }
}
// ---------------------------------------------------------------------------
// Notification state
// ---------------------------------------------------------------------------

class AppNotificationState extends ChangeNotifier {
  int _unreadCount = 3;

  int get unreadCount => _unreadCount;

  void markAllRead() {
    _unreadCount = 0;
    notifyListeners();
  }
}
