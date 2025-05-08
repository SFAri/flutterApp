import 'package:ecommerce/features/shop/screens/chat/models/Message.dart';
import 'package:ecommerce/features/shop/screens/chat/widgets/message_bubble.dart';
import 'package:ecommerce/features/shop/screens/chat/widgets/message_input.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textController = TextEditingController();
  final List<Message> messages = [
    Message(
      text: 'Hello!',
      date: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      isSentByMe: false,
    ),
    Message(
      text: 'Hi there!',
      date: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      isSentByMe: true,
    ),
    Message(
      text: 'Good morning!',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      isSentByMe: false,
    ),
    Message(
      text: 'Morning! How are you?',
      date: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
      isSentByMe: true,
    ),
    Message(
      text: 'Doing well. You?',
      date: DateTime.now().subtract(const Duration(minutes: 30)),
      isSentByMe: false,
    ),

    Message(
      text: 'Hey, how was your weekend?',
      date: DateTime.now().subtract(const Duration(days: 2, hours: 10)),
      isSentByMe: false,
    ),
    Message(
      text: 'It was great! Went hiking. Yours?',
      date: DateTime.now().subtract(
        const Duration(days: 2, hours: 9, minutes: 30),
      ),
      isSentByMe: true,
    ),
    Message(
      text: 'Pretty chill, just relaxed at home.',
      date: DateTime.now().subtract(const Duration(days: 2, hours: 9)),
      isSentByMe: false,
    ),
    Message(
      text: 'Fine, thanks! Ready for today?',
      date: DateTime.now().subtract(const Duration(minutes: 25)),
      isSentByMe: true,
    ),
    Message(
      text: 'Absolutely! Got a busy day ahead.',
      date: DateTime.now().subtract(const Duration(minutes: 10)),
      isSentByMe: false,
    ),
    Message(
      text: 'Same here. Let\'s crush it! 💪',
      date: DateTime.now().subtract(const Duration(minutes: 5)),
      isSentByMe: true,
    ),
    Message(
      text: '👍',
      date: DateTime.now().subtract(const Duration(minutes: 1)),
      isSentByMe: false,
    ),
  ];
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void sendMessage(String text) {
    print(text);
    if (text.isNotEmpty) {
      setState(() {
        messages.add(
          Message(text: text.trim(), date: DateTime.now(), isSentByMe: true),
        );
        textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = CHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: CAppBar(
        showBackArrows: true,
        title: Text(
          'Chat Screen',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GroupedListView<Message, DateTime>(
              padding: const EdgeInsets.all(CSizes.sm),
              reverse: true,
              order: GroupedListOrder.DESC,
              useStickyGroupSeparators: true,
              floatingHeader: true,
              elements: messages,
              groupBy:
                  (message) => DateTime(
                    message.date.year,
                    message.date.month,
                    message.date.day,
                  ),
              groupHeaderBuilder: (Message message) {
                // final bool dark is already available from the build method's scope
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(
                      color:
                          isDark ? CColors.dark : CColors.grey.withOpacity(0.5),
                      thickness: 1,
                      height: CSizes.spaceBtwItems,
                    ),
                    SizedBox(
                      height: CSizes.heightDateTime,
                      child: Center(
                        child: Card(
                          elevation: 1, // Slight elevation for the date card
                          margin: const EdgeInsets.symmetric(
                            vertical: CSizes.xs / 2,
                          ), // Add a little vertical margin
                          color: CColors.primary.withOpacity(0.8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: CSizes.md,
                              vertical: CSizes.sm,
                            ),
                            child: Text(
                              DateFormat.yMMMd().format(message.date),
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: CColors.textWhite,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              itemComparator:
                  (Message m1, Message m2) => m1.date.compareTo(
                    m2.date,
                  ), // Sorts messages within a group
              itemBuilder: (context, Message message) {
                return MessageBubble(message: message, isDark: isDark);
              },
            ),
          ),
          MessageInputField(
            textController: textController,
            onSendMessage: sendMessage,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}
