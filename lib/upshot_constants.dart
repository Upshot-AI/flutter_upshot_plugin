class ActivityTypes {
  static int any = -1;
  static int survey = 0;
  static int rating = 1;
  static int fullScreenAd = 3;
  static int poll = 5;
  static int tutorials = 7;
  static int inAppMessage = 8;
  static int badges = 9;
  static int screenTips = 10;
  static int trivia = 11;
  static int customActions = 12;
  static int miniGames = 13;
}

class UpshotInitOptions {
  static String appId = "appId";
  static String ownerId = "ownerId";
  static String enableLocation = "enableLocation";
  static String enableDebuglogs = "enableDebuglogs";
  static String enableExternalStorage = "enableExternalStorage";
  static String enableCrashlogs = "enableCrashlogs";
}

class UpshotInboxScreenConfig {
  static String inboxType = "BKInboxType";
  static String showReadNotifications = "BKShowReadNotifications";
  static String deListingType = "BKDeListingType";
  static String enableLoadMore = "BKEnableLoadMore";
  static String pushFetchLimit = "BKPushFetchLimit";
  static String displayMessageCount = "BKDisplayMsgCount";
  static String displayTime = "BKDisplayTime";
}

class UpshotAttribution {
  static String attributionSource = "attributionSource";
  static String utmSource = "utmSource";
  static String utmMedium = "utmMedium";
  static String utmCampaign = "utmCampaign";
}

class UpshotProfileAttributes {
  static String lastName = "lastName";
  static String middleName = "middleName";
  static String firstName = "firstName";
  static String language = "language";
  static String occupation = "occupation";
  static String qualification = "qualification";
  static String maritalStatus = "maritalStatus";
  static String phone = "phone";
  static String localeCode = "localeCode";
  static String userName = "userName";
  static String email = "email";
  static String age = "age";
  static String gender = "gender";
  static String emailOpt = "email_opt";
  static String smsOpt = "sms_opt";
  static String pushOpt = "push_opt";
  static String dataOpt = "data_opt";
  static String ipOpt = "ip_opt";
  static String appuID = "appuID";
  static String facebookID = "facebookID";
  static String twitterID = "twitterID";
  static String foursquareID = "foursquareID";
  static String linkedinID = "linkedinID";
  static String googleplusID = "googleplusID";
  static String enterpriseUID = "enterpriseUID";
  static String advertisingID = "advertisingID";
  static String instagramID = "instagramID";
  static String pinterest = "pinterest";
  static String day = "day";
  static String month = "month";
  static String year = "year";
}

class UpshotGender {
  static int reset = 0;
  static int male = 1;
  static int female = 2;
  static int others = 3;
}

class UpshotMaritalStatus {
  static int reset = 0;
  static int single = 1;
  static int engaged = 2;
  static int married = 3;
  static int widow = 4;
  static int widower = 4;
  static int divorced = 5;
}

class UpshotInboxType {
  static int onlyInAppNudges = 1;
  static int onlyPush = 2;
  static int both = 3;
}

class UpshotDelistingType {
  static int campaign = 1;
  static int variable = 2;
}
