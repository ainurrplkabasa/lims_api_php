import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../common/conts.dart';
import '../storages/user_local.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController ctrlUsername = TextEditingController();
  TextEditingController ctrlPassword = TextEditingController();
  final UserLocal db = UserLocal();
  File? imageFile;

  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  Future<void> login() async {
    final String apiUrl = '$BASE_URL/login.php';

    final response = await http.post(Uri.parse(apiUrl), body: {
      'username': ctrlUsername.text,
      'password': ctrlPassword.text,
    });

    print(response.body);

    final data = json.decode(response.body);

    if (data['success'] == 1) {
      await db.saveUser(data['user']);
      Navigator.pushNamedAndRemoveUntil(context, '/dasboard', (r) => false);
    } else {
      // Display an error message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message']),
        ),
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
      // getData('');
      return Fluttertoast.showToast(
        backgroundColor: Colors.green,
        textColor: Colors.white,
        msg: 'Pengguna berhasil di tambahkan',
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

  StatefulBuilder _alertDialog() {
    TextEditingController ctrlUsername = TextEditingController();
    TextEditingController ctrlPassword = TextEditingController();

    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Text('Register Pengguna Baru'),
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
              // getData('');
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(children: [
                SizedBox(
                  height: 90,
                  width: 90,
                  child: Image.asset("assets/images/tutwuri.png"),
                ),
                Center(
                  child: Text(
                    'Login LIMS',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: ctrlUsername,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan username anda';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: ctrlPassword,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        !_passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan password anda';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                //ini adalah tombol login
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        login();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll<Color>(Colors.indigo),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                //ini adalah tombol registrasi
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return _alertDialog();
                          });
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                          Color.fromARGB(255, 255, 116, 2)),
                    ),
                    child: Text(
                      'Registrasi',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),

                SizedBox(
                  height: 180,
                  width: 180,
                  child: Image.asset("assets/images/boelims.png"),
                ),

                Center(
                  child: Text(
                    'Terima Kasih Kepada : ',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ),

                Center(
                  child: Text(
                    'BBPPMPV BOE Malang (Lokasi Upskilling Reskilling)',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ),

                Center(
                  child: Text(
                    'PT. Humma Teknologi Indonesia (Lokasi Magang Industri)',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    'Peserta Diklat :',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Center(
                  child: Text(
                    'Ainur Roziqin, S.Kom (SMKS Babussalam Malang)',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
