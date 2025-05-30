import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({Key? key}) : super(key: key);

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  late MobileScannerController controller;
  Barcode? result;
  bool flashOn = false;
  bool frontCamera = false;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: false,
      returnImage: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Scanner QR Code',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // Bouton Flash
          IconButton(
            icon: Icon(
              flashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
            onPressed: () async {
              await controller.toggleTorch();
              setState(() {
                flashOn = !flashOn;
              });
            },
          ),
          // Bouton Camera
          IconButton(
            icon: Icon(
              frontCamera ? Icons.camera_front : Icons.camera_rear,
              color: Colors.white,
            ),
            onPressed: () async {
              await controller.switchCamera();
              setState(() {
                frontCamera = !frontCamera;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                // Scanner QR avec Mobile Scanner
                MobileScanner(
                  controller: controller,
                  onDetect: _onDetect,
                  overlay: Container(
                    decoration: ShapeDecoration(
                      shape: QrScannerOverlayShape(
                        borderColor: Colors.green,
                        borderRadius: 10,
                        borderLength: 30,
                        borderWidth: 10,
                        cutOutSize: 250,
                      ),
                    ),
                  ),
                ),

                // Instructions overlay
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Placez le QR code dans le cadre\npour scanner l\'ID de l\'élève',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (result != null)
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'QR Code scanné:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      result!.displayValue ?? 'N/A',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Retourner l'ID scanné
                                  Get.back(result: result!.displayValue);
                                },
                                icon: const Icon(Icons.check),
                                label: const Text('Utiliser cet ID'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    result = null;
                                  });
                                  controller.start();
                                },
                                icon: const Icon(Icons.refresh),
                                label: const Text('Scanner à nouveau'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Dirigez la caméra vers un QR code',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Le scan se fera automatiquement',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;

    if (result == null && barcodes.isNotEmpty) {
      setState(() {
        result = barcodes.first;
      });

      // Arrêter le scanner
      controller.stop();

      // Vibration feedback
      HapticFeedback.mediumImpact();

      // Son de succès (optionnel)
      SystemSound.play(SystemSoundType.click);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

// Classe personnalisée pour l'overlay (forme de scanner)
class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.green,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path path = Path()..addRect(rect);

    // Créer le carré central
    double cutOutLeft = rect.center.dx - cutOutSize / 2;
    double cutOutTop = rect.center.dy - cutOutSize / 2;
    Rect cutOutRect = Rect.fromLTWH(
      cutOutLeft,
      cutOutTop,
      cutOutSize,
      cutOutSize,
    );

    // Créer les coins arrondis
    RRect cutOutRRect = RRect.fromRectAndRadius(
      cutOutRect,
      Radius.circular(borderRadius),
    );
    path.addRRect(cutOutRRect);

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // Peindre l'overlay
    final paint =
        Paint()
          ..color = overlayColor
          ..style = PaintingStyle.fill;

    canvas.drawPath(getOuterPath(rect), paint);

    // Peindre les coins du scanner
    final borderPaint =
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth;

    double cutOutLeft = rect.center.dx - cutOutSize / 2;
    double cutOutTop = rect.center.dy - cutOutSize / 2;
    double cutOutRight = cutOutLeft + cutOutSize;
    double cutOutBottom = cutOutTop + cutOutSize;

    // Coin supérieur gauche
    canvas.drawPath(
      Path()
        ..moveTo(cutOutLeft, cutOutTop + borderLength)
        ..lineTo(cutOutLeft, cutOutTop + borderRadius)
        ..quadraticBezierTo(
          cutOutLeft,
          cutOutTop,
          cutOutLeft + borderRadius,
          cutOutTop,
        )
        ..lineTo(cutOutLeft + borderLength, cutOutTop),
      borderPaint,
    );

    // Coin supérieur droit
    canvas.drawPath(
      Path()
        ..moveTo(cutOutRight - borderLength, cutOutTop)
        ..lineTo(cutOutRight - borderRadius, cutOutTop)
        ..quadraticBezierTo(
          cutOutRight,
          cutOutTop,
          cutOutRight,
          cutOutTop + borderRadius,
        )
        ..lineTo(cutOutRight, cutOutTop + borderLength),
      borderPaint,
    );

    // Coin inférieur gauche
    canvas.drawPath(
      Path()
        ..moveTo(cutOutLeft, cutOutBottom - borderLength)
        ..lineTo(cutOutLeft, cutOutBottom - borderRadius)
        ..quadraticBezierTo(
          cutOutLeft,
          cutOutBottom,
          cutOutLeft + borderRadius,
          cutOutBottom,
        )
        ..lineTo(cutOutLeft + borderLength, cutOutBottom),
      borderPaint,
    );

    // Coin inférieur droit
    canvas.drawPath(
      Path()
        ..moveTo(cutOutRight - borderLength, cutOutBottom)
        ..lineTo(cutOutRight - borderRadius, cutOutBottom)
        ..quadraticBezierTo(
          cutOutRight,
          cutOutBottom,
          cutOutRight,
          cutOutBottom - borderRadius,
        )
        ..lineTo(cutOutRight, cutOutBottom - borderLength),
      borderPaint,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth * t,
      overlayColor: overlayColor,
      borderRadius: borderRadius * t,
      borderLength: borderLength * t,
      cutOutSize: cutOutSize * t,
    );
  }
}
