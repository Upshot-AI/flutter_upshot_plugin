package com.upshot.flutter_upshot_plugin;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import io.flutter.app.FlutterActivity;

import androidx.annotation.NonNull;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.brandkinesis.BrandKinesis;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class BKPushAction extends BroadcastReceiver implements FlutterPlugin, MethodChannel.MethodCallHandler, PluginRegistry.NewIntentListener, ActivityAware {

    private MethodChannel channel;
    private Activity mainActivity;
    private Map payload;
//    private RemoteMessage initialMessage;

    @Override
    public void onReceive(final Context context, Intent intent) {

        final Bundle bundle = intent.getExtras();
        if (bundle != null && bundle.containsKey("bk")) {
            String channelName = "flutter_upshot_plugin";
//            channel = new MethodChannel(FlutterUpshotPlugin.messenger, channelName);
            //If push contains buttons, Button action data will get from actionData
            String actionData = bundle.getString("actionData");
            //If push contains deeplink, Data will get from appData
            String appData = intent.getStringExtra("appData");
            payload = new HashMap<>();
            if (appData != null) {
                payload.put("appData", appData);
            }
            if (actionData != null) {
                payload.put("actionData", actionData);
            }
            Class mainActivity = null;
            String packageName = context.getPackageName();
            Intent launchIntent = context.getPackageManager().getLaunchIntentForPackage(packageName);
            String className = launchIntent.getComponent().getClassName();
            try { //loading the Main Activity to not import it in the plugin
                mainActivity = Class.forName(className);
            } catch (Exception e) {
                e.printStackTrace();
            }
            if (mainActivity == null) {
                return;
            }

            launchIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
            launchIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
//            new UpshotEventEmitter().emit("sendCallback", payload.toString());
            FlutterUpshotPlugin.eventSinkChannel.success(payload);
//            channel.invokeMethod("upshotPushClickPayload", payload);
//             context.startActivity(launchIntent);

        }


//            FlutterUpshotPlugin.pushClickData(payload);


//            Intent intent1 = null;
//            String url = null;
//            JSONObject data = null;
//            try {
//                data = new JSONObject(appData);
//                if (data.has("deepLink")) {
//                    url = data.getString("deepLink");
//                }/**
//                 * Along with deeplink we can pass key, value pairs (if needed) and we can use.*/
//                else if (data.has("key1")) {
//                    url = data.getString("key1");
//                } else if (data.has("key2")) {
//                    url = data.getString("key2");
//                }
//            } catch (JSONException e) {
//                e.printStackTrace();
//            }
//
//            if (!TextUtils.isEmpty(url)) {
//                //Based on conditions Redirect to specific activity
//            } else {
                /**
                 * When tap the push launching the application(Application Home activity).
                 */
//                Intent i = new Intent(context, SplashScreenActivity.class);
//                if (i == null) {
//                    return;
//                }
//                i.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK |
//                        Intent.FLAG_ACTIVITY_CLEAR_TASK);
//                i.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK |
//                        Intent.FLAG_ACTIVITY_CLEAR_TASK);
//                i.putExtra("actionValue", action);
//                i.putExtra("appData", appData);
//                i.putExtra("launchOptions", launchOptions);
//                context.startActivity(i);
//            }
            BrandKinesis bkInstance = BrandKinesis.getBKInstance();
            bkInstance.handlePushNotification(context, bundle);
        }


        private void initInstance(BinaryMessenger messenger) {

        channel.setMethodCallHandler(this);

        // Register broadcast receiver
//        IntentFilter intentFilter = new IntentFilter();
//        intentFilter.addAction(FlutterFirebaseMessagingUtils.ACTION_TOKEN);
//        intentFilter.addAction(FlutterFirebaseMessagingUtils.ACTION_REMOTE_MESSAGE);
//        LocalBroadcastManager manager =
//                LocalBroadcastManager.getInstance(ContextHolder.getApplicationContext());
//        manager.registerReceiver(this, intentFilter);
//
//        registerPlugin(channelName, this);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        initInstance(binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        if (binding.getApplicationContext() != null) {
            LocalBroadcastManager.getInstance(binding.getApplicationContext()).unregisterReceiver(this);
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

    }

    @Override
    public boolean onNewIntent(Intent intent) {

        if (intent == null || intent.getExtras() == null) {
            return false;
        }
        if (payload == null) {
            return false;
        }
        channel.invokeMethod("upshotPushClick", payload);
        mainActivity.setIntent(intent);
        return true;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        binding.addOnNewIntentListener(this);
        this.mainActivity = binding.getActivity();
        if (mainActivity.getIntent() != null && mainActivity.getIntent().getExtras() != null) {
            if ((mainActivity.getIntent().getFlags() & Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY)
                    != Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY) {
                onNewIntent(mainActivity.getIntent());
            }
        }
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        binding.addOnNewIntentListener(this);
        this.mainActivity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {

    }
}