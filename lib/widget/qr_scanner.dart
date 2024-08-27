import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatelessWidget {
  final Function(String) onQRCodeScanned;

  const QRScanner({super.key, required this.onQRCodeScanned});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: QRView(
        key: GlobalKey(debugLabel: 'QR'),
        onQRViewCreated: (controller) {
          controller.scannedDataStream.listen((scanData) {
            onQRCodeScanned(scanData.code.toString());
          });
        },
      ),
    );
  }
}
