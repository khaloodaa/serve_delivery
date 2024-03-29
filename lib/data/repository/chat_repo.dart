import 'dart:async';
import 'package:efood_multivendor_driver/data/api/api_client.dart';
import 'package:efood_multivendor_driver/helper/user_type.dart';
import 'package:efood_multivendor_driver/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ChatRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  ChatRepo({required this.apiClient, required this.sharedPreferences});

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }
  Future<Response> getConversationList(int offset) async {
    return await apiClient.getData('${AppConstants.getConversationListUri}?token=${getUserToken()}&offset=$offset&limit=10');
  }

  Future<Response> searchConversationList(String name) async {
    return apiClient.getData('${AppConstants.searchConversationListUri}?name=$name&token=${getUserToken()}&limit=20&offset=1');
  }

  Future<Response> getMessages(int offset, int? userId, UserType userType, int? conversationID) async {
    return await apiClient.getData('${AppConstants.getMessageListUri}?${conversationID != null ?
    'conversation_id' : userType == UserType.user ? 'user_id' : 'vendor_id'}=${conversationID ?? userId}&token=${getUserToken()}&offset=$offset&limit=10');
  }

  Future<Response> sendMessage(String message, List<MultipartBody> file, int? conversationId, int? userId, UserType userType) async {
    return apiClient.postMultipartData(
        AppConstants.sendMessageUri,
        {'message': message, 'receiver_type': userType.name,  conversationId != null ? 'conversation_id' : 'receiver_id': '${conversationId ?? userId}', 'token': getUserToken(), 'offset': '1', 'limit': '10'},
        file, [],
    );
  }

}
