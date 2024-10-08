import 'package:easy_authenticator/model/totp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TOTPAccountCard extends StatelessWidget {
  final TOTP account;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final double progress;
  final int seconds;
  final bool isDark;

  const TOTPAccountCard({
    super.key,
    required this.account,
    required this.onEdit,
    required this.onDelete,
    required this.progress,
    required this.seconds,
    required this.isDark,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: account.totp ?? '')).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Code copied to clipboard!'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      account.accountName,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit,
                        color: isDark ? Colors.white : Colors.black),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete,
                        color: isDark ? Colors.white : Colors.black),
                    onPressed: onDelete,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        account.totp ?? 'Generating...',
                        style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy,
                            color: isDark ? Colors.white : Colors.black),
                        onPressed: () => _copyToClipboard(context),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 35,
                    height: 35,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 3,
                            color: isDark ? Colors.white : Colors.black),
                        Text(
                          seconds.toString(),
                          style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white : Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
