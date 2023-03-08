package com.upshot.flutter_upshot_plugin;

import static java.lang.System.out;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.text.Editable;
import android.text.Html;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.text.HtmlCompat;

import org.xml.sax.XMLReader;

import java.util.Map;
import java.util.Objects;

import io.flutter.FlutterInjector;
import io.flutter.Log;
import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.plugin.platform.PlatformView;

public class NativeTutorialUI implements PlatformView {
    @NonNull private final WebView webView;

    NativeTutorialUI(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {
        float textSize = 0;
        String fontName="ShantellSans-Medium";
        final int[] height = {0};
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
        FlutterLoader loader = FlutterInjector.instance().flutterLoader();
////        FlutterLoader loader = FlutterInjector.instance().flutterLoader();
        String key = loader.getLookupKeyForAsset("fonts/" + fontName + ".ttf");
//        String key = loader.getLookupKeyForAsset("assets/UpshotCustomisation.json");
//        System.out.println("The real key is "+key);
        String description;
        final String startHtml="<html><head><style type=\"text/css\" > @font-face {font-family:MyFont;src:url(\"file:///"+key+"\")}p,body {font-family:MyFont;font-size:"+textSize+";}</style></head><body>";
        final String endHtml="</body></html>";

        if(creationParams.get("description") !=null){
            out.println(Objects.requireNonNull(creationParams.get("description")));
            description= Objects.requireNonNull(creationParams.get("description")).toString();
        }else{
            description="";
        }

        webView= new WebView(context);
        webView.loadDataWithBaseURL(null,startHtml+description+endHtml,"text/html; charset=utf-8","utf8",null);
//        webView.loadData(startHtml+description+endHtml,"text/html","UTF-8");
        webView.setBackgroundColor(Color.TRANSPARENT);
        TextView textView=new TextView(context);
        textView.setText(HtmlCompat.fromHtml(description, 0));

        Paint paint = textView.getPaint();
        Rect bounds = new Rect();
        paint.getTextBounds(textView.getText().toString(), 0, textView.getText().length(), bounds);
        out.println("The bounds height is "+bounds.height());
//        int heightMeasure=View.MeasureSpec.makeMeasureSpec(0,View.MeasureSpec.UNSPECIFIED);
//        int widthMeasure=View.MeasureSpec.makeMeasureSpec(0,View.MeasureSpec.UNSPECIFIED);
//        textView.measure(View.MeasureSpec.makeMeasureSpec(0,View.MeasureSpec.UNSPECIFIED),View.MeasureSpec.makeMeasureSpec(0,View.MeasureSpec.UNSPECIFIED));

        out.println("The description is" + textView.getText());
        out.println("The text real height return is  lineHeight: " +textView.getLineHeight() + "  minHeight : " + textView.getMinHeight() + "  measuredheight :"+textView.getMeasuredHeight() + " getHeight :" + textView.getHeight());
//        webView.getSettings().font
//        description="<p style=\"fo    nt-family: Arial, proxima-nova, sans-serif; color: #000000;\">This is the first comment <span style=\"color: red;\">section</span><br /><span style=\"color: yellow\">This is the second comment section<br /><span style=\"color: #000000;\">This is the <span style=\"color: #e03e2d;\">third </span>comment section</span></span></p>";
//        textView = new TextView(context);
//        textView.setTextSize(textSize);
//        textView.setBackgroundColor(Color.TRANSPARENT);
//        textView.setText(HtmlCompat.fromHtml(description,HtmlCompat.FROM_HTML_MODE_LEGACY));
        out.println("The text is"+description);
        out.println("The text size is"+textSize);
    }

    @NonNull
    @Override
    public View getView() {
        System.out.println("The webview return height is "+webView.getContentHeight());

        return webView;
    }

    @Override
    public void dispose() {
        webView.destroy();

    }
}
