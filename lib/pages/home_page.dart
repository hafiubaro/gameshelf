import 'package:flutter/material.dart';
import '../models/game.dart';
import '../data/game_repository.dart';
import '../data/favorites_store.dart';
import '../widgets/game_widgets.dart';
import 'category_page.dart';
import 'detail_page.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.repository});
  final GameRepository repository;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final favorites = FavoritesStore();
  late Future<List<Game>> gamesFuture;
  String query = '';
  @override
  void initState() { super.initState(); gamesFuture = widget.repository.fetchGames(); }
  @override
  void dispose() { favorites.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Game>>(
    future: gamesFuture,
    builder: (context, snapshot) {
      final games = snapshot.data ?? const <Game>[];
      return Scaffold(
        appBar: AppBar(title: const Text('GameShelf',
          style: TextStyle(fontWeight: FontWeight.w800)), actions: [
          IconButton(tooltip: 'Buka favorit',
            onPressed: snapshot.hasData ? () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => FavoritesPage(
                games: games, favorites: favorites))) : null,
            icon: const Icon(Icons.favorite_border)),
          const SizedBox(width: 8),
        ]),
        body: snapshot.connectionState != ConnectionState.done
          ? const Center(child: CircularProgressIndicator())
          : snapshot.hasError ? Center(child: Padding(
            padding: const EdgeInsets.all(24), child: Column(
            mainAxisSize: MainAxisSize.min, children: [
              const Text('Katalog belum dapat dimuat.', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(onPressed: () => setState(() {
                gamesFuture = widget.repository.fetchGames();
              }), child: const Text('Coba lagi')),
            ])))
          : _content(games),
      );
    },
  );

  Widget _content(List<Game> games) {
    final results = filterGames(games, query: query);
    final genres = games.map((game) => game.genre).toSet().toList()..sort();
    return ContentFrame(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: double.infinity, padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(colors: [Color(0xFF50418B), Color(0xFF252C49)])),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('TEMUKAN FAVORIT BARUMU',
              style: TextStyle(letterSpacing: 2, fontSize: 11, color: Color(0xFFE2DBFF))),
            const SizedBox(height: 12),
            const Text('Dunia baru,\npilihanmu.', style: TextStyle(fontSize: 32,
              height: 1.15, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 12),
            Text('${games.length} game pilihan untuk dijelajahi.',
              style: const TextStyle(color: Color(0xFFE2DBFF))),
          ])),
        const SizedBox(height: 24),
        TextField(onChanged: (value) => setState(() => query = value),
          decoration: const InputDecoration(labelText: 'Cari game, genre, atau platform',
            prefixIcon: Icon(Icons.search))),
        const SizedBox(height: 24),
        Text('Jelajahi kategori', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: genres.map((genre) => ActionChip(
          label: Text(genre), avatar: const Icon(Icons.grid_view_rounded, size: 17),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => CategoryPage(genre: genre, games: games,
              favorites: favorites))))).toList()),
        const SizedBox(height: 26),
        Text(query.trim().isEmpty ? 'Pilihan untukmu' : 'Hasil pencarian (${results.length})',
          style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        if (results.isEmpty) EmptyMessage(
          title: games.isEmpty ? 'Katalog masih kosong' : 'Game tidak ditemukan',
          message: games.isEmpty ? 'Tambahkan data game untuk memulai.'
            : 'Coba judul, genre, atau platform lainnya.')
        else GameGrid(games: results, onSelected: (game) =>
          Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => DetailPage(game: game, favorites: favorites)))),
        const SizedBox(height: 24),
        const Text('Katalog demonstrasi / UTS Mobile Programming',
          style: TextStyle(color: Color(0xFFC2C3D0))),
      ]));
  }
}
