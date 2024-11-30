import 'package:dio/dio.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:ticket_app/core/api/app_faild.dart';
import 'package:ticket_app/core/api/base_response.dart';
import 'package:ticket_app/core/const/logger.dart';
import 'package:ticket_app/core/const/net_work_info.dart';

class ApiCommon {
  static final Dio _dio = Dio();

  static Future<BaseResponse> get({
    required String url,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    CancelToken cancelToken = CancelToken();

    try {
      bool isConnected = await NetWorkInfo.isConnectedToInternet();
      if (!isConnected) {
        return BaseResponse(
          error: AppFailure(message: 'Không có kết nối Internet'),
        );
      }

      Map<String, dynamic> headersDefauld = {
        "Content-Type": "application/json",
      };

      final response = await _dio.get(
        url,
        options: Options(
          headers: headers ?? headersDefauld,
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
        cancelToken: cancelToken,
        queryParameters: queryParameters,
      );

      if (response.data['data'] != null) {
        return BaseResponse(data: response.data['data']);
      } else {
        return BaseResponse(error: response.data['message']);
      }
    } on DioException catch (dioError) {
      dioError.error.printError();
      debugLog("DioError: ${dioError.message}");

      if (dioError.type == DioExceptionType.connectionTimeout ||
          dioError.type == DioExceptionType.receiveTimeout ||
          dioError.type == DioExceptionType.sendTimeout) {
        if (!cancelToken.isCancelled) {
          cancelToken.cancel();
        }
        return BaseResponse(
          error: AppFailure(
              message: "Kết nói quá hạn, vui lòng kiểm tra lại đường truyền"),
        );
      }

      return BaseResponse(
        error: AppFailure(message: "Đã có lỗi xảy ra vui lòng thử lại"),
      );
    } catch (e) {
      if (!cancelToken.isCancelled) {
        cancelToken.cancel();
      }

      debugLog("error: ${e.toString()}");

      return BaseResponse(
        error: AppFailure(message: "Đã có lỗi xảy ra vui lòng thử lại"),
      );
    }
  }

  static Future<BaseResponse> post(
      {required String url,
      required Map<String, dynamic> data,
      Map<String, dynamic>? headers,
      Map<String, dynamic>? queryParameters}) async {
    CancelToken cancelToken = CancelToken();

    try {
      bool isConnected = await NetWorkInfo.isConnectedToInternet();
      if (!isConnected) {
        return BaseResponse(
            error: AppFailure(message: 'Không có kết nối Internet'));
      }

      Map<String, dynamic> headersDefauld = {
        "Content-Type": "application/json",
      };

      final response = await _dio.post(
        url,
        data: data,
        options: Options(
          headers: headers ?? headersDefauld,
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
        cancelToken: cancelToken,
        queryParameters: queryParameters,
      );

      if (response.data['data'] != null) {
        return BaseResponse(data: response.data['data']);
      } else {
        return BaseResponse(
          error: AppFailure(
            message: response.data['message'],
          ),
        );
      }
    } on DioException catch (dioError) {
      debugLog("DioError: ${dioError.message}");

      if (dioError.type == DioExceptionType.connectionTimeout ||
          dioError.type == DioExceptionType.receiveTimeout ||
          dioError.type == DioExceptionType.sendTimeout) {
        if (!cancelToken.isCancelled) {
          cancelToken.cancel();
        }
        return BaseResponse(
          error: AppFailure(
              message: "Kết nói quá hạn, vui lòng kiểm tra lại đường truyền"),
        );
      }

      return BaseResponse(
        error: AppFailure(message: "Đã có lỗi xảy ra vui lòng thử lại"),
      );
    } catch (e) {
      if (!cancelToken.isCancelled) {
        cancelToken.cancel();
      }

      debugLog("error: ${e.toString()}");

      return BaseResponse(
        error: AppFailure(message: "Đã có lỗi xảy ra vui lòng thử lại"),
      );
    }
  }
}
