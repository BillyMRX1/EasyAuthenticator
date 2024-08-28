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
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      title: const Text('Add Account Manually'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _accountController,
            decoration: InputDecoration(
              labelText: 'Account Name',
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary)),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary)),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            controller: _secretController,
            decoration: InputDecoration(
              labelText: 'Secret Key',
              errorText: _errorMessage,
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary)),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary)),
            ),
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
              if (secret.length < 16) {
                setState(() {
                  _errorMessage = 'Secret Key is too short';
                });
              } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(secret)) {
                setState(() {
                  _errorMessage = 'Secret Key has illegal character';
                });
              } else {
                widget.onAddAccount(accountName, secret);
                Navigator.pop(context);
              }
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
