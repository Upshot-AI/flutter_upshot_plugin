class ActivityTypes {
  static int any = -1;
  static int survey = 0;
  static int rating = 1;
  static int poll = 5;
  static int tutorials = 7;
  static int inAppMessage = 8;
  static int badges = 9;
  static int screenTips = 10;
  static int trivia = 11;
  static int customActions = 12;
  static int miniGames = 13;
}

enum UpshotInitOptions {
  appId,
  ownerId,
  enableLocation,
  enableDebuglogs,
  enableExternalStorage,
  enableCrashlogs
}

enum UpshotAttribution {
  attributionSource,
  utmSource,
  utmMedium,
  utmCampaign
}

enum UpshotProfileAttributes {
  lastName,
  middleName,
  firstName,
  language,
  occupation,
  qualification,
  maritalStatus,
  phone,
  localeCode,
  userName,
  email,
  age,
  gender,
  email_opt,
  sms_opt,
  push_opt,
  data_opt,
  ip_opt,
  appuID,
  facebookID,
  twitterID,
  foursquareID,
  linkedinID,
  googleplusID,
  enterpriseUID,
  advertisingID,
  instagramID,
  pinterest,
  day,
  month,
  year
}
