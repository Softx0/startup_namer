import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

//Todos los widgets son inmutables.
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hello niggu',
      theme: ThemeData(
        primaryColor: Colors.deepOrangeAccent,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RandomWordState();
  }
}

class RandomWordState extends State<RandomWords> {
  //_suggestion _ me dice que es private
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>(); // Las qu ele gustan al usuario
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nombres Aleatorios!'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.list,
            ),
            onPressed: _favorites,
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      //Creando el list view
      itemBuilder: (context, i) {
        //funcion anonima
        if (i.isOdd) {
          return Divider();
        }
        if (i >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        final index = i ~/ 2;

        return _buildRow(_suggestions[index]);
      }, //Anonymous Class
    );
  } //Widget

  //Funcion para las filas
  Widget _buildRow(WordPair suggestion) {
    final alreadySaved = _saved.contains(suggestion);
    return ListTile(
      title: Text(
        suggestion.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved
            ? Icons.favorite
            : Icons
                .favorite_border, // Si esta seleccionado en el set entonces se
        // marca sino se pone sin bordes.
        color: alreadySaved
            ? Colors.red
            : null, // Si esta en el Set se pone rojo sino, se queda igual.
      ),
      onTap: () {
        //funcion anonima
        //funcion de primordial importancia de los stateful widgets
        setState(() {
          if (alreadySaved) {
            _saved.remove(suggestion);
          } else {
            _saved.add(suggestion);
          }
        }); //setState
      },
    );
  }

  void _favorites() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      final tiles = _saved.map((suggestion) {
        //recorriendo las palabras que tenemos
        return ListTile(
          title: Text(
            suggestion.asPascalCase,
            style: _biggerFont,
          ),
        );
      });

      final divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();
      return Scaffold(
        appBar: AppBar(
          title: Text('Nombres guardados'),
        ),
        body: ListView(
          children: divided,
        ),
      );
    }));
  }
}
