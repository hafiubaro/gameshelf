import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameshelf/data/favorites_store.dart';
import 'package:gameshelf/data/game_repository.dart';
import 'package:gameshelf/main.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/pages/category_page.dart';
import 'package:gameshelf/pages/detail_page.dart';
import 'package:gameshelf/widgets/game_widgets.dart';

const sample = Game(id: 'orbit', title: 'Orbit Runner', genre: 'Arcade',
  platform: 'Android', developer: 'Demo', rating: 4.8,
  description: 'Petualangan orbit.', color: 0xFF6754AD, symbol: 'rocket',
  features: ['Kontrol sederhana']);

class FakeRepository implements GameRepository {
  bool fail = false;
  @override
  Future<List<Game>> fetchGames() async {
    if (fail) throw const FormatException('Data rusak');
    return [sample];
  }
}

class StringBundle extends CachingAssetBundle {
  StringBundle(this.contents);
  final String contents;
  @override
  Future<ByteData> load(String key) async =>
    ByteData.sublistView(Uint8List.fromList(utf8.encode(contents)));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('JSON round-trip mempertahankan field utama', () {
    final parsed = Game.fromJson(sample.toJson());
    expect(parsed.toJson(), sample.toJson());
  });
  test('Rating di luar rentang ditolak', () {
    expect(() => Game.fromJson({...sample.toJson(), 'rating': 7}),
      throwsFormatException);
  });
  test('Pencarian mengabaikan kapital dan spasi, kategori tetap berlaku', () {
    expect(filterGames([sample], query: ' ORBIT ', genre: 'Arcade'), [sample]);
    expect(filterGames([sample], query: 'android'), [sample]);
    expect(filterGames([sample], genre: 'Puzzle'), isEmpty);
  });
  test('Favorit dapat ditambah dan dihapus serta mengirim notifikasi', () {
    final store = FavoritesStore();
    var calls = 0;
    store.addListener(() => calls++);
    store.toggle('orbit');
    expect(store.contains('orbit'), isTrue);
    store.toggle('orbit');
    expect(store.contains('orbit'), isFalse);
    expect(calls, 2);
    store.dispose();
  });
  test('Repository menolak ID duplikat', () async {
    final repo = LocalGameRepository(bundle: StringBundle(
      jsonEncode([sample.toJson(), sample.toJson()])));
    await expectLater(repo.fetchGames(), throwsFormatException);
  });
  test('Asset nyata berisi 8 game dengan 4 kategori', () async {
    final games = await LocalGameRepository().fetchGames();
    expect(games.length, 8);
    expect(games.map((g) => g.genre).toSet().length, 4);
    expect(games.map((g) => g.id).toSet().length, 8);
  });
  testWidgets('Beranda menuju kategori dan detail, lalu kembali', (tester) async {
    await tester.pumpWidget(GameShelfApp(repository: FakeRepository()));
    await tester.pumpAndSettle();
    final category = find.widgetWithText(ActionChip, 'Arcade');
    await tester.ensureVisible(category);
    await tester.tap(category);
    await tester.pumpAndSettle();
    expect(find.byType(CategoryPage), findsOneWidget);
    await tester.ensureVisible(find.byType(GameTile));
    await tester.tap(find.byType(GameTile));
    await tester.pumpAndSettle();
    expect(find.byType(DetailPage), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(CategoryPage), findsOneWidget);
  });
  testWidgets('Favorit pada detail muncul di halaman favorit', (tester) async {
    await tester.pumpWidget(GameShelfApp(repository: FakeRepository()));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(GameTile));
    await tester.tap(find.byType(GameTile));
    await tester.pumpAndSettle();
    final save = find.text('Simpan ke favorit');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(find.text('Hapus dari favorit'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Buka favorit'));
    await tester.pumpAndSettle();
    expect(find.text('1 game disimpan'), findsOneWidget);
    expect(find.text('Orbit Runner'), findsOneWidget);
  });
  testWidgets('Kegagalan pemuatan bisa dicoba ulang', (tester) async {
    final repository = FakeRepository()..fail = true;
    await tester.pumpWidget(GameShelfApp(repository: repository));
    await tester.pumpAndSettle();
    expect(find.text('Katalog belum dapat dimuat.'), findsOneWidget);
    repository.fail = false;
    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();
    expect(find.text('Pilihan untukmu'), findsOneWidget);
  });
  testWidgets('Pencarian kosong menampilkan pesan', (tester) async {
    await tester.pumpWidget(GameShelfApp(repository: FakeRepository()));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'tidak-ada');
    await tester.pumpAndSettle();
    expect(find.text('Game tidak ditemukan'), findsOneWidget);
  });
  for (final width in [320.0, 800.0, 1200.0]) {
    testWidgets('Layout beranda tanpa exception pada lebar $width', (tester) async {
      await tester.binding.setSurfaceSize(Size(width, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(GameShelfApp(repository: FakeRepository()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
