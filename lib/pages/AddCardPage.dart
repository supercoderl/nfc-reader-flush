import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_reader_flush/api/modules/card.dart';
import 'package:nfc_reader_flush/model/CardInfo.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _cardholderNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  
  String _cardType = '';
  bool _isSubmitting = false;
  String? _errorMessage;
  String? _successMessage;

  // Detect card type based on first digit
  void _detectCardType(String number) {
    if (number.isEmpty) {
      setState(() {
        _cardType = '';
      });
      return;
    }

    final firstDigit = number[0];
    setState(() {
      if (firstDigit == '4') {
        _cardType = 'Visa';
      } else if (firstDigit == '5') {
        _cardType = 'MasterCard';
      } else {
        _cardType = '';
      }
    });
  }

  // Format card number with spaces
  String _formatCardNumber(String text) {
    // Remove all non-digits
    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');
    
    // Limit to 16 digits
    final truncated = digitsOnly.substring(0, digitsOnly.length.clamp(0, 16));
    
    // Add spaces after every 4 digits
    final buffer = StringBuffer();
    for (int i = 0; i < truncated.length; i++) {
      buffer.write(truncated[i]);
      if ((i + 1) % 4 == 0 && i != truncated.length - 1) {
        buffer.write(' ');
      }
    }
    
    return buffer.toString();
  }

  Future<void> _submitCard() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
      _successMessage = null;
    });
    
    try {  
      // Send tokenized data to your API
      final statusCode = await createCard(CardInfo(
        cardType: _cardType,
        cardNumber: _cardNumberController.text.replaceAll(' ', ''),
        cardholderName: _cardholderNameController.text,
        expiryDate: _expiryDateController.text,
        cvv: _cvvController.text,
      ));
      
      if (statusCode == 201) {
        // Card created successfully
        setState(() {
          _successMessage = 'Card added successfully!';
          
          // Clear form fields
          _cardholderNameController.clear();
          _cardNumberController.clear();
          _expiryDateController.clear();
          _cvvController.clear();
          _cardType = '';
        });
      } else {
        // Handle error response
        setState(() {
          _errorMessage = 'Failed to add card. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please check your connection and try again.';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    _cardholderNameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Card'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card type indicator
              if (_cardType.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Icon(
                        _cardType == 'Visa' ? Icons.credit_card : Icons.credit_card,
                        color: _cardType == 'Visa' ? Colors.blue : Colors.red,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        _cardType,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Cardholder Name
              TextFormField(
                controller: _cardholderNameController,
                decoration: const InputDecoration(
                  labelText: 'Cardholder Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the cardholder name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              
              // Card Number
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                  hintText: '1234 5678 9012 3456',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  // Format the input with spaces
                  final formatted = _formatCardNumber(value);
                  if (formatted != value) {
                    _cardNumberController.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(offset: formatted.length),
                    );
                  }
                  
                  // Detect card type based on first digit
                  if (value.isNotEmpty) {
                    _detectCardType(value);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the card number';
                  }
                  
                  final digitsOnly = value.replaceAll(' ', '');
                  if (digitsOnly.length < 15 || digitsOnly.length > 16) {
                    return 'Card number must be 15-16 digits';
                  }
                  
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              
              // Row for Expiry Date and CVV
              Row(
                children: [
                  // Expiry Date
                  Expanded(
                    child: TextFormField(
                      controller: _expiryDateController,
                      decoration: const InputDecoration(
                        labelText: 'Expiry Date (MM/YY)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.date_range),
                        hintText: 'MM/YY',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        _ExpiryDateInputFormatter(),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        
                        if (value.length < 5) {
                          return 'Invalid format';
                        }
                        
                        // Check if the expiry date is valid
                        final parts = value.split('/');
                        if (parts.length != 2) {
                          return 'Invalid format';
                        }
                        
                        final month = int.tryParse(parts[0]);
                        if (month == null || month < 1 || month > 12) {
                          return 'Invalid month';
                        }
                        
                        final year = int.tryParse('20${parts[1]}');
                        final currentYear = DateTime.now().year;
                        final currentMonth = DateTime.now().month;
                        
                        if (year == null || year < currentYear) {
                          return 'Card expired';
                        }
                        
                        if (year == currentYear && month < currentMonth) {
                          return 'Card expired';
                        }
                        
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  
                  // CVV
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.security),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        
                        if (value.length < 3 || value.length > 4) {
                          return 'CVV must be 3-4 digits';
                        }
                        
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              
              // Error message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.red.shade100,
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                ),
              
              // Success message
              if (_successMessage != null)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.green.shade100,
                  child: Text(
                    _successMessage!,
                    style: TextStyle(color: Colors.green.shade900),
                  ),
                ),
              
              const SizedBox(height: 16.0),
              
              // Submit button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitCard,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      )
                    : const Text(
                        'ADD CARD',
                        style: TextStyle(fontSize: 16.0),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom formatter for expiry date (MM/YY)
class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    
    if (newText.isEmpty) {
      return newValue;
    }
    
    // Handle deletion
    if (oldValue.text.length > newText.length) {
      return newValue;
    }
    
    String formatted = newText;
    
    // Add slash after the month (after 2 digits)
    if (newText.length == 2 && oldValue.text.length == 1) {
      formatted = '$newText/';
    }
    // Handle manual input of slash
    else if (newText.length == 2 && !newText.contains('/')) {
      formatted = '$newText/';
    }
    // Handle input after slash
    else if (newText.length > 2 && !newText.contains('/')) {
      formatted = '${newText.substring(0, 2)}/${newText.substring(2)}';
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}