import 'package:dio/dio.dart';

import '../utils/logger.dart';
import '../utils/toast.dart';
import 'api.dart';
import 'api_error.dart';
import 'interceptor/app_log_interceptor.dart';

class MyHttp {
  static MyHttp? _httpDio;

  static MyHttp get instance {
    _httpDio ??= MyHttp();
    return _httpDio!;
  }

  late Dio _dio;

  MyHttp() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Api.HELLOGITHUB_API,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.addAll([
      AppLogInterceptor(),
    ]);

    // if (Platform.isIOS || Platform.isAndroid) {
    //   dio.httpClientAdapter = IOHttpClientAdapter(
    //     createHttpClient: () {
    //       final client = HttpClient();
    //       // client.findProxy = (uri) {
    //       //   return 'PROXY http://localhost:8080';
    //       // };
    //       client.badCertificateCallback =
    //           (X509Certificate cert, String host, int port) => true;
    //       return client;
    //     },
    //   );
    // }

    // dio.httpClientAdapter = IOHttpClientAdapter()
    //   ..onHttpClientCreate = (client) {
    //     client.findProxy = (uri) {
    //       return 'PROXY 10.137.105.112';
    //     };
    //     client.badCertificateCallback =
    //         (X509Certificate cert, String host, int port) => true;
    //     return client;
    //   };
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? header,
    String? baseUrl,
    bool isShowToast = true,
  }) async {
    baseUrl ??= Api.HELLOGITHUB_API;
    data ??= {};
    header ??= {};
    try {
      var result = await _dio.post(
        baseUrl + path,
        data: data,
        options: Options(
          responseType: ResponseType.json,
          headers: header,
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      if (result.data == null || result.data.isEmpty) {
        throw ApiError('服务器异常', -1);
      }
      return result.data;
    } catch (e) {
      Error.handleError(e);
    }
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? header,
    String? baseUrl,
    bool isShowToast = true,
  }) async {
    baseUrl ??= Api.HELLOGITHUB_API;
    queryParameters ??= {};
    header ??= {};
    try {
      var result = await _dio.get(
        baseUrl + path,
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.json,
          headers: header,
        ),
      );
      if (result.data == null || result.data.isEmpty) {
        throw ApiError('服务器异常', -1);
      }
      return result.data;
    } catch (e) {
      Error.handleError(e);
    }
  }
}

class Error {
  static handleError(Object e, {bool isShowErrorMessage = true}) {
    Log.d('错误->$e');
    if (e is ApiError) {
      if (isShowErrorMessage) {
        MyToast.showToast(e.message ?? '服务器异常');
      }
      return e;
    } else if (e is DioException) {
      MyToast.showToast('连接异常，请检查网络');
      return {};
    } else {
      MyToast.showToast('未知错误');
      return {};
    }
  }
}

class ApiCode {
  static const int SUCCESS = 200;
}
