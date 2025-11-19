// create class for end points
class Endpoints {
  // static const String baseUrl = 'https://vkapsprojects.com/aayojan-app/api';
  // static const String baseUrl = 'https://aayojan.co.in/api';
  static const String baseUrl = 'https://aayojan.co.in/api';
  // static const String imageUrl =
  //     'https://vkapsprojects.com/aayojan-app/storage/';

  static const String imageUrl = 'https://aayojan.co.in/storage/';

  static const String signUp = '$baseUrl/register';
  static const String login = '$baseUrl/login';
  static const String verify = '$baseUrl/verify-otp';
  static const String resendOTP = '$baseUrl/resend-otp';
  //
  static const String profileUpdate = '$baseUrl/profile';
  static const String userInfo = '$baseUrl/user-info';
  // event
  static const String createEvent = '$baseUrl/event/create';
  static const String getEvents = '$baseUrl/event';
  static const String getEventDetails = '$baseUrl/event/show';
  static const String updateEvent = '$baseUrl/event/update';
  static const String deleteEvent = '$baseUrl/event/delete';
  static const String deleteSubEvent = '$baseUrl/sub-event/delete';

  // sub-event
  static const String createSubEvent = '$baseUrl/sub-event/create';
  static const String updateSubEvent = '$baseUrl/sub-event/update';
  static const String getSubEventDetails = '$baseUrl/sub-event/show';

  static const String getSubEvents = '$baseUrl/sub-event';

  // invitation
  static const String invitation = '$baseUrl/invitation/list';
  static const String invitationAction =
      '$baseUrl/invitation/response-to-invitation';
  // family
  static const String createFamily = '$baseUrl/family-member/create';
  static const String updateFamily = '$baseUrl/family-member/update';
  static const String getFamilies = '$baseUrl/family-member';
  static const String deleteFamily = '$baseUrl/family-member/delete';

  // guest
  static const String getGuests = '$baseUrl/guest-management';
  static const String getGuest = '$baseUrl/guest-management';
  static const String getGuestByPhone = '$baseUrl/guest-management';
  static const String addGuest = '$baseUrl/guest-management';
  static const String editGuest = '$baseUrl/guest-management';
  static const String deleteGuest = '$baseUrl/guest-management';
  static const String uploadExcelFile = '$baseUrl/guest-management/upload-csv';
  static const String saveGuests = '$baseUrl/guest-management/save-guest-list';
  static const String getEventGuests =
      '$baseUrl/guest-management/fetch-guest-list';
  static const String getFamilyMembers = '$baseUrl/family-member/family-list';

  static const String getSubEventGuests = '$baseUrl/sub-event/subevent-guest-list';

  static const String getUserByPhone = '$baseUrl/fetch-guest-info';

  // relations
  static const String getRelations = '$baseUrl/relation';
  static const String getRelationCategories = '$baseUrl/relation/category';

  // religion
  static const String getReligion = '$baseUrl/religion';

  static const String getCity = '$baseUrl/city';
  static const String getState = '$baseUrl/state';
  static const String getCommunity = '$baseUrl/community';

  static const String getNotification = '$baseUrl/notification/list';
}
