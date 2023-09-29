import 'package:flutter/material.dart';

class KotakWidget extends StatelessWidget {
  const KotakWidget({
    super.key,
    required this.warna,
    required this.isi,
    required this.warnatul,
    required this.image,
  });

  final Color warna;
  final String isi;
  final Color warnatul;
  final Image image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 150,
      color: warna,
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          image,
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              isi,
              style: TextStyle(fontSize: 16, color: warnatul),
            ),
          )
        ],
      ),
    );
  }
}
