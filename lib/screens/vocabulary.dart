import 'package:flutter/material.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  final List<String> _words = [];
  final TextEditingController _controller = TextEditingController();

  // void _addWord() {
  //   if (_controller.text.isNotEmpty) {
  //     setState(() {
  //       _words.add(_controller.text);
  //       _controller.clear();
  //     });
  //   }
  // }

  // void _removeWord(int index) {
  //   setState(() {
  //     _words.removeAt(index);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (ctx) => {}),
              // );
            },
          ),
        ],
      ),
      body: Column(),
    );
  }
}
