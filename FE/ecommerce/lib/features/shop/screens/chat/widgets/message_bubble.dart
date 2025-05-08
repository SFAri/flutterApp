import 'package:ecommerce/features/shop/screens/chat/models/Message.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message, required this.isDark});

  final Message message;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.isSentByMe;
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: screenWidth * 0.75),
        margin: const EdgeInsets.symmetric(
          horizontal: CSizes.sm,
          vertical: CSizes.xs,
        ),
        padding: const EdgeInsets.all(CSizes.md),
        decoration: BoxDecoration(
          color:
              isMe
                  ? CColors.primary
                  : (isDark ? CColors.dark : CColors.lightGrey),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(CSizes.borderRadiusLg),
            topRight: const Radius.circular(CSizes.borderRadiusLg),
            bottomLeft: Radius.circular(isMe ? CSizes.borderRadiusLg : 0),
            bottomRight: Radius.circular(isMe ? 0 : CSizes.borderRadiusLg),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color:
                isMe
                    ? CColors.textWhite
                    : (isDark ? CColors.textWhite : CColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
