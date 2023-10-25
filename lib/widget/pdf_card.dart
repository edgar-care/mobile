import 'dart:io';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFCard extends StatelessWidget {
  final String pdfUrl;
  final String text;

  const PDFCard({super.key, required this.pdfUrl, required this.text});

  Future<File> downloadPDF(String url, String filename) async {
    var request = await http.Client().get(Uri.parse(url));
    var tempDir = await getTemporaryDirectory();
    File file = File('${tempDir.path}/$filename');
    return file.writeAsBytes(request.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      child: SizedBox(
        height: 140,
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(BootstrapIcons.download),
                    onPressed: () async {
                    },
                  ),
                  IconButton(
                    icon: const Icon(BootstrapIcons.eye),
                    onPressed: () async {
                      File file = await downloadPDF(pdfUrl, 'my-pdf.pdf');
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFScreen(path: file.path),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PDFScreen extends StatelessWidget {
  final String path;

  const PDFScreen({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return PDFView(
      filePath: path,
    );
  }
}