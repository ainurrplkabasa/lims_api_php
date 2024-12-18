import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGenerator {
  Future<Uint8List> generatePdf(List<dynamic> laporan) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            pw.Text(
              "Laporan Data Peminjaman",
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
                    pw.Text("kode borrow",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Nama Item",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("identitas",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Nama Peminjam",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Tgl Pinjam",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Tgl Kembali",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Tgl Estimasi",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("keterangan",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                ...laporan.map((item) {
                  return pw.TableRow(
                    children: [
                      pw.Text(item['kd_borrow'].toString()),
                      pw.Text(item['nama_item']),
                      pw.Text(item['nama_peminjam']),
                      pw.Text(item['tgl_pinjam']),
                      pw.Text(item['tgl_kembali']),
                      pw.Text(item['tgl_est']),
                      pw.Text(item['keterangan']),
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
