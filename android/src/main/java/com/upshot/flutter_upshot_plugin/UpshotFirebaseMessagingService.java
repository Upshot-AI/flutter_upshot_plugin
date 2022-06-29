package com.upshot.flutter_upshot_plugin;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import androidx.annotation.NonNull;


import com.brandkinesis.BrandKinesis;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import java.util.Map;

public class UpshotFirebaseMessagingService extends FirebaseMessagingService {

    @Override
    public void onNewToken(@NonNull String token) {
        super.onNewToken(token);
    }

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);

        Bundle bundle = new Bundle();
        for (Map.Entry<String, String> entry : remoteMessage.getData().entrySet()) {
            bundle.putString(entry.getKey(), entry.getValue());
        }
        if (bundle.containsKey("bk")) {
            sendPushBundleToBK(bundle, this, true);            
        } else {
            if (FlutterUpshotPlugin.pushReceiveSinkChannel != null) {
                Map<String, String> remoteData = remoteMessage.getData();
                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        FlutterUpshotPlugin.pushReceiveSinkChannel.success(remoteData);
                    }
                });
            }
        }
    }

    private void sendPushBundleToBK(final Bundle pushBundle, final Context mContext, boolean allowPushForeground) {

        BrandKinesis bkInstance1 = BrandKinesis.getBKInstance();
        bkInstance1.buildEnhancedPushNotification(mContext, pushBundle, allowPushForeground);
    }
}
