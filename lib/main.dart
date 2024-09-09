import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'My Second App With FLUTTER',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;     // ← Add this property.

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPageList();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Tus me gusta!',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
          print('selected: $value');
        },
      ),
    );
  }
}


class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  // ↓ Add this.
  void getNext() {
    current = WordPair.random();
    notifyListeners(); // notifica a todos los elementos que escuchan a myAppState
  }

  // ↓ Add the code below.
  var favorites = <WordPair>[];

  void toggleFavorite() {
    print('favoritos --> $favorites');
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class FavoritesPageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
   // final List<String> entries = <String>['A', 'B', 'C'];
    final List<WordPair> entries = appState.favorites;

    final List<int> colorCodes = <int>[200, 400, 100];

    print('lista de favoritos: $entries' );

    var theme = Theme.of(context);

    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.inversePrimary,
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GenericTopText(
              style: style,
              text: 'Tu lista de favoritos:', // Pasar el texto aquí
            ),
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: entries.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 60,
                      color: Colors.deepPurpleAccent[colorCodes[index]],
                      child: Center(child: Text('Nomber favorito: ${entries[index]}'))
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }

}
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    var theme = Theme.of(context);

    // ↓ Add this.
    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.inversePrimary,
    );

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, //para alinear los elementos al centro
          children: [
            GenericTopText(
              style: style,
              text: 'Dale like al nombre más original:',
            ),
            SizedBox(height: 10),
            BigCard(pair: pair),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Dale Like'),
                ),
                SizedBox(width: 10),// brinda espacios entre elementos
                ElevatedButton.icon(
                  onPressed: () {
                    appState.getNext();
                  },
                  icon: Icon(Icons.navigate_next),
                  label: Text('Siguiente'),
                ),

              ],
            )
          ],
        ),
    );
  }
}


class GenericTopText extends StatelessWidget {
  const GenericTopText({
    super.key,
    required this.style,
    required this.text, // Añadir esta propiedad
  });

  final TextStyle style;
  final String text; // Añadir esta propiedad

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text, // Usar la propiedad text aquí
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }
}


class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);

    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(100),
        child: Text(
            pair.asPascalCase,
            style: style,
            semanticsLabel: pair.asPascalCase
        ),
      ),
    );
  }
}