package com.upshot.flutter_upshot_plugin;

import static java.lang.System.out;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.opengl.Visibility;
import android.os.Build;
import android.text.Editable;
import android.text.Html;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.text.HtmlCompat;

import org.w3c.dom.Text;
import org.xml.sax.XMLReader;

import java.util.Map;
import java.util.Objects;

import io.flutter.FlutterInjector;
import io.flutter.Log;
import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class NativeTutorialUI implements PlatformView {
    @NonNull private final WebView webView;
    @NonNull private final TextView textView;

    @NonNull private final  LinearLayout linearLayout;


    NativeTutorialUI(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams, @NonNull MethodChannel internalChannel) {
        textView=new TextView(context);
        webView=new WebView(context);
        linearLayout=new LinearLayout(context);
        linearLayout.removeAllViews();
        float textSize;
        String description;
        float dpiValue=context.getResources().getDisplayMetrics().density;

        String fontName="ShantellSans-Medium";
        if(creationParams.get("text_size") !=null){
            textSize =Float.parseFloat(Objects.requireNonNull(creationParams.get("text_size")).toString());
        }
//        else if (creationParams.get("font_name")!=null) {
//            fontName=creationParams.get("font_name").toString();
//        }
        else{
            textSize =25;
//            fontName="PFHandbookPro-Medium";
        }

        if(creationParams.get("description") !=null){
            out.println(Objects.requireNonNull(creationParams.get("description")));
            description= Objects.requireNonNull(creationParams.get("description")).toString();
        }else{
            description="";
        }
        FlutterLoader loader = FlutterInjector.instance().flutterLoader();
        String key = loader.getLookupKeyForAsset("fonts/" + fontName + ".ttf");
//        String key = loader.getLookupKeyForAsset("assets/UpshotCustomisation.json");
//        System.out.println("The real key is "+key);
        final String startHtml="<html><head><style type=\"text/css\" > @font-face {font-family:MyFont;src:url(\"file:///"+key+"\")}p,body {font-family:MyFont;font-size:"+textSize+";}</style></head><body>";
        final String endHtml="</body></html>";


        webView.loadDataWithBaseURL(null,startHtml+description+endHtml,"text/html; charset=utf-8","utf8",null);
        webView.setBackgroundColor(Color.TRANSPARENT);
        textView.setText(HtmlCompat.fromHtml(description, HtmlCompat.FROM_HTML_MODE_LEGACY));
        textView.setTextSize(textSize);

        final ViewTreeObserver vto = textView.getViewTreeObserver();
        vto.addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @SuppressLint("NewApi")
            @Override
            public void onGlobalLayout() {
                out.println("The dp value is"+dpiValue);
                out.println("The pixel height is"+textView.getHeight());
                out.println("The dp height is"+textView.getHeight()/(dpiValue));
                 internalChannel.invokeMethod("get_height",textView.getHeight()  / context.getResources().getDisplayMetrics().density);
                textView.setVisibility(View.GONE);
                // remove this layout listener - as it will run every time the view updates
                if (textView.getViewTreeObserver().isAlive()) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                        textView.getViewTreeObserver()
                                .removeOnGlobalLayoutListener(this);
                    } else {
                        textView.getViewTreeObserver()
                                .removeGlobalOnLayoutListener(this);
                    }
                }
            }
        });

        linearLayout.addView(textView);
        linearLayout.addView(webView);

    }

    @NonNull
    @Override
    public View getView() {
        return linearLayout;
    }

    @Override
    public void dispose() {
        webView.destroy();
    }


}

class CustomTagHandler implements Html.TagHandler {

    @Override
    public void handleTag(boolean b, String s, Editable editable, XMLReader xmlReader) {
        out.println("The tag is"+s);
    }
}
