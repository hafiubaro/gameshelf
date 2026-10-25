import 'package:flutter/material.dart';
import '../models/game.dart';
import '../data/favorites_store.dart';
import '../widgets/game_widgets.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.game, required this.favorites});
  final Game game;
  final FavoritesStore favorites;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Detail game')),
    body: ContentFrame(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GameArt(game: game, height: 240),
        const SizedBox(height: 24),
        Text(game.title, style: Theme.of(context).textTheme.headlineMedium
          ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: [
          Chip(label: Text(game.genre)), Chip(label: Text(game.platform)),
          Chip(avatar: const Icon(Icons.star_rounded, size: 18),
            label: Text('${game.rating.toStringAsFixed(1)} / 5')),
        ]),
        const SizedBox(height: 20),
        Text('Tentang game', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Text(game.description, style: const TextStyle(height: 1.7, fontSize: 16)),
        const SizedBox(height: 18),
        Text('Pengembang: ${game.developer}'),
        const SizedBox(height: 22),
        Text('Fitur utama', style: Theme.of(context).textTheme.titleLarge),
        ...game.features.map((feature) => Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.check_circle_outline, size: 20,
              color: Color(0xFFA89AFF)), const SizedBox(width: 10),
            Expanded(child: Text(feature)),
          ]))),
        const SizedBox(height: 28),
        ListenableBuilder(listenable: favorites, builder: (context, _) {
          final saved = favorites.contains(game.id);
          return SizedBox(width: double.infinity, child: FilledButton.icon(
            onPressed: () => favorites.toggle(game.id),
            icon: Icon(saved ? Icons.favorite : Icons.favorite_border),
            label: Padding(padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(saved ? 'Hapus dari favorit' : 'Simpan ke favorit'))));
        }),
        const SizedBox(height: 16),
        const Text('Data demonstrasi. Nama, rating, dan informasi game bersifat fiktif. '
          'Favorit tersimpan hanya selama aplikasi dibuka.',
          style: TextStyle(color: Color(0xFFC2C3D0), height: 1.5)),
      ])),
  );
}
