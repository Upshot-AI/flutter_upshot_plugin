package com.upshot.flutter_upshot_plugin;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import com.brandkinesis.BrandKinesis;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

public class BKPushAction extends BroadcastReceiver {

    public static Map<String, String> bundleToMap(Bundle extras) {
        Map<String, String> map = new HashMap<String, String>();

        Set<String> ks = extras.keySet();
        Iterator<String> iterator = ks.iterator();
        while (iterator.hasNext()) {
            String key = iterator.next();
            map.put(key, extras.getString(key));
        } /* from w ww .j a v a 2s .c o m */
        return map;
    }

    @Override
    public void onReceive(final Context context, Intent intent) {

        final Bundle bundle = intent.getExtras();
        if (bundle != null && bundle.containsKey("bk")) {

            Class mainActivity = null;
            String packageName = context.getPackageName();
            Intent launchIntent = context.getPackageManager().getLaunchIntentForPackage(packageName);
            String className = launchIntent.getComponent().getClassName();
            try { // loading the Main Activity to not import it in the plugin
                mainActivity = Class.forName(className);
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
            if (mainActivity == null) {
                return;
            }
            launchIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
            launchIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(launchIntent);
            BrandKinesis bkInstance = BrandKinesis.getBKInstance();
            bkInstance.handlePushNotification(context, bundle);

            if (FlutterUpshotPlugin.eventSinkChannel != null) {
                FlutterUpshotPlugin.eventSinkChannel.success(bundleToMap(bundle));
            } else {
                FlutterUpshotPlugin.onEventSinkChannelListener(new EventSinkChannelCallback() {
                    @Override
                    public void onEventSinkChannelReady() {
                        FlutterUpshotPlugin.eventSinkChannel.success(bundleToMap(bundle));
                    }
                });
            }
        }

    }
}