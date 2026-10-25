import 'package:flutter/material.dart';
import '../models/game.dart';
import '../data/favorites_store.dart';
import '../widgets/game_widgets.dart';
import 'detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key, required this.games, required this.favorites});
  final List<Game> games;
  final FavoritesStore favorites;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Favorit saya')),
    body: ListenableBuilder(listenable: favorites, builder: (context, _) {
      final saved = games.where((game) => favorites.contains(game.id)).toList();
      return ContentFrame(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${saved.length} game disimpan',
            style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          if (saved.isEmpty) const EmptyMessage(title: 'Belum ada favorit',
            message: 'Buka detail game, lalu pilih Simpan ke favorit.')
          else GameGrid(games: saved, onSelected: (game) =>
            Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => DetailPage(game: game, favorites: favorites)))),
        ]));
    }),
  );
}
