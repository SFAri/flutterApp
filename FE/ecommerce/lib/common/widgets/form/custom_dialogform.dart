import 'package:flutter/material.dart';

class DialogForm extends StatelessWidget {
  const DialogForm({
    super.key,
    required this.title,
    required this.widgets,
    required this.acceptFunction,
  });

  final String title;
  final Widget widgets;
  final Function acceptFunction;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
    return AlertDialog(
      title: Text(title),
      content: Form(
        key: _dialogFormKey,
        child: widgets
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
          child: const Text('Ok'),
          onPressed: () {
            // acceptFunction();
            // Navigator.of(context).pop();
            // if (_dialogFormKey.validate()) { // Kiểm tra tính hợp lệ của form
            //   acceptFunction(); // Gọi hàm chấp nhận
            //   Navigator.of(context).pop(); // Đóng dialog
            // }
            if (_dialogFormKey.currentState?.validate() ?? false) { // Kiểm tra tính hợp lệ
              acceptFunction(); // Gọi hàm chấp nhận nếu hợp lệ
              Navigator.of(context).pop(); // Đóng dialog
            }
          },
        ),
      ],
    );
  }
}