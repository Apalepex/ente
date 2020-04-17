import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:myapp/core/constants.dart' as Constants;
import 'package:myapp/db/db_helper.dart';

import 'models/face.dart';
import 'models/photo.dart';
import 'models/search_result.dart';

class FaceSearchManager {
  final _logger = Logger();
  final _dio = Dio();

  FaceSearchManager._privateConstructor();
  static final FaceSearchManager instance =
      FaceSearchManager._privateConstructor();

  Future<List<Face>> getFaces() {
    return _dio
        .get(Constants.ENDPOINT + "/faces",
            queryParameters: {"user": Constants.USER})
        .then((response) => (response.data["faces"] as List)
            .map((face) => new Face.fromJson(face))
            .toList())
        .catchError(_onError);
  }

  Future<List<Photo>> getFaceSearchResults(Face face) async {
    var futures = _dio.get(
        Constants.ENDPOINT + "/search/face/" + face.faceID.toString(),
        queryParameters: {"user": Constants.USER}).then((response) => (response
            .data["results"] as List)
        .map((result) => (DatabaseHelper.instance.getPhotoByPath(result))));
    return Future.wait(await futures);
  }

  void _onError(error) {
    _logger.e(error);
  }
}
