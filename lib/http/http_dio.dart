
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

  /// Get请求，返回Map
  /// * [path] 请求链接
  /// * [cancel] 任务取消Token
  /// * [queryParameters] 请求参数
  /// * [header] 请求头
  /// * [withApiAuth] 是否需要API认证
  /// * [withUserAuth] 是否需要用户认证
  /// * [isRetry] 是否重试
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
    if (withUserAuth) {
      //TODO
    }
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
          extra: {
            "withApiAuth": withApiAuth,
            "withUserAuth": withUserAuth,
          },
        ),
        cancelToken: cancel,
      );
      return result.data;
    } catch (e) {
      return {};
    }
  }

  /// Post请求，返回Map
  /// * [path] 请求链接
  /// * [cancel] 任务取消Token
  /// * [data] 内容
  /// * [header] 请求头
  /// * [withApiAuth] 是否需要API认证
  /// * [withUserAuth] 是否需要用户认证
  /// * [isRetry] 是否重试
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
      Log.d("登录接口..");
      if (withUserAuth) {
        //TODO
      }
      header ??= {};

      var result = await dio.post(
        baseUrl + path,
        data: data,
        options: Options(
          responseType: responseType,
          headers: header,
          extra: {
            "withApiAuth": withApiAuth,
            "withUserAuth": withUserAuth,
          },
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
