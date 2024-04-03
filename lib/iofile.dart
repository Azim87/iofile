import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class IOFileScreen extends StatefulWidget {
  const IOFileScreen({super.key});

  @override
  State<IOFileScreen> createState() => _IOFileScreenState();
}

class _IOFileScreenState extends State<IOFileScreen> {
  static const String KLocalFileName = 'demo_localfile.txt';
  late final TextEditingController _textController;
  String _localFileContent = '';
  String _localFilePath = KLocalFileName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textController = TextEditingController();
    _readTextFromLocalFile();
    _getLocalFile.then((file) => setState(() => _localFilePath = file.path));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode textFieldFocusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local file read/write Demo'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          const Text(
            'Write to local file:',
            style: TextStyle(fontSize: 20),
          ),
          TextFormField(
            focusNode: textFieldFocusNode,
            controller: _textController,
            maxLines: null,
            style: const TextStyle(fontSize: 20),
          ),
          ButtonBar(
            children: <Widget>[
              MaterialButton(
                child: const Text(
                  'Load',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  _readTextFromLocalFile();
                  _textController.text = _localFileContent;
                  FocusScope.of(context).requestFocus(textFieldFocusNode);
                  log('Text successfully loaded from local file');
                },
              ),
              MaterialButton(
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  if(_textController.text.isEmpty) {
                    _localFileContent = 'text is empty';
                    return;
                  }

                  await _writeTextToLocalFile(_textController.text);
                  _textController.clear();
                  await _readTextFromLocalFile();
                  log('Text successfully has written to the local file');
                },
              ),
            ],
          ),
          const Divider(height: 20.0),
          Text('Local file path:', style: Theme.of(context).textTheme.headline6),
          Text(_localFilePath, style: Theme.of(context).textTheme.subtitle1),
          const Divider(height: 20.0),
          Text('Local file content:', style: Theme.of(context).textTheme.headline6),
          Text(_localFileContent, style: Theme.of(context).textTheme.subtitle1),
        ],
      ),
    );
  }

  Future<String> get _getLocalPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _getLocalFile async {
    final path = await _getLocalPath;
    return File('$path/$KLocalFileName');
  }

  Future<File> _writeTextToLocalFile(String text) async {
    final file = await _getLocalFile;
    return file.writeAsString(text);
  }

  Future _readTextFromLocalFile() async {
    String content;
    try {
      final file = await _getLocalFile;
      content = file.readAsStringSync();
    } catch (e) {
      content = 'Error loading local file: $e';
    }
    setState(() => _localFileContent = content);
  }
}
