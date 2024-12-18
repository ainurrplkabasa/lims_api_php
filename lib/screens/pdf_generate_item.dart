import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGenerateItem {
  Future<Uint8List> generatePdf(List<dynamic> laporan) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            pw.Text(
              "Laporan Data Item",
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Text("kode Item",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Nama Item",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Spesifikasi",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Merk",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Tahun Anggaran",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Sumber Dana",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Keterangan",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Jumlah",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                ...laporan.map((item) {
                  return pw.TableRow(
                    children: [
                      pw.Text(item['kd_item'].toString()),
                      pw.Text(item['nama_item']),
                      pw.Text(item['spesifikasi']),
                      pw.Text(item['merk']),
                      pw.Text(item['tahun_anggaran']),
                      pw.Text(item['sumber_dana']),
                      pw.Text(item['keterangan']),
                      pw.Text(item['jumlah']),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );

    return pdf.save();
  }
}
