package com.upshot.flutter_upshot_plugin;

import android.app.Activity;
import android.os.Bundle;
import android.os.StrictMode;

import com.brandkinesis.BKProperties;
import com.brandkinesis.BrandKinesis;
import com.brandkinesis.utils.BKAppStatusUtil;

import java.util.HashMap;

import io.flutter.app.FlutterApplication;

public class UpshotApplication extends FlutterApplication {
    private static UpshotApplication application;
    public static String initType = "";
    public static HashMap<String, Object> options = null;

    private UpshotListener customListener;
    @Override
    public void onCreate() {
        super.onCreate();

        application = this;
        BKAppStatusUtil.getInstance().register(this, listener);
        strictModePolicy();
    }

    BKAppStatusUtil.BKAppStatusListener listener = new BKAppStatusUtil.BKAppStatusListener() {
        @Override
        public void onAppComesForeground(Activity activity) {

            if (customListener != null) {
                customListener.onAppComesForeground(activity);
            }
            if (!initType.isEmpty()) {
                if (initType == "Config") {
                    initializeUsingConfig();
                } else if (initType == "Options") {
                    initializeUsingOptions();
                }
            }
        }


        @Override
        public void onAppGoesBackground() {
            BrandKinesis.getBKInstance().terminate(application);
        }

        @Override
        public void onAppRemovedFromRecentsList() {

        }
    };

    private void initializeUsingConfig() {
        try {
            BrandKinesis.initialiseBrandKinesis(this, null);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void initializeUsingOptions() {
        if (options == null) {
            return;
        }
        String appId = "";
        if (options.containsKey("appId")) {
           appId = (String) options.get("appId");
        }

        String ownerId = "";
        if (options.containsKey("ownerId")) {
            ownerId = (String) options.get("ownerId");
        }

        boolean fetchLocation = false;
        if (options.containsKey("enableLocation")) {
            fetchLocation = (boolean) options.get("enableLocation");
        }
        boolean enableDebugLogs = false;
        if (options.containsKey("enableDebuglogs")) {
            enableDebugLogs = (boolean) options.get("enableDebuglogs");
        }
        boolean useExternalStorage = false;
        if (options.containsKey("enableExternalStorage")) {
            useExternalStorage = (boolean) options.get("enableExternalStorage");
        }

        boolean enableCrashLogs = false;
        if (options.containsKey("enableCrashlogs")) {
            enableCrashLogs = (boolean) options.get("enableCrashlogs");
        }

        if (appId != null && ownerId != null && !appId.isEmpty() && !ownerId.isEmpty()) {
            Bundle bundle = new Bundle();
            bundle.putString(BKProperties.BK_APPLICATION_ID, appId);
            bundle.putString(BKProperties.BK_APPLICATION_OWNER_ID, ownerId);
            bundle.putBoolean(BKProperties.BK_FETCH_LOCATION, fetchLocation);
            bundle.putBoolean(BKProperties.BK_ENABLE_DEBUG_LOGS, enableDebugLogs);
            bundle.putBoolean(BKProperties.BK_USE_EXTERNAL_STORAGE, useExternalStorage);
            bundle.putBoolean(BKProperties.BK_EXCEPTION_HANDLER, enableCrashLogs);
            BrandKinesis.initialiseBrandKinesis(this, bundle, null);
        }
    }

    private void strictModePolicy() {
        StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
        StrictMode.setVmPolicy(builder.build());
    }

    public void setCustomListener(UpshotListener customListener) {
        this.customListener = customListener;
    }

    public static UpshotApplication getApplicationInstance() {
        return application;
    }

}