package com.upshot.flutter_upshot_plugin;

import android.app.Activity;
import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.Bundle;
import android.view.View;

import androidx.annotation.NonNull;

import com.brandkinesis.BrandKinesis;
import com.brandkinesis.activitymanager.BKActivityTypes;
import com.brandkinesis.callback.BKBadgeAccessListener;
import com.brandkinesis.callback.BKInboxAccessListener;
import com.brandkinesis.callback.BrandKinesisCallback;
import com.brandkinesis.pushnotifications.BKNotificationsCountResponseListener;
import com.brandkinesis.pushnotifications.BKNotificationsResponseListener;
import com.brandkinesis.rewards.BKRewardsResponseListener;
import com.brandkinesis.callback.BrandKinesisUserStateCompletion;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.messaging.FirebaseMessaging;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONArray;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Iterator;
import java.util.Set;

import io.flutter.FlutterInjector;
import io.flutter.Log;
import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.EventChannel;

/**
 * FlutterUpshotPlugin
 */
public class FlutterUpshotPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native
    /// Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine
    /// and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private MethodChannel internal_channel;
    private FlutterPluginBinding binding;
    private Handler handler;
    public static EventChannel.EventSink eventSinkChannel = null;
    public static EventChannel.EventSink pushReceiveSinkChannel = null;
    private Context context;

    UpshotHelper helper = new UpshotHelper();

    private class UserInfoAsync extends AsyncTask<Set<String>, Void, Map<String, Object>> {

        @Override
        protected Map<String, Object> doInBackground(Set<String>... params) {
            Set<String> keys = params[0];
            BrandKinesis brandKinesis = BrandKinesis.getBKInstance();
            return brandKinesis.getUserDetails(keys);
        }

        @Override
        protected void onPostExecute(Map<String, Object> userInfo) {
            super.onPostExecute(userInfo);
            channel.invokeMethod("upshotCurrentUserDetails", userInfo);
        }
    }

    public String loadJSONFromAsset(Context context, String fileName) {
        String json = null;
        try {
            InputStream is = context.getAssets().open(fileName);
            int size = is.available();
            byte[] buffer = new byte[size];
            is.read(buffer);
            is.close();
            json = new String(buffer, "UTF-8");
        } catch (IOException ex) {
            ex.printStackTrace();
            return null;
        }
        return json;
    }

    public String loadJSONFromAsset(Context context, AssetFileDescriptor afd) {
        String json = null;
        try {
            InputStream is = afd.createInputStream();
            int size = is.available();
            byte[] buffer = new byte[size];
            is.read(buffer);
            is.close();
            json = new String(buffer, "UTF-8");
        } catch (IOException ex) {
            ex.printStackTrace();
            return null;
        }
        return json;
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {

        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_upshot_plugin");
        channel.setMethodCallHandler(this);

        internal_channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(),
                "flutter_upshot_plugin_internal");
        internal_channel.setMethodCallHandler(this);
        Log.d("Upshot", "flutter_upshot_plugin_internal onAttachedToEngine");

        this.context = flutterPluginBinding.getApplicationContext();
        handler = new Handler(Looper.getMainLooper());
        binding = flutterPluginBinding;
        FlutterLoader loader = FlutterInjector.instance().flutterLoader();
        String key = loader.getLookupKeyForAsset("assets/UpshotCustomisation.json");

        // AssetManager assetManager = binding.getApplicationContext().getAssets();

        // AssetFileDescriptor fd = assetManager.openFd(key);
        String customizationJson = loadJSONFromAsset(context, key);

        helper.setCustomizationData(customizationJson, context);

        new EventChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_upshot_plugin/pushClick")
                .setStreamHandler(new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        eventSinkChannel = events;
                    }

                    @Override
                    public void onCancel(Object arguments) {

                    }
                });
        new EventChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_upshot_plugin/onPushReceive")
                .setStreamHandler(new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        pushReceiveSinkChannel = events;
                    }

                    @Override
                    public void onCancel(Object arguments) {

                    }
                });
        UpshotApplication.getApplicationInstance().setCustomListener(customListener);
    }

    UpshotListener customListener = new UpshotListener() {
        @Override
        public void onAppComesForeground(Activity activity) {

            setUpshotGlobalCallback();
        }
    };

    private void fetchTokenFromFirebaseSdk() {

        try {
            FirebaseMessaging.getInstance().getToken()
                    .addOnCompleteListener(new OnCompleteListener<String>() {
                        @Override
                        public void onComplete(@NonNull Task<String> task) {
                            if (!task.isSuccessful()) {
                                return;
                            }
                            String token = task.getResult();
                            HashMap<String, String> response = new HashMap<>();
                            response.put("token", token);
                            handler.post(new Runnable() {
                                @Override
                                public void run() {
                                    channel.invokeMethod("upshotPushToken", response);
                                }
                            });
                            helper.updateDeviceToken(token);
                        }
                    });
        } catch (Exception e) {
            // if (BuildConfig.DEBUG) {
            // e.printStackTrace();
            // }
        }
    }

    private void setUpshotGlobalCallback() {
        BrandKinesis bkInstance = BrandKinesis.getBKInstance();
        bkInstance.setBrandkinesisCallback(new BrandKinesisCallback() {
            @Override
            public void brandKinesisInboxActivityPresented() {
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        HashMap<String, Integer> response = new HashMap<>();
                        channel.invokeMethod("upshotInboxActivityPresented", response);
                    }
                });
            }

            @Override
            public void brandKinesisInboxActivityDismissed() {
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        HashMap<String, Integer> response = new HashMap<>();
                        channel.invokeMethod("upshotInboxActivityDismiss", response);
                    }
                });
            }

            @Override
            public void userStateCompletion(boolean status) {

            }

            @Override
            public void onUserInfoUploaded(boolean uploadSuccess) {
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("upshotProfileUpdatingStatus", uploadSuccess);
                    }
                });
            }

            @Override
            public void onMessagesAvailable(List<HashMap<String, Object>> message) {

            }

            @Override
            public void brandkinesisCampaignDetailsLoaded() {
                helper.getActivity("Upshot_loaded", -1, context);
            }

            @Override
            public void onBadgesAvailable(HashMap<String, List<HashMap<String, Object>>> badges) {

            }

            @Override
            public void onAuthenticationError(String errorMsg) {

                HashMap<String, String> response = new HashMap<>();
                response.put("status", "Fail");
                response.put("errorMessage", errorMsg);
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("upshotAuthenticationStatus", response);
                    }
                });
            }

            @Override
            public void onAuthenticationSuccess() {
                fetchTokenFromFirebaseSdk();
                HashMap<String, String> response = new HashMap<>();
                response.put("status", "Success");
                response.put("errorMessage", "");
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("upshotAuthenticationStatus", response);
                    }
                });
            }

            @Override
            public void onActivityError(int error) {
                Log.d("Upshot", "onActivityError---" + Integer.toString(error));
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        HashMap<String, String> response = new HashMap<>();
                        response.put("error", Integer.toString(error));
                        channel.invokeMethod("upshotActivityError", response);
                    }
                });
            }

            @Override
            public void onActivityCreated(BKActivityTypes activityType) {
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        HashMap<String, Integer> response = new HashMap<>();
                        response.put("activityType", activityType.getValue());
                        channel.invokeMethod("upshotActivityDidAppear", response);
                    }
                });
            }

            @Override
            public void onActivityDestroyed(BKActivityTypes activityType) {
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        HashMap<String, Integer> response = new HashMap<>();
                        response.put("activityType", activityType.getValue());
                        channel.invokeMethod("upshotActivityDidDismiss", response);
                    }
                });
            }

            @Override
            public void getBannerView(View bannerView, String tag) {

            }

            @Override
            public void onErrorOccurred(int errorCode) {

            }

            @Override
            public void brandKinesisActivityPerformedActionWithParams(BKActivityTypes activityType,
                    Map<String, Object> actionData) {

                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        String data = (String) actionData.get("deepLink");
                        HashMap<String, Object> response = new HashMap<>();
                        response.put("activityType", activityType.getValue());
                        if (data != null) {
                            try {
                                JSONObject deeplinkJSON = new JSONObject(data);
                                response.put("deepLink_keyValue", deeplinkJSON.toString());
                                channel.invokeMethod("upshotActivityDeeplink", response);
                            } catch (JSONException e) {
                                response.put("deepLink", data);
                                channel.invokeMethod("upshotActivityDeeplink", response);
                                e.printStackTrace();
                            }
                        }
                    }
                });
            }

            @Override
            public void brandKinesisInteractiveTutorialInfoForPlugin(String data) {
                Log.d("Upshot", "brandKinesisInteractiveTutorialInfoForPlugin");
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        if (data != null) {
                            try {
                                internal_channel.invokeMethod("upshot_interactive_tutoInfo", data);
                                Log.d("upshot_interactive_tutoInfo", "callback send");

                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }

                    }
                });
            }
        });
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

        switch (call.method) {

            case "initializeUpshotUsingConfigFile": {
                if (UpshotApplication.initType == null || UpshotApplication.initType.isEmpty()) {
                    helper.initializeUsingConfig(context);
                }
                UpshotApplication.initType = "Config";
            }
                break;
            case "initializeUsingOptions": {
                HashMap<String, Object> data = (HashMap<String, Object>) call.arguments;
                UpshotApplication.initType = "Options";
                if (UpshotApplication.options == null || UpshotApplication.options.isEmpty()) {
                    UpshotApplication.options = data;
                    helper.initialize(data, context);
                }
            }
                break;
            case "terminate":
                break;
            case "sendUserDetails": {
                HashMap<String, Object> data = (HashMap<String, Object>) call.arguments;
                helper.setUserProfile(data);
            }
                break;
            case "getUserDetails": {
                Set<String> keys = new HashSet<>();
                new UserInfoAsync().execute(keys);
            }
                break;
            case "sendLogoutDetails": {
                helper.logoutDetails();
            }
                break;
            case "sendDeviceToken": {
                String token = call.argument("token");
                helper.updateDeviceToken(token);
            }
                break;
            case "sendPushClickDetails": {
            }
                break;
            case "displayNotification": {
                HashMap<String, Object> data = (HashMap<String, Object>) call.arguments;
                Bundle pushBundle = convertMapToBundle(data);
                BrandKinesis.getBKInstance().buildEnhancedPushNotification(context, pushBundle, true);
            }
                break;
            case "getUserId": {
                result.success(helper.getUserId(context));
            }
                break;
            case "getSDKVersion": {
                result.success(helper.getSDKVersion());
            }
                break;
            case "createCustomEvent": {
                String eventName = call.argument("eventName");
                HashMap<String, Object> data = call.argument("data");
                boolean isTimed = call.argument("isTimed");
                String eventId = helper.createCustomEvent(data, eventName, isTimed);
                result.success(eventId);
            }
                break;
            case "createPageViewEvent": {
                String pageName = (String) call.arguments;
                String eventId = helper.createPageEvent(pageName);
                result.success(eventId);
            }
                break;

            case "createAttributionEvent": {
                HashMap<String, String> data = (HashMap<String, String>) call.arguments;
                String eventId = helper.createAttributionEvent(data);
                result.success(eventId);
            }
                break;
            case "createLocationEvent": {
                BrandKinesis bkInstance = BrandKinesis.getBKInstance();
                String latitude = call.argument("latitude");
                String longitude = call.argument("longitude");
                helper.createLocationEvent(Double.parseDouble(latitude), Double.parseDouble(longitude));
            }
                break;
            case "setValueAndClose": {
                String eventId = call.argument("eventId");
                HashMap<String, Object> data = call.argument("data");
                helper.setValueAndClose(eventId, data);
            }
                break;
            case "closeEventForId": {
                String eventId = (String) call.arguments;
                helper.closeEvent(eventId);
            }
                break;
            case "dispatchEvents": {
                boolean isTimed = (boolean) call.arguments;
                helper.dispatch(isTimed, context);
            }
                break;
            case "dispatchInterval": {
                int interval = Integer.parseInt(call.arguments.toString());
                BrandKinesis.getBKInstance().setDispatchEventTime(interval * 1000);
            }
                break;
            case "showActivity": {
                String tag = call.argument("tag");
                Integer type = call.argument("type");
                Log.d("Upshot", "showActivity---" + tag);
                helper.getActivity(tag, type, context);
            }
                break;
            case "showActivityWithId": {
                String activityId = (String) call.arguments;
                helper.getActivityById(activityId);
            }
                break;
            case "removeTutorial": {
                helper.removeTuroial(context);
            }
                break;
            case "getBadges": {
                BrandKinesis.getBKInstance().getBadges(new BKBadgeAccessListener() {
                    @Override
                    public void onBadgesAvailable(HashMap<String, List<HashMap<String, Object>>> hashMap) {
                        handler.post(new Runnable() {
                            @Override
                            public void run() {
                                channel.invokeMethod("upshotBadgesData", hashMap);
                            }
                        });
                    }
                });
            }
                break;

            case "getInboxDetails": {
                BrandKinesis.getBKInstance().fetchInboxInfo(new BKInboxAccessListener() {
                    @Override
                    public void onMessagesAvailable(List<HashMap<String, Object>> list) {
                        handler.post(new Runnable() {
                            @Override
                            public void run() {
                                HashMap<String, Object> data = new HashMap<>();
                                data.put("data", list);
                                channel.invokeMethod("upshotCampaignDetails", data);
                            }
                        });
                    }
                });
            }
                break;
            case "fetchRewards": {
                BrandKinesis.getBKInstance().getRewardsStatusWithCompletionBlock(context,
                        new BKRewardsResponseListener() {
                            @Override
                            public void rewardsResponse(Object o) {
                                HashMap<String, Object> data = new HashMap<>();
                                data.put("status", "Success");
                                data.put("response", o);
                                handler.post(new Runnable() {
                                    @Override
                                    public void run() {
                                        channel.invokeMethod("upshotRewardsResponse", data);
                                    }
                                });
                            }

                            @Override
                            public void onErrorReceived(Object o) {
                                HashMap<String, Object> data = new HashMap<>();
                                data.put("status", "Fail");
                                data.put("errorMessage", o);
                                handler.post(new Runnable() {
                                    @Override
                                    public void run() {
                                        channel.invokeMethod("upshotRewardsResponse", data);
                                    }
                                });
                            }
                        });
            }
                break;
            case "fetchRewardHistory": {
                String programId = call.argument("programId");
                int historyType = call.argument("type");

                BrandKinesis.getBKInstance().getRewardHistoryForProgramId(context, programId, historyType,
                        new BKRewardsResponseListener() {
                            @Override
                            public void rewardsResponse(Object o) {
                                HashMap<String, Object> data = new HashMap<>();
                                data.put("status", "Success");
                                data.put("response", o);
                                handler.post(new Runnable() {
                                    @Override
                                    public void run() {
                                        channel.invokeMethod("upshotRewardHistoryResponse", data);
                                    }
                                });
                            }

                            @Override
                            public void onErrorReceived(Object o) {
                                HashMap<String, Object> data = new HashMap<>();
                                data.put("status", "Fail");
                                data.put("errorMessage", o);
                                handler.post(new Runnable() {
                                    @Override
                                    public void run() {
                                        channel.invokeMethod("upshotRewardHistoryResponse", data);
                                    }
                                });
                            }
                        });
            }
                break;
            case "fetchRewardRules": {
                String programId = (String) call.arguments;
                BrandKinesis.getBKInstance().getRewardDetailsForProgramId(context, programId,
                        new BKRewardsResponseListener() {
                            @Override
                            public void rewardsResponse(Object o) {
                                HashMap<String, Object> data = new HashMap<>();
                                data.put("status", "Success");
                                data.put("response", o);
                                handler.post(new Runnable() {
                                    @Override
                                    public void run() {
                                        channel.invokeMethod("upshotRewardRulesResponse", data);
                                    }
                                });
                            }

                            @Override
                            public void onErrorReceived(Object o) {
                                HashMap<String, Object> data = new HashMap<>();
                                data.put("status", "Fail");
                                data.put("errorMessage", o);
                                handler.post(new Runnable() {
                                    @Override
                                    public void run() {
                                        channel.invokeMethod("upshotRewardRulesResponse", data);
                                    }
                                });
                            }
                        });
            }
                break;
            case "redeemRewards": {

                String programId = call.argument("programId");
                int redeemAmount = call.argument("redeemAmount");
                int transactionValue = call.argument("transactionValue");
                String tag = call.argument("tag");

                BrandKinesis.getBKInstance().redeemRewardsWithProgramId(context, programId, transactionValue,
                        redeemAmount, tag, new BKRewardsResponseListener() {
                            @Override
                            public void rewardsResponse(Object o) {

                                HashMap<String, Object> data = new HashMap<>();
                                data.put("status", "Success");
                                data.put("response", o);
                                handler.post(new Runnable() {
                                    @Override
                                    public void run() {
                                        channel.invokeMethod("upshotRedeemRewardsResponse", data);
                                    }
                                });
                            }

                            @Override
                            public void onErrorReceived(Object o) {
                                HashMap<String, Object> data = new HashMap<>();
                                data.put("status", "Fail");
                                data.put("errorMessage", o);
                                handler.post(new Runnable() {
                                    @Override
                                    public void run() {
                                        channel.invokeMethod("upshotRedeemRewardsResponse", data);
                                    }
                                });
                            }
                        });

            }
                break;
            case "disableUser": {

                boolean disable = (boolean) call.arguments;
                BrandKinesis.getBKInstance().disableUser(disable, context, new BrandKinesisUserStateCompletion() {
                    @Override
                    public void userStateCompletion(final boolean status) {

                    }
                });
            }
                break;
            case "getNotifications": {
                boolean loadMore = call.argument("loadMore");
                boolean fetchFromStart = !loadMore;
                int limit = call.argument("limit");
                BrandKinesis.getBKInstance().getNotifications(context, fetchFromStart, limit,
                        new BKNotificationsResponseListener() {
                            @Override
                            public void notificationsResponse(Object o) {
                                HashMap<String, Object> data = new HashMap<>();
                                data.put("status", "Success");
                                data.put("response", o);
                                handler.post(new Runnable() {
                                    @Override
                                    public void run() {
                                        channel.invokeMethod("upshotGetNotifications", data);
                                    }
                                });
                            }

                            @Override
                            public void onErrorReceived(Object o) {
                                HashMap<String, Object> data = new HashMap<>();
                                data.put("status", "Fail");
                                data.put("errorMessage", o);
                                handler.post(new Runnable() {
                                    @Override
                                    public void run() {
                                        channel.invokeMethod("upshotGetNotifications", data);
                                    }
                                });
                            }
                        });
            }
                break;
            case "showInboxScreen": {
                HashMap<String, Object> options = (HashMap<String, Object>) call.arguments;
                int inboxType = Integer.parseInt(options.get("BKInboxType").toString());
                Boolean readNotifications = (Boolean) options.get("BKShowReadNotifications");
                options.put("bkShowReadNotifications", readNotifications);
                options.put("bkInboxType", inboxType);
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        BrandKinesis.getBKInstance().showInboxActivity(context, convertMapToBundle(options), null);
                    }
                });
            }
                break;
            case "getUnreadNotificationsCount": {

                HashMap<String, Object> options = (HashMap<String, Object>) call.arguments;
                int inboxType = Integer.parseInt(options.get("inboxType").toString());
                int limit = Integer.parseInt(options.get("limit").toString());

                BrandKinesis.getBKInstance().getUnreadNotificationsCount(context, limit, inboxType,
                        new BKNotificationsCountResponseListener() {
                            @Override
                            public void notificationsCount(int i) {
                                HashMap<String, Object> data = new HashMap<>();
                                data.put("count", i);
                                handler.post(new Runnable() {
                                    @Override
                                    public void run() {
                                        channel.invokeMethod("upshotUnreadNotificationsCount", data);
                                    }
                                });
                            }
                        });
            }

            case "setTechnologyType": {

                // Call JAVA Funtion with value flutter
                Log.d("Upshot", "setTechnologyType");
                BrandKinesis.getBKInstance().setTechnologyType(context, "Flutter");
            }
                break;

            case "activityShown_Internal": {
                HashMap<String, Object> payload = (HashMap<String, Object>) call.arguments;

                BrandKinesis.getBKInstance().activityPresentedCallback(payload);
                break;
            }

            case "activitySkiped_Internal": {
                HashMap<String, Object> payload = (HashMap<String, Object>) call.arguments;

                BrandKinesis.getBKInstance().activitySkipCallback(payload);
                break;
            }
            case "activityDismiss_Internal": {
                HashMap<String, Object> payload = (HashMap<String, Object>) call.arguments;
                // String payload=call.arguments.toString();
                BrandKinesis.getBKInstance().activityRespondCallback(payload);
                break;
            }
            case "activityRedirection_Internal": {
                HashMap<String, Object> payload = (HashMap<String, Object>) call.arguments;
                BrandKinesis.getBKInstance().activityRedirectionCallback(payload);
                break;
            }
            case "fetchStreaks": {
                String streakData = BrandKinesis.getBKInstance().getStreakData();
                try {
                    JSONObject jsonObject = new JSONObject(streakData);
                    JSONArray streakObj = jsonObject.getJSONArray("streakData");
                    String jsonString = streakObj.toString();
                    HashMap<String, Object> data = new HashMap<>();
                    data.put("response", streakData);
                    handler.post(new Runnable() {
                        @Override
                        public void run() {
                            channel.invokeMethod("upshotStreakResponse", data);
                        }
                    });
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            case "fetchWebViewHeight":{
                Map<String,Object> payload= (Map<String, Object>) call.arguments;
                try{
                    final int height= helper.calculateWebViewHeight(context,payload);
                    Log.e("webView","The description is"+payload);
                    internal_channel.invokeMethod("webViewHeight",height);
                }catch (Exception e){
                    e.printStackTrace();
                }

            }
            default:
                Log.d("Upshot", "No Method");
        }
    }

    private static Bundle convertMapToBundle(HashMap<String, Object> data) {

        Bundle bundle = new Bundle();
        Iterator<String> iterator = data.keySet().iterator();
        while (iterator.hasNext()) {

            String key = iterator.next();
            Object value = data.get(key);
            try {

                if (value == null) {
                    bundle.putString(key, null);
                } else if (value instanceof Number) {
                    bundle.putInt(key, (Integer) value);
                } else if (value instanceof String) {
                    bundle.putString(key, (String) value);
                } else if (value instanceof Boolean) {
                    boolean boolValue = (boolean) value;
                    bundle.putBoolean(key, boolValue);
                } else if (value.getClass().isArray() || value instanceof Map || value instanceof List) {

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                        Object json = JSONObject.wrap(value);
                        if (json instanceof JSONArray || json instanceof JSONObject) {
                            bundle.putString(key, json.toString());
                        } else {
                            Log.i("Data", "invalid value for '" + key);
                        }
                    } else {
                        Log.i("Data", "invalid value for '" + key);
                    }
                } else {

                    Log.i("Data", "invalid value for '" + key);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return bundle;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
