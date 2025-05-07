import 'package:flutter/material.dart';
import 'package:nfc_reader_flush/api/modules/card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nfc_reader_flush/pages/AddCardPage.dart';

class Card {
  final String id;
  final String cardType;
  final String cardNumber;
  final String cardholderName;
  final String expiryDate;
  final bool hasRFID;
  
  Card({
    required this.id,
    required this.cardType,
    required this.cardNumber,
    required this.cardholderName,
    required this.expiryDate,
    required this.hasRFID,
  });
  
  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      id: json['id'],
      cardType: json['cardType'] ?? 'Card',
      cardNumber: json['cardNumber'] ?? '**** **** **** ****',
      cardholderName: json['cardholderName'] ?? 'CARDHOLDER',
      expiryDate: json['expiryDate'] ?? 'MM/YY',
      hasRFID: json['hasRFID'] ?? false,
    );
  }
  
  // For preparing data to be tokenized when adding a new card
  Map<String, dynamic> toJson() {
    return {
      'cardType': cardType,
      'cardNumber': cardNumber,
      'cardholderName': cardholderName,
      'expiryDate': expiryDate,
      'hasRFID': hasRFID,
    };
  }
}

class CardListPage extends StatefulWidget {
  const CardListPage({super.key});

  @override
  State<CardListPage> createState() => _CardListPageState();
}

class _CardListPageState extends State<CardListPage> {
  bool _isLoading = true;
  List<Card> _cards = [];
  String? _defaultCardId;
  
  @override
  void initState() {
    super.initState();
    _loadCards();
    _loadDefaultCardId();
  }
  
  Future<void> _loadDefaultCardId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _defaultCardId = prefs.getString('defaultCardId');
    });
  }
  
  Future<void> _setDefaultCard(String cardId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultCardId', cardId);
    setState(() {
      _defaultCardId = cardId;
    });
    
    // Reorder cards to move default to top
    _reorderCards();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Default card updated')),
    );
  }
  
  void _reorderCards() {
    if (_defaultCardId != null) {
      _cards.sort((a, b) {
        if (a.id == _defaultCardId) return -1;
        if (b.id == _defaultCardId) return 1;
        return 0;
      });
    }
  }
  
  Future<void> _loadCards() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Get the auth token from secure storage (you'll need to implement this)
      
      final data = await getCards();
      
      if (data != null) {
        setState(() {
          _cards = data.map((cardJson) => Card.fromJson(cardJson)).toList();
          _isLoading = false;
        });
        
        // After loading cards, reorder them
        _reorderCards();
      } else {
        // Handle error
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

   Future<void> _deleteCard(String cardId) async {
    try {
      final statusCode = await deleteCard(cardId);
      
      if (statusCode == 200) {
        // If we're deleting the default card, clear the default card setting
        if (cardId == _defaultCardId) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('defaultCardId');
          setState(() {
            _defaultCardId = null;
          });
        }
        
        _loadCards(); // Reload the cards list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Card removed successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove card')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cards'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCards,
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _cards.isEmpty 
            ? _buildEmptyState() 
            : _buildCardList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCardPage()),
          );
          
          if (result == true) {
            _loadCards();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.credit_card_off,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No cards found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first card by tapping the + button',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddCardPage()),
              ).then((result) {
                if (result == true) {
                  _loadCards();
                }
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Card'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCardList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _cards.length + 1, // +1 for the Add New Card button
      separatorBuilder: (context, index) {
        if (index == _cards.length) return const SizedBox.shrink();
        return const SizedBox(height: 16);
      },
      itemBuilder: (context, index) {
        if (index == _cards.length) {
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 16)
          );
        }
        
        final card = _cards[index];
        final isDefault = card.id == _defaultCardId;
        
        Color cardColor;
        switch (card.cardType.toLowerCase()) {
          case 'visa':
            cardColor = Colors.blue.shade800;
            break;
          case 'mastercard':
            cardColor = Colors.red.shade800;
            break;
          case 'american express':
            cardColor = Colors.blueGrey.shade800;
            break;
          default:
            cardColor = Colors.purple.shade800;
        }
        
        return _buildCreditCard(
          context,
          card: card,
          color: cardColor,
          isDefault: isDefault,
        );
      },
    );
  }

  Widget _buildCreditCard(
    BuildContext context, {
    required Card card,
    required Color color,
    required bool isDefault,
  }) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => _buildCardOptions(card),
        );
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: color,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Card background pattern
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    // Use a gradient instead of an image that might not load
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.05)],
                    ),
                  ),
                ),
              ),
            ),

            // Default card indicator
            if (isDefault)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Default',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        card.cardType,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            card.hasRFID ? Icons.wifi : Icons.wifi_off,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            card.hasRFID ? 'RFID Enabled' : 'No RFID',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    card.cardNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CARDHOLDER',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            card.cardholderName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'EXPIRES',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            card.expiryDate,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCardOptions(Card card) {
    final isDefault = card.id == _defaultCardId;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Card Options',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: Text('${card.cardType} ending in ${card.cardNumber.substring(card.cardNumber.length - 4)}'),
            subtitle: Text(card.cardholderName),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              isDefault ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isDefault ? Colors.green : null,
            ),
            title: Text(isDefault ? 'Default Card' : 'Set as Default'),
            onTap: () {
              if (!isDefault) {
                _setDefaultCard(card.id);
              }
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Remove Card'),
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Remove Card'),
                  content: const Text('Are you sure you want to remove this card?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Close bottom sheet
                        _deleteCard(card.id);
                      },
                      child: const Text('REMOVE', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}