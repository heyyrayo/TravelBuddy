import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/branding/travelbuddy_ai_logo.dart';
import '../../data/travelbuddy_ai_service.dart';
import '../../domain/travelbuddy_ai_message.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

class TravelBuddyAiScreen extends StatefulWidget {
  const TravelBuddyAiScreen({
    super.key,
    this.context,
  });

  final TravelBuddyAiContext? context;

  @override
  State<TravelBuddyAiScreen> createState() => _TravelBuddyAiScreenState();
}

class _TravelBuddyAiScreenState extends State<TravelBuddyAiScreen> {
  late final TravelBuddyAiService _aiService;

  final TextEditingController _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final List<TravelBuddyAiMessage> _messages = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _aiService = TravelBuddyAiService();

    _messages.add(
      TravelBuddyAiMessage(
        role: TravelBuddyAiMessageRole.assistant,
        content: "Hi! I'm TravelBuddy AI 👋\n\n"
            "I can help you plan trips, discover destinations, "
            "create itineraries, estimate budgets, choose "
            "activities, and answer your travel questions.\n\n"
            "Where would you like to go?",
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _aiService.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();

    if (message.isEmpty || _isLoading) {
      return;
    }

    _messageController.clear();

    final userMessage = TravelBuddyAiMessage(
      role: TravelBuddyAiMessageRole.user,
      content: message,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final history = _messages
          .where((item) => item != userMessage)
          .where(
            (item) =>
                item.role == TravelBuddyAiMessageRole.user ||
                item.role == TravelBuddyAiMessageRole.assistant,
          )
          .toList();

      final answer = await _aiService.sendMessage(
        message: message,
        history: history,
        context: widget.context,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _messages.add(
          TravelBuddyAiMessage(
            role: TravelBuddyAiMessageRole.assistant,
            content: answer,
            timestamp: DateTime.now(),
          ),
        );

        _isLoading = false;
      });

      _scrollToBottom();
    } on TravelBuddyAiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      _showError(error.message);
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      _showError(
        'Something went wrong. Please try again.',
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'DISMISS',
            onPressed: () {},
          ),
        ),
      );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _useSuggestion(String suggestion) {
    _messageController.text = suggestion;

    _messageController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: _messageController.text.length,
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        titleSpacing: AppSpacing.md,
        title: Row(
          children: [
            _buildAiLogo(),
            const SizedBox(width: AppSpacing.sm),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'TravelBuddy AI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Your travel assistant',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isLoading && index == _messages.length) {
                    return const _TypingIndicator();
                  }

                  final message = _messages[index];

                  return _MessageBubble(
                    message: message,
                  );
                },
              ),
            ),
            if (_messages.length == 1 && !_isLoading) _buildSuggestions(),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildAiLogo() {
    return const TravelBuddyAiLogo(size: 40);
  }

  Widget _buildSuggestions() {
    const suggestions = [
      'Plan a 3-day trip to Goa',
      'Best places to visit in Manali',
      'Plan a budget trip from Nagpur',
    ];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          return ActionChip(
            label: Text(suggestions[index]),
            onPressed: () => _useSuggestion(suggestions[index]),
            backgroundColor: AppColors.surfaceContainerLow,
            side: BorderSide(
              color: AppColors.outlineVariant,
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              enabled: !_isLoading,
              minLines: 1,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Ask TravelBuddy AI anything...',
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    final hasText = _messageController.text.trim().isNotEmpty;

    return Material(
      color: hasText && !_isLoading
          ? AppColors.primary
          : AppColors.surfaceContainerHigh,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: hasText && !_isLoading ? _sendMessage : null,
        child: SizedBox(
          width: 48,
          height: 48,
          child: _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(14),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              : Icon(
                  Icons.arrow_upward_rounded,
                  color: hasText
                      ? AppColors.onPrimary
                      : AppColors.onSurfaceVariant,
                ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
  });

  final TravelBuddyAiMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            const TravelBuddyAiLogo(size: 30),
            const SizedBox(width: AppSpacing.xs),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.86,
              ),
              margin: EdgeInsets.only(
                bottom: AppSpacing.sm,
                left: isUser ? AppSpacing.xl : 0,
                right: isUser ? 0 : AppSpacing.xl,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color:
                    isUser ? AppColors.primary : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 5),
                  bottomRight: Radius.circular(isUser ? 5 : 18),
                ),
              ),
              child: isUser
                  ? Text(
                      message.content,
                      style: TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 15,
                        height: 1.45,
                      ),
                    )
                  : MarkdownBody(
                      data: message.content,
                      selectable: true,
                      shrinkWrap: true,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 15,
                          height: 1.5,
                        ),
                        h1: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                        h2: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                        h3: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                        strong: TextStyle(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                        listBullet: TextStyle(
                          color: AppColors.primary,
                          fontSize: 15,
                        ),
                        blockquote: TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 14,
                          height: 1.45,
                        ),
                        code: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 13,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: AppSpacing.sm,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dot(delay: 0),
            const SizedBox(width: 4),
            _Dot(delay: 150),
            const SizedBox(width: 4),
            _Dot(delay: 300),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  const _Dot({
    required this.delay,
  });

  final int delay;

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 900,
      ),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value =
            (_controller.value * 900 - widget.delay).clamp(0, 900) / 900;

        final opacity = 0.35 + (value * 0.65);

        return Opacity(
          opacity: opacity.clamp(0.35, 1.0),
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: AppColors.onSurfaceVariant,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
