package com.upshot.flutter_upshot_plugin;

import android.content.Context;
import android.os.Bundle;
import com.brandkinesis.BKProperties;
import com.brandkinesis.BKUserInfo;
import com.brandkinesis.BrandKinesis;
import com.brandkinesis.activitymanager.BKActivityTypes;
import org.json.JSONException;
import org.json.JSONObject;
import java.util.*;

class UpshotHelper {

    public void initialize(HashMap<String, Object> options, Context context) {

        if (options == null) {return;}

        String appId  = options.containsKey("appId") ? options.get("appId").toString() : "";
        String ownerId = options.containsKey("ownerId") ? options.get("ownerId").toString() : "";
        Boolean fetchLocation = options.containsKey("enableLocation") ? (Boolean) options.get("enableLocation") : false ;
        Boolean enableDebugLogs = options.containsKey("enableDebuglogs") ? (Boolean) options.get("enableDebuglogs") : false ;
        Boolean useExternalStorage = options.containsKey("enableExternalStorage") ? (Boolean) options.get("enableExternalStorage") : false ;
        Boolean enableCrashLogs = options.containsKey("enableCrashlogs") ? (Boolean) options.get("enableCrashlogs") : false ;
        if (appId != null && ownerId != null && !appId.isEmpty && !ownerId.isEmpty) {
            
            Bundle bundle =new Bundle();
            bundle.putString(BKProperties.BK_APPLICATION_ID, appId);
            bundle.putString(BKProperties.BK_APPLICATION_OWNER_ID, ownerId);
            bundle.putBoolean(BKProperties.BK_FETCH_LOCATION, fetchLocation);
            bundle.putBoolean(BKProperties.BK_ENABLE_DEBUG_LOGS, enableDebugLogs);
            bundle.putBoolean(BKProperties.BK_USE_EXTERNAL_STORAGE, useExternalStorage);
            bundle.putBoolean(BKProperties.BK_EXCEPTION_HANDLER, enableCrashLogs);
            BrandKinesis.initialiseBrandKinesis(context, bundle, null);
        }
    }

