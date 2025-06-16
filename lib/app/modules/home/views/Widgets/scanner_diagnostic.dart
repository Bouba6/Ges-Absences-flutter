import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class ScannerDiagnostic extends StatefulWidget {
  @override
  _ScannerDiagnosticState createState() => _ScannerDiagnosticState();
}

class _ScannerDiagnosticState extends State<ScannerDiagnostic> {
  late MobileScannerController controller;
  String status = "Initialisation...";
  bool hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final permission = await Permission.camera.status;

    setState(() {
      status = "Permission: ${permission.toString()}";
      hasPermission = permission.isGranted;
    });

    if (!permission.isGranted) {
      final result = await Permission.camera.request();
      setState(() {
        hasPermission = result.isGranted;
        status = "Permission après demande: ${result.toString()}";
      });
    }

    if (hasPermission) {
      _initController();
    }
  }

  void _initController() {
    controller = MobileScannerController();
    setState(() {
      status = "Controller initialisé";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Diagnostic Scanner')),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(status, style: TextStyle(fontSize: 16)),
          ),
          if (hasPermission)
            Expanded(
              child: Container(
                color: Colors.black,
                child: MobileScanner(
                  controller: controller,
                  onDetect: (capture) {
                    setState(() {
                      status =
                          "QR détecté: ${capture.barcodes.first.displayValue}";
                    });
                  },
                ),
              ),
            )
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 64, color: Colors.grey),
                    Text('Permission caméra requise'),
                    ElevatedButton(
                      onPressed: _checkPermissions,
                      child: Text('Demander permission'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (hasPermission) {
      controller.dispose();
    }
    super.dispose();
  }
}
