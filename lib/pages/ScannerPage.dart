import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRCardScannerPage extends StatefulWidget {
  const QRCardScannerPage({super.key});

  @override
  _QRCardScannerPageState createState() => _QRCardScannerPageState();
}

class _QRCardScannerPageState extends State<QRCardScannerPage>
    with SingleTickerProviderStateMixin {
  // Scanner states
  bool _isScanning = true;
  bool _cardDetected = false;
  bool _readingComplete = false;
  String _statusMessage = "Position the QR code in the frame to scan";
  Map<String, String> _cardInfo = {};

  // QR Scanner controller
  QRViewController? _qrController;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool _flashOn = false;

  @override
  void dispose() {
    // Dispose of QR controller
    _qrController?.dispose();
    super.dispose();
  }

  // Handle QR view creation
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrController = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      if (_isScanning && !_cardDetected && !_readingComplete) {
        setState(() {
          _cardDetected = true;
          _statusMessage = "QR code detected! Processing...";
        });

        // Process the QR data
        _processQRData(scanData);
      }
    });
  }

  // Process QR code data
  void _processQRData(Barcode scanData) {
    if (scanData.code == null) {
      setState(() {
        _statusMessage = "Could not read QR code data";
        _cardDetected = false;
      });
      return;
    }

    // Parse the QR data
    // Assuming a format like "CARD:VISA|NUMBER:4111111111111111|EXP:12/25|NAME:John Doe"
    String data = scanData.code!;
    Map<String, dynamic> qrData = {};

    try {
      // For demonstration - in reality, QR formats would be standardized
      if (data.contains("|")) {
        List<String> parts = data.split("|");
        for (String part in parts) {
          if (part.contains(":")) {
            List<String> keyValue = part.split(":");
            qrData[keyValue[0]] = keyValue[1];
          }
        }

        // Set card type based on content
        if (data.toLowerCase().contains("visa")) {
          qrData["cardType"] = "VISA Card";
        } else if (data.toLowerCase().contains("master")) {
          qrData["cardType"] = "MasterCard";
        } else if (data.toLowerCase().contains("amex")) {
          qrData["cardType"] = "American Express";
        } else {
          qrData["cardType"] = "QR Payment Card";
        }
      } else {
        // Simple fallback for unknown formats
        qrData["cardType"] = "QR Payment Info";
        qrData["rawData"] = data;
      }

      // Update UI with card info
      setState(() {
        _isScanning = false;
        _readingComplete = true;
        _statusMessage = "Card details captured from QR code!";
        _cardInfo = _formatCardInfo(qrData);
      });

      // Stop camera
      _qrController?.stopCamera();
    } catch (e) {
      setState(() {
        _statusMessage = "Error processing QR data: $e";
        _cardDetected = false;
      });
    }
  }

  // Format card data for display
  Map<String, String> _formatCardInfo(Map<String, dynamic> data) {
    String cardType = data['cardType'] ?? 'Unknown';

    // Note: In a real app, you would NOT display the full card number for security reasons
    Map<String, String> formattedInfo = {
      "Card Type": cardType,
      "Last Scan": DateTime.now().toString().substring(0, 16)
    };

    // Add card-type specific information
    if (cardType.contains('VISA') ||
        cardType.contains('MasterCard') ||
        cardType.contains('American Express') ||
        cardType == 'QR Payment Card') {
      
      // For QR scanned data
      if (data.containsKey('NUMBER')) {
        String cardNumber = data['NUMBER'] ?? '';
        formattedInfo["Card Number"] = _formatCardNumber(cardNumber, cardType);
      } else {
        formattedInfo["Card Number"] = "**** **** **** 1234"; // Masked for security
      }

      // Cardholder name
      if (data.containsKey('NAME')) {
        formattedInfo["Cardholder"] = data['NAME'];
      } else {
        formattedInfo["Cardholder"] = "CARD HOLDER";
      }

      // Expiry date
      if (data.containsKey('EXP')) {
        formattedInfo["Expiry Date"] = data['EXP'];
      } else {
        formattedInfo["Expiry Date"] = "**/**";
      }

      // Technology info
      formattedInfo["Card Technology"] = "QR Code";
      formattedInfo["Security"] = "QR Encrypted";
    } else if (cardType == 'QR Payment Info') {
      formattedInfo["Card Technology"] = "QR Code";
      formattedInfo["Security"] = "QR Encrypted";

      // If we have raw QR data
      if (data.containsKey('rawData')) {
        String rawData = data['rawData'] ?? '';
        // Display a preview of the data
        formattedInfo["Data"] = rawData.length > 20 ? "${rawData.substring(0, 20)}..." : rawData;
      }
    } else {
      formattedInfo["Card Number"] = "Unknown format";
      formattedInfo["Card Technology"] = "QR Code";
      formattedInfo["Security"] = "Unknown";
    }

    return formattedInfo;
  }

  // Format credit card number based on card type
  String _formatCardNumber(String number, String cardType) {
    // Mask most of the card number for security
    if (number.length < 4) return number;

    String lastFour = number.substring(number.length - 4);
    String masked;

    if (cardType.contains('American Express')) {
      masked = "**** ****** *$lastFour";
    } else {
      masked = "**** **** **** $lastFour";
    }

    return masked;
  }

  // Restart scanning
  void _restartScan() {
    setState(() {
      _isScanning = true;
      _cardDetected = false;
      _readingComplete = false;
      _cardInfo = {};
      _statusMessage = "Position the QR code in the frame to scan";
    });

    // Resume QR scanning
    _qrController?.resumeCamera();
  }

  // Toggle flashlight for QR scanning
  void _toggleFlash() {
    if (_qrController != null) {
      _qrController!.toggleFlash();
      setState(() {
        _flashOn = !_flashOn;
      });
    }
  }

  // Helper method to build info items for the card details display
  Widget _buildInfoItem({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Card Scanner'),
        elevation: 0,
        actions: [
          // Flash toggle
          if (_isScanning)
            IconButton(
              icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off),
              onPressed: _toggleFlash,
              tooltip: _flashOn ? 'Turn off flash' : 'Turn on flash',
            ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Scanner Animation Area
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: _isScanning ? EdgeInsets.zero : const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _isScanning ? _buildQRScanner() : _buildCardResult(),
                ),
              ),
            ),

            // Status and Information
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Column(
                  children: [
                    // Status message with appropriate colors
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        color: _readingComplete
                            ? Colors.green.shade100
                            : _cardDetected
                                ? Colors.blue.shade100
                                : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _readingComplete
                                ? Icons.check_circle
                                : _cardDetected
                                    ? Icons.qr_code_scanner
                                    : Icons.qr_code,
                            color: _readingComplete
                                ? Colors.green
                                : _cardDetected
                                    ? Colors.blue
                                    : Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              _statusMessage,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _readingComplete
                                    ? Colors.green.shade800
                                    : _cardDetected
                                        ? Colors.blue.shade800
                                        : Colors.grey.shade700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Card information grid
                    if (_readingComplete && _cardInfo.isNotEmpty)
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoItem(
                                      title: "Card Technology",
                                      value: _cardInfo["Card Technology"] ?? "QR Code",
                                      icon: Icons.qr_code,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildInfoItem(
                                      title: "Security",
                                      value: _cardInfo["Security"] ?? "Encrypted",
                                      icon: Icons.enhanced_encryption,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Help text and actions
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        children: [
                          if (_readingComplete)
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context, _cardInfo);
                              },
                              icon: const Icon(Icons.save),
                              label: const Text('Save Card Information'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                            )
                          else
                            Text(
                              _cardDetected
                                  ? "Processing QR code data..."
                                  : "Center the QR code within the frame to scan.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Button Row
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _restartScan,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Scan Again'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Back'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRScanner() {
    return Stack(
      children: [
        // QR View
        QRView(
          key: _qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.blue,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: MediaQuery.of(context).size.width * 0.7,
          ),
        ),

        // Scanning animation
        const Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              "Scan QR Code",
              style: TextStyle(
                color: Colors.white,
                backgroundColor: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),

        // Card type hint
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Supports Visa, MasterCard, Amex QR codes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardResult() {
    // When a card has been successfully scanned, show the card details
    final cardType = _cardInfo["Card Type"] ?? "Unknown Card";

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cardType.contains("VISA")
                ? const Color(0xFF1A1F71)
                : cardType.contains("MasterCard")
                    ? const Color(0xFFFF5F00)
                    : cardType.contains("American Express")
                        ? const Color(0xFF2E77BB)
                        : const Color(0xFF2D3748),
            cardType.contains("VISA")
                ? const Color(0xFF202A8F)
                : cardType.contains("MasterCard")
                    ? const Color(0xFFEB001B)
                    : cardType.contains("American Express")
                        ? const Color(0xFF1C478B)
                        : const Color(0xFF1A202C),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Card pattern
          CustomPaint(
            painter: CardPatternPainter(),
            size: Size.infinite,
          ),

          // Card content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card type and QR icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cardType,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.qr_code,
                      color: Colors.white.withOpacity(0.8),
                      size: 30,
                    ),
                  ],
                ),

                const Spacer(),

                // Card number
                if (_cardInfo.containsKey("Card Number"))
                  Text(
                    _cardInfo["Card Number"]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.0,
                    ),
                  ),

                const SizedBox(height: 16),

                // Card holder and expiry date (if available)
                Row(
                  children: [
                    // Card holder
                    if (_cardInfo.containsKey("Cardholder"))
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "CARD HOLDER",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _cardInfo["Cardholder"]!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Expiry date
                    if (_cardInfo.containsKey("Expiry Date"))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "EXPIRES",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _cardInfo["Expiry Date"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                // Display Data for QR codes
                if (_cardInfo.containsKey("Data"))
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "DATA",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _cardInfo["Data"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Card pattern painter for background design
class CardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw some circles
    for (int i = 0; i < 5; i++) {
      final radius = size.width * 0.2 + i * 20;
      canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.2),
        radius,
        paint,
      );
    }

    // Draw some lines
    for (int i = 0; i < 8; i++) {
      final y = size.height * 0.6 + i * 10;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}