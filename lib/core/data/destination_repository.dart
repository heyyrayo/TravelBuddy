// Destination domain models and repository
class Destination {
  const Destination({
    required this.id,
    required this.name,
    required this.state,
    required this.category,
    required this.budgetTier,
    this.description,
  });

  final String id;
  final String name;
  final String state;
  final String category;
  final String budgetTier;
  final String? description;
}

abstract class DestinationRepository {
  Future<List<Destination>> getAll();
  Future<Destination?> getById(String id);
  Future<List<Destination>> search(String query);
}

class InMemoryDestinationRepository implements DestinationRepository {
  static const _data = [
    Destination(id: 'manali', name: 'Manali', state: 'Himachal Pradesh', category: 'Hill Stations', budgetTier: '₹₹'),
    Destination(id: 'goa', name: 'Goa', state: 'Goa', category: 'Beaches', budgetTier: '₹₹'),
    Destination(id: 'jaipur', name: 'Jaipur', state: 'Rajasthan', category: 'Heritage', budgetTier: '₹₹'),
    Destination(id: 'rishikesh', name: 'Rishikesh', state: 'Uttarakhand', category: 'Adventure', budgetTier: '₹'),
    Destination(id: 'kerala', name: 'Kerala Backwaters', state: 'Kerala', category: 'Beaches', budgetTier: '₹₹₹'),
    Destination(id: 'ranthambore', name: 'Ranthambore', state: 'Rajasthan', category: 'Wildlife', budgetTier: '₹₹₹'),
    Destination(id: 'varanasi', name: 'Varanasi', state: 'Uttar Pradesh', category: 'Religious', budgetTier: '₹'),
    Destination(id: 'munnar', name: 'Munnar', state: 'Kerala', category: 'Hill Stations', budgetTier: '₹₹'),
    Destination(id: 'jaisalmer', name: 'Jaisalmer', state: 'Rajasthan', category: 'Heritage', budgetTier: '₹₹'),
    Destination(id: 'gokarna', name: 'Gokarna', state: 'Karnataka', category: 'Beaches', budgetTier: '₹'),
  ];

  @override
  Future<List<Destination>> getAll() async => _data;

  @override
  Future<Destination?> getById(String id) async =>
      _data.where((d) => d.id == id).firstOrNull;

  @override
  Future<List<Destination>> search(String query) async {
    final q = query.toLowerCase();
    return _data.where((d) =>
        d.name.toLowerCase().contains(q) ||
        d.state.toLowerCase().contains(q) ||
        d.category.toLowerCase().contains(q)).toList();
  }
}
