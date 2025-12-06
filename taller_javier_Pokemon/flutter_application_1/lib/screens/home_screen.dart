import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../widgets/pokemon_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PokemonService _pokemonService = PokemonService();
  Pokemon? _pokemon1;
  Pokemon? _pokemon2;
  bool _isLoading1 = false;
  bool _isLoading2 = false;
  String? _resultMessage;

  Future<void> _searchPokemon1() async {
    setState(() {
      _isLoading1 = true;
      _pokemon1 = null;
      _pokemon2 = null; // Reset opponent when searching new
      _resultMessage = null;
    });

    final pokemon = await _pokemonService.fetchRandomPokemon();

    setState(() {
      _pokemon1 = pokemon;
      _isLoading1 = false;
    });
  }

  Future<void> _matchPokemon() async {
    if (_pokemon1 == null) return;

    setState(() {
      _isLoading2 = true;
      _pokemon2 = null;
      _resultMessage = null;
    });

    final pokemon = await _pokemonService.fetchRandomPokemon();

    setState(() {
      _pokemon2 = pokemon;
      _isLoading2 = false;
    });

    _determineWinner();
  }

  void _determineWinner() {
    if (_pokemon1 == null || _pokemon2 == null) return;

    if (_pokemon1!.totalStats > _pokemon2!.totalStats) {
      _resultMessage = "¡Ganó ${_pokemon1!.name.toUpperCase()}!";
    } else if (_pokemon2!.totalStats > _pokemon1!.totalStats) {
      _resultMessage = "¡Ganó ${_pokemon2!.name.toUpperCase()}!";
    } else {
      _resultMessage = "¡Es un EMPATE!";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emparejamiento Pokémon'),
        backgroundColor: const Color(0xFF1976D2), // Blue 700
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFBBDEFB), // Blue 100
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pokemon 1 Section
            PokemonCard(pokemon: _pokemon1, isLoading: _isLoading1),
            
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading1 || _isLoading2 ? null : _searchPokemon1,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3), // Blue 500
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Buscar Pokémon',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (_pokemon1 == null || _isLoading1 || _isLoading2)
                        ? null
                        : _matchPokemon,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0), // Blue 800
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Emparejar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Result Section
            if (_resultMessage != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1976D2), width: 2),
                ),
                child: Text(
                  _resultMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Pokemon 2 Section (Opponent)
            if (_pokemon2 != null || _isLoading2)
              Column(
                children: [
                  const Text(
                    "Oponente",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  PokemonCard(pokemon: _pokemon2, isLoading: _isLoading2),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
