import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class MessageInputField extends StatelessWidget {
  const MessageInputField({
    super.key,
    required this.textController,
    required this.onSendMessage,
    required this.isDark,
  });

  final TextEditingController textController;
  final Function(String) onSendMessage;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(CSizes.sm).copyWith(
        bottom: CSizes.sm + MediaQuery.of(context).padding.bottom,
      ), // Handle notch
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? CColors.dark : CColors.lightGrey,
                hintText: 'Type your message here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(CSizes.borderRadiusLg),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: CSizes.md,
                  vertical: CSizes.sm,
                ),
              ),
              onSubmitted: onSendMessage,
            ),
          ),
          const SizedBox(width: CSizes.spaceBtwItems / 2),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => onSendMessage(textController.text),
            color: CColors.primary,
            style: IconButton.styleFrom(
              backgroundColor: CColors.primary.withOpacity(0.1),
              padding: const EdgeInsets.all(CSizes.sm),
            ),
          ),
        ],
      ),
    );
  }
}
