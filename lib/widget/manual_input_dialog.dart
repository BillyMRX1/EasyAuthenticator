import 'package:flutter/material.dart';

class ManualInputDialog extends StatefulWidget {
  final Function(String, String) onAddAccount;

  const ManualInputDialog({super.key, required this.onAddAccount});

  @override
  _ManualInputDialogState createState() => _ManualInputDialogState();
}

class _ManualInputDialogState extends State<ManualInputDialog> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _secretController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Account Manually'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _accountController,
            decoration: const InputDecoration(labelText: 'Account Name'),
          ),
          TextField(
            controller: _secretController,
            decoration: const InputDecoration(labelText: 'Secret Key'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final accountName = _accountController.text;
            final secret = _secretController.text;

            if (accountName.isNotEmpty && secret.isNotEmpty) {
              widget.onAddAccount(accountName, secret);
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
