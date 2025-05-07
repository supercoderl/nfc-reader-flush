import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:http/http.dart' as http;

class CardScannerPage extends StatefulWidget {
  const CardScannerPage({Key? key}) : super(key: key);

  @override
  _CardScannerPageState createState() => _CardScannerPageState();
}

class _CardScannerPageState extends State<CardScannerPage> {
  bool _isScanning = false;
  String _statusMessage = 'Ready to scan';
  Map<String, dynamic>? _cardData;
  final String _apiUrl = 'https://your-api-endpoint.com/save-card'; // Replace with your API endpoint

  // Start NFC scanning
  Future<void> _startScan() async {
    setState(() {
      _isScanning = true;
      _statusMessage = 'Scanning...';
      _cardData = null;
    });

    try {
      // Check NFC availability
      NFCAvailability availability = await FlutterNfcKit.nfcAvailability;
      if (availability != NFCAvailability.available) {
        setState(() {
          _isScanning = false;
          _statusMessage = 'NFC not available on this device';
        });
        return;
      }

      // Start NFC session - specifically targeting payment cards
      NFCTag tag = await FlutterNfcKit.poll(
        timeout: Duration(seconds: 20),
        iosAlertMessage: "Hold your card near the device to scan",
        iosMultipleTagMessage: "Multiple cards detected, please present only one card",
      );

      // Process the card data
      if (tag.type == NFCTagType.iso7816) {
        // This is likely a payment card (EMV)
        setState(() {
          _statusMessage = 'Card detected! Processing...';
        });

        // Extract card information
        // Note: Real EMV processing requires more complex APDU commands
        // The below is simplified for demonstration
        var cardInfo = await _processEMVCard(tag);
        
        setState(() {
          _cardData = cardInfo;
          _statusMessage = 'Card scanned successfully!';
        });
      } else {
        setState(() {
          _statusMessage = 'Not a payment card. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: ${e.toString()}';
      });
    } finally {
      await FlutterNfcKit.finish();
      setState(() {
        _isScanning = false;
      });
    }
  }

  // Process EMV card data
  Future<Map<String, dynamic>> _processEMVCard(NFCTag tag) async {
    print("Card: ${tag.id}");
    print("Standard: ${tag.standard}");
    print("Type: ${tag.type}");
    
    // This is a simplified version
    // In a real app, you would send specific APDU commands to get card data
    
    Map<String, dynamic> cardInfo = {
      'tagId': tag.id,
      'standard': tag.standard,
      'cardType': _determineCardType(tag.id),
      'lastFourDigits': 'XXXX', // In a real app, you would extract this from the card
      'expiryDate': 'XX/XX',    // In a real app, you would extract this from the card
    };
    
    return cardInfo;
  }

  Future<String> _sendAPDUCommand(NFCTag tag, String apduCommand) async {
    // Gửi APDU command và nhận kết quả từ thẻ (cần sử dụng thư viện hỗ trợ NFC)
    // Kết quả trả về là dữ liệu từ thẻ
    return "Response from APDU command";  // Đây chỉ là ví dụ
  }

  // Determine if the card is Visa or Mastercard
  // This is very simplified and would need more robust logic in a real app
  String _determineCardType(String tagId) {
    // This is placeholder logic - real identification would use AID or other EMV data
    if (tagId.startsWith('A')) {
      return 'Visa';
    } else if (tagId.startsWith('B')) {
      return 'Mastercard';
    } else {
      return 'Unknown';
    }
  }

  // Save card data to API
  Future<void> _saveCardData() async {
    if (_cardData == null) {
      setState(() {
        _statusMessage = 'No card data to save';
      });
      return;
    }

    setState(() {
      _statusMessage = 'Saving card data...';
    });

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_cardData),
      );

      if (response.statusCode == 200) {
        setState(() {
          _statusMessage = 'Card data saved successfully!';
        });
        
        // Navigate back or to next page
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(_cardData); // Return card data to previous page
        });
      } else {
        setState(() {
          _statusMessage = 'Failed to save card data. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error saving card data: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Scanner'),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Card scanner illustration
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _isScanning
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Icon(
                        Icons.credit_card,
                        size: 100,
                        color: Colors.blue,
                      ),
              ),
              const SizedBox(height: 40),
              
              // Status message
              Text(
                _statusMessage,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _statusMessage.contains('Error')
                      ? Colors.red
                      : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              // Card data display
              if (_cardData != null) ...[
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Card Type: ${_cardData!['cardType']}', 
                          style: TextStyle(fontSize: 16)),
                      Text('Last Four: ${_cardData!['lastFourDigits']}', 
                          style: TextStyle(fontSize: 16)),
                      Text('Expiry: ${_cardData!['expiryDate']}', 
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isScanning ? null : _startScan,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(_isScanning ? 'Scanning...' : 'Scan Card'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _cardData != null && !_isScanning ? _saveCardData : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: Colors.green,
                    ),
                    child: Text('Save Card'),
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