import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'api_service.dart';
import 'pdf_generator.dart';

class ReportBorrow extends StatefulWidget {
  const ReportBorrow({super.key});

  @override
  State<ReportBorrow> createState() => _ReportBorrowState();
}

class _ReportBorrowState extends State<ReportBorrow> {
  final ApiService apiService = ApiService();
  final PdfGenerator pdfGenerator = PdfGenerator();

  List<dynamic> laporan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await apiService.fetchLaporan();
      setState(() {
        laporan = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cetak Laporan PDF"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: laporan.length,
                    itemBuilder: (context, index) {
                      final item = laporan[index];
                      return ListTile(
                        title: Text(item['nama_peminjam']),
                        subtitle: Text(item['tgl_pinjam']),
                        trailing: Text(item['tgl_kembali']),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final pdfData = await pdfGenerator.generatePdf(laporan);

                    // Tampilkan PDF untuk dicetak atau dibagikan
                    await Printing.layoutPdf(onLayout: (format) => pdfData);
                  },
                  child: const Text("Generate PDF"),
                ),
              ],
            ),
    );
  }
}