    public void initializeUsingConfig(Context context) {
        try {
            BrandKinesis.initialiseBrandKinesis(context, null);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void terminateUpshot(Context context) {
        BrandKinesis.getBKInstance().terminate(context);

    }

    public void setUserProfile(String userData) {

        HashMap<String, String> predefinedKeys = new HashMap();

        predefinedKeys.put("lastName", BKUserInfo.BKUserData.LAST_NAME);
        predefinedKeys.put("middleName", BKUserInfo.BKUserData.MIDDLE_NAME);
        predefinedKeys.put("firstName", BKUserInfo.BKUserData.FIRST_NAME);
        predefinedKeys.put("language", BKUserInfo.BKUserData.LANGUAGE);
        predefinedKeys.put("occupation", BKUserInfo.BKUserData.OCCUPATION);
        predefinedKeys.put("qualification", BKUserInfo.BKUserData.QUALIFICATION);
        predefinedKeys.put("phone", BKUserInfo.BKUserData.PHONE);
        predefinedKeys.put("localeCode", BKUserInfo.BKUserData.LOCALE_CODE);
        predefinedKeys.put("userName", BKUserInfo.BKUserData.USER_NAME);
        predefinedKeys.put("email", BKUserInfo.BKUserData.EMAIL);
        predefinedKeys.put("appuID", BKUserInfo.BKExternalIds.APPUID);
        predefinedKeys.put("facebookID", BKUserInfo.BKExternalIds.FACEBOOK);
        predefinedKeys.put("twitterID", BKUserInfo.BKExternalIds.TWITTER);
        predefinedKeys.put("foursquareID", BKUserInfo.BKExternalIds.FOURSQUARE);
        predefinedKeys.put("linkedinID", BKUserInfo.BKExternalIds.LINKEDIN);
        predefinedKeys.put("googleplusID", BKUserInfo.BKExternalIds.GOOGLEPLUS);
        predefinedKeys.put("enterpriseUID", BKUserInfo.BKExternalIds.ENTERPRISE_UID);
        predefinedKeys.put("advertisingID", BKUserInfo.BKExternalIds.ADVERTISING_ID);
        predefinedKeys.put("instagramID", BKUserInfo.BKExternalIds.INSTAGRAM);
        predefinedKeys.put("pinterest", BKUserInfo.BKExternalIds.PINTEREST);
        predefinedKeys.put("token", BKUserInfo.BKExternalIds.GCM);
        predefinedKeys.put("gender", BKUserInfo.BKUserData.GENDER);
        predefinedKeys.put("maritalStatus", BKUserInfo.BKUserData.MARITAL_STATUS);
        predefinedKeys.put("year", BKUserInfo.BKUserDOBdata.YEAR);
        predefinedKeys.put("month", BKUserInfo.BKUserDOBdata.MONTH);
        predefinedKeys.put("day", BKUserInfo.BKUserDOBdata.DAY);
        predefinedKeys.put("age", BKUserInfo.BKUserData.AGE);
        predefinedKeys.put("email_opt", BKUserInfo.BKUserData.EMAIL_OPT_OUT);
        predefinedKeys.put("push_opt", BKUserInfo.BKUserData.PUSH_OPT_OUT);
        predefinedKeys.put("sms_opt", BKUserInfo.BKUserData.SMS_OPT_OUT);
        predefinedKeys.put("data_opt", BKUserInfo.BKUserData.DATA_OPT_OUT);
        predefinedKeys.put("ip_opt", BKUserInfo.BKUserData.IP_OPT_OUT);

        try {
            JSONObject providedJson = new JSONObject(userData);
            JSONObject othersJson = new JSONObject();
            Bundle bundle = new Bundle();
            Iterator<String> keys = providedJson.keys();
            while (keys.hasNext()) {
                String key = keys.next();
                Object value = providedJson.get(key);
                if (predefinedKeys.containsKey(key)) {
                    // predefined
                    String bkKey = predefinedKeys.get(key);
                    if (value instanceof Integer) {
                        bundle.putInt(bkKey, providedJson.optInt(key));
                    } else if (value instanceof Float || value instanceof Double) {
                        bundle.putFloat(bkKey, (float) providedJson.optDouble(key));
                    } else {
                        bundle.putString(bkKey, providedJson.optString(key));
                    }
                } else {
                    othersJson.put(key, value);
                }
            }
            if (othersJson.length() != 0) {
                HashMap<String, Object> others = jsonToHashMap(othersJson);
                if (others != null) {
                    bundle.putSerializable("others", others);
                }
            }
            BrandKinesis bkInstance = BrandKinesis.getBKInstance();
            bkInstance.setUserInfoBundle(bundle, null);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public Map<String, Object> getUserDetails()  {
        return BrandKinesis.getBKInstance().getUserDetails(null);
    }

    public void logoutDetails() {
        Bundle userInfo =new Bundle();
        userInfo.putString(BKUserInfo.BKExternalIds.APPUID, "");
        BrandKinesis.getBKInstance().setUserInfoBundle(userInfo, null);
    }

    public void updateDeviceToken(String token) {

        if (token == null) { return ; }
        Bundle userInfo =new Bundle();
        userInfo.putString(BKUserInfo.BKExternalIds.GCM, token);
        BrandKinesis.getBKInstance().setUserInfoBundle(userInfo, null);
    }

    public String getUserId(Context context) {
        return  BrandKinesis.getBKInstance().getUserId(context);
    }

    public String getSDKVersion() {
        return BrandKinesis.getBKInstance().getSdkVersion();
    }

    public String createCustomEvent(HashMap<String, Object> data, String eventName, Boolean timed)  {

        if (eventName == null || eventName.isEmpty() || data == null) {  return null ;}
        return  BrandKinesis.getBKInstance().createEvent(eventName, data, timed);
    }

    public String createPageEvent(String pageName) {

        if (pageName == null || pageName.isEmpty()) {return  null;}
        HashMap data = new HashMap<String, Object>();
        data.put(BrandKinesis.BK_CURRENT_PAGE, pageName);
        return BrandKinesis.getBKInstance().createEvent(BKProperties.BKPageViewEvent.NATIVE, data, true);
    }

    public String createAttributionEvent(HashMap<String, String> data) {
        if (data == null) { return null;}
        return BrandKinesis.getBKInstance().createAttributionEvent(data);
    }

    public String createLocationEvent(Double latitude, Double longitude) {
        return BrandKinesis.getBKInstance().createLocationEvent(latitude, longitude);
    }

    public void setValueAndClose(String eventId, HashMap<String, Object> data) {
        if (eventId == null || eventId.isEmpty() || data == null) {return ;}

        BrandKinesis.getBKInstance().closeEvent(eventId, data);
    }

    public void closeEvent(String eventId) {
        if (eventId == null || eventId.isEmpty()) {return ;}

        BrandKinesis.getBKInstance().closeEvent(eventId);
    }

    public void dispatch(Boolean timed, Context context) {
        BrandKinesis.getBKInstance().dispatchNow(context, timed, null);
    }

    public void getActivity(String tag, int type, Context context) {
        BrandKinesis.getBKInstance().getActivity(context, BKActivityTypes.parse(type), tag);
    }

    public void getActivityById(String activityId) {
        if (activityId == null || activityId.isEmpty()) {return ;}
        BrandKinesis.getBKInstance().getActivity(activityId, null);
    }

    public void removeTuroial(Context context) {
        BrandKinesis.getBKInstance().removeTutorial(context);
    }

    public HashMap<String, Object> jsonToHashMap(JSONObject jsonObject) {
        HashMap<String, Object> data = new HashMap();
        Iterator iter  = jsonObject.keys();
        while (iter.hasNext()) {
            String key = (String) iter.next();
            Object value = null;
            try {
                value = jsonObject.get(key);

                data.put(key, value);

            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        return data;
    }
}