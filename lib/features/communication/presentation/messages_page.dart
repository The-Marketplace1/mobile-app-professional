import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/app_router.dart';
import '../../../core/models/domain.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_widgets.dart';
import '../../../shared/widgets/section_card.dart';
import '../../shell/presentation/app_shell.dart';

class MessagesPage extends ConsumerStatefulWidget {
  const MessagesPage({super.key});

  @override
  ConsumerState<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends ConsumerState<MessagesPage> {
  String? selected;
  String? messagesConversationId;
  Future<List<dynamic>>? messagesFuture;
  final composer = TextEditingController();
  bool sending = false;

  @override
  void dispose() {
    composer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(appControllerProvider);
    if (controller.conversations.isEmpty) {
      final emptyMessage = controller.workspaceLoadError ??
          (controller.workspaceLoading
              ? 'Loading conversations.'
              : controller.workspaceLoaded
              ? 'No conversations yet.'
              : 'Conversation data is unavailable.');
      return FeaturePageFrame(
        eyebrow: 'Stay close to the work',
        title: 'Messages',
        body: emptyMessage,
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: Text('No conversations to display.')),
        ),
      );
    }
    selected ??= controller.conversations.first.id;
    final conversationId = selected!;
    if (messagesConversationId != conversationId) {
      messagesConversationId = conversationId;
      messagesFuture = ref
          .read(communicationRepositoryProvider)
          .listMessages(conversationId);
    }
    final conversation = controller.conversations.firstWhere(
      (item) => item.id == selected,
    );
    return FeaturePageFrame(
      eyebrow: 'Stay close to the work',
      title: 'Messages',
      body: 'Customer conversations.',
      action: IconButton(
        tooltip: 'Choose a conversation',
        onPressed: () => _chooseConversation(context, controller.conversations),
        icon: const Icon(Icons.add_comment_outlined),
      ),
      child: Column(
        children: [
          SectionCard(
            title: conversation.customer,
            subtitle: conversation.online ? 'Online now' : 'Offline',
            trailing: IconButton(
              tooltip: 'Call options',
              onPressed: _showCallContractNotice,
              icon: const Icon(Icons.call_outlined),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 280,
                  child: FutureBuilder<List<dynamic>>(
                    future: messagesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Messages could not be loaded.'),
                        );
                      }
                      final messages = snapshot.data ?? const <dynamic>[];
                      if (messages.isEmpty) {
                        return const Center(
                          child: Text('No messages in this conversation.'),
                        );
                      }
                      return ListView(
                        children: [
                          for (final value in messages)
                            _gatewayMessage(value),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: composer,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText: 'Write a message',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: sending || composer.text.trim().isEmpty
                          ? null
                          : () => _sendMessage(conversation.id),
                      icon: const Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          for (final item in controller.conversations)
            Card(
              child: ListTile(
                onTap: () => setState(() => selected = item.id),
                leading: AvatarCircle(name: item.customer),
                title: Text(
                  item.customer,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(item.preview),
                trailing: item.unread > 0
                    ? Badge(label: Text('${item.unread}'))
                    : Text(
                        item.timeLabel,
                        style: const TextStyle(fontSize: 11),
                      ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String conversationId) async {
    final content = composer.text.trim();
    if (content.isEmpty) return;
    setState(() => sending = true);
    try {
      await ref
          .read(communicationRepositoryProvider)
          .sendMessage(conversationId: conversationId, content: content);
      if (!mounted) return;
      setState(() {
        composer.clear();
        messagesFuture = ref
            .read(communicationRepositoryProvider)
            .listMessages(conversationId);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Message sent.')));
    } catch (error) {
      if (!mounted) return;
      final message = error is ApiConfigurationException
          ? 'Configure the API Gateway before sending messages.'
          : 'The message could not be sent. Please try again.';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => sending = false);
    }
  }

  Future<void> _chooseConversation(
    BuildContext context,
    List<ConversationItem> conversations,
  ) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final item in conversations)
              ListTile(
                title: Text(item.customer),
                subtitle: Text(item.preview),
                onTap: () => Navigator.pop(sheetContext, item.id),
              ),
          ],
        ),
      ),
    );
    if (choice != null && mounted) setState(() => selected = choice);
  }

  void _showCallContractNotice() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Calls are not enabled yet'),
        content: const Text(
          'Calls must route through the API Gateway and Communication service. '
          'The current contract includes call history but not call initiation.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.mine, this.timeLabel});

  final String text;
  final bool mine;
  final String? timeLabel;

  @override
  Widget build(BuildContext context) => Align(
    alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      constraints: const BoxConstraints(maxWidth: 290),
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: mine ? AppTheme.navy : const Color(0xFFE9EFEC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: mine ? Colors.white : AppTheme.ink,
              height: 1.35,
            ),
          ),
          if (timeLabel != null) ...[
            const SizedBox(height: 4),
            Text(
              timeLabel!,
              style: TextStyle(
                color: mine ? Colors.white70 : AppTheme.muted,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

Widget _gatewayMessage(Object? value) {
  if (value is! Map) {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Text('A message could not be displayed.'),
    );
  }
  final data = value.map((key, value) => MapEntry(key.toString(), value));
  final content = data['content'];
  final senderType = data['senderType'];
  if (content is! String || senderType is! String) {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Text('A message could not be displayed.'),
    );
  }
  final sentAt = data['sentAt'];
  final time = sentAt is String ? DateTime.tryParse(sentAt) : null;
  return _Bubble(
    text: content,
    mine: senderType.toLowerCase() == 'professional',
    timeLabel: time == null ? null : DateFormat('MMM d, h:mm a').format(time),
  );
}

