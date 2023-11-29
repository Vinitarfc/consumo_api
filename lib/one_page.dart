// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:consumo_api/widgets/custom_button_widget.dart';

class OnePage extends StatefulWidget {
  const OnePage({Key? key}) : super(key: key);

  @override
  State<OnePage> createState() => _OnePageState();
}

class _OnePageState extends State<OnePage> {
  ValueNotifier<List<Post>> posts = ValueNotifier<List<Post>>([]);

  callAPI() async {
    var client = http.Client();
    var url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    try {
      var response = await client.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as List;
        posts.value = jsonResponse.map((e) => Post.fromJson(e)).toList();
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('reconstruindo');
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder<List<Post>>(
                valueListenable: posts,
                builder: (_, value, __) => ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: value.length,
                  itemBuilder: (_, idx) => ListTile(
                    title: Text(value[idx].title),
                  ),
                ),
              ),
              SizedBox(height: 10),
              CustomButtonWidget(
                disable: false,
                onPressed: () => callAPI(),
                title: 'Gerar lista',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post(this.userId, this.id, this.title, this.body);

  factory Post.fromJson(Map json) {
    return Post(
      json['userId'],
      json['id'],
      json['title'],
      json['body'],
    );
  }

  @override
  String toString() {
    return 'Post(userId: $userId, id: $id, title: $title, body: $body)';
  }
}
