import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: const DogAPI());
  }
}

class DogAPI extends StatefulWidget {
  const DogAPI({super.key});

  @override
  State<DogAPI> createState() => _DogAPIState();
}

class _DogAPIState extends State<DogAPI> {
  String? imageUrl;
  bool isLoading = false;
  String? selected;

  static const String link = "https://dog.ceo/api/";

  List<String> breeds = [];

  Future<dynamic> getDataFromAPI(String url) async {
    setState(() => isLoading = true);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('response err');
    }
  }

  Future<void> getAllBreeds() async {
    const String suffix = "breeds/list/all";
    setState(() => isLoading = true);

    try {
      final data = await getDataFromAPI('$link$suffix');
      setState(() {
        breeds = [];
        List<String> keys = (data['message'] as Map<String, dynamic>).keys
            .toList();
        for (String key in keys) {
          if (data['message'][key].length == 0) {
            breeds.add(key);
          } else {
            for (String breed in data['message'][key]) {
              breeds.add("$breed $key");
            }
          }
        }
        breeds.sort();
      });
    } catch (e) {
      debugPrint('Load-ERR: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchDogImage() async {
    String suffix = "";
    if (selected == null) {
      suffix = "breeds/image/random";
    } else {
      suffix = "breed/";
      if (selected!.contains(' ')) {
        final words = selected!.split(' ');
        suffix = '$suffix${words[1]}/${words[0]}';
      } else {
        suffix = '$suffix$selected';
      }
      suffix = '$suffix/images/random';
    }

    //print("link = $link$suffix");
    setState(() {
      isLoading = true;
      imageUrl = null;
    });

    try {
      final data = await getDataFromAPI('$link$suffix');
      setState(() {
        imageUrl = data['message'];
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Pic-load-ERR: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getAllBreeds();
    fetchDogImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dog API App')),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              DropdownButton<String>(
                value: selected,
                hint: const Text('All breeds'),
                onChanged: (value) => setState(() {
                  selected = value;
                  fetchDogImage();
                  //print("selected = $selected");
                }),
                items: breeds
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
              ),

              FilledButton.icon(
                onPressed: () {
                  fetchDogImage();
                },
                icon: const Icon(Icons.refresh),
                label: Text("new rnd image"),
              ),

              Expanded(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : imageUrl != null
                    ? Image.network(imageUrl!)
                    : Image.network(
                        'https://www.jusel.com/upload/thumb/mala_729x.jpg',
                        //'https://images.template.net/528959/Scrapbook-Dog-Lost-Blank-Poster-Template-edit-online.png',
                      ),
                //: Image.network('https://dog.ceo/img/dog-api-logo.svg'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
