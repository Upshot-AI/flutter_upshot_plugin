package com.upshot.flutter_upshot_plugin;

import android.app.Activity;
import android.content.Context;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.view.View;

import androidx.annotation.NonNull;

import com.brandkinesis.BrandKinesis;
import com.brandkinesis.activitymanager.BKActivityTypes;
import com.brandkinesis.callback.BKBadgeAccessListener;
import com.brandkinesis.callback.BKInboxAccessListener;
import com.brandkinesis.callback.BrandKinesisCallback;
import com.brandkinesis.rewards.BKRewardsResponseListener;
import com.brandkinesis.utils.BKAppStatusUtil;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterUpshotPlugin */
public class FlutterUpshotPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Handler handler;

  private Context context;
  HashMap<String, List<HashMap<String, Object>>> badgesResult;

  public static HashMap<String, Object> options = null;
  public static String initType = null;
  UpshotHelper helper = new UpshotHelper();

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_upshot_plugin");
    channel.setMethodCallHandler(this);
    this.context = flutterPluginBinding.getApplicationContext();
    handler = new Handler(Looper.getMainLooper());
  }

  BKAppStatusUtil.BKAppStatusListener listener = new BKAppStatusUtil.BKAppStatusListener() {
    @Override
    public void onAppComesForeground(Activity activity) {
      if (initType != null) {
        setUpshotGlobalCallback();
        if (initType == "Config") {
          helper.initializeUsingConfig(context);
        } else if(initType == "Options"){
          helper.initialize(options, context);
        }
      }
    }

    @Override
    public void onAppGoesBackground() {
      helper.terminateUpshot(context);
    }

    @Override
    public void onAppRemovedFromRecentsList() {
      Log.e("App status==", "removed from recent list");
    }
  };

  private void setUpshotGlobalCallback() {
    BrandKinesis bkInstance = BrandKinesis.getBKInstance();
    bkInstance.setBrandkinesisCallback(new BrandKinesisCallback() {
      @Override
      public void userStateCompletion(boolean status) {

      }

      @Override
      public void onUserInfoUploaded(boolean uploadSuccess) {

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
        Log.e("Badges","Badges are: \n" + badges.values());
        badgesResult = badges;
      }

      @Override
      public void onAuthenticationError(String errorMsg) {

        HashMap<String, String> response = new HashMap<>();
        response.put("status","Fail");
        response.put("errorMessage",errorMsg);
        channel.invokeMethod("upshotAuthenticationStatus", response);
      }

      @Override
      public void onAuthenticationSuccess() {
        handler.post(new Runnable() {
        @Override
        public void run() {
          HashMap<String, String> response = new HashMap<>();
          response.put("status","Success");
          response.put("errorMessage","");
          channel.invokeMethod("upshotAuthenticationStatus", response);
        }
        });
      }

      @Override
      public void onActivityError(int error) {

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
      public void brandKinesisActivityPerformedActionWithParams(BKActivityTypes activityType, Map<String, Object> actionData) {

        handler.post(new Runnable() {
          @Override
          public void run() {
            String data = (String) actionData.get("deepLink");
            HashMap<String, Object> response = new HashMap<>();
            response.put("activityType", activityType.getValue());
            if (data != null) {
              try {
                JSONObject deeplinkJSON = new JSONObject(data);
                HashMap<String, Object> keyValue = new HashMap<>();
                keyValue.put("deepLink_keyValue", deeplinkJSON);
                response.put("params", keyValue);
                channel.invokeMethod("upshotActivityDidDismiss", response);
              } catch (JSONException e) {
                response.put("params", actionData);
                channel.invokeMethod("upshotActivityDidDismiss", response);
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
          setUpshotGlobalCallback();
          helper.initializeUsingConfig(context);
          initType = "Config";
          BKAppStatusUtil.getInstance().register(context, listener);
        }
        break;
        case "initializeUsingOptions": {
          HashMap<String , Object> data = (HashMap<String, Object>) call.arguments;
          helper.initialize(data, context);
          setUpshotGlobalCallback();
          initType = "Options";
          BKAppStatusUtil.getInstance().register(context, listener);
        }
        break;
        case "terminate":
        break;
        case "sendUserDetails":{
          HashMap<String , Object> data = (HashMap<String, Object>) call.arguments;
          helper.setUserProfile(data.toString());
        }
        break;
        case "getUserDetails": {
          Map<String, Object> details = helper.getUserDetails();
          result.success(details);
        }
        break;
        case "sendLogoutDetails": {
          helper.logoutDetails();
        }
        break;
        case "sendDeviceToken":{
          String token = (String) call.arguments;
          helper.updateDeviceToken(token);
        }
        break;
        case "sendPushClickDetails":{ }
        break;
        case "getUserId":{
          result.success(helper.getUserId(context));
        }
        break;
        case "getSDKVersion":{
          result.success(helper.getSDKVersion());
        }
        break;
        case "createCustomEvent":{
          String eventName = call.argument("eventName");
          HashMap<String , Object> data = call.argument("data");
          boolean isTimed = call.argument("isTimed");

          String eventID =  helper.createCustomEvent(data, eventName, isTimed);
          if (eventID == null || eventID.isEmpty()){
            result.error("400","Fail to create event",0);
          }else{
            result.success(eventID);
          }
        }
        break;
        case "createPageViewEvent": {
          String pageName = (String) call.arguments;
          String eventID = helper.createPageEvent(pageName);
          if (eventID == null || eventID.isEmpty()){
            result.error("400","Fail to create event",0);
          }else{
            result.success(eventID);
          }
        }
        break;

        case "createAttributionEvent":{
          HashMap<String, String> data = (HashMap<String, String>) call.arguments;
          String eventId = helper.createAttributionEvent(data);
          if (eventId == null || eventId.isEmpty()) {
            result.error("400","Fail to create event",0);
          } else  {
            result.success(eventId);
          }
        }
        break;
        case "createLocationEvent":{
          BrandKinesis bkInstance = BrandKinesis.getBKInstance();
          String latitude = call.argument("latitude");
          String longitude = call.argument("longitude");
          helper.createLocationEvent(Double.parseDouble(latitude), Double.parseDouble(longitude));
        }
        break;
        case "setValueAndClose":{
          String eventId = call.argument("eventId");
          HashMap<String , Object> data = call.argument("data");
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
        case "showActivity": {
          String tag = call.argument("tag");
          Integer type = call.argument("activityType");
          helper.getActivity(tag, type, context);
        }
        break;
        case "showActivityWithId": {
          String activityId = (String) call.arguments;
          helper.getActivityById(activityId);
        }
        break;
        case "removeTutorial":{
          helper.removeTuroial(context);
        }
        break;
        case "getBadges":{
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

        case "getInboxDetails":{
          BrandKinesis.getBKInstance().fetchInboxInfo(new BKInboxAccessListener() {
            @Override
            public void onMessagesAvailable(List<HashMap<String, Object>> list) {
              handler.post(new Runnable() {
                @Override
                public void run() {
                  HashMap<String, Object> data = new HashMap<>();
                  if (list.size() > 0) {
                    data.put("data", list);
                    channel.invokeMethod("upshotCampaignDetails", data);
                  }
                }
              });
            }
          });
        }
        break;
        case "fetchRewards": {
          BrandKinesis.getBKInstance().getRewardsStatusWithCompletionBlock(context, new BKRewardsResponseListener() {
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

          BrandKinesis.getBKInstance().getRewardHistoryForProgramId(context, programId, historyType, new BKRewardsResponseListener() {
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
            BrandKinesis.getBKInstance().getRewardDetailsForProgramId(context, programId, new BKRewardsResponseListener() {
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

          BrandKinesis.getBKInstance().redeemRewardsWithProgramId(context, programId, redeemAmount, transactionValue, tag, new BKRewardsResponseListener() {
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
        default:
          Log.d("Upshot","No Method");
      }
  }


  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
