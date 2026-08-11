import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import 'package:social_media_app/cubit/chat_cubit/chat_cubit.dart';
import 'package:social_media_app/cubit/chat_cubit/chat_state.dart';

class ChatMessage {
  final String message;
  final bool isUser;

  ChatMessage({
    required this.message,
    required this.isUser,
  });
}

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  Future<void> sendMessage() async {
    final message = _messageController.text.trim();

    if (message.isEmpty) {
      return;
    }

    // Add user's message to the chat.
    setState(() {
      _messages.add(
        ChatMessage(
          message: message,
          isUser: true,
        ),
      );
    });

    _messageController.clear();

    scrollToBottom();

    // Send message to AI.
    final response = await context.read<ChatCubit>().sendMessage(message);

    if (!mounted) {
      return;
    }

    // Add AI response to the chat.
    if (response != null) {
      setState(() {
        _messages.add(
          ChatMessage(
            message: response,
            isUser: false,
          ),
        );
      });

      scrollToBottom();
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.read<ChatCubit>().errorMessage,
              ),
            ),
          );
        }
      },

      child: Scaffold(
        appBar: AppBar(
          title: const Text('AI Assistant'),
          centerTitle: true,
        ),

        body: Column(
          children: [
            //------------------messages--------------------
            Expanded(
              child: _messages.isEmpty
                  ? const Center(
                      child: Text(
                        'Ask me for a post idea!',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,

                      itemBuilder: (context, index) {
                        final message = _messages[index];

                        return Align(
                          alignment: message.isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,

                          child: Container(
                            margin: const EdgeInsets.only(
                              bottom: 12,
                            ),

                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),

                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),

                            decoration: BoxDecoration(
                              color: message.isUser
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade800,

                              borderRadius: BorderRadius.circular(
                                18,
                              ),
                            ),

                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    message.message,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                                if (!message.isUser) ...[
                                  const SizedBox(width: 8),

                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: message.message,
                                        ),
                                      );

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Copied!'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },

                                    child: const Icon(
                                      Icons.copy,
                                      size: 18,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            //----------------------------Loading---------------------------
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Padding(
                    padding: EdgeInsets.only(
                      bottom: 8,
                    ),

                    child: Row(
                      children: [
                        SizedBox(width: 16),

                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),

                        SizedBox(width: 10),

                        Text(
                          'AI is thinking...',
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),

            //---------------Text Field-------------------
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,

                        textInputAction: TextInputAction.send,

                        onSubmitted: (_) {
                          final state = context.read<ChatCubit>().state;

                          if (state is! ChatLoading) {
                            sendMessage();
                          }
                        },

                        decoration: InputDecoration(
                          hintText: 'Type a message...',

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              25,
                            ),
                          ),

                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    //-----------------Send Button------------------
                    BlocBuilder<ChatCubit, ChatState>(
                      builder: (context, state) {
                        final isLoading = state is ChatLoading;

                        return IconButton(
                          onPressed: isLoading ? null : sendMessage,

                          icon: const Icon(
                            Icons.send,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
