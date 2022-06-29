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
  static String email_opt = "email_opt";
  static String sms_opt = "sms_opt";
  static String push_opt = "push_opt";
  static String data_opt = "data_opt";
  static String ip_opt = "ip_opt";
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
  static int RESET_GENDER = 0;
  static int MALE = 1;
  static int FEMALE = 2;
  static int OTHERS = 3;
}

class UpshotMaritalStatus {
  static int RESET_MARITAL_STATUS = 0;
  static int SINGLE = 1;
  static int ENGAGED = 2;
  static int MARRIED = 3;
  static int WIDOW = 4;
  static int WIDOWER = 4;
  static int DIVORCED = 5;
}
