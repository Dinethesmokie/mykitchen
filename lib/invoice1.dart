import 'dart:io';
import 'dart:typed_data';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfInvoiceApi {
  static Future<Uint8List> generate() async {
    final pdf = pw.Document();
    List<pw.Widget> widget = [];
    final logoArea = pw.Center(
        child: pw.Container(
            padding: pw.EdgeInsets.all(10),
            height: 500,
            color: PdfColor.fromHex("#aaddfbd9"),
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text("Thank you for buying our product",
                      style: pw.TextStyle(fontSize: 30)),
                  pw.SizedBox(height: 20),
                  pw.Text('our customer will contact you',
                      style: pw.TextStyle(fontSize: 30)),
                ])));

    widget.add(logoArea);
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a3,
        build: (pw.Context context) {
          return widget;
        }));
    return pdf.save();
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = '${output.path}/$fileName.pdf';
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenFile.open(filePath);
  }
}
