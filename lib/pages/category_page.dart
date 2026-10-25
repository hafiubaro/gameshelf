import 'package:flutter/material.dart';
import '../models/game.dart';
import '../data/game_repository.dart';
import '../data/favorites_store.dart';
import '../widgets/game_widgets.dart';
import 'detail_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key, required this.genre, required this.games,
    required this.favorites});
  final String genre;
  final List<Game> games;
  final FavoritesStore favorites;
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final results = filterGames(widget.games, query: query, genre: widget.genre);
    return Scaffold(appBar: AppBar(title: Text('Kategori ${widget.genre}')),
      body: ContentFrame(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Temukan petualanganmu', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 10),
          Text('${results.length} game dalam kategori ${widget.genre}'),
          const SizedBox(height: 20),
          TextField(onChanged: (value) => setState(() => query = value),
            decoration: const InputDecoration(labelText: 'Cari dalam kategori',
              prefixIcon: Icon(Icons.search))),
          const SizedBox(height: 24),
          if (results.isEmpty) const EmptyMessage(title: 'Game tidak ditemukan',
            message: 'Coba kata kunci lain dalam kategori ini.')
          else GameGrid(games: results, onSelected: (game) =>
            Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => DetailPage(game: game, favorites: widget.favorites)))),
        ])));
  }
}
