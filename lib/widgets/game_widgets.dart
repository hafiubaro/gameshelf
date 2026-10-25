import 'package:flutter/material.dart';
import '../models/game.dart';

IconData gameIcon(String symbol) => switch (symbol) {
  'rocket' => Icons.rocket_launch_rounded,
  'forest' => Icons.forest_rounded,
  'car' => Icons.sports_motorsports_rounded,
  'puzzle' => Icons.extension_rounded,
  'castle' => Icons.castle_rounded,
  _ => Icons.sports_esports_rounded,
};

class GameArt extends StatelessWidget {
  const GameArt({super.key, required this.game, this.height = 140});
  final Game game;
  final double height;
  @override
  Widget build(BuildContext context) => Container(
    height: height, width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [Color(game.color), const Color(0xFF242535)])),
    child: Stack(children: [
      Positioned(right: -20, top: -30, child: Icon(Icons.circle_outlined,
        size: height + 50, color: Colors.white12)),
      Center(child: Icon(gameIcon(game.symbol), size: height * .50,
        color: Colors.white)),
      Positioned(left: 14, bottom: 12, child: Text(game.genre.toUpperCase(),
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800,
          letterSpacing: 2, color: Colors.white))),
    ]),
  );
}

class GameTile extends StatelessWidget {
  const GameTile({super.key, required this.game, required this.onTap});
  final Game game;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero, clipBehavior: Clip.antiAlias,
    color: const Color(0xFF202331),
    child: InkWell(onTap: onTap, child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GameArt(game: game),
        const SizedBox(height: 14),
        Text(game.title, style: const TextStyle(fontSize: 19,
          fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text('${game.genre} / ${game.platform}',
          style: const TextStyle(color: Color(0xFFC2C3D0))),
        const SizedBox(height: 12),
        Row(children: [const Icon(Icons.star_rounded, size: 19,
          color: Color(0xFFFFD77D)), const SizedBox(width: 5),
          Expanded(child: Text('${game.rating.toStringAsFixed(1)} / 5')),
          const Icon(Icons.arrow_forward_rounded, size: 20)]),
      ]),
    )),
  );
}

class GameGrid extends StatelessWidget {
  const GameGrid({super.key, required this.games, required this.onSelected});
  final List<Game> games;
  final ValueChanged<Game> onSelected;
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, box) {
    // Wrap memakai tinggi intrinsik: judul panjang dan teks besar tidak terpotong.
    final columns = box.maxWidth >= 950 ? 3 : box.maxWidth >= 600 ? 2 : 1;
    final width = (box.maxWidth - (columns - 1) * 16) / columns;
    return Wrap(spacing: 16, runSpacing: 16, children: games.map((game) =>
      SizedBox(width: width, child: GameTile(game: game,
        onTap: () => onSelected(game)))).toList());
  });
}

class ContentFrame extends StatelessWidget {
  const ContentFrame({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(child: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1160),
      child: Padding(padding: const EdgeInsets.all(20), child: child)))));
}

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({super.key, required this.title, required this.message});
  final String title, message;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48),
    child: Center(child: Column(children: [
      const Icon(Icons.search_off_rounded, size: 52),
      const SizedBox(height: 16),
      Text(title, textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8), Text(message, textAlign: TextAlign.center),
    ])),
  );
}
