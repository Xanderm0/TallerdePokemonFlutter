import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonService {
  final String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  Future<Pokemon?> fetchRandomPokemon() async {
    final randomId = Random().nextInt(1000) + 1; // IDs 1 to 1000
    final url = Uri.parse('$baseUrl/$randomId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Pokemon.fromJson(data);
      } else {
        print('Failed to load pokemon: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching pokemon: $e');
      return null;
    }
  }
}
