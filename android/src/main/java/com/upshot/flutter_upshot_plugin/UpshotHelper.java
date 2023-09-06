package com.upshot.flutter_upshot_plugin;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.view.WindowManager;
import android.widget.TextView;

import androidx.core.text.HtmlCompat;

import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.SeekBar;

import com.brandkinesis.BKProperties;
import com.brandkinesis.BKUIPrefComponents;
import com.brandkinesis.BKUserInfo;
import com.brandkinesis.BrandKinesis;
import com.brandkinesis.activitymanager.BKActivityTypes;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

class UpshotHelper {

    public void initialize(HashMap<String, Object> options, Context context) {

        try {
            if (options == null) {
                return;
            }
            String appId = options.containsKey("appId") ? options.get("appId").toString() : "";
            String ownerId = options.containsKey("ownerId") ? options.get("ownerId").toString() : "";
            Boolean fetchLocation = options.containsKey("enableLocation") ? (Boolean) options.get("enableLocation")
                    : false;
            Boolean enableDebugLogs = options.containsKey("enableDebuglogs") ? (Boolean) options.get("enableDebuglogs")
                    : false;
            Boolean useExternalStorage = options.containsKey("enableExternalStorage")
                    ? (Boolean) options.get("enableExternalStorage")
                    : false;
            Boolean enableCrashLogs = options.containsKey("enableCrashlogs") ? (Boolean) options.get("enableCrashlogs")
                    : false;
            if (appId != null && ownerId != null && !appId.isEmpty() && !ownerId.isEmpty()) {

                Bundle bundle = new Bundle();
                bundle.putString(BKProperties.BK_APPLICATION_ID, appId);
                bundle.putString(BKProperties.BK_APPLICATION_OWNER_ID, ownerId);
                bundle.putBoolean(BKProperties.BK_FETCH_LOCATION, fetchLocation);
                bundle.putBoolean(BKProperties.BK_ENABLE_DEBUG_LOGS, enableDebugLogs);
                bundle.putBoolean(BKProperties.BK_USE_EXTERNAL_STORAGE, useExternalStorage);
                bundle.putBoolean(BKProperties.BK_EXCEPTION_HANDLER, enableCrashLogs);
                BrandKinesis.initialiseBrandKinesis(context, bundle, null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // if (BuildConfig.DEBUG) {
            //
            // }
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

    public void setUserProfile(HashMap<String, Object> userData) {

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
            JSONObject othersJson = new JSONObject();
            Bundle bundle = new Bundle();

            // using for-each loop for iteration over Map.entrySet()
            for (Map.Entry<String, Object> entry : userData.entrySet()) {
                String key = entry.getKey();
                Object value = entry.getValue();

                if (predefinedKeys.containsKey(key)) {
                    // predefined
                    String bkKey = predefinedKeys.get(key);
                    if (value instanceof Integer) {
                        bundle.putInt(bkKey, (Integer) userData.get(key));
                    } else if (value instanceof Float) {
                        bundle.putFloat(bkKey, (float) userData.get(key));
                    } else if (value instanceof Double) {
                        bundle.putDouble(bkKey, (double) userData.get(key));
                    } else {
                        bundle.putString(bkKey, (String) userData.get(key));
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

    public void logoutDetails() {
        Bundle userInfo = new Bundle();
        userInfo.putString(BKUserInfo.BKExternalIds.APPUID, "");
        BrandKinesis.getBKInstance().setUserInfoBundle(userInfo, null);
    }

    public void updateDeviceToken(String token) {

        if (token == null) {
            return;
        }
        Bundle userInfo = new Bundle();
        userInfo.putString(BKUserInfo.BKExternalIds.GCM, token);
        BrandKinesis.getBKInstance().setUserInfoBundle(userInfo, null);
    }

    public String getUserId(Context context) {
        return BrandKinesis.getBKInstance().getUserId(context);
    }

    public String getSDKVersion() {
        return BrandKinesis.getBKInstance().getSdkVersion();
    }

    public String createCustomEvent(HashMap<String, Object> data, String eventName, Boolean timed) {

        if (eventName == null || eventName.isEmpty()) {
            return null;
        }
        return BrandKinesis.getBKInstance().createEvent(eventName, data, timed);
    }

    public String createPageEvent(String pageName) {

        if (pageName == null || pageName.isEmpty()) {
            return null;
        }
        HashMap data = new HashMap<String, Object>();
        data.put(BrandKinesis.BK_CURRENT_PAGE, pageName);
        return BrandKinesis.getBKInstance().createEvent(BKProperties.BKPageViewEvent.NATIVE, data, true);
    }

    public String createAttributionEvent(HashMap<String, String> data) {
        if (data == null) {
            return null;
        }
        return BrandKinesis.getBKInstance().createAttributionEvent(data);
    }

    public String createLocationEvent(Double latitude, Double longitude) {
        return BrandKinesis.getBKInstance().createLocationEvent(latitude, longitude);
    }

    public void setValueAndClose(String eventId, HashMap<String, Object> data) {
        if (eventId == null || eventId.isEmpty()) {
            return;
        }
        BrandKinesis.getBKInstance().closeEvent(eventId, data);
    }

    public void closeEvent(String eventId) {
        if (eventId == null || eventId.isEmpty()) {
            return;
        }
        BrandKinesis.getBKInstance().closeEvent(eventId);
    }

    public void dispatch(Boolean timed, Context context) {
        BrandKinesis.getBKInstance().dispatchNow(context, timed, null);
    }

    public void getActivity(String tag, int type, Context context) {
        BKActivityTypes activityType = BKActivityTypes.ACTIVITY_ANY;
        if (type >= 0) {
            activityType = BKActivityTypes.parse(type);
        }
        BrandKinesis.getBKInstance().getActivity(context, activityType, tag);
    }

    public void getActivityById(String activityId) {
        if (activityId == null || activityId.isEmpty()) {
            return;
        }
        BrandKinesis.getBKInstance().getActivity(activityId, null);
    }

    public void removeTuroial(Context context) {
        BrandKinesis.getBKInstance().removeTutorial(context);
    }

    public HashMap<String, Object> jsonToHashMap(JSONObject jsonObject) {
        HashMap<String, Object> data = new HashMap();
        Iterator iter = jsonObject.keys();
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

    public void setCustomizationData(String surveyThemeJson, String ratingThemeJson, String pollThemeJson,
            String triviaThemeJson, Context context, FlutterLoader loader, FlutterPlugin.FlutterPluginBinding binding) {

        {
            try {
                JSONObject surveyJSON = new JSONObject(surveyThemeJson);
                JSONObject ratingJSON = new JSONObject(ratingThemeJson);
                JSONObject pollJSON = new JSONObject(pollThemeJson);
                JSONObject triviaJSON = new JSONObject(triviaThemeJson);
                UpshotSurveyCustomization surveyCustomization = new UpshotSurveyCustomization(context, surveyJSON);
                UpshotRatingCustomization ratingCustomization = new UpshotRatingCustomization(context, ratingJSON);
                UpshotOpinionPollCustomization pollCustomization = new UpshotOpinionPollCustomization(context,
                        pollJSON);
                UpshotTriviaCustomization triviaCustomization = new UpshotTriviaCustomization(context, triviaJSON,
                        loader, binding);

                BKUIPrefComponents components = new BKUIPrefComponents() {
                    @Override
                    public void setPreferencesForRelativeLayout(RelativeLayout relativeLayout,
                            BKActivityTypes bkActivityTypes,
                            BKActivityRelativeLayoutTypes bkActivityRelativeLayoutTypes, boolean b) {
                        switch (bkActivityTypes) {
                            case ACTIVITY_SURVEY:
                                surveyCustomization.customizeRelativeLayout(bkActivityRelativeLayoutTypes,
                                        relativeLayout, b);
                                break;
                            case ACTIVITY_RATINGS:
                                ratingCustomization.customizeRelativeLayout(bkActivityRelativeLayoutTypes,
                                        relativeLayout, b);
                                break;
                            case ACTIVITY_OPINION_POLL:
                                pollCustomization.customizeRelativeLayout(bkActivityRelativeLayoutTypes, relativeLayout,
                                        b);
                                break;
                            case ACTIVITY_TRIVIA:
                                triviaCustomization.customizeRelativeLayout(bkActivityRelativeLayoutTypes,
                                        relativeLayout, b);
                                break;
                        }
                    }

                    @Override
                    public void setPreferencesForImageButton(ImageButton imageButton, BKActivityTypes bkActivityTypes,
                            BKActivityImageButtonTypes bkActivityImageButtonTypes) {

                        switch (bkActivityTypes) {
                            case ACTIVITY_SURVEY:
                                surveyCustomization.customizeImageButton(imageButton, bkActivityImageButtonTypes);
                                break;
                            case ACTIVITY_RATINGS:
                                ratingCustomization.customizeImageButton(imageButton, bkActivityImageButtonTypes);
                                break;
                            case ACTIVITY_OPINION_POLL:
                                pollCustomization.customizeImageButton(imageButton, bkActivityImageButtonTypes);
                                break;
                            case ACTIVITY_TRIVIA:
                                triviaCustomization.customizeImageButton(imageButton, bkActivityImageButtonTypes);
                                break;
                        }
                    }

                    @Override
                    public void setPreferencesForButton(Button button, BKActivityTypes bkActivityTypes,
                            BKActivityButtonTypes bkActivityButtonTypes) {

                        switch (bkActivityTypes) {
                            case ACTIVITY_SURVEY:
                                surveyCustomization.customizeButton(button, bkActivityButtonTypes);
                                break;
                            case ACTIVITY_RATINGS:
                                ratingCustomization.customizeButton(button, bkActivityButtonTypes);
                                break;
                            case ACTIVITY_OPINION_POLL:
                                pollCustomization.customizeButton(button, bkActivityButtonTypes);
                                break;
                            case ACTIVITY_TRIVIA:
                                triviaCustomization.customizeButton(button, bkActivityButtonTypes);
                                break;
                        }
                    }

                    @Override
                    public void setPreferencesForTextView(TextView textView, BKActivityTypes bkActivityTypes,
                            BKActivityTextViewTypes bkActivityTextViewTypes) {
                        switch (bkActivityTypes) {
                            case ACTIVITY_SURVEY:
                                surveyCustomization.customizeTextView(bkActivityTextViewTypes, textView);
                                break;
                            case ACTIVITY_RATINGS:
                                ratingCustomization.customizeTextView(bkActivityTextViewTypes, textView);
                                break;
                            case ACTIVITY_OPINION_POLL:
                                pollCustomization.customizeTextView(bkActivityTextViewTypes, textView);
                                break;
                            case ACTIVITY_TRIVIA:
                                triviaCustomization.customizeTextView(bkActivityTextViewTypes, textView);
                                break;
                        }

                    }

                    @Override
                    public void setPreferencesForImageView(ImageView imageView, BKActivityTypes bkActivityTypes,
                            BKActivityImageViewType bkActivityImageViewType) {

                        switch (bkActivityTypes) {
                            case ACTIVITY_SURVEY:
                                surveyCustomization.customizeImageView(imageView, bkActivityImageViewType);
                                break;
                            case ACTIVITY_RATINGS:
                                ratingCustomization.customizeImageView(imageView, bkActivityImageViewType);
                                break;
                            case ACTIVITY_OPINION_POLL:
                                pollCustomization.customizeImageView(imageView, bkActivityImageViewType);
                                break;
                            case ACTIVITY_TRIVIA:
                                triviaCustomization.customizeImageView(imageView, bkActivityImageViewType);
                                break;
                        }

                    }

                    @Override
                    public void setPreferencesForOptionsSeparatorView(View view, BKActivityTypes bkActivityTypes) {

                        switch (bkActivityTypes) {
                            case ACTIVITY_SURVEY:
                                surveyCustomization.customizeForOptionsSeparatorView(view);
                                break;
                            case ACTIVITY_RATINGS:
                                ratingCustomization.customizeForOptionsSeparatorView(view);
                                break;
                            case ACTIVITY_OPINION_POLL:
                                pollCustomization.customizeForOptionsSeparatorView(view);
                                break;
                            case ACTIVITY_TRIVIA:
                                triviaCustomization.customizeForOptionsSeparatorView(view);
                                break;
                        }

                    }

                    @Override
                    public void setCheckBoxRadioSelectorResource(BKUICheckBox bkuiCheckBox,
                            BKActivityTypes bkActivityTypes, boolean b) {

                        switch (bkActivityTypes) {
                            case ACTIVITY_SURVEY:
                                surveyCustomization.customizeRadioButton(bkuiCheckBox, b);
                                break;
                            case ACTIVITY_RATINGS:
                                ratingCustomization.customizeRadioButton(bkuiCheckBox, b);
                                break;
                            case ACTIVITY_OPINION_POLL:
                                pollCustomization.customizeRadioButton(bkuiCheckBox, b);
                                break;
                            case ACTIVITY_TRIVIA:
                                triviaCustomization.customizeRadioButton(bkuiCheckBox, b);
                                break;
                        }
                    }

                    @Override
                    public void setRatingSelectorResource(List<Bitmap> list, List<Bitmap> list1,
                            BKActivityTypes bkActivityTypes, BKActivityRatingTypes bkActivityRatingTypes) {

                        switch (bkActivityTypes) {
                            case ACTIVITY_SURVEY:
                                surveyCustomization.customizeRating(list, list1, bkActivityRatingTypes);
                                break;
                            case ACTIVITY_RATINGS:
                                ratingCustomization.customizeRating(list, list1, bkActivityRatingTypes);
                                break;
                            case ACTIVITY_OPINION_POLL:
                                pollCustomization.customizeRating(list, list1, bkActivityRatingTypes);
                                break;
                            case ACTIVITY_TRIVIA:
                                triviaCustomization.customizeRating(list, list1, bkActivityRatingTypes);
                                break;
                        }
                    }

                    @Override
                    public void setPreferencesForUIColor(BKBGColors bkbgColors, BKActivityTypes bkActivityTypes,
                            BKActivityColorTypes bkActivityColorTypes) {

                        switch (bkActivityTypes) {
                            case ACTIVITY_SURVEY:
                                surveyCustomization.customizeBGColor(bkbgColors, bkActivityColorTypes);
                                break;
                            case ACTIVITY_RATINGS:
                                ratingCustomization.customizeBGColor(bkbgColors, bkActivityColorTypes);
                                break;
                            case ACTIVITY_OPINION_POLL:
                                pollCustomization.customizeBGColor(bkbgColors, bkActivityColorTypes);
                                break;
                            case ACTIVITY_TRIVIA:
                                triviaCustomization.customizeBGColor(bkbgColors, bkActivityColorTypes);
                                break;
                        }
                    }

                    @Override
                    public void setPreferencesForGraphColor(BKGraphType bkGraphType, List<Integer> list,
                            BKActivityTypes bkActivityTypes) {

                        switch (bkActivityTypes) {
                            case ACTIVITY_SURVEY:
                                surveyCustomization.customizeForGraphColor(bkGraphType, list);
                                break;
                            case ACTIVITY_RATINGS:
                                ratingCustomization.customizeForGraphColor(bkGraphType, list);
                                break;
                            case ACTIVITY_OPINION_POLL:
                                pollCustomization.customizeForGraphColor(bkGraphType, list);
                                break;
                            case ACTIVITY_TRIVIA:
                                triviaCustomization.customizeForGraphColor(bkGraphType, list);
                                break;
                        }
                    }

                    @Override
                    public int getPositionPercentageFromBottom(BKActivityTypes bkActivityTypes, BKViewType bkViewType) {
                        return 0;
                    }

                    @Override
                    public void setPreferencesForSeekBar(SeekBar seekBar, BKActivityTypes bkActivityTypes,
                            BKActivitySeekBarTypes bkActivitySeekBarTypes) {
                        switch (bkActivityTypes) {
                            case ACTIVITY_SURVEY:

                                surveyCustomization.customizeSeekBar(bkActivitySeekBarTypes, seekBar);
                                break;
                            case ACTIVITY_RATINGS:
                                ratingCustomization.customizeSeekBar(bkActivitySeekBarTypes, seekBar);
                                break;
                            case ACTIVITY_OPINION_POLL:
                                pollCustomization.customizeSeekBar(bkActivitySeekBarTypes, seekBar);
                                break;
                            case ACTIVITY_TRIVIA:
                                triviaCustomization.customizeSeekBar(bkActivitySeekBarTypes, seekBar);
                                break;
                        }

                    }

                    @Override
                    public void setPreferencesForEditText(EditText editText, BKActivityTypes bkActivityTypes,
                            BKActivityEditTextTypes bkActivityEditTextTypes) {

                        switch (bkActivityTypes) {
                            case ACTIVITY_SURVEY:
                                surveyCustomization.customizeEditText(bkActivityEditTextTypes, editText);
                                break;
                            case ACTIVITY_RATINGS:
                                ratingCustomization.customizeEditText(bkActivityEditTextTypes, editText);
                                break;
                            case ACTIVITY_OPINION_POLL:
                                pollCustomization.customizeEditText(bkActivityEditTextTypes, editText);
                                break;
                            case ACTIVITY_TRIVIA:
                                triviaCustomization.customizeEditText(bkActivityEditTextTypes, editText);
                                break;
                        }
                    }

                    @Override
                    public void setPreferencesForLinearLayout(LinearLayout linearLayout,
                            BKActivityTypes bkActivityTypes, BKActivityLinearLayoutTypes bkActivityLinearLayoutTypes) {

                        switch (bkActivityTypes) {
                            case ACTIVITY_SURVEY:
                                surveyCustomization.customizeForLinearLayout(linearLayout, bkActivityLinearLayoutTypes);
                                break;
                            case ACTIVITY_RATINGS:
                                ratingCustomization.customizeForLinearLayout(linearLayout, bkActivityLinearLayoutTypes);
                                break;
                            case ACTIVITY_OPINION_POLL:
                                pollCustomization.customizeForLinearLayout(linearLayout, bkActivityLinearLayoutTypes);
                                break;
                            case ACTIVITY_TRIVIA:
                                triviaCustomization.customizeForLinearLayout(linearLayout, bkActivityLinearLayoutTypes);
                                break;
                        }
                    }
                };
                BrandKinesis.getBKInstance().setUIPreferences(components);
            } catch (JSONException e) {
                throw new RuntimeException(e);
            }

        }
        // try {
        // BrandKinesis bkInstance = BrandKinesis.getBKInstance();
        // UpshotCustomization upshotCustomization = new UpshotCustomization();
        // upshotCustomization.setCustomizationData(new JSONObject(customizationJson),
        // bkInstance, context);
        // } catch (JSONException e) {
        // e.printStackTrace();
        // }
    }

    public int calculateWebViewHeight(Context context, Map<String, Object> description) {
        TextView textView = new TextView(context);
        final float densityDpi = context.getResources().getDisplayMetrics().densityDpi;
        final int fontSize = Integer.parseInt(description.get("fontSize").toString());
        final String fontName = description.get("fontName").toString();
        WindowManager windowManager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics displayMetrics = new DisplayMetrics();
        windowManager.getDefaultDisplay().getMetrics(displayMetrics);
        float px = TypedValue.applyDimension(
                TypedValue.COMPLEX_UNIT_PX,
                fontSize,
                context.getResources().getDisplayMetrics());
        final int descriptionWidth = (int) (((displayMetrics.widthPixels * 0.9) - 40)
                / (densityDpi / DisplayMetrics.DENSITY_DEFAULT));
        String text = HtmlCompat.fromHtml("<html><head>\n" +
                "</head> <body>" + description.get("text").toString() + "</body></html>",
                HtmlCompat.FROM_HTML_OPTION_USE_CSS_COLORS).toString();
        textView.setText(text.substring(0, text.length() - 1));

        textView.setTextSize(TypedValue.COMPLEX_UNIT_PX, fontSize - 1);
        int widthMeasureSpec = View.MeasureSpec.makeMeasureSpec(descriptionWidth, View.MeasureSpec.AT_MOST);
        int heightMeasureSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
        textView.measure(widthMeasureSpec, heightMeasureSpec);
        return textView.getMeasuredHeight() + 5;
    }
}