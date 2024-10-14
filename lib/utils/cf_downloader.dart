import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

Future<int> getFileSize(String url, String token) async {
  http.Response res = await http
      .head(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
  if (!res.headers.containsKey('content-length')) {
    throw Exception('File size could not be determined');
  }
  return int.parse(res.headers['content-length']!);
}

Future<void> downloadFile(String url, String token, File file,
    {int? fileSize}) async {
  int? size;
  try {
    size = fileSize ?? await getFileSize(url, token);
  } catch (_) {}
  if (size == null) {
    debugPrint("Unable to get file size, trying direct download $url");
    return await _directDownloadFile(url, token, file);
  } else {
    debugPrint("file size $size, trying parallel download");
    return await _parallelDownloadFile(url, token, file, size);
  }
}

Future<void> _directDownloadFile(String url, String token, File file) async {
  http.Client client = http.Client();
  http.Response res = await client
      .get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
  await _writeToFile(file, res.bodyBytes);
}

Future<void> _parallelDownloadFile(
    String url, String token, File file, int fileSize) async {
  int downloaded = 0;

  onPartDownloaded(int partSize) {
    downloaded += partSize;
    debugPrint('Downloaded CF ${((downloaded / fileSize) * 100).round()}%');
  }

  // print(size);

  List<String> ranges = _getRanges(fileSize);

  // print(ranges);

  List<Uint8List> parts =
      List.generate(ranges.length, ((index) => Uint8List(0)));

  http.Client client = http.Client();

  await Future.wait(
      ranges.mapIndexed((index, element) => _downloadPart(
          client, url, element, parts, index, onPartDownloaded, token)),
      eagerError: true);

  List<int> concatenated = [];

  for (var element in parts) {
    concatenated.addAll(element);
  }

  // print(concatenated.length);

  await _writeToFile(file, concatenated);
}

_writeToFile(File file, List<int> bytes) async {
  await file.writeAsBytes(bytes);
}

_downloadPart(
    http.Client client,
    String url,
    String range,
    List<Uint8List> partsArray,
    int index,
    Function onPartDownloaded,
    String token) async {
  // print('$index -> $range');

  http.Response res = await client.get(Uri.parse(url),
      headers: {'Range': 'bytes=$range', 'Authorization': 'Bearer $token'});

  // print('$index -> ${res.bodyBytes.length}');

  onPartDownloaded(res.bodyBytes.length);

  partsArray[index] = res.bodyBytes;
}

_getRanges(size) {
  int partSize = 1024 * 1024;

  int index = 0;

  List<String> ranges = [];

  while ((index + partSize) < size) {
    ranges.add('$index-${index + partSize - 1}');

    index += partSize;
  }

  ranges.add('$index-${(size - 1)}');

  return ranges;
}
