import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show Clipboard, ClipboardData, rootBundle;
import 'package:syntax_highlight/syntax_highlight.dart';

class SourceCodeView extends StatefulWidget {
  final String filePath;
  const SourceCodeView({required this.filePath, Key? key}) : super(key: key);

  @override
  _SourceCodeViewState createState() => _SourceCodeViewState();
}

class _SourceCodeViewState extends State<SourceCodeView> {
  late Highlighter highlighter;
  String code = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _setup() async {
    final loadedCode = await rootBundle.loadString(widget.filePath);
    await Highlighter.initialize(['dart']);
    final theme = await HighlighterTheme.loadLightTheme();
    highlighter = Highlighter(language: 'dart', theme: theme);
    setState(() {
      code = loadedCode;
      isLoading = false;
    });
  }

  void _copyAllCodeToClipboard() {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('All code copied to clipboard')));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Source Code')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filePath.split('/').last),
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            tooltip: 'Copy all code',
            onPressed: _copyAllCodeToClipboard,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: SelectableText.rich(
          highlighter.highlight(code),
          style: TextStyle(fontFamily: 'monospace', fontSize: 14),
        ),
      ),
    );
  }
}
