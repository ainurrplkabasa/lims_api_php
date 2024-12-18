import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_app/components/date_input.dart';
import 'package:login_app/screens/report_borrow.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

import '../common/conts.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  List data = [];
  List categoryItemlist = [];
  String searchText = "";
  String? statusDropdown;
  File? imageFile;

  final List<String> items = [
    '',
    'Dipinjam',
    'Kembali',
    'Masih di Pinjam',
    'Terlambat Mengembalikan',
  ];

  @override
  void initState() {
    getData('');
    super.initState();
    getAllCategory();
  }

  var dropdownvalue;

  Future<Uint8List> generatePdf(List<Map<String, dynamic>> data) async {
    final pdf = pw.Document();

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return pw.Text(data[index]['field_name']);
            },
          );
        },
      ),
    );

    // Generate the PDF and return as bytes
    return pdf.save();
  }

  Future getAllCategory() async {
    var baseUrl = "$BASE_URL/search_item_in_borrow.php";

    http.Response response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        categoryItemlist = jsonData;
      });
    }
  }

  Future getData(String search) async {
    var response;
    var uri = Uri.parse('$BASE_URL/search.php');
    response = await http.post(uri, body: {
      "search": search,
    });
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      return Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Something went wrong ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future addData(
      String kditem,
      String identitas,
      String namaPeminjam,
      DateTime tglPinjam,
      DateTime tglKembali,
      DateTime tglEst,
      String status,
      String keterangan,
      File imageFile) async {
    // ignore: deprecated_member_use
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse('$BASE_URL/insert.php');
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile("image", stream, length,
        filename: path.basename(imageFile.path));

    request.files.add(multipartFile);
    request.fields['kd_item'] = kditem;
    request.fields['identitas'] = identitas;
    request.fields['nama_peminjam'] = namaPeminjam;
    request.fields['tgl_pinjam'] = tglPinjam.toString();
    request.fields['tgl_kembali'] = tglKembali.toString();
    request.fields['tgl_estimasi'] = tglEst.toString();
    request.fields['status'] = status;
    request.fields['keterangan'] = keterangan;

    var response = await request.send();
    print(response.toString());
    if (response.statusCode == 200) {
      getData('');
      return Fluttertoast.showToast(
        backgroundColor: Colors.green,
        textColor: Colors.white,
        msg: 'Data Berhasil Ditambahkan',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      return Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Something went wrong ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Widget _displayMedia(String? media) {
    print(media);
    if (media == null || media == '') {
      return Image.asset('assets/images/icon item.png');
    } else {
      return Image.network(
        '$BASE_URL/img/$media',
        errorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/images/icon item.png'),
      );
    }
  }

  Future updateData({
    required String kdborrow,
    required String status,
    required String keterangan,
  }) async {
    var response;
    var uri = Uri.parse('$BASE_URL/update.php');
    response = await http.post(uri, body: {
      "kd_borrow": kdborrow,
      "status": status,
      "keterangan": keterangan,
    });
    if (response.statusCode == 200) {
      getData('');
      return Fluttertoast.showToast(
        backgroundColor: Colors.green,
        textColor: Colors.white,
        msg: 'Data Berhasil Diubah',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      return Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Something went wrong ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future DetailData({
    required String kdborrow,
    required String kditem,
    required String identitas,
    required String namaPeminjam,
    required DateTime tglPinjam,
    required DateTime tglKembali,
    required DateTime tglEsti,
    required String status,
    required String keterangan,
  }) async {
    var response;
    var uri = Uri.parse('$BASE_URL/update.php');
    response = await http.post(uri, body: {
      "kd_borrow": kdborrow,
      "kd_item": kditem,
      "identitas": identitas,
      "nama_peminjam": namaPeminjam,
      "tgl_pinjam": tglPinjam,
      "tgl_kembali": tglKembali,
      "tgl_est": tglEsti,
      "status": status,
      "keterangan": keterangan,
    });
    if (response.statusCode == 200) {
      getData('');
      return Fluttertoast.showToast(
        backgroundColor: Colors.green,
        textColor: Colors.white,
        msg: 'Data Berhasil Diubah',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      return Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Something went wrong ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  AlertDialog _alertDialogDetail(Map<String, dynamic> data) {
    TextEditingController ctrlKdborrow = TextEditingController();
    TextEditingController ctrlKditem = TextEditingController();
    TextEditingController ctrlIdentitas = TextEditingController();
    TextEditingController ctrlNamapeminjam = TextEditingController();
    TextEditingController ctrlTglpinjam = TextEditingController();
    TextEditingController ctrlTglkembali = TextEditingController();
    TextEditingController ctrlEst = TextEditingController();
    TextEditingController ctrlStatus = TextEditingController();
    TextEditingController ctrlKeterangan = TextEditingController();

    ctrlKdborrow.text = data['kd_borrow'];
    ctrlKditem.text = data['kd_item'].toString();
    ctrlIdentitas.text = data['identitas'];
    ctrlNamapeminjam.text = data['nama_peminjam'];
    ctrlTglpinjam.text = data['tgl_pinjam'];
    ctrlTglkembali.text = data['tgl_kembali'];
    ctrlEst.text = data['tgl_est'];
    ctrlStatus.text = data['status'];
    ctrlKeterangan.text = data['keterangan'];

    return AlertDialog(
      title: Text('Detail Data'),
      content: SingleChildScrollView(
        child: Scrollbar(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrlKdborrow,
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('kd Borrow'),
                ),
              ),
              TextField(
                controller: ctrlKditem,
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('Kd Item'),
                ),
              ),
              TextField(
                controller: ctrlIdentitas,
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('Identitas'),
                ),
              ),
              TextField(
                controller: ctrlNamapeminjam,
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('Nama Peminjam'),
                ),
              ),
              TextField(
                controller: ctrlTglpinjam,
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('TGL Pinjam'),
                ),
              ),
              TextField(
                controller: ctrlTglkembali,
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('Tgl Kembali'),
                ),
              ),
              TextField(
                controller: ctrlEst,
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('TGl Estimasi'),
                ),
              ),
              TextField(
                controller: ctrlStatus,
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('Status'),
                ),
              ),
              TextField(
                controller: ctrlKeterangan,
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('Keterangan'),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Kembali'),
        ),
      ],
    );
  }

  AlertDialog _alertDialogUpdate(Map<String, dynamic> data) {
    TextEditingController ctrlStatus = TextEditingController();
    TextEditingController ctrlKeterangan = TextEditingController();
    ctrlStatus.text = data['status'];
    ctrlKeterangan.text = data['keterangan'];

    return AlertDialog(
      title: Text('Update Data'),
      content: StatefulBuilder(builder: (context, setState) {
        return SingleChildScrollView(
          child: Scrollbar(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton(
                  isExpanded: true,
                  // Initial Value
                  value: ctrlStatus.text,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),

                  onChanged: (String? newValue) {
                    ctrlStatus.text = newValue!;
                    setState(() {});
                  },
                ),
                TextField(
                  controller: ctrlKeterangan,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: Text('Keterangan'),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            updateData(
                kdborrow: data['kd_borrow'],
                status: ctrlStatus.text,
                keterangan: ctrlKeterangan.text);
            Navigator.of(context).pop();
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }

  StatefulBuilder _alertDialog() {
    DateTime dateTime = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    TextEditingController ctrlKditem = TextEditingController();
    TextEditingController ctrlIdentitas = TextEditingController();
    TextEditingController ctrlNamapeminjam = TextEditingController();
    TextEditingController ctrlTglpinjam =
        TextEditingController(text: formattedDate.toString());
    TextEditingController ctrlTglkembali =
        TextEditingController(text: formattedDate.toString());
    TextEditingController ctrlEsti =
        TextEditingController(text: formattedDate.toString());
    TextEditingController ctrlStatus = TextEditingController(text: "Dipinjam");
    TextEditingController ctrlKeterangan = TextEditingController();

    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Text('Tambah Data'),
        content: SingleChildScrollView(
          child: Scrollbar(
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              TextField(
                controller: ctrlKditem,
                readOnly: true,
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('kd Item'),
                ),
              ),
              Container(
                width: 250,
                child: DropdownButton(
                  isExpanded: true,
                  hint: Text('Silahkan Pilih'),
                  items: categoryItemlist.map((item) {
                    return DropdownMenuItem(
                      value: item['kd_item'].toString(),
                      child: Text(item['nama_item'].toString()),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      dropdownvalue = newVal;
                      ctrlKditem.text = dropdownvalue;
                    });
                  },
                  value: dropdownvalue,
                ),
              ),
              TextField(
                controller: ctrlIdentitas,
                decoration: const InputDecoration(
                  label: Text('Identitas'),
                ),
              ),
              TextField(
                controller: ctrlNamapeminjam,
                decoration: const InputDecoration(
                  label: Text('Nama Peminjam'),
                ),
              ),
              TextField(
                controller: ctrlTglpinjam,
                readOnly: true,
                decoration: const InputDecoration(
                  label: Text('Tgl Pinjam'),
                ),
              ),
              DateInput(controller: ctrlTglkembali, hint: 'Tgl Kembali'),
              DateInput(controller: ctrlEsti, hint: 'Tgl Estimasi'),
              TextField(
                controller: ctrlStatus,
                readOnly: true,
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('Status'),
                ),
              ),
              TextField(
                controller: ctrlKeterangan,
                decoration: const InputDecoration(
                  label: Text('Keterangan'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final image = await ImagePicker().pickImage(
                            source: ImageSource.camera, imageQuality: 30);
                        if (image == null) return;
                        final imageTemp = File(image.path);
                        setState(() {
                          imageFile = imageTemp;
                        });
                      } on PlatformException catch (e) {
                        print('Failed to pick image: $e');
                      }
                    },
                    child: Text('Camera'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final image = await ImagePicker().pickImage(
                            source: ImageSource.gallery, imageQuality: 30);
                        if (image == null) return;
                        final imageTemp = File(image.path);
                        setState(() {
                          imageFile = imageTemp;
                        });
                      } on PlatformException catch (e) {
                        print('Failed to pick image: $e');
                      }
                    },
                    child: Text('Gallery'),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              imageFile == null
                  ? Container()
                  : SizedBox(
                      height: 250,
                      width: 250,
                      child: Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                      ),
                    ),
            ]),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              addData(
                  ctrlKditem.text,
                  ctrlIdentitas.text,
                  ctrlNamapeminjam.text,
                  DateTime.parse(ctrlTglpinjam.text),
                  DateTime.parse(ctrlTglkembali.text),
                  DateTime.parse(ctrlEsti.text),
                  ctrlStatus.text,
                  ctrlKeterangan.text,
                  imageFile!);
              getData('');
              Navigator.of(context).pop();
              setState(() {
                imageFile = null;
              });
            },
            child: const Text('Simpan'),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return _alertDialog();
                    });
              },
              tooltip: 'add Borrow',
              child: Icon(Icons.add),
            ),
          ],
        ),
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          leading: BackButton(
            color: Colors.white,
          ),
          title: AnimatedSearchBar(
            label: "Search Borrows",
            labelAlignment: Alignment.center,
            labelStyle: TextStyle(color: Colors.white),
            searchDecoration: const InputDecoration(
              hintText: "Search Borrows",
              alignLabelWithHint: false,
              fillColor: Colors.white,
              focusColor: Colors.white,
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
            searchStyle: TextStyle(fontSize: 17),
            onChanged: (value) {
              setState(() {
                searchText = value;
                getData(value);
              });
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 20),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Container(
                    width: 40,
                    height: 250,
                    child: _displayMedia(data[index]['foto'])),
                title: Text(data[index]['nama_peminjam'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
                subtitle: Text(
                    'Tgl Kembali : ${data[index]['tgl_kembali']} Status : ${data[index]['status']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return _alertDialogUpdate(data[index]);
                              });
                        },
                        icon: Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return _alertDialogDetail(data[index]);
                              });
                        },
                        icon: Icon(Icons.list)),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
