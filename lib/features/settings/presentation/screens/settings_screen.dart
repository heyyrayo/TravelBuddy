import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.onLogout});

  final VoidCallback? onLogout;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;

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
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          _SectionHeader(title: 'Preferences'),
          _ToggleTile(
            icon: AppIcons.darkMode,
            label: 'Dark Mode',
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
          ),
          _NavTile(
            icon: AppIcons.language,
            label: 'Language',
            trailing: 'English',
            onTap: () {},
          ),
          _ToggleTile(
            icon: AppIcons.bell,
            label: 'Notifications',
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
          ),
          const Divider(height: 1),
          _SectionHeader(title: 'Privacy & Security'),
          _NavTile(
            icon: AppIcons.privacy,
            label: 'Privacy Policy',
            onTap: () {},
          ),
          _NavTile(
            icon: AppIcons.gear,
            label: 'Permissions',
            onTap: () {},
          ),
          const Divider(height: 1),
          _SectionHeader(title: 'Support'),
          _NavTile(
            icon: AppIcons.helpCenter,
            label: 'Help Center',
            onTap: () {},
          ),
          _NavTile(
            icon: AppIcons.about,
            label: 'About TravelBuddy',
            trailing: 'v2.4.1',
            onTap: () {},
          ),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: TextButton.icon(
              onPressed: widget.onLogout,
              icon: const Icon(AppIcons.logout, color: AppColors.error),
              label: const Text(
                'Sign Out',
                style: TextStyle(color: AppColors.error),
              ),
              style: TextButton.styleFrom(
                minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
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
          AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.xs),
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

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      label: label,
      child: SwitchListTile(
        secondary: Icon(icon, color: AppColors.onSurfaceVariant),
        title: Text(label),
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: ListTile(
        leading: Icon(icon, color: AppColors.onSurfaceVariant),
        title: Text(label),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailing != null)
              Text(
                trailing!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            const Icon(AppIcons.chevronRight, color: AppColors.outlineVariant),
          ],
        ),
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      ),
    );
  }
}
