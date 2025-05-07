import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC News'),
         automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildNewsArticle(
            context,
            title: 'New EMV Chip Standards Released for Enhanced Security',
            date: 'April 25, 2025',
            summary:
                'The major card networks have announced new security standards for EMV chip technology to combat the latest fraud techniques.',
            image: 'https://placehold.co/800x400?text=EMV+Standards',
          ),
          _buildNewsArticle(
            context,
            title: 'How to Protect Your Cards from RFID Skimming',
            date: 'April 20, 2025',
            summary:
                'Learn about the latest techniques criminals use to steal card information and how you can protect yourself.',
            image: 'https://placehold.co/800x400?text=RFID+Protection',
          ),
          _buildNewsArticle(
            context,
            title: 'The Future of Payment Card Technology',
            date: 'April 15, 2025',
            summary:
                'Biometric authentication, dynamic CVV, and other innovations coming to credit and debit cards in the next few years.',
            image: 'https://placehold.co/800x400?text=Future+Cards',
          ),
          _buildNewsArticle(
            context,
            title: 'Major Banks Moving to Contactless-Only Cards',
            date: 'April 10, 2025',
            summary:
                'Several major financial institutions have announced plans to phase out mag-stripe only cards within the next 18 months.',
            image: 'https://placehold.co/800x400?text=Contactless+Cards',
          ),
        ],
      ),
    );
  }

  Widget _buildNewsArticle(
    BuildContext context, {
    required String title,
    required String date,
    required String summary,
    required String image,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRW5v9k8iZQEVFSmhK3Oxkb9WkZ--WvGIJx3Q&s',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  summary,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Open full article
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Full article feature coming soon!')));
                    },
                    child: const Text('Read More'),
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
