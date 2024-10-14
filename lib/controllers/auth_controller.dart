import 'package:ema_v4/constants/preferences.dart';
import 'package:ema_v4/controllers/app_controller.dart';
import 'package:ema_v4/models/api/request/login.dart';
import 'package:ema_v4/models/api/response/tokens.dart';
import 'package:ema_v4/services/apiService.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/ui/durations.dart';
import '../models/api/request/invitation.dart';
import '../pages/login/login_screen.dart';
class AuthController extends GetxController{
  AuthController(PendingDynamicLinkData? initialLink){
    if(initialLink!=null){
      _handleDynamicLink(initialLink);
    }
  }
  final RxnString accessToken=RxnString();
  final RxnString _refreshToken=RxnString();
  late final SharedPreferences _prefs;
  final RxnString autoInviteCode = RxnString();

  @override
  Future<void> onInit() async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      _handleDynamicLink(dynamicLinkData);
    }).onError((error) {
      // Handle errors
    });
    _prefs = await SharedPreferences.getInstance();
    _refreshToken.value = _prefs.getString(PreferenceKey.refreshToken);
    accessToken.value = _prefs.getString(PreferenceKey.accessToken);
    Future.delayed(splashScreenDelayDuration,(){
      if(accessToken.value!=null&&_refreshToken.value!=null){
        refreshTokens();
      }else{
        Get.offAllNamed(LoginPage.routeName);
      }
    });
    super.onInit();
  }

  Future<void> login({required String nhsId,required String password}) async {
    TokenResponse? response = await ApiService().login(LoginRequest(nhsId: nhsId, password: password));
    if(response!=null){
      await _handleTokenResponse(response);
    }
  }
  Future<void> acceptInvite({required String nhsId,required String password,required String inviteCode}) async {
    debugPrint("accepting ${inviteCode}");
    TokenResponse? response = await ApiService().acceptInvite(AcceptInviteRequest(nhsId: nhsId, password: password),inviteCode);
    if(response!=null){
      await _handleTokenResponse(response);
    }
  }
  Future<bool> refreshTokens() async {
    TokenResponse? response = await ApiService().refreshTokens(_refreshToken.value!);
    if(response!=null){
      _handleTokenResponse(response);
      return true;
    }else{
      logout();
      return false;
    }
  }
  _handleTokenResponse(TokenResponse tokenResponse) async {
    _refreshToken.value = tokenResponse.refreshToken;
    accessToken.value = tokenResponse.accessToken;
    await _prefs.setString(PreferenceKey.refreshToken, tokenResponse.refreshToken);
    await _prefs.setString(PreferenceKey.accessToken, tokenResponse.accessToken);
    await Get.find<AppController>().startApp();
  }
  _handleDynamicLink(PendingDynamicLinkData dynamicLinkData){
    autoInviteCode.value = dynamicLinkData.link.queryParameters["invite"];
  }
  logout() async {
    if(await ApiService().logout()??false) {
      _prefs.clear();
      _refreshToken.value = null;
      accessToken.value = null;
      Get.offAllNamed(LoginPage.routeName);
    }
  }
}