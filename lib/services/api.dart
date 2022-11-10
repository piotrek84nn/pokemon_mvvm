import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pokemon/core/helpers/extension.dart';
import 'package:pokemon/core/model/pokemon_model.dart';

class Api {
  _ApiClient? _client;
  final _endpoint = 'pokeapi.co';
  static Api initApi() {
    return Api._();
  }

  Api._() {
    _client = _ApiClient();
  }

  Future<Pokemon?> searchPokemonByName(String name) async {
    Pokemon? pokemonResponse;
    Uri url = Uri.https(_endpoint, '/api/v2/pokemon/${name.toLowerCase()}');
    var response = await _client!.get(url);
    if (response.statusCode == 200) {
      pokemonResponse = Pokemon.fromMap(json.decode(response.body));
    }
    return pokemonResponse;
  }
}

class _ApiClient {
  final Client _client = Client();

  void close() {
    _client.close();
  }

  Future<Response> parseServerResponse(Response response,
      {BuildContext? context}) async {
    if (context != null) {
      if (response.statusCode >= 500) {
        String body = 'Internal Server Error';
        if (!response.body.isNullOrEmpty()) {
          body += ':\\n\\n${response.body}';
        }
        return Response(body, response.statusCode);
      }
    }
    return response;
  }

  Future<Map<String, String>> prepareHeaders() async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    return headers;
  }

  Future<Response> get(Uri url, {BuildContext? context}) async {
    Response response = await _client.get(url, headers: await prepareHeaders());

    printRequest(url: url, type: "GET", response: response);
    return await parseServerResponse(response, context: context);
  }

  Future<Response> post(Uri url,
      {Object? body, Encoding? encoding, BuildContext? context}) async {
    Response response = await _client.post(url,
        headers: await prepareHeaders(), body: body, encoding: encoding);

    printRequest(url: url, type: 'POST', body: body, response: response);
    return await parseServerResponse(response, context: context);
  }

  Future<Response> put(Uri url,
      {Object? body, Encoding? encoding, BuildContext? context}) async {
    Response response = await _client.put(url,
        headers: await prepareHeaders(), body: body, encoding: encoding);

    printRequest(url: url, type: 'PUT', body: body, response: response);
    return await parseServerResponse(response, context: context);
  }

  Future<Response> delete(Uri url,
      {Object? body, Encoding? encoding, BuildContext? context}) async {
    Response response = await _client.delete(url,
        headers: await prepareHeaders(), encoding: encoding, body: body);

    printRequest(url: url, type: "DELETE", response: response);
    return await parseServerResponse(response, context: context);
  }

  printRequest(
      {required Uri url,
      required String type,
      required Response response,
      Object? body}) {
    StringBuffer sb = StringBuffer();
    sb.write('************** HTTPS REQUEST **************\n');
    sb.write('Type: $type\n');
    sb.write('Request: $url\n');
    body.isNullOrEmpty() != true
        ? sb.write('BODY: ${body.toString()}\n')
        : sb.write('BODY: \n');
    sb.write('\n');

    sb.write('************** HTTPS RESPONSE **************\n');
    sb.write('Status code: ${response.statusCode}\n');
    sb.write('Body: ${response.body}\n');
    sb.write('\n\n');
    debugPrint(sb.toString(), wrapWidth: 1024);
  }
}
