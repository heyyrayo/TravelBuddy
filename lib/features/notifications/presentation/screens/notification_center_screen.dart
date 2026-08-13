import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

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
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        children: [
          _SectionHeader(title: 'Today'),
          _NotificationTile(
            icon: AppIcons.warning,
            iconColor: AppColors.error,
            bgColor: AppColors.errorContainer,
            title: 'Emergency Alert',
            body: 'Heavy rainfall predicted in Manali region for Oct 14',
            time: '2h ago',
            isUnread: true,
          ),
          _NotificationTile(
            icon: AppIcons.weather,
            iconColor: AppColors.tertiary,
            bgColor: AppColors.tertiaryFixed.withOpacity(0.4),
            title: 'Weather Alert',
            body: 'Temperatures dropping to 5°C in Manali. Pack extra layers.',
            time: '4h ago',
            isUnread: true,
          ),
          _NotificationTile(
            icon: AppIcons.saveMoney,
            iconColor: AppColors.secondary,
            bgColor: AppColors.secondaryFixed.withOpacity(0.5),
            title: 'Budget Suggestion',
            body: 'Book The Himalayan Hotel now — prices going up next week.',
            time: '6h ago',
            isUnread: false,
          ),
          const Divider(height: 1),
          _SectionHeader(title: 'Earlier'),
          _NotificationTile(
            icon: AppIcons.trips,
            iconColor: AppColors.primary,
            bgColor: AppColors.primaryFixed.withOpacity(0.4),
            title: 'Packing Reminder',
            body: 'You\'re 3 items away from completing your packing list!',
            time: 'Yesterday',
            isUnread: false,
          ),
          _NotificationTile(
            icon: AppIcons.bell,
            iconColor: AppColors.secondary,
            bgColor: AppColors.secondaryFixed.withOpacity(0.4),
            title: 'Festival Notification',
            body: 'Kullu Dussehra starts tomorrow — one of India\'s biggest festivals!',
            time: '2 days ago',
            isUnread: false,
          ),
          _NotificationTile(
            icon: AppIcons.check,
            iconColor: AppColors.primary,
            bgColor: AppColors.primaryFixed.withOpacity(0.4),
            title: 'Trip Created',
            body: 'Your Manali Retreat trip plan has been saved successfully.',
            time: '3 days ago',
            isUnread: false,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.body,
    required this.time,
    required this.isUnread,
  });

  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String body;
  final String time;
  final bool isUnread;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title. $body. $time',
      child: InkWell(
        onTap: () {},
        child: Container(
          color: isUnread ? AppColors.primaryFixed.withOpacity(0.08) : null,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline dot
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
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
                            title,
                            style:
                                Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: AppColors.onSurface,
                                      fontWeight: isUnread
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      body,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.outline,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
