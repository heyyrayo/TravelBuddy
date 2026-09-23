import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../application/recommendation_preferences_state.dart';
import '../../domain/recommendation_experience.dart';
import '../../domain/recommendation_user_preferences.dart';

class RecommendationPreferencesScreen extends StatefulWidget {
  const RecommendationPreferencesScreen({
    super.key,
  });

  @override
  State<RecommendationPreferencesScreen> createState() =>
      _RecommendationPreferencesScreenState();
}

class _RecommendationPreferencesScreenState
    extends State<RecommendationPreferencesScreen> {
  String _travelMonth = '01';
  TemperaturePreference _temperaturePreference =
      TemperaturePreference.moderate;

  bool _templeInterest = false;
  bool _shrineInterest = false;
  bool _palaceInterest = false;
  bool _monumentInterest = false;
  bool _churchInterest = false;
  bool _museumInterest = false;
  bool _stadiumInterest = false;
  bool _customsHouseInterest = false;

  final Set<RecommendationExperience> _experiences =
      <RecommendationExperience>{};

  static const _supportedExperiences = <RecommendationExperience>[
    RecommendationExperience.hills,
    RecommendationExperience.mountains,
    RecommendationExperience.forests,
    RecommendationExperience.lakes,
    RecommendationExperience.rivers,
    RecommendationExperience.protectedNature,
  ];

  TransportPreference _transportPreference = TransportPreference.either;
  TourismPreference _tourismPreference = TourismPreference.either;
  PopulationPreference _populationPreference = PopulationPreference.either;

  final TextEditingController _tripDurationController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    final preferences =
        context.read<RecommendationPreferencesState>().preferences;

    if (preferences != null) {
      _travelMonth = preferences.travelMonth;
      _temperaturePreference = preferences.temperaturePreference;
      _templeInterest = preferences.templeInterest;
      _shrineInterest = preferences.shrineInterest;
      _palaceInterest = preferences.palaceInterest;
      _monumentInterest = preferences.monumentInterest;
      _churchInterest = preferences.churchInterest;
      _museumInterest = preferences.museumInterest;
      _stadiumInterest = preferences.stadiumInterest;
      _customsHouseInterest = preferences.customsHouseInterest;
      _experiences
        ..clear()
        ..addAll(
          preferences.experiences.where(
            _supportedExperiences.contains,
          ),
        );
      _transportPreference = preferences.transportPreference;
      _tourismPreference = preferences.tourismPreference;
      _populationPreference = preferences.populationPreference;

      if (preferences.tripDurationDays != null) {
        _tripDurationController.text =
            preferences.tripDurationDays.toString();
      }
    }
  }

  @override
  void dispose() {
    _tripDurationController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final durationText = _tripDurationController.text.trim();
    int? tripDurationDays;

    if (durationText.isNotEmpty) {
      tripDurationDays = int.tryParse(durationText);

      if (tripDurationDays == null || tripDurationDays <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Trip duration must be a positive whole number.',
            ),
          ),
        );
        return;
      }
    }

    final preferences = RecommendationUserPreferences(
      travelMonth: _travelMonth,
      temperaturePreference: _temperaturePreference,
      templeInterest: _templeInterest,
      shrineInterest: _shrineInterest,
      palaceInterest: _palaceInterest,
      monumentInterest: _monumentInterest,
      churchInterest: _churchInterest,
      museumInterest: _museumInterest,
      stadiumInterest: _stadiumInterest,
      customsHouseInterest: _customsHouseInterest,
      transportPreference: _transportPreference,
      tourismPreference: _tourismPreference,
      populationPreference: _populationPreference,
      tripDurationDays: tripDurationDays,
      experiences: Set<RecommendationExperience>.from(_experiences),
    );

    await context.read<RecommendationPreferencesState>().save(preferences);

    if (!mounted) {
      return;
    }

    final state = context.read<RecommendationPreferencesState>();

    if (state.status == RecommendationPreferencesStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not save recommendation preferences.',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recommendation preferences saved.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RecommendationPreferencesState>();
    final isSaving =
        state.status == RecommendationPreferencesStatus.saving;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        title: const Text('Recommendation Preferences'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Tell TravelBuddy what you want to use for destination matching.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),

          _SectionTitle(title: 'Travel Month'),
          DropdownButtonFormField<String>(
            value: _travelMonth,
            decoration: const InputDecoration(
              labelText: 'Month',
            ),
            items: List.generate(
              12,
              (index) {
                final month = (index + 1).toString().padLeft(2, '0');

                return DropdownMenuItem(
                  value: month,
                  child: Text(month),
                );
              },
            ),
            onChanged: isSaving
                ? null
                : (value) {
                    if (value != null) {
                      setState(() => _travelMonth = value);
                    }
                  },
          ),

          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(title: 'Temperature'),
          SegmentedButton<TemperaturePreference>(
            segments: const [
              ButtonSegment(
                value: TemperaturePreference.cool,
                label: Text('Cool'),
              ),
              ButtonSegment(
                value: TemperaturePreference.moderate,
                label: Text('Moderate'),
              ),
              ButtonSegment(
                value: TemperaturePreference.warm,
                label: Text('Warm'),
              ),
            ],
            selected: {_temperaturePreference},
            onSelectionChanged: isSaving
                ? null
                : (selection) {
                    setState(
                      () => _temperaturePreference = selection.first,
                    );
                  },
          ),

          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(title: 'Experience Interests'),
          Text(
            'Select the natural experiences you want considered.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),

          ..._supportedExperiences.map(
            (experience) => CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(experience.displayName),
              value: _experiences.contains(experience),
              onChanged: isSaving
                  ? null
                  : (selected) {
                      if (selected == null) {
                        return;
                      }

                      setState(() {
                        if (selected) {
                          _experiences.add(experience);
                        } else {
                          _experiences.remove(experience);
                        }
                      });
                    },
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(title: 'Attraction Interests'),

          _interestTile(
            'Temples',
            _templeInterest,
            (value) => setState(() => _templeInterest = value),
            isSaving,
          ),
          _interestTile(
            'Shrines',
            _shrineInterest,
            (value) => setState(() => _shrineInterest = value),
            isSaving,
          ),
          _interestTile(
            'Palaces',
            _palaceInterest,
            (value) => setState(() => _palaceInterest = value),
            isSaving,
          ),
          _interestTile(
            'Monuments',
            _monumentInterest,
            (value) => setState(() => _monumentInterest = value),
            isSaving,
          ),
          _interestTile(
            'Churches',
            _churchInterest,
            (value) => setState(() => _churchInterest = value),
            isSaving,
          ),
          _interestTile(
            'Museums',
            _museumInterest,
            (value) => setState(() => _museumInterest = value),
            isSaving,
          ),
          _interestTile(
            'Stadiums',
            _stadiumInterest,
            (value) => setState(() => _stadiumInterest = value),
            isSaving,
          ),
          _interestTile(
            'Customs Houses',
            _customsHouseInterest,
            (value) => setState(() => _customsHouseInterest = value),
            isSaving,
          ),

          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(title: 'Transport'),
          SegmentedButton<TransportPreference>(
            segments: const [
              ButtonSegment(
                value: TransportPreference.rail,
                label: Text('Rail'),
              ),
              ButtonSegment(
                value: TransportPreference.air,
                label: Text('Air'),
              ),
              ButtonSegment(
                value: TransportPreference.either,
                label: Text('Either'),
              ),
            ],
            selected: {_transportPreference},
            onSelectionChanged: isSaving
                ? null
                : (selection) {
                    setState(
                      () => _transportPreference = selection.first,
                    );
                  },
          ),

          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(title: 'Tourism Preference'),
          SegmentedButton<TourismPreference>(
            segments: const [
              ButtonSegment(
                value: TourismPreference.popular,
                label: Text('Popular'),
              ),
              ButtonSegment(
                value: TourismPreference.lessTouristy,
                label: Text('Less Touristy'),
              ),
              ButtonSegment(
                value: TourismPreference.either,
                label: Text('Either'),
              ),
            ],
            selected: {_tourismPreference},
            onSelectionChanged: isSaving
                ? null
                : (selection) {
                    setState(
                      () => _tourismPreference = selection.first,
                    );
                  },
          ),

          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(title: 'City Size'),
          SegmentedButton<PopulationPreference>(
            segments: const [
              ButtonSegment(
                value: PopulationPreference.largeCity,
                label: Text('Large City'),
              ),
              ButtonSegment(
                value: PopulationPreference.smallCity,
                label: Text('Small City'),
              ),
              ButtonSegment(
                value: PopulationPreference.either,
                label: Text('Either'),
              ),
            ],
            selected: {_populationPreference},
            onSelectionChanged: isSaving
                ? null
                : (selection) {
                    setState(
                      () => _populationPreference = selection.first,
                    );
                  },
          ),

          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(title: 'Trip Duration'),
          TextField(
            controller: _tripDurationController,
            enabled: !isSaving,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Days (optional)',
              hintText: 'Example: 5',
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: isSaving ? null : _save,
            child: Text(
              isSaving ? 'Saving...' : 'Save Preferences',
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _interestTile(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
    bool disabled,
  ) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      value: value,
      onChanged: disabled
          ? null
          : (nextValue) {
              if (nextValue != null) {
                onChanged(nextValue);
              }
            },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

