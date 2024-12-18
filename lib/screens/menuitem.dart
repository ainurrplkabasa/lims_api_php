import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_app/common/conts.dart';
import 'package:login_app/screens/qrcodepage.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:login_app/components/date_input.dart';

class MenuItem extends StatefulWidget {
  const MenuItem({super.key});

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  List data = [];
  String searchText = "";
  File? imageFile;

  @override
  void initState() {
    getData('');
    getData2('');
    super.initState();
  }

  Future getData(String? search) async {
    var uri = Uri.parse('$BASE_URL/search_item.php?kd=$search');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      print('Response : ${response.body}');
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

  Future getData2(String search) async {
    var response;
    var uri = Uri.parse('$BASE_URL/search_text_item.php');
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
      String namaItem,
      String spesifikasi,
      String merk,
      int tahunAnggaran,
      String sumberDana,
      String keterangan,
      int jumlah,
      DateTime tglPengadaan,
      File imageFile) async {
    // ignore: deprecated_member_use
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse('$BASE_URL/insert_item.php');
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile("image", stream, length,
        filename: path.basename(imageFile.path));

    request.files.add(multipartFile);
    request.fields['nama_item'] = namaItem;
    request.fields['spesifikasi'] = spesifikasi;
    request.fields['merk'] = merk;
    request.fields['tahun_anggaran'] = tahunAnggaran.toString();
    request.fields['sumber_dana'] = sumberDana;
    request.fields['keterangan'] = keterangan;
    request.fields['jumlah'] = jumlah.toString();
    request.fields['tgl_pengadaan'] = tglPengadaan.toString();

    var response = await request.send();

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

  Future deleteData(String kditem) async {
    var response;
    var uri = Uri.parse('$BASE_URL/delete_item.php');
    response = await http.post(uri, body: {
      "kd_item": kditem,
    });

    if (response.statusCode == 200) {
      getData('');
      return Fluttertoast.showToast(
        backgroundColor: Colors.green,
        textColor: Colors.white,
        msg: 'Data Berhasil Dihapus',
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

  AlertDialog _alertDialogDelete(Map<String, dynamic> data) {
    return AlertDialog(
      title: Text('Delete Data'),
      content: Text('Apakah anda ingin menghapus ${data['nama_item']}'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            deleteData(data['kd_item']);
            Navigator.of(context).pop();
          },
          child: const Text('Hapus'),
        ),
      ],
    );
  }

  Widget _displayMedia(String? media) {
    if (media == null || media == '') {
      return Image.asset('assets/images/icon item.png');
    } else {
      return Image.network('$BASE_URL/img/$media');
    }
  }

  Future updateData(
      String kditem,
      String namaitem,
      String spesifikasi,
      String merk,
      int tahunanggaran,
      String sumberdana,
      String keterangan,
      int jumlah,
      DateTime tglPengadaan) async {
    var response;
    var uri = Uri.parse('$BASE_URL/update_item.php');
    response = await http.post(uri, body: {
      "kd_item": kditem,
      "nama_item": namaitem,
      "spesifikasi": spesifikasi,
      "merk": merk,
      "tahun_anggaran": tahunanggaran.toString(),
      "sumber_dana": sumberdana,
      "keterangan": keterangan,
      "jumlah": jumlah.toString(),
      "tgl_pengadaan": tglPengadaan.toString(),
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

  AlertDialog _alertDialogUpdate(Map<String, dynamic> data) {
    TextEditingController ctrlNamaitem = TextEditingController();
    TextEditingController ctrlSpesifikasi = TextEditingController();
    TextEditingController ctrlMerk = TextEditingController();
    TextEditingController ctrlTahunanggaran = TextEditingController();
    TextEditingController ctrlSumberdana = TextEditingController();
    TextEditingController ctrlKeterangan = TextEditingController();
    TextEditingController ctrlJumlah = TextEditingController();
    TextEditingController ctrlTglpengadaan = TextEditingController();

    ctrlNamaitem.text = data['nama_item'];
    ctrlSpesifikasi.text = data['spesifikasi'];
    ctrlMerk.text = data['merk'];
    ctrlTahunanggaran.text = data['tahun_anggaran'];
    ctrlSumberdana.text = data['sumber_dana'];
    ctrlKeterangan.text = data['keterangan'];
    ctrlJumlah.text = data['jumlah'];
    ctrlTglpengadaan.text = data['tgl_pengadaan'];

    return AlertDialog(
      title: Text('Update Data'),
      content: SingleChildScrollView(
        child: Scrollbar(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrlNamaitem,
                // enabled: false,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  label: Text('Nama Item'),
                ),
              ),
              TextField(
                controller: ctrlSpesifikasi,
                // enabled: false,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  label: Text('Spesifikasi'),
                ),
              ),
              TextField(
                controller: ctrlMerk,
                // enabled: false,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  label: Text('Merk'),
                ),
              ),
              TextField(
                controller: ctrlTahunanggaran,
                // enabled: false,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text('Tahun Anggaran'),
                ),
              ),
              TextField(
                controller: ctrlSumberdana,
                keyboardType: TextInputType.text,
                // enabled: false,
                decoration: const InputDecoration(
                  label: Text('Sumber Dana'),
                ),
              ),
              TextField(
                controller: ctrlKeterangan,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  label: Text('Keterangan'),
                ),
              ),
              TextField(
                controller: ctrlJumlah,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text('Jumlah'),
                ),
              ),
              DateInput(controller: ctrlTglpengadaan, hint: 'Tgl Pengandaan'),
            ],
          ),
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
            updateData(
                data['kd_item'],
                ctrlNamaitem.text,
                ctrlSpesifikasi.text,
                ctrlMerk.text,
                int.parse(ctrlTahunanggaran.text),
                ctrlSumberdana.text,
                ctrlKeterangan.text,
                int.parse(ctrlJumlah.text),
                DateTime.parse(ctrlTglpengadaan.text));

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

    TextEditingController ctrlNamaitem = TextEditingController();
    TextEditingController ctrlSpesifikasi = TextEditingController();
    TextEditingController ctrlMerk = TextEditingController();
    TextEditingController ctrlTahunanggaran = TextEditingController();
    TextEditingController ctrlSumberdana = TextEditingController();
    TextEditingController ctrlKeterangan = TextEditingController();
    TextEditingController ctrlJumlah = TextEditingController();
    TextEditingController ctrlPengadaan =
        TextEditingController(text: formattedDate.toString());

    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Text('Tambah Data'),
        content: SingleChildScrollView(
          child: Scrollbar(
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              TextField(
                controller: ctrlNamaitem,
                decoration: const InputDecoration(
                  label: Text('Nama Item'),
                ),
              ),
              TextField(
                controller: ctrlSpesifikasi,
                decoration: const InputDecoration(
                  label: Text('Spesifikasi'),
                ),
              ),
              TextField(
                controller: ctrlMerk,
                decoration: const InputDecoration(
                  label: Text('Merk'),
                ),
              ),
              TextField(
                controller: ctrlTahunanggaran,
                decoration: const InputDecoration(
                  label: Text('Tahun Anggaran'),
                ),
              ),
              TextField(
                controller: ctrlSumberdana,
                decoration: const InputDecoration(
                  label: Text('Sumber Dana'),
                ),
              ),
              TextField(
                controller: ctrlKeterangan,
                decoration: const InputDecoration(
                  label: Text('Keterangan'),
                ),
              ),
              TextField(
                controller: ctrlJumlah,
                decoration: const InputDecoration(
                  label: Text('Jumlah'),
                ),
              ),
              DateInput(controller: ctrlPengadaan, hint: 'Tgl Pengadaan'),
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
                ],
              ),
              SizedBox(
                height: 20,
              ),
              imageFile == null
                  ? Container()
                  : SizedBox(
                      height: 250,
                      width: 350,
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
                  ctrlNamaitem.text,
                  ctrlSpesifikasi.text,
                  ctrlMerk.text,
                  int.parse(ctrlTahunanggaran.text),
                  ctrlSumberdana.text,
                  ctrlKeterangan.text,
                  int.parse(ctrlJumlah.text),
                  DateTime.parse(ctrlPengadaan.text),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return _alertDialog();
              });
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: BackButton(
          color: Colors.white,
        ),
        title: AnimatedSearchBar(
          label: "Search Items",
          labelAlignment: Alignment.center,
          labelStyle: TextStyle(color: Colors.white),
          searchDecoration: const InputDecoration(
            hintText: "Search Item",
            alignLabelWithHint: true,
            fillColor: Colors.white,
            focusColor: Colors.white,
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          searchStyle: TextStyle(fontSize: 17),
          onChanged: (value) {
            setState(() {
              searchText = value;
              getData2(value);
            });
          },
        ),
        actions: [
          InkWell(
            onTap: () async {
              var result = await BarcodeScanner.scan();
              print('Here : ${result.rawContent}');
              await getData(result.rawContent);
            },
            child: Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => QrCodePage(
                    qrData: data[index]['kd_item'],
                  ),
                ),
              );
            },
            leading: Container(
                width: 50,
                height: 50,
                child: _displayMedia(data[index]['gambar'])),
            title: Text(
              data[index]['nama_item'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
                'Spesifikasi : ${data[index]['spesifikasi']} Jumlah : ${data[index]['jumlah']}'),
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
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return _alertDialogDelete(data[index]);
                        });
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
