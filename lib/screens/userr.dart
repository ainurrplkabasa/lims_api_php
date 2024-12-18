import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

import '../common/conts.dart';

class userItem extends StatefulWidget {
  const userItem({super.key});

  @override
  State<userItem> createState() => _userItemState();
}

class _userItemState extends State<userItem> {
  List data = [];
  String searchText = "";
  File? imageFile;

  @override
  void initState() {
    getData('');
    super.initState();
  }

  Future getData(String search) async {
    var response;
    var uri = Uri.parse('$BASE_URL/search_user.php');
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

  Future addData(String username, String password, File imageFile) async {
    // ignore: deprecated_member_use
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse('$BASE_URL/insert_user.php');
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile("foto", stream, length,
        filename: path.basename(imageFile.path));

    request.files.add(multipartFile);
    request.fields['username'] = username;
    request.fields['password'] = password;

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

  Future deleteData(String id) async {
    var response;
    var uri = Uri.parse('$BASE_URL/delete_user.php');
    response = await http.post(uri, body: {
      "id": id,
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
      content: Text('Apakah anda ingin menghapus ${data['username']}'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            deleteData(data['id']);
            Navigator.of(context).pop();
          },
          child: const Text('Hapus'),
        ),
      ],
    );
  }

  Widget _displayMedia(String? media) {
    print(media);
    if (media == null || media.isEmpty) {
      return Image.asset('assets/images/users.jpg');
    } else {
      return Image.network(
        '$BASE_URL/img/$media',
        // loadingBuilder: (context, child, loadingProgress) =>
        //     CircularProgressIndicator(),
        errorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/images/users.jpg'),
      );
    }
  }

  Future updateData(
      {required String id,
      required String username,
      required String password}) async {
    var response;
    var uri = Uri.parse('$BASE_URL/update_user.php');
    response = await http.post(uri, body: {
      "id": id,
      'username': username,
      'password': password,
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
    TextEditingController ctrlUsername = TextEditingController();
    TextEditingController ctrlPassword = TextEditingController();

    ctrlUsername.text = data['username'];
    //ctrlPassword.text = data['password'];

    return AlertDialog(
      title: Text('Update Data'),
      content: SingleChildScrollView(
        child: Scrollbar(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrlUsername,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  label: Text('Masukkan Username Terbaru'),
                ),
              ),
              TextField(
                controller: ctrlPassword,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  label: Text('Masukkan Password Terbaru'),
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
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            updateData(
                id: data['id'],
                username: ctrlUsername.text,
                password: ctrlPassword.text);
            Navigator.of(context).pop();
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }

  StatefulBuilder _alertDialog() {
    TextEditingController ctrlUsername = TextEditingController();
    TextEditingController ctrlPassword = TextEditingController();

    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Text('Tambah Data'),
        content: SingleChildScrollView(
          child: Scrollbar(
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              TextField(
                controller: ctrlUsername,
                decoration: const InputDecoration(
                  label: Text('Username'),
                ),
              ),
              TextField(
                controller: ctrlPassword,
                decoration: const InputDecoration(
                  label: Text('Password'),
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
              addData(ctrlUsername.text, ctrlPassword.text, imageFile!);
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
          backgroundColor: Colors.blueAccent,
          leading: BackButton(
            color: Colors.white,
          ),
          title: AnimatedSearchBar(
            label: "Search Users",
            labelAlignment: Alignment.center,
            labelStyle: TextStyle(color: Colors.white),
            searchDecoration: const InputDecoration(
              hintText: "Search Users",
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
                getData(value);
              });
            },
          ),
        ),
        body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Container(
                  width: 40,
                  height: 180,
                  child: _displayMedia(data[index]['foto'])),
              title: Text(data[index]['username'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )),
              subtitle: Text('username : ${data[index]['username']}'),
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
                              return _alertDialogDelete(data[index]);
                            });
                      },
                      icon: Icon(Icons.delete)),
                ],
              ),
            );
          },
        ));
  }
}
