import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:quotes_app/constant.dart';
import 'package:quotes_app/quotes.dart';
import 'package:http/http.dart' as http;

class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  List? imagelist;
  int? imagenumber = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImagesFromunsplash();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
      children: [
        AnimatedSwitcher(
          duration: Duration(seconds: 1),
          child: BlurHash(
            hash: imagelist![imagenumber!]['blur_hash'],
            duration: Duration(microseconds: 500),
            image: imagelist![imagenumber!]['urls']['regular'],
            curve: Curves.easeInOut,
            imageFit: BoxFit.cover,
          ),
        ),
        Container(
          width: width,
          height: height,
          child: SafeArea(
            child: CarouselSlider.builder(
                itemCount: quotesList.length,
                itemBuilder: (context, index1, index2) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          quotesList[index1][kQuote],
                          style: kQuoteTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '-${quotesList[index1][kAuthor]}-',
                        style: kAuthortextstyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
                options: CarouselOptions(
                    scrollDirection: Axis.vertical,
                    pageSnapping: true,
                    initialPage: 0,
                    enlargeCenterPage: true,
                    onPageChanged: (index, value) {
                      HapticFeedback.lightImpact();
                      imagenumber = index;
                      setState(() {});
                    })),
          ),
        )
      ],
    ));
  }

  Future<void> getImagesFromunsplash() async {
    var url =
        'https://api.unsplash.com/search/photos?per_page=30&query=nature&order_by=relevant&client_id=$accesskey';
    var uri = Uri.parse(url);
    var response = await http.get(uri);
    print(response.statusCode);
    var unsplashdata = json.decode(response.body);
    imagelist = unsplashdata['results'];
    setState(() {});
    print(unsplashdata);
  }
}
