class Game {
  const Game({required this.id, required this.title, required this.genre,
    required this.platform, required this.developer, required this.rating,
    required this.description, required this.color, required this.symbol,
    required this.features});

  final String id, title, genre, platform, developer, description, symbol;
  final double rating;
  final int color;
  final List<String> features;

  factory Game.fromJson(Map<String, dynamic> json) {
    final rating = (json['rating'] as num).toDouble();
    if (rating < 0 || rating > 5) {
      throw const FormatException('Rating harus berada pada rentang 0-5.');
    }
    return Game(
      id: json['id'] as String,
      title: json['title'] as String,
      genre: json['genre'] as String,
      platform: json['platform'] as String,
      developer: json['developer'] as String,
      rating: rating,
      description: json['description'] as String,
      color: int.parse(json['color'] as String, radix: 16),
      symbol: json['symbol'] as String,
      features: List<String>.unmodifiable(json['features'] as List),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'genre': genre, 'platform': platform,
    'developer': developer, 'rating': rating, 'description': description,
    'color': color.toRadixString(16).padLeft(8, '0'), 'symbol': symbol,
    'features': features,
  };
}
