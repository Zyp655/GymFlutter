import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/chat_message.dart';
import '../../l10n/app_localizations.dart';
import '../cubits/ai_chat/ai_chat_cubit.dart';
import '../cubits/ai_chat/ai_chat_state.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen>
    with TickerProviderStateMixin {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.lightImpact();
    context.read<AiChatCubit>().sendMessage(text);
    _controller.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildAppBar(colorScheme, l10n),
            Expanded(
              child: BlocConsumer<AiChatCubit, AiChatState>(
                listener: (context, state) {
                  if (state is AiChatLoaded && !state.isTyping) {
                    _scrollToBottom();
                  }
                },
                builder: (context, state) {
                  if (state is AiChatLoaded && state.messages.isEmpty) {
                    return _buildWelcome(colorScheme, l10n);
                  }

                  final messages = state is AiChatLoaded
                      ? state.messages
                      : state is AiChatError
                      ? state.previousMessages
                      : <ChatMessage>[];
                  final isTyping = state is AiChatLoaded
                      ? state.isTyping
                      : false;

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: messages.length + (isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length && isTyping) {
                        return _buildTypingIndicator(colorScheme);
                      }
                      return _buildMessageBubble(messages[index], colorScheme);
                    },
                  );
                },
              ),
            ),
            _buildSuggestionChips(colorScheme, l10n),
            _buildInputBar(colorScheme, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(ColorScheme colorScheme, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 8,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: AppColors.navyDark,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aiAssistant,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'GymFit AI • GPT-4o mini',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: colorScheme.primary),
            onPressed: () {
              HapticFeedback.mediumImpact();
              context.read<AiChatCubit>().clearChat();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcome(ColorScheme colorScheme, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppColors.goldGlowDecoration(borderRadius: 24),
              child: const Icon(
                Icons.auto_awesome,
                size: 48,
                color: AppColors.navyDark,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.aiAssistant,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.aiWelcomeMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, ColorScheme colorScheme) {
    final isUser = message.role == ChatRole.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 16,
                color: AppColors.navyDark,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: isUser
                  ? BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    )
                  : AppColors.glassmorphismDecoration(borderRadius: 16),
              child: Text(
                message.content,
                style: TextStyle(
                  color: isUser ? AppColors.navyDark : colorScheme.onSurface,
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: isUser ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 16,
              color: AppColors.navyDark,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: AppColors.glassmorphismDecoration(borderRadius: 16),
            child: _TypingDots(color: colorScheme.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChips(ColorScheme colorScheme, AppLocalizations l10n) {
    return BlocBuilder<AiChatCubit, AiChatState>(
      builder: (context, state) {
        if (state is AiChatLoaded && state.messages.isNotEmpty) {
          return const SizedBox.shrink();
        }

        final suggestions = [
          l10n.aiSuggestion1,
          l10n.aiSuggestion2,
          l10n.aiSuggestion3,
          l10n.aiSuggestion4,
        ];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.map((s) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.read<AiChatCubit>().sendMessage(s);
                  _scrollToBottom();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    s,
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildInputBar(ColorScheme colorScheme, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 8,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: AppColors.glassmorphismDecoration(borderRadius: 24),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: l10n.typeMessage,
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          BlocBuilder<AiChatCubit, AiChatState>(
            builder: (context, state) {
              final isTyping = state is AiChatLoaded && state.isTyping;
              return GestureDetector(
                onTap: isTyping ? null : _sendMessage,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: isTyping ? null : AppColors.goldGradient,
                    color: isTyping
                        ? colorScheme.surfaceContainerHighest
                        : null,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isTyping
                        ? null
                        : [
                            BoxShadow(
                              color: AppColors.gold.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Icon(
                    Icons.send_rounded,
                    color: isTyping
                        ? colorScheme.onSurfaceVariant
                        : AppColors.navyDark,
                    size: 22,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  final Color color;

  const _TypingDots({required this.color});

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (i) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      )..repeat(reverse: true);
    });

    for (var i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) _controllers[i].forward();
      });
    }

    _animations = _controllers.map((c) {
      return Tween<double>(
        begin: 0,
        end: -6,
      ).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));
    }).toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animations[i].value),
              child: Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
