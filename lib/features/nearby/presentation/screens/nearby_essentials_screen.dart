import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/inputs/search_field.dart';

class NearbyEssentialsScreen extends StatefulWidget {
  const NearbyEssentialsScreen({super.key});

  @override
  State<NearbyEssentialsScreen> createState() => _NearbyEssentialsScreenState();
}

class _NearbyEssentialsScreenState extends State<NearbyEssentialsScreen> {
  bool _isListView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        leading: Semantics(
          label: 'Back',
          child: IconButton(
            icon: const Icon(AppIcons.back),
            tooltip: 'Back',
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        title: const Text('Nearby Essentials'),
        actions: [
          Semantics(
            label: _isListView ? 'Switch to Map' : 'Switch to List',
            child: IconButton(
              icon: Icon(_isListView ? AppIcons.map : AppIcons.list),
              tooltip: _isListView ? 'Map view' : 'List view',
              onPressed: () => setState(() => _isListView = !_isListView),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
            child: SearchField(
              hintText: 'Search nearby services...',
              showMicButton: false,
            ),
          ),
        ),
      ),
      body: _isListView ? _ListView() : _MapPlaceholder(),
    );
  }
}

class _ListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Find critical services around your current location',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _CategorySection(
            title: 'Emergency',
            borderColor: AppColors.error,
            items: const [
              _NearbyItem(AppIcons.hospital, 'City General Hospital', '1.2 km', 'Open 24/7', AppColors.error),
              _NearbyItem(AppIcons.police, 'Central Police Station', '0.8 km', 'Open 24/7', AppColors.error),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _CategorySection(
            title: 'Travel',
            borderColor: AppColors.primary,
            items: const [
              _NearbyItem(AppIcons.transport, 'Main Railway Station', '2.1 km', 'Open Now', AppColors.primary),
              _NearbyItem(AppIcons.flight, 'Bus Stand', '1.5 km', 'Open Now', AppColors.primary),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _CategorySection(
            title: 'Daily Needs',
            borderColor: AppColors.tertiary,
            items: const [
              _NearbyItem(AppIcons.atm, 'SBI ATM', '0.3 km', 'Open 24/7', AppColors.tertiary),
              _NearbyItem(AppIcons.restaurant, 'Johnson Café', '0.5 km', 'Closes 11 PM', AppColors.tertiary),
              _NearbyItem(AppIcons.store, 'Mountain Pharmacy', '0.7 km', 'Open Now', AppColors.tertiary),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.title,
    required this.borderColor,
    required this.items,
  });

  final String title;
  final Color borderColor;
  final List<_NearbyItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...items.map((item) => _NearbyCard(item: item, borderColor: borderColor)),
      ],
    );
  }
}

class _NearbyItem {
  const _NearbyItem(this.icon, this.name, this.distance, this.status, this.color);

  final IconData icon;
  final String name;
  final String distance;
  final String status;
  final Color color;
}

class _NearbyCard extends StatelessWidget {
  const _NearbyCard({required this.item, required this.borderColor});

  final _NearbyItem item;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${item.name}, ${item.distance}, ${item.status}',
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border(
            left: BorderSide(color: borderColor, width: 4),
          ),
          boxShadow: AppColors.level2Shadow,
        ),
        child: ListTile(
          leading: Icon(item.icon, color: item.color),
          title: Text(item.name, style: Theme.of(context).textTheme.titleSmall),
          subtitle: Text(item.status,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  )),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            ),
            child: Text(
              item.distance,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.tertiaryFixed.withOpacity(0.3),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.map, size: 64, color: AppColors.tertiary),
            SizedBox(height: AppSpacing.md),
            Text('Map view', style: TextStyle(color: AppColors.tertiary)),
          ],
        ),
      ),
    );
  }
}
