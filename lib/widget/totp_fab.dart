import 'package:flutter/material.dart';

class TOTPFloatingActionButtons extends StatelessWidget {
  final VoidCallback onScanQRCode;
  final VoidCallback onManualInput;

  const TOTPFloatingActionButtons({
    super.key,
    required this.onScanQRCode,
    required this.onManualInput,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: onScanQRCode,
          tooltip: 'Scan QR Code',
          child: const Icon(Icons.qr_code),
        ),
        const SizedBox(width: 10),
        FloatingActionButton(
          onPressed: onManualInput,
          tooltip: 'Add Account Manually',
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
