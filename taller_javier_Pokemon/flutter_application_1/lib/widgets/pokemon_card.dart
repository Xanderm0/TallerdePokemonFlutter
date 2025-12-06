import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon? pokemon;
  final bool isLoading;

  const PokemonCard({
    super.key,
    this.pokemon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: SizedBox(
          height: 300,
          width: double.infinity,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (pokemon == null) {
      return const Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: SizedBox(
          height: 300,
          width: double.infinity,
          child: Center(
            child: Text(
              'No Pokémon Selected',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image
            pokemon!.imageUrl.isNotEmpty
                ? Image.network(
                    pokemon!.imageUrl,
                    height: 150,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        height: 150,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.grey,
                    ),
                  )
                : const Icon(Icons.image_not_supported, size: 100),
            const SizedBox(height: 16),
            // Name
            Text(
              pokemon!.name.toUpperCase(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2), // Blue 700
              ),
            ),
            const SizedBox(height: 8),
            // Types
            Wrap(
              spacing: 8,
              children: pokemon!.types
                  .map((type) => Chip(
                        label: Text(
                          type.toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: const Color(0xFF2196F3), // Blue 500
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            // Stats
            _buildStatRow('HP', pokemon!.hp),
            _buildStatRow('Attack', pokemon!.attack),
            _buildStatRow('Defense', pokemon!.defense),
            const Divider(),
            _buildStatRow('Total', pokemon!.totalStats, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, int value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? const Color(0xFF1976D2) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
