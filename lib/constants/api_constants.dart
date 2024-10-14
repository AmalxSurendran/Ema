import '../env.dart';

class ApiConstants {
  static String baseUrl = env.baseUrl;
  static String getTokens = '/auth/tokenRequest';
  static String revokeTokens = '/auth/tokenRevoke?all=1';
  static String forgotPassword = '/credentials/resetRequest';
  static String refreshTokens = '/auth/accessToken';

  static String acceptInvitation(String invitationDocumentId) =>
      '/invitations/$invitationDocumentId/accept';
  static String updateAppMeta = '/app/meta';
  static String getSelfUser = '/users/self';
  static String updateSelfUser = '/users/self';

  static String getTasksForTheDay(String dateString) => '/tasks/$dateString';

  static String createTaskSession(String taskID) =>
      '/taskSessions?task=$taskID';

  static String getDailyReports = '/dailyReports';
  static String createFeedback = '/app/feedback';
}
