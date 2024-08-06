import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/foundation.dart'; // Import this for describeEnum
import 'package:awesome_dialog/awesome_dialog.dart'; // Import AwesomeDialog
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../MYcustomWidgets/Constant_page.dart';

class QrScannerPage extends StatefulWidget {
  @override
  _QrScannerPageState createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;
  bool isScanning = true;
  bool isProcessing = false; // Added state for processing

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Set the desired height
        child: AppBar(
          backgroundColor: appBarColor, // Replace with your app bar color
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(1),
            ),
          ),
          flexibleSpace: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Empty space to push the title to the center
                    SizedBox(width: 80), // Adjust width as needed

                    // Title in the center
                    Text(
                      'QR Scanner',
                      style: TextStyle(
                        color: Colors.white, // Replace with your title color
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Action icons on the right (if needed)
                    SizedBox(width: 64), // Adjust width as needed
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor:
                  appBarColor, // Replace with your overlay border color
              borderRadius: 20,
              borderLength: 40,
              borderWidth: 12,
              cutOutSize: MediaQuery.of(context).size.width * 0.75,
            ),
          ),
          if (result != null &&
              !isProcessing) // Show result container only if not processing
            Center(
              child: Container(
                color: Colors.black.withOpacity(0.6),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Barcode Type: ${describeEnum(result!.format)}',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Data: ${result!.code}',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          if (isProcessing)
            Center(
              child: SpinKitRipple(
                color: Colors.blue, // Replace with your spinner color
                size: 80.0,
              ),
            ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        isScanning = false;
        isProcessing = true; // Start showing loading animation
      });
      controller.pauseCamera(); // Pause the camera after a successful scan

      // Simulate processing time and show the dialog afterward
      Future.delayed(Duration(seconds: 2), () {
        _handleQRCode(result!.code);
      });
    });
  }

  void _handleQRCode(String? code) {
    if (code != null && code.toLowerCase() == 'surya') {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'Success',
        desc: 'You are marked present!',
        btnOkOnPress: () {
          Navigator.pop(context, true); // Return true to indicate success
        },
        btnOkColor: Theme.of(context).colorScheme.primary,
        headerAnimationLoop: false, // No tick symbol
      ).show();
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Failed',
        desc: 'Invalid QR code!',
        btnOkOnPress: () {
          Navigator.pop(context, false); // Return false to indicate failure
        },
        btnOkColor: Theme.of(context).colorScheme.primary,
      ).show();
    }

    // Stop showing the loading animation
    setState(() {
      isProcessing = false;
    });
  }

  @override
  void dispose() {
    controller?.dispose(); // Dispose the controller when the page is disposed
    super.dispose();
  }
}
