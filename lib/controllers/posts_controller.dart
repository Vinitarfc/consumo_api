import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:consumo_api/models/posts_model.dart';
import 'package:flutter/material.dart';

class PostsController {
  ValueNotifier<List<Post>> posts = ValueNotifier<List<Post>>([]);
  ValueNotifier<bool> inLoader = ValueNotifier<bool>(false);

  callAPI() async {
    var client = http.Client();
    var url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    try {
      inLoader.value = true;
      var response = await client.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as List;
        posts.value = jsonResponse.map((e) => Post.fromJson(e)).toList();
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
      //Abaixo é só para ver o funcionamento do "Loader"
      await Future.delayed(Duration(seconds: 3));
    } finally {
      client.close();
      inLoader.value = false;
    }
  }
}
