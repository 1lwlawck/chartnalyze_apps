import 'package:flutter/material.dart';

class MarketStocksList extends StatelessWidget {
  const MarketStocksList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Text('${index + 1}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(width: 12),
              const CircleAvatar(radius: 18, child: Icon(Icons.trending_up)),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Stock ${index + 1}',
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              const Text('\$123.45',
                  style: TextStyle(color: Colors.black, fontSize: 13)),
            ],
          ),
        );
      },
    );
  }
}
