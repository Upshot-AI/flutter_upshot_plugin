package com.upshot.flutter_upshot_plugin;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class NativeTutorialViewFactory extends PlatformViewFactory {
//    @NonNull private final String path;
    NativeTutorialViewFactory() {
        super(StandardMessageCodec.INSTANCE);
//        this.path=path;
    }

    @NonNull
    @Override
    public PlatformView create(@NonNull Context context, int id, @Nullable Object args) {
        final Map<String, Object> creationParams = (Map<String, Object>) args;
        return new NativeTutorialUI(context, id, creationParams);
    }
}
