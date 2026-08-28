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
        _baseUrl = baseUrl ?? _defaultBaseUrl;

  static const String _defaultBaseUrl = 'http://127.0.0.2:3000';

  final http.Client _client;
  final String _baseUrl;

  Uri get _chatUri => Uri.parse('$_baseUrl/api/ai/chat');

  Future<String> sendMessage({
    required String message,
    List<TravelBuddyAiMessage> history = const [],
    TravelBuddyAiContext? context,
  }) async {
    final cleanMessage = message.trim();

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

    final requestBody = {
      'message': cleanMessage,
      'history': history.map((item) => item.toApiJson()).toList(),
      'context': context?.toJson() ?? <String, dynamic>{},
    };

    try {
      final response = await _client
          .post(
            _chatUri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(
            const Duration(seconds: 45),
          );

      return _handleResponse(response);
    } on TravelBuddyAiException {
      rethrow;
    } on http.ClientException {
      throw const TravelBuddyAiException(
        'Unable to connect to TravelBuddy AI. '
        'Please make sure the AI server is running.',
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

    final success = decoded['success'] == true;

    if (success) {
      final answer = decoded['answer'];

      if (answer is String && answer.trim().isNotEmpty) {
        return answer.trim();
      }

      throw const TravelBuddyAiException(
        'TravelBuddy AI did not return an answer.',
      );
    }

    final error = decoded['error'];

    if (error is String && error.trim().isNotEmpty) {
      throw TravelBuddyAiException(
        error.trim(),
      );
    }

    switch (response.statusCode) {
      case 400:
        throw const TravelBuddyAiException(
          'TravelBuddy AI could not understand that request.',
        );

      case 429:
        throw const TravelBuddyAiException(
          'TravelBuddy AI is temporarily busy. '
          'Please try again in a moment.',
        );

      case 500:
      case 502:
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
