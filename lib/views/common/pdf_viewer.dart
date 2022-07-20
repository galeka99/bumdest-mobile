import 'package:bumdest/components/custom_appbar.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';

class ProposalPage extends StatelessWidget {
  final PDFDocument document;
  final String title;
  const ProposalPage(this.document, {Key? key, this.title = 'Proposal'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, this.title),
      body: PDFViewer(
        document: document,
        showNavigation: true,
        showIndicator: true,
      ),
    );
  }
}
