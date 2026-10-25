import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/game.dart';

// Kontrak yang sama dapat diimplementasikan oleh ApiGameRepository kelak.
abstract class GameRepository {
  Future<List<Game>> fetchGames();
}

class LocalGameRepository implements GameRepository {
  LocalGameRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;
  final AssetBundle _bundle;

  @override
  Future<List<Game>> fetchGames() async {
    final raw = await _bundle.loadString('assets/data/games.json');
    final data = jsonDecode(raw) as List<dynamic>;
    final games = data.map((item) =>
      Game.fromJson(item as Map<String, dynamic>)).toList();
    if (games.map((game) => game.id).toSet().length != games.length) {
      throw const FormatException('ID game harus unik.');
    }
    return List<Game>.unmodifiable(games);
  }
}

List<Game> filterGames(List<Game> games, {String query = '', String? genre}) {
  final keyword = query.trim().toLowerCase();
  return games.where((game) =>
    (genre == null || game.genre == genre) &&
    '${game.title} ${game.genre} ${game.platform}'.toLowerCase()
      .contains(keyword)).toList();
}
