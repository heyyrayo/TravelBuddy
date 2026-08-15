import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../../../core/services/location_service.dart';

class LocationTestScreen extends StatefulWidget {
  const LocationTestScreen({
    super.key,
  });

  @override
  State<LocationTestScreen> createState() => _LocationTestScreenState();
}

class _LocationTestScreenState extends State<LocationTestScreen> {
  final LocationService _locationService = const LocationService();

  Position? _position;
  LocationServiceException? _error;
  bool _loading = false;

  Future<void> _getLocation() async {
    setState(() {
      _loading = true;
      _position = null;
      _error = null;
    });

    try {
      final position = await _locationService.getCurrentPosition();

      if (!mounted) {
        return;
      }

      setState(() {
        _position = position;
        _loading = false;
      });
    } on LocationServiceException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _error = error;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _error = LocationServiceException(
          LocationServiceError.unavailable,
          'Unexpected location error: $error',
          cause: error,
        );
        _loading = false;
      });
    }
  }

  Future<void> _openLocationSettings() async {
    await _locationService.openLocationSettings();
  }

  Future<void> _openAppSettings() async {
    await _locationService.openAppSettings();
  }

  String _formatTimestamp(DateTime timestamp) {
    final localTime = timestamp.toLocal();

    return DateFormat(
      'dd MMM yyyy, hh:mm:ss a',
    ).format(localTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on,
                  size: 64,
                ),
                const SizedBox(height: 24),
                const Text(
                  'TravelBuddy GPS Test',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'This test verifies that TravelBuddy can obtain your real device location.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (_loading) const CircularProgressIndicator(),
                if (_position != null) ...[
                  const Text(
                    'Location acquired successfully',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Latitude: ${_position!.latitude}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Longitude: ${_position!.longitude}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Accuracy: ${_position!.accuracy.toStringAsFixed(1)} m',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Timestamp: ${_formatTimestamp(_position!.timestamp)}',
                    textAlign: TextAlign.center,
                  ),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _error!.message,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (_error!.error == LocationServiceError.serviceDisabled)
                    OutlinedButton(
                      onPressed: _openLocationSettings,
                      child: const Text(
                        'Enable Location',
                      ),
                    ),
                  if (_error!.error ==
                      LocationServiceError.permissionDeniedForever)
                    OutlinedButton(
                      onPressed: _openAppSettings,
                      child: const Text(
                        'Open App Settings',
                      ),
                    ),
                ],
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _loading ? null : _getLocation,
                  icon: const Icon(
                    Icons.my_location,
                  ),
                  label: const Text(
                    'Get My Location',
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
