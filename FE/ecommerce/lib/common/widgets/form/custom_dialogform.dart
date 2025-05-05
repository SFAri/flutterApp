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
    return AlertDialog(
      title: Text(title),
      content: widgets,
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
            acceptFunction;
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}