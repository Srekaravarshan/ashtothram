import 'package:ashtothram/datas/ashtothrams.dart';
import 'package:ashtothram/datas/parayanams.dart';
import 'package:ashtothram/pages/ashtothram_page.dart';
import 'package:ashtothram/pages/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

SizedBox vSpace(double size) {
  return SizedBox(height: size);
}

SizedBox hSpace(double size) {
  return SizedBox(width: size);
}

Widget listCollection({
  required List<Map> list,
  bool isParayanam = false,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          const BoxShadow(
              color: Color.fromRGBO(50, 50, 93, 0.25),
              offset: Offset(0, 25),
              blurRadius: 50,
              spreadRadius: -10),
          // BoxShadow(
          //     color: Colors.black.withOpacity(0.3),
          //     offset: Offset(0, 15),
          //     blurRadius: 30,
          //     spreadRadius: -15)
          // ],
          // border: Border.all(
          //     color: dark ? Colors.transparent : Colors.black12, width: 1),
          // gradient: LinearGradient(
          //   colors: [Color(scolor), Color(lcolor)],
          //   begin: const Alignment(-1.0, -1),
          //   end: const Alignment(1.0, 1),
          // ),
        ],
        color: Colors.white),
    child: ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: list.length,
      // separatorBuilder: (context, index) => const Divider(height: 0),
      itemBuilder: (context, index) {
        Ashtothram? manthra = isParayanam
            ? parayanams[list[index]['id']]
            : astothrams[list[index]['id']];
        return mListTile(manthra?.title, manthra?.id, context,
            isParayanam: isParayanam);
      },
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    ),
  );
}

ListTile mListTile(String? title, String? id, BuildContext context,
    {bool isParayanam = false}) {
  return ListTile(
      onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              Ashtothram manthra = (isParayanam
                      ? parayanams[id]
                      : astothrams[id]) ??
                  Ashtothram('Error', 'error', '$id is not in the database');
              bool isPdf = manthra.isPdf;
              if (isPdf) {
                return PDFViewer();
              } else {
                return AshtothramPage(
                    id: id ?? '', isParayanam: isParayanam, manthra: manthra);
              }
            },
          )),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      title: Text(
        title ?? '',
        style: TextStyle(
            color: Colors.black, fontSize: 17, fontFamily: 'TiroTamil'),
      ),
      leading: tileLeading(id));
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

Future<AssetImage> buildImage(String? title) async {
  if (title == null) return const AssetImage('assets/images/null.webp');
  ByteData bytes;
  try {
    bytes = await rootBundle.load('assets/images/gods/$title.jpeg');
    return AssetImage('assets/images/gods/$title.jpeg');
  } catch (_) {
    return const AssetImage('assets/images/null.webp');
  }
}

Widget tileLeading(String? id) {
  return FutureBuilder<AssetImage>(
      future: buildImage(id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/null.webp'));
        }
        return CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: snapshot.data,
          radius: 35,
        );
      });
}

// Widget circleAvatar