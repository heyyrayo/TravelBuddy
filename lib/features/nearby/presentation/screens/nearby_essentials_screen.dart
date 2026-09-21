import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/data/nearby_repository.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/nearby_places_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../models/nearby_place.dart';

class NearbyEssentialsScreen extends StatefulWidget {
  const NearbyEssentialsScreen({super.key});

  @override
  State<NearbyEssentialsScreen> createState() => _NearbyEssentialsScreenState();
}

class _NearbyEssentialsScreenState extends State<NearbyEssentialsScreen> {
  final NearbyRepository _repository = const NearbyRepository();
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  bool _isListView = true;
  bool _isLoading = true;
  String? _errorMessage;
  List<NearbyPlace> _places = const [];
  String _searchQuery = '';
  String? _selectedCategory;
  NearbyPlace? _selectedPlace;

  double? _userLatitude;
  double? _userLongitude;

  @override
  void initState() {
    super.initState();
    _loadNearbyPlaces();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNearbyPlaces() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectedPlace = null;
    });

    try {
      final position = await _repository.getCurrentPosition();
      final places = await _repository.getNearbyPlaces(
        radiusMeters: 5000,
        category: _selectedCategory,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _userLatitude = position.latitude;
        _userLongitude = position.longitude;
        _places = places;
        _isLoading = false;
      });

      if (!_isListView) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _moveMapToCurrentLocation();
        });
      }
    } on LocationServiceException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _places = const [];
        _isLoading = false;
        _errorMessage = error.message;
      });
    } on NearbyPlacesException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _places = const [];
        _isLoading = false;
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _places = const [];
        _isLoading = false;
        _errorMessage = 'Unable to load nearby places. Please try again.';
      });
    }
  }

  List<NearbyPlace> get _filteredPlaces {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return _places;
    }

    return _places.where((place) {
      return place.name.toLowerCase().contains(query) ||
          place.category.toLowerCase().contains(query) ||
          (place.address?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  List<String> get _categories {
    final categories = _places
        .map((place) => place.category)
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList();

    categories.sort();
    return categories;
  }

  String get _summaryText {
    final places = _filteredPlaces;
    final count = places.length;

    if (count == 0) {
      return 'No places nearby';
    }

    final query = _searchQuery.trim();
    if (query.isNotEmpty) {
      return '$count result${count == 1 ? '' : 's'} for "$query"';
    }

    if (_selectedCategory != null) {
      return '$count ${_selectedCategory!.toLowerCase()}${count == 1 ? '' : 's'} within 5 km';
    }

    return '$count places nearby';
  }

  IconData _iconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'hospital':
        return AppIcons.hospital;
      case 'police':
        return AppIcons.police;
      case 'railway':
        return AppIcons.transport;
      case 'bus':
        return AppIcons.transport;
      case 'atm':
        return AppIcons.atm;
      case 'restaurant':
        return AppIcons.restaurant;
      case 'pharmacy':
        return AppIcons.store;
      case 'shop':
        return AppIcons.store;
      default:
        return AppIcons.location;
    }
  }

  Color _colorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'hospital':
        return const Color(0xFFCB3A3A);
      case 'police':
        return const Color(0xFF2F4F8F);
      case 'railway':
      case 'bus':
        return AppColors.primary;
      case 'atm':
        return const Color(0xFF0F766E);
      case 'restaurant':
        return const Color(0xFFE07A34);
      case 'pharmacy':
        return const Color(0xFF4F46E5);
      case 'shop':
        return const Color(0xFF0F766E);
      default:
        return AppColors.tertiary;
    }
  }

  void _moveMapToCurrentLocation() {
    final latitude = _userLatitude;
    final longitude = _userLongitude;

    if (latitude == null || longitude == null) {
      return;
    }

    _mapController.move(
      LatLng(latitude, longitude),
      14,
    );
  }

  void _zoomMap(double delta) {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(
      _mapController.camera.center,
      (currentZoom + delta).clamp(3.0, 19.0),
    );
  }

  LatLng? _currentLocation() {
    final latitude = _userLatitude;
    final longitude = _userLongitude;

    if (latitude == null || longitude == null) {
      return null;
    }

    return LatLng(latitude, longitude);
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
      _selectedPlace = null;
    });
    _loadNearbyPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final places = _filteredPlaces;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Semantics(
          label: 'Back',
          child: IconButton(
            icon: const Icon(AppIcons.back),
            tooltip: 'Back',
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nearby Essentials'),
            Text(
              'Everything you need around you',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        actions: [
          Semantics(
            label: _isListView ? 'Switch to map' : 'Switch to list',
            child: IconButton(
              icon: Icon(
                _isListView ? AppIcons.map : AppIcons.list,
              ),
              tooltip: _isListView ? 'Map view' : 'List view',
              onPressed: () {
                setState(() {
                  _isListView = !_isListView;
                });

                if (!_isListView) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _moveMapToCurrentLocation();
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: _isListView
            ? _buildListView(context, places)
            : _buildMapView(context, places),
      ),
    );
  }

  Widget _buildListView(
    BuildContext context,
    List<NearbyPlace> places,
  ) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _ErrorState(
        message: _errorMessage!,
        onRetry: _loadNearbyPlaces,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNearbyPlaces,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.xxl,
        ),
        children: [
          _buildSearchBar(context),
          const SizedBox(height: AppSpacing.md),
          _buildCategoryStrip(context),
          const SizedBox(height: AppSpacing.md),
          _buildSummaryTile(context, _summaryText),
          const SizedBox(height: AppSpacing.md),
          if (places.isEmpty)
            _EmptyState(
              onClear: () {
                setState(() {
                  _searchQuery = '';
                  _selectedCategory = null;
                  _searchController.clear();
                });
                _loadNearbyPlaces();
              },
            )
          else
            ...places.map(
              (place) => InkWell(
                onTap: () => _showPlaceDetails(context, place),
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                child: _NearbyPlaceCard(
                  place: place,
                  icon: _iconForCategory(place.category),
                  color: _colorForCategory(place.category),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMapView(
    BuildContext context,
    List<NearbyPlace> places,
  ) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _ErrorState(
        message: _errorMessage!,
        onRetry: _loadNearbyPlaces,
      );
    }

    final center = _currentLocation();

    if (center == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Text('Current location is unavailable.'),
        ),
      );
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: 14,
            minZoom: 3,
            maxZoom: 19,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.travelbuddy.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: center,
                  width: 62,
                  height: 62,
                  child: _CurrentLocationMarker(),
                ),
                ...places.map(
                  (place) {
                    final selected = _selectedPlace?.id == place.id;
                    return Marker(
                      point: LatLng(place.latitude, place.longitude),
                      width: selected ? 58 : 46,
                      height: selected ? 58 : 46,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPlace = place;
                          });
                          _showPlaceDetails(context, place);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOutCubic,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _colorForCategory(place.category),
                            border: Border.all(
                              color: selected
                                  ? AppColors.surfaceContainerLowest
                                  : AppColors.surfaceContainerLowest,
                              width: selected ? 3 : 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _colorForCategory(place.category)
                                    .withOpacity(0.32),
                                blurRadius: selected ? 16 : 10,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            _iconForCategory(place.category),
                            color: Colors.white,
                            size: selected ? 22 : 20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution('OpenStreetMap contributors'),
              ],
            ),
          ],
        ),
        Positioned(
          top: AppSpacing.md,
          left: AppSpacing.md,
          right: AppSpacing.md,
          child: Column(
            children: [
              _buildSearchBar(context),
              const SizedBox(height: AppSpacing.sm),
              _buildSummaryTile(context, _summaryText),
            ],
          ),
        ),
        Positioned(
          right: AppSpacing.md,
          bottom: AppSpacing.md,
          child: _MapControls(
            onMyLocation: _moveMapToCurrentLocation,
            onZoomIn: () => _zoomMap(1),
            onZoomOut: () => _zoomMap(-1),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withOpacity(0.96),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppColors.level2Shadow,
      ),
      child: Row(
        children: [
          const SizedBox(width: AppSpacing.md),
          const Icon(AppIcons.search,
              color: AppColors.onSurfaceVariant, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search hospitals, restaurants, ATMs...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                isDense: true,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.outline,
                    ),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          if (_searchQuery.trim().isNotEmpty)
            IconButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
              tooltip: 'Clear search',
              icon: const Icon(Icons.close_rounded),
              color: AppColors.onSurfaceVariant,
            ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
    );
  }

  Widget _buildCategoryStrip(BuildContext context) {
    final categories = _categories;

    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    final chips = <Widget>[
      _CategoryChip(
        label: 'All',
        icon: AppIcons.location,
        selected: _selectedCategory == null,
        onTap: () => _onCategorySelected(null),
      ),
      ...categories.map(
        (category) => _CategoryChip(
          label: category,
          icon: _iconForCategory(category),
          selected: _selectedCategory == category,
          onTap: () => _onCategorySelected(category),
        ),
      ),
    ];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) => chips[index],
      ),
    );
  }

  Widget _buildSummaryTile(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withOpacity(0.96),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppColors.level2Shadow,
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.onSurface,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AppSpacing.md),
          Text('Finding essentials around you...'),
        ],
      ),
    );
  }

  void _showPlaceDetails(
    BuildContext context,
    NearbyPlace place,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final color = _colorForCategory(place.category);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: color.withOpacity(0.14),
                      child: Icon(
                        _iconForCategory(place.category),
                        color: color,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        place.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.10),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusPill),
                      ),
                      child: Text(
                        place.category,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    if (place.distanceMeters != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusPill),
                        ),
                        child: Text(
                          place.distanceLabel,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                  ],
                ),
                if (place.address != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        AppIcons.location,
                        size: 18,
                        color: AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          place.address!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (place.phone != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(
                        AppIcons.phone,
                        size: 18,
                        color: AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          place.phone!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
                if (place.website != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        AppIcons.helpCenter,
                        size: 18,
                        color: AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          place.website!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.info_outline_rounded),
                    label: const Text('View details'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CurrentLocationMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.12),
          ),
        ),
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            border: Border.all(
              color: AppColors.surfaceContainerLowest,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MapControls extends StatelessWidget {
  const _MapControls({
    required this.onMyLocation,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  final VoidCallback onMyLocation;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withOpacity(0.96),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppColors.level2Shadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MapControlButton(
            icon: AppIcons.gps,
            tooltip: 'My location',
            onPressed: onMyLocation,
          ),
          const SizedBox(height: 6),
          _MapControlButton(
            icon: Icons.add,
            tooltip: 'Zoom in',
            onPressed: onZoomIn,
          ),
          const SizedBox(height: 6),
          _MapControlButton(
            icon: Icons.remove,
            tooltip: 'Zoom out',
            onPressed: onZoomOut,
          ),
        ],
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  const _MapControlButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: tooltip,
      child: Material(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: SizedBox(
            width: 42,
            height: 42,
            child: Icon(icon, size: 20, color: AppColors.onSurface),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.onSurfaceVariant;

    return Semantics(
      label: label,
      button: true,
      child: Material(
        color: selected
            ? AppColors.primary.withOpacity(0.08)
            : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.outlineVariant,
                width: selected ? 1.2 : 1,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: color,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NearbyPlaceCard extends StatelessWidget {
  const _NearbyPlaceCard({
    required this.place,
    required this.icon,
    required this.color,
  });

  final NearbyPlace place;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${place.name}, ${place.category}, ${place.distanceLabel}',
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(color: AppColors.outlineVariant, width: 1),
          boxShadow: AppColors.level2Shadow,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    place.category,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (place.distanceMeters != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      place.distanceLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                  ],
                  if (place.address != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      place.address!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(
              AppIcons.chevronRight,
              size: 18,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.location_off_outlined,
                size: 36,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Unable to load nearby places',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Check your connection or location permission and try again.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.onClear,
  });

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxl,
      ),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 42,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'No results found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Try another category or search term.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.filter_alt_off_rounded),
            label: const Text('Clear filters'),
          ),
        ],
      ),
    );
  }
}
