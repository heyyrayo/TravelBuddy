import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/travelbuddy_ai_message.dart';

class TravelBuddyAiContext {
  const TravelBuddyAiContext({
    this.screen,
    this.destination,
    this.tripName,
    this.budget,
    this.travellers,
    this.duration,
  });

  final String? screen;
  final String? destination;
  final String? tripName;
  final String? budget;
  final int? travellers;
  final String? duration;

  Map<String, dynamic> toJson() {
    return {
      if (screen != null) 'screen': screen,
      if (destination != null) 'destination': destination,
      if (tripName != null) 'tripName': tripName,
      if (budget != null) 'budget': budget,
      if (travellers != null) 'travellers': travellers,
      if (duration != null) 'duration': duration,
    };
  }
}

class TravelBuddyAiException implements Exception {
  const TravelBuddyAiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class TravelBuddyAiService {
  TravelBuddyAiService({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = _normalizeBaseUrl(
          baseUrl ?? _defaultBaseUrl,
        );

  // ==========================================================
  // PRODUCTION BACKEND
  // ==========================================================
  //
  // TravelBuddy now uses the deployed cloud backend.
  // The app no longer depends on server.js running on your laptop.
  //
  static const String _defaultBaseUrl =
      'https://travelbuddy-ai-xxt9.onrender.com';

  final http.Client _client;
  final String _baseUrl;

  static String _normalizeBaseUrl(String value) {
    return value.trim().replaceFirst(
          RegExp(r'/+$'),
          '',
        );
  }

  Uri get _chatUri {
    return Uri.parse(
      '$_baseUrl/api/ai/chat',
    );
  }

  Future<String> sendMessage({
    required String message,
    List<TravelBuddyAiMessage> history = const [],
    TravelBuddyAiContext? context,
  }) async {
    final cleanMessage = message.trim();

    // ========================================================
    // VALIDATION
    // ========================================================

    if (cleanMessage.isEmpty) {
      throw const TravelBuddyAiException(
        'Please enter a message.',
      );
    }

    if (cleanMessage.length > 4000) {
      throw const TravelBuddyAiException(
        'Your message is too long. Please keep it under 4000 characters.',
      );
    }

    final requestBody = <String, dynamic>{
      'message': cleanMessage,
      'history': history
          .map(
            (item) => item.toApiJson(),
          )
          .toList(),
      'context':
          context?.toJson() ??
          <String, dynamic>{},
    };

    // ========================================================
    // NETWORK REQUEST
    // ========================================================

    try {
      final response = await _client
          .post(
            _chatUri,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(
            const Duration(seconds: 75),
          );

      return _handleResponse(response);
    } on TravelBuddyAiException {
      rethrow;
    } on TimeoutException {
      throw const TravelBuddyAiException(
        'TravelBuddy AI is taking too long to respond. '
        'Please try again in a moment.',
      );
    } on http.ClientException {
      throw const TravelBuddyAiException(
        'Unable to connect to TravelBuddy AI right now. '
        'Please check your internet connection and try again.',
      );
    } on FormatException {
      throw const TravelBuddyAiException(
        'TravelBuddy AI returned an invalid response.',
      );
    } catch (_) {
      throw const TravelBuddyAiException(
        'TravelBuddy AI is temporarily unavailable. '
        'Please try again.',
      );
    }
  }

  String _handleResponse(
    http.Response response,
  ) {
    dynamic decoded;

    // ========================================================
    // PARSE JSON
    // ========================================================

    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw const TravelBuddyAiException(
        'TravelBuddy AI returned an invalid response.',
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw const TravelBuddyAiException(
        'TravelBuddy AI returned an unexpected response.',
      );
    }

    final success =
        decoded['success'] == true;

    // ========================================================
    // SUCCESS
    // ========================================================

    if (success) {
      final answer =
          decoded['answer'];

      if (
        answer is String &&
        answer.trim().isNotEmpty
      ) {
        return answer.trim();
      }

      throw const TravelBuddyAiException(
        'TravelBuddy AI did not return an answer.',
      );
    }

    // ========================================================
    // SERVER ERROR
    // ========================================================

    final error =
        decoded['error'];

    if (
      error is String &&
      error.trim().isNotEmpty
    ) {
      throw TravelBuddyAiException(
        error.trim(),
      );
    }

    switch (response.statusCode) {
      case 400:
        throw const TravelBuddyAiException(
          'TravelBuddy AI could not understand that request.',
        );

      case 401:
        throw const TravelBuddyAiException(
          'TravelBuddy AI authentication failed on the server.',
        );

      case 404:
        throw const TravelBuddyAiException(
          'TravelBuddy AI service endpoint was not found.',
        );

      case 429:
        throw const TravelBuddyAiException(
          'TravelBuddy AI is temporarily busy. '
          'Please try again in a moment.',
        );

      case 500:
      case 502:
      case 503:
        throw const TravelBuddyAiException(
          'TravelBuddy AI is temporarily unavailable. '
          'Please try again.',
        );

      default:
        throw TravelBuddyAiException(
          'TravelBuddy AI request failed '
          '(${response.statusCode}).',
        );
    }
  }

  void dispose() {
    _client.close();
  }
}