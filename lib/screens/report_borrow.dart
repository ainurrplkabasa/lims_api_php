import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

class ReportBorrow extends StatefulWidget {
  @override
  _ReportBorrowState createState() => _ReportBorrowState();
}

class _ReportBorrowState extends State<ReportBorrow> {
  String _reportHtml = "";

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  Future<void> _fetchReport() async {
    final response = await http.get(Uri.parse('your_api_url/report.php'));

    if (response.statusCode == 200) {
      setState(() {
        _reportHtml = response.body;
      });
    } else {
      throw Exception('Failed to load report');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Report Viewer'),
        ),
        body: SingleChildScrollView(
          child: Html(data: _reportHtml),
        ),
      ),
    );
  }
}
