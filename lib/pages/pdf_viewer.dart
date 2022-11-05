import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewer extends StatefulWidget {
  @override
  _PDFViewer createState() => _PDFViewer();
}

class _PDFViewer extends State<PDFViewer> {
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vigneshwarar'),
      ),
      body: SfPdfViewer.asset(
        'assets/pdfs/vigneshwarar.pdf',
        key: _pdfViewerKey,
        enableTextSelection: false,
        controller: _pdfViewerController,
      ),
    );
  }
}
