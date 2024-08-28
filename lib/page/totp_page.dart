import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/totp_provider.dart';
import '../widget/empty_state.dart';
import '../widget/totp_account_card.dart';
import '../widget/manual_input_dialog.dart';
import 'qr_page.dart';
import '../widget/totp_fab.dart';

class TOTPPage extends StatelessWidget {
  const TOTPPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TOTPProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Easy Authenticator',
              style: TextStyle(
                  color: provider.isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  provider.isDarkMode ? Icons.brightness_7 : Icons.brightness_2,
                ),
                onPressed: () {
                  provider.toggleDarkMode();
                },
              ),
            ],
          ),
          body: provider.accounts.isEmpty
              ? EmptyState(isDarkMode: provider.isDarkMode)
              : Padding(
                  padding: const EdgeInsets.only(bottom: 64),
                  child: ListView.builder(
                    itemCount: provider.accounts.length,
                    itemBuilder: (context, index) {
                      final account = provider.accounts[index];
                      return TOTPAccountCard(
                        account: account,
                        onEdit: () => _showRenameDialog(
                            context, account.id, account.accountName),
                        onDelete: () => _confirmDelete(context, account.id),
                        progress: provider.progress,
                        seconds: provider.second.toInt(),
                        isDark: provider.isDarkMode,
                      );
                    },
                  ),
                ),
          floatingActionButton: TOTPFloatingActionButtons(
            onScanQRCode: () => _scanQRCode(context),
            onManualInput: () => _showManualInputDialog(context),
          ),
        );
      },
    );
  }

  void _scanQRCode(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRPage(
          onQRCodeScanned: (qrText, stopProcessing) {
            try {
              final uri = Uri.parse(qrText);
              if (uri.scheme == 'otpauth' && uri.host == 'totp') {
                final accountName = uri.pathSegments.last;
                final secret = uri.queryParameters['secret'];
                if (secret != null) {
                  Provider.of<TOTPProvider>(context, listen: false)
                      .addAccount(accountName, secret);
                }
                Navigator.pop(context);
                stopProcessing();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Key Added')),
                );
              } else {
                stopProcessing();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('QR Code Not Supported')),
                );
              }
            } catch (e) {
              stopProcessing();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('QR Scan Failed')),
              );
            }
          },
        ),
      ),
    );
  }

  void _showManualInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ManualInputDialog(
          onAddAccount: (accountName, secret) {
            Provider.of<TOTPProvider>(context, listen: false)
                .addAccount(accountName, secret);
          },
        );
      },
    );
  }

  void _showRenameDialog(BuildContext context, String id, String currentName) {
    final TextEditingController _controller =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename Account'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'New Account Name',
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary)),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary)),
            ),
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
                final newName = _controller.text;
                if (newName.isNotEmpty) {
                  Provider.of<TOTPProvider>(context, listen: false)
                      .renameAccount(id, newName);
                  Navigator.pop(context);
                }
              },
              child: const Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete this account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<TOTPProvider>(context, listen: false)
                    .deleteAccount(id);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
