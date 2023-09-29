import 'package:flutter/material.dart';

import '../storages/user_local.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserLocal db = UserLocal();
    print(db.getUser);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/login logo.png",
                width: 150,
                height: 150,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 1, bottom: 1),
                child: Text(
                  "Library Inventory Managemen System",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  "Welcome : ${db.getUser?['username']}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/mainmenu');
                      },
                      child: Container(
                        height: 205,
                        width: 120,
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: AssetImage(
                                "assets/images/gambar peminjaman.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Center(
                              child: Text(
                                "Borrows",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 12, 12, 12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/menuitem');
                      },
                      child: Container(
                        height: 205,
                        width: 120,
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/gambar item.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Center(
                              child: Text(
                                "Items",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 12, 12, 12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/userr');
                      },
                      child: Container(
                        height: 205,
                        width: 120,
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/users.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Center(
                              child: Text(
                                "Users",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 12, 12, 12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context, '/userr');
                    },
                    child: Container(
                      height: 205,
                      width: 120,
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 207, 208, 209),
                        borderRadius: BorderRadius.circular(8),
                        // image: const DecorationImage(
                        //   image: AssetImage("assets/images/tut wuri.png"),
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Center(
                            child: Text(
                              "Laporan",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 12, 12, 12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context, '/userr');
                    },
                    child: Container(
                      height: 205,
                      width: 120,
                      margin: const EdgeInsets.all(2),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 207, 208, 209),
                        borderRadius: BorderRadius.circular(8),
                        // image: const DecorationImage(
                        //   image: AssetImage("assets/images/boe malang.png"),
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Center(
                            child: Text(
                              "Abouts",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 12, 12, 12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context, '/userr');
                    },
                    child: Container(
                      height: 205,
                      width: 120,
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 207, 208, 209),
                        borderRadius: BorderRadius.circular(8),
                        // image: const DecorationImage(
                        //   image: AssetImage("assets/images/tut wuri.png"),
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Center(
                            child: Text(
                              "Abouts 3",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 12, 12, 12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(60.0),
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    await db.logout();

                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (r) => false);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromARGB(255, 247, 59, 2)),
                  ),
                  child: Text(
                    'LogOut',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
