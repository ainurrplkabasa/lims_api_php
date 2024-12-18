import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:login_app/common/conts.dart';

class ApiItem {
  final String apiUrl = '$BASE_URL/report_item.php';

  Future<List<dynamic>> fetchLaporan() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to load laporan");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
