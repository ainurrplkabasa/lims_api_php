import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'api_item.dart';
import 'pdf_generate_item.dart';

class ReportItem extends StatefulWidget {
  const ReportItem({super.key});

  @override
  State<ReportItem> createState() => _ReportItemState();
}

class _ReportItemState extends State<ReportItem> {
  final ApiItem apiItem = ApiItem();
  final PdfGenerateItem pdfGenerator = PdfGenerateItem();

  List<dynamic> laporan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await apiItem.fetchLaporan();
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
                        title: Text(item['nama_item']),
                        subtitle: Text(item['spesifikasi']),
                        trailing: Text(item['jumlah']),
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
