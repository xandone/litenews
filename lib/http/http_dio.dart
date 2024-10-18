
import 'package:dio/dio.dart';

import '../utils/logger.dart';
import 'api.dart';
import 'interceptor/app_log_interceptor.dart';

class MyHttp {
  static MyHttp? _httpUtil;

  static MyHttp get instance {
    _httpUtil ??= MyHttp();
    return _httpUtil!;
  }

  late Dio dio;

  MyHttp() {
    dio = Dio(
      BaseOptions(
        baseUrl: Api.HELLOGITHUB_API,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
      ),
    );

    dio.interceptors.addAll([
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

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? header,
    String? baseUrl,
    CancelToken? cancel,
    bool withApiAuth = false,
    bool withUserAuth = false,
    bool isRetry = false,
    ResponseType responseType = ResponseType.json,
  }) async {
    baseUrl ??= Api.HELLOGITHUB_API;
    queryParameters ??= {};
    try {
      header ??= {};
      var result = await dio.get(
        baseUrl + path,
        queryParameters: queryParameters,
        options: Options(
          responseType: responseType,
          headers: header,
        ),
        cancelToken: cancel,
      );
      return result.data;
    } catch (e) {
      return {};
    }
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? header,
    String? baseUrl,
    CancelToken? cancel,
    bool withApiAuth = false,
    bool withUserAuth = false,
    bool isRetry = false,
    bool formUrlEncoded = false,
    bool isShowToast = true,
    ResponseType responseType = ResponseType.json,
  }) async {
    baseUrl ??= Api.HELLOGITHUB_API;
    data ??= {};
    try {
      header ??= {};

      var result = await dio.post(
        baseUrl + path,
        data: data,
        options: Options(
          responseType: responseType,
          headers: header,
          contentType: formUrlEncoded
              ? Headers.formUrlEncodedContentType
              : Headers.formUrlEncodedContentType,
        ),
        cancelToken: cancel,
      );
      return result.data;
    } catch (e) {
      if (e is DioException) {
        Log.d('错误->${e}');
      }
      return {};
    }
  }
}
