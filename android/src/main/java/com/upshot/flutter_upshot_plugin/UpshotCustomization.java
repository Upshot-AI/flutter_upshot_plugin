package com.upshot.flutter_upshot_plugin;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.LayerDrawable;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.StateListDrawable;
import android.graphics.drawable.shapes.RectShape;
import android.text.TextUtils;
import android.util.StateSet;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.SeekBar;
import android.widget.TextView;

import com.brandkinesis.BKUIPrefComponents;
import com.brandkinesis.BKUIPrefComponents.BKActivityButtonTypes;
import com.brandkinesis.BKUIPrefComponents.BKActivityColorTypes;
import com.brandkinesis.BKUIPrefComponents.BKActivityImageViewType;
import com.brandkinesis.BKUIPrefComponents.BKActivityRatingTypes;
import com.brandkinesis.BKUIPrefComponents.BKActivityTextViewTypes;
import com.brandkinesis.BKUIPrefComponents.BKBGColors;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import static com.brandkinesis.BKUIPrefComponents.BKActivityImageButtonTypes;
import static com.brandkinesis.BKUIPrefComponents.BKUICheckBox;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.Log;
import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

public class UpshotCustomization {

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

    private int validateJsonInt(JSONObject json, String key) {

        try {
            if (json.has(key) && json.get(key) != null) {
                if (json.get(key) instanceof Integer) {
                    return json.getInt(key);
                } else if (json.get(key) instanceof String) {
                    try {
                        return Integer.parseInt(json.getString(key));
                    } catch (Exception e) {
                        return 0;
                    }
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public String validateJsonString(JSONObject json, String key) {

        try {
            if (json.has(key)) {
                if (json.get(key) == null || !(json.get(key) instanceof String)) {
                    return "";
                } else {
                    return json.getString(key);
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return "";
    }

    private static Drawable generateDrawableRectangle(int backgroundColor, int borderColor, Button button) {
        // Default state
//        GradientDrawable background = new GradientDrawable();
//        background.setShape(GradientDrawable.RECTANGLE);
//        background.setColor(backgroundColor);
//        background.setStroke(4, borderColor);
//        return  background;
//        StateListDrawable stateListDrawable = new StateListDrawable();
//        stateListDrawable.addState(StateSet.WILD_CARD, background);

//        GradientDrawable topGradient = new GradientDrawable(
//                GradientDrawable.Orientation.TOP_BOTTOM,
//                new int[]{0xFF0000FF, 0xFF000000}); // Top to bottom gradient (Blue to Black)
//
//        GradientDrawable bottomGradient = new GradientDrawable(
//                GradientDrawable.Orientation.TOP_BOTTOM,
//                new int[]{0xFF00FF00, 0xFF000000}); // Top to bottom gradient (Green to Black)

        // Create a layer list drawable and set the gradients as layers
//        LayerDrawable layerDrawable = new LayerDrawable(new Drawable[]{topGradient, bottomGradient});

//        return  layerDrawable;
//        GradientDrawable gd = new GradientDrawable();
//        gd.setShape(GradientDrawable.RECTANGLE);
//
//        gd.setColor(Color.RED); // Changes this drawbale to use a single color instead of a gradient
//        gd.setCornerRadius(8);
//        gd.setStroke(10, Color.BLUE);
//        TextView tv = (TextView)findViewById(R.id.textView1);
//        tv.setBackground(gd);

//        return gd;
        ShapeDrawable shapedrawable = new ShapeDrawable();
        shapedrawable.setShape(new RectShape());
        shapedrawable.getPaint().setColor(Color.RED);
        shapedrawable.getPaint().setStrokeWidth(5f);
        shapedrawable.getPaint().setStyle(Paint.Style.STROKE);

        Canvas canvas = new Canvas();
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q) {
            int rId = button.getSourceLayoutResId();
            Log.d("id", String.valueOf(rId));
        }
        return shapedrawable;

//        Paint paint = new Paint();
//        paint.setStyle(Paint.Style.STROKE);
//        paint.setColor(Color.RED);
//        paint.setStrokeWidth(4);
//        return new BorderDrawable(null);

//        canvas.drawLine(bounds.left, bounds.top, bounds.right, bounds.top, paint);






    }
    private  void  applyBorderRadiusProperties(JSONObject buttonJson, Button button) {

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.JELLY_BEAN_MR2) {
            button.setPadding(5,5,5,5);

            button.setBackground(generateDrawableRectangle(Color.RED, Color.GRAY, button));
        }

    }
    public void applyEditTextProperties(Context mContext, JSONObject submitButtonJsonObject, EditText editText) {
        applyFontAttribute(mContext, editText, submitButtonJsonObject);
        applyTextSizeAttribute(mContext, editText, submitButtonJsonObject);
        applyTextColorAttribute(mContext, editText, submitButtonJsonObject);
    }

    public void applyButtonProperties(Context context, JSONObject submitButtonJsonObject, Button button, FlutterLoader loader, FlutterPlugin.FlutterPluginBinding binding) {
        applyFontAttribute(context, button, submitButtonJsonObject, loader, binding);
        applyTextSizeAttribute(context, button, submitButtonJsonObject);
        applyTextColorAttribute(context, button, submitButtonJsonObject);
        applyBgColorAttribute(context, button, submitButtonJsonObject);
        applyBgImageAttribute(context, button, submitButtonJsonObject);
        applyBorderRadiusProperties(submitButtonJsonObject, button);
    }
    public void applyButtonProperties(Context context, JSONObject submitButtonJsonObject, Button button) {
        applyFontAttribute(context, button, submitButtonJsonObject);
        applyTextSizeAttribute(context, button, submitButtonJsonObject);
        applyTextColorAttribute(context, button, submitButtonJsonObject);
        applyBgColorAttribute(context, button, submitButtonJsonObject);
        applyBgImageAttribute(context, button, submitButtonJsonObject);
    }

    private void setImageResourceToView(Context context, String bgImage, View view) {
        if (!TextUtils.isEmpty(bgImage)) {

            int resourceId = getIdentifier(context, bgImage);
            if (resourceId > 0) {
                if (view instanceof ImageButton) {
                    ((ImageButton)view).setImageResource(resourceId);
                }else if (view instanceof ImageView) {
                    ((ImageView)view).setImageResource(resourceId);
                }
            }
        }
    }



    private void applyImageResourceAttribute(Context context, View view, JSONObject jsonObject) {
        String bgImage = validateJsonString(jsonObject, "image");
        setImageResourceToView(context, bgImage, view);
    }

//    public void applyRelativeLayoutProperties(Context context, String imageName, RelativeLayout view, FlutterLoader loader) {
//        setBgToView(context, imageName, view, loader);
//    }

    public void applyRelativeLayoutProperties(Context context, String imageName, RelativeLayout view) {
        setBgToView(context, imageName, view);
    }

    public void applyImageProperties(Context context, String imageName, ImageView view) {
        setBgToView(context, imageName, view);
    }

    public void applyImageButtonProperties(Context context, JSONObject submitButtonJsonObject, ImageButton button) {
        applyImageResourceAttribute(context, button, submitButtonJsonObject);
    }

    public void applyTextViewProperties(Context context, JSONObject jsonObject, TextView textView) {
        applyFontAttribute(context, textView, jsonObject);
        applyTextSizeAttribute(context, textView, jsonObject);
        applyTextColorAttribute(context, textView, jsonObject);
        applyBgColorAttribute(context, textView, jsonObject);
        applyBgImageAttribute(context, textView, jsonObject);
    }

    public void applyTextViewProperties(Context context, JSONObject jsonObject, TextView textView, FlutterLoader loader, FlutterPlugin.FlutterPluginBinding binding) {
        applyFontAttribute(context, textView, jsonObject, loader, binding);
        applyTextSizeAttribute(context, textView, jsonObject);
        applyTextColorAttribute(context, textView, jsonObject);
        applyBgColorAttribute(context, textView, jsonObject);
        applyBgImageAttribute(context, textView, jsonObject);
    }

    private void applyBgImageAttribute(Context context, View view, JSONObject jsonObject, FlutterLoader loader) {
        String bgImage = validateJsonString(jsonObject, "image");
        setImageToView(context, bgImage, view, loader, null);
    }
    private void applyBgImageAttribute(Context context, View view, JSONObject jsonObject) {
        String bgImage = validateJsonString(jsonObject, "image");
        setBgToView(context, bgImage, view);
    }

    public Bitmap getImageFromAssets(FlutterLoader loader, String imageName, FlutterPlugin.FlutterPluginBinding binding) {

        String imageFilePath = loader.getLookupKeyForAsset("assets/images/"+imageName);
        AssetManager assetManager = binding.getApplicationContext().getAssets();
        try {
            InputStream imageStream = assetManager.open(imageFilePath);
            BitmapFactory.Options options = new BitmapFactory.Options();
            options.inScaled = true;
            Bitmap bitmap = BitmapFactory.decodeStream(imageStream, null, options);
            return bitmap;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return  null;
    }

    private void setBgToView(Context context, String bgImage, View view) {
        if (!TextUtils.isEmpty(bgImage)) {

            int resourceId = getIdentifier(context, bgImage);
            if (resourceId > 0) {
                view.setBackgroundResource(resourceId);
            }
        }
    }

    public void setImageToView(Context context, String imageName, View view, FlutterLoader loader, FlutterPlugin.FlutterPluginBinding binding) {
        if (!TextUtils.isEmpty(imageName)) {
            int resourceId = getIdentifier(context, imageName);
            if (resourceId > 0) {
                view.setBackgroundResource(resourceId);
            }
//            AssetManager assetManager = binding.getApplicationContext().getAssets();

//            try {
//                AssetFileDescriptor fileDescriptor = assetManager.openNonAssetFd("sa");
//
//            } catch (IOException e) {
//                throw new RuntimeException(e);
//            }
//            Bitmap imageMap = getImageFromAssets(loader, imageName, binding);
//            if (view instanceof ImageButton) {
//                ((ImageButton)view).setImageBitmap(imageMap);
//
////                ((ImageButton)view).setImageDrawable(new BitmapDrawable( view.getContext().getResources(), imageMap));
//            } else  {
//                view.setBackground(new BitmapDrawable( view.getContext().getResources(), imageMap));
//            }
//            view.setBackgroundResource(0);

        }
    }



    public int getIdentifier(Context context, String bgImage) {
        try {
            Resources resources = context.getResources();
            int resourceId = resources.getIdentifier(bgImage, "drawable", context.getPackageName());
            return resourceId;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private void applyBgColorAttribute(Context context, View view, JSONObject jsonObject) {
        String bgcolor = validateJsonString(jsonObject, "bgcolor");
        if (!TextUtils.isEmpty(bgcolor)) {
            try {
                view.setBackgroundColor(Color.parseColor(bgcolor));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void applyTextColorAttribute(Context context, View view, JSONObject jsonObject) {
        String text_color = validateJsonString(jsonObject, "color");
        if (!TextUtils.isEmpty(text_color)) {
            try {
                if (view instanceof Button) {
                    ((Button) view).setTextColor(Color.parseColor(text_color));
                } else if (view instanceof TextView) {
                    ((TextView) view).setTextColor(Color.parseColor(text_color));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void applyTextSizeAttribute(Context context, View view, JSONObject jsonObject) {
        int font_size = validateJsonInt(jsonObject, "size");
        try {
            if (view instanceof Button) {
                ((Button) view).setTextSize(font_size);
            } else if (view instanceof TextView) {
                ((TextView) view).setTextSize(font_size);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Typeface getTypeFace(FlutterLoader loader, String fontName, FlutterPlugin.FlutterPluginBinding binding) {

        String fontFilePath = loader.getLookupKeyForAsset("fonts/"+fontName);
        AssetManager assetManager = binding.getApplicationContext().getAssets();
        Typeface typeface = Typeface.createFromAsset(assetManager, fontFilePath);
        return  typeface;
    }
    private void applyFontAttribute(Context context, View view, JSONObject jsonObject, FlutterLoader loader, FlutterPlugin.FlutterPluginBinding binding) {
        String font_name = validateJsonString(jsonObject, "font_name");
        if (!TextUtils.isEmpty(font_name)) {
            try {
                Typeface typeface = getTypeFace(loader, font_name, binding);
                if (view instanceof Button) {
                    ((Button) view).setTypeface(typeface);
                } else if (view instanceof TextView) {
                    ((TextView) view).setTypeface(typeface);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void applyFontAttribute(Context context, View view, JSONObject jsonObject) {
        String font_name = validateJsonString(jsonObject, "font_name");
        if (!TextUtils.isEmpty(font_name)) {
            try {
                Typeface typeface = Typeface.createFromAsset(context.getAssets(), "fonts/" + font_name);
                if (view instanceof Button) {
                    ((Button) view).setTypeface(typeface);
                } else if (view instanceof TextView) {
                    ((TextView) view).setTypeface(typeface);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void customizeSeekBar(BKUIPrefComponents.BKActivitySeekBarTypes seekBarTypes, SeekBar seekBar) {

    }

    public void customizeRelativeLayout(BKUIPrefComponents.BKActivityRelativeLayoutTypes relativeLayoutTypes, RelativeLayout relativeLayout, boolean isFullScreen) {

    }

    public void customizeTextView(BKActivityTextViewTypes textViewType, TextView textView) {

    }

    public void customizeRating(List<Bitmap> selectedRatingList, List<Bitmap> unselectedRatingList, BKActivityRatingTypes ratingType) {

    }

    public void customizeImageView(ImageView imageView, BKActivityImageViewType imageType) {

    }

    public void customizeButton(Button button, BKActivityButtonTypes buttonType) {

    }

    public void customizeImageButton(ImageButton imageButton, BKActivityImageButtonTypes buttonType) {

    }

    public void customizeRadioButton(BKUICheckBox bkUiCheckBox, boolean isCheckBox) {

    }

    public void customizeBGColor(BKBGColors color, BKActivityColorTypes colorType) {

    }

    public void customizeEditText(BKUIPrefComponents.BKActivityEditTextTypes EditTextType, EditText editText) {

    }

    public void customizeForGraphColor(BKUIPrefComponents.BKGraphType graphType, List<Integer> colorsList) {

    }

    public void customizeForLinearLayout(LinearLayout linearLayout, BKUIPrefComponents.BKActivityLinearLayoutTypes linearLayoutTypes){

    }

    public void customizeForOptionsSeparatorView(View view){

    }
}
