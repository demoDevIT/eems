import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'provider/dept_QR_scan_provider.dart';

class DeptQRScanPage extends StatefulWidget {
  const DeptQRScanPage({super.key});

  @override
  State<DeptQRScanPage> createState() => _DeptQRScanPageState();
}

class _DeptQRScanPageState extends State<DeptQRScanPage> {

  final MobileScannerController _controller = MobileScannerController(
    autoStart: true,
  );

  bool _handled = false;

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<DeptQRScanProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR Code"),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () async => await _controller.toggleTorch(),
          ),
        ],
      ),

      body: Stack(
        fit: StackFit.expand,
        children: [

          MobileScanner(
            controller: _controller,
            onDetect: (barcodeCapture) async {

              if (_handled) return;

              final String? raw = barcodeCapture.barcodes.first.rawValue;

              if (raw == null) return;

              _handled = true;

              await provider.handleQRCode(context, raw);

              _handled = false;
              await _controller.start();
            },
          ),

          /// Scan Box UI
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}