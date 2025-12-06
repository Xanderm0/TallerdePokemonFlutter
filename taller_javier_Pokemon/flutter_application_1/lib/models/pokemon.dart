class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int hp;
  final int attack;
  final int defense;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.hp,
    required this.attack,
    required this.defense,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Extract types
    List<String> typesList = (json['types'] as List)
        .map((t) => t['type']['name'].toString())
        .toList();

    // Extract stats
    int hp = 0;
    int attack = 0;
    int defense = 0;

    for (var stat in json['stats']) {
      String statName = stat['stat']['name'];
      int baseStat = stat['base_stat'];
      if (statName == 'hp') hp = baseStat;
      if (statName == 'attack') attack = baseStat;
      if (statName == 'defense') defense = baseStat;
    }

    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'] ??
          json['sprites']['front_default'] ??
          '',
      types: typesList,
      hp: hp,
      attack: attack,
      defense: defense,
    );
  }

  int get totalStats => hp + attack + defense;
}
