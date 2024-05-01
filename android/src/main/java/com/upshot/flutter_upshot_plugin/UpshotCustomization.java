package com.upshot.flutter_upshot_plugin;

import android.content.Context;
import android.content.res.AssetManager;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.text.TextUtils;
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

import java.util.List;

import static com.brandkinesis.BKUIPrefComponents.BKActivityImageButtonTypes;
import static com.brandkinesis.BKUIPrefComponents.BKUICheckBox;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

public class UpshotCustomization {

    private int getFontSize(JSONObject json, String key) {

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
            UpshotHelper.logException(e);
        }
        return 14;
    }

    public String getImageName(JSONObject json, String key) {

        String imageName = validateJsonString(json, key);
        if (imageName.contains(".")) {
            String[] list = imageName.split("\\.");
            if (list.length > 0) {
                return list[0];
            }
        }
        return imageName;
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
            UpshotHelper.logException(e);
        }
        return "";
    }

    public void applyEditTextProperties(JSONObject editTextJson, EditText editText, FlutterLoader loader,
            FlutterPlugin.FlutterPluginBinding binding) {

        GradientDrawable gd = new GradientDrawable();
        String borderColor = validateJsonString(editTextJson, "border_color");
        String bgColorValue = validateJsonString(editTextJson, "bgcolor");

        int bgColor = Color.TRANSPARENT;
        if (borderColor != null && !borderColor.isEmpty()) {
            gd.setStroke(3, Color.parseColor(borderColor));
        }

        if (bgColorValue != null && !bgColorValue.isEmpty()) {
            bgColor = Color.parseColor(bgColorValue);
        }
        gd.setCornerRadius(8);
        gd.setColor(bgColor);
        editText.setBackground(gd);

        applyFontAttribute(editText, editTextJson, loader, binding);
        applyTextSizeAttribute(editText, editTextJson);
        applyTextColorAttribute(editText, editTextJson);
    }

    public void applyButtonProperties(Context context, JSONObject buttonJson, Button button, FlutterLoader loader,
            FlutterPlugin.FlutterPluginBinding binding) {

        String border_color = validateJsonString(buttonJson, "border_color");
        String bgColor = validateJsonString(buttonJson, "bgcolor");
        String bgImage = getImageName(buttonJson, "image");

        if (!border_color.isEmpty()) {
            applyBorderColorForButtons(button, border_color, bgColor);
        } else {
            applyBgColorAttribute(button, buttonJson);
        }
        setImageToView(context, bgImage, button);
        applyTextSizeAttribute(button, buttonJson);
        applyTextColorAttribute(button, buttonJson);
        applyFontAttribute(button, buttonJson, loader, binding);
    }

    public void applySkipImage(Context context, JSONObject buttonJson, ImageButton button) {
        String bgImage = getImageName(buttonJson, "image");
        if (!TextUtils.isEmpty(bgImage)) {

            int resourceId = getIdentifier(context, bgImage);
            if (resourceId > 0) {
                button.setImageResource(resourceId);
            }
        }
    }

    public void applyTextViewProperties(JSONObject jsonObject, TextView textView, FlutterLoader loader,
            FlutterPlugin.FlutterPluginBinding binding) {
        applyFontAttribute(textView, jsonObject, loader, binding);
        applyTextSizeAttribute(textView, jsonObject);
        applyTextColorAttribute(textView, jsonObject);
    }

    public void applyBorderColorForButtons(Button button, String border_color, String bg_color) {
        GradientDrawable borderDrawable = new GradientDrawable();
        borderDrawable.setStroke(3, Color.parseColor(border_color));

        if (!bg_color.isEmpty()) {
            borderDrawable.setColor(Color.parseColor(bg_color));
        }
        button.setBackground(borderDrawable);
    }

    public void setImageToView(Context context, String imageName, View view) {
        if (!TextUtils.isEmpty(imageName)) {
            int resourceId = getIdentifier(context, imageName);
            if (resourceId > 0) {
                view.setBackgroundResource(resourceId);
            }
        }
    }

    public int getIdentifier(Context context, String imageName) {
        try {
            Resources resources = context.getResources();
            int resourceId = resources.getIdentifier(imageName, "drawable", context.getPackageName());
            return resourceId;
        } catch (Exception e) {
            UpshotHelper.logException(e);
        }
        return 0;
    }

    private void applyBgColorAttribute(View view, JSONObject jsonObject) {
        String bgColor = validateJsonString(jsonObject, "bgcolor");
        if (!TextUtils.isEmpty(bgColor)) {
            try {
                view.setBackgroundColor(Color.parseColor(bgColor));
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    private void applyTextColorAttribute(View view, JSONObject jsonObject) {
        String text_color = validateJsonString(jsonObject, "color");
        if (!TextUtils.isEmpty(text_color)) {
            try {
                if (view instanceof Button) {
                    ((Button) view).setTextColor(Color.parseColor(text_color));
                } else if (view instanceof TextView) {
                    ((TextView) view).setTextColor(Color.parseColor(text_color));
                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    private void applyTextSizeAttribute(View view, JSONObject jsonObject) {
        int font_size = getFontSize(jsonObject, "size");
        try {
            if (view instanceof Button) {
                ((Button) view).setTextSize(font_size);
            } else if (view instanceof TextView) {
                ((TextView) view).setTextSize(font_size);
            }
        } catch (Exception e) {
            UpshotHelper.logException(e);
        }
    }

    public Typeface getTypeFace(FlutterLoader loader, String fontName, FlutterPlugin.FlutterPluginBinding binding) {

        String fontFilePath = loader.getLookupKeyForAsset("fonts/" + fontName);
        AssetManager assetManager = binding.getApplicationContext().getAssets();
        Typeface typeface = Typeface.createFromAsset(assetManager, fontFilePath);
        return typeface;
    }

    private void applyFontAttribute(View view, JSONObject jsonObject, FlutterLoader loader,
            FlutterPlugin.FlutterPluginBinding binding) {

        String font_name = validateJsonString(jsonObject, "font_name");
        if (!TextUtils.isEmpty(font_name)) {
            try {
                if (!font_name.contains(".ttf")) {
                    font_name += ".ttf";
                }
                Typeface typeface = getTypeFace(loader, font_name, binding);
                if (typeface != null) {
                    if (view instanceof Button) {
                        ((Button) view).setTypeface(typeface);
                    } else if (view instanceof TextView) {
                        ((TextView) view).setTypeface(typeface);
                    }
                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    public void customizeSeekBar(BKUIPrefComponents.BKActivitySeekBarTypes seekBarTypes, SeekBar seekBar) {

    }

    public void customizeRelativeLayout(BKUIPrefComponents.BKActivityRelativeLayoutTypes relativeLayoutTypes,
            RelativeLayout relativeLayout, boolean isFullScreen) {

    }

    public void customizeTextView(BKActivityTextViewTypes textViewType, TextView textView) {

    }

    public void customizeRating(List<Bitmap> selectedRatingList, List<Bitmap> unselectedRatingList,
            BKActivityRatingTypes ratingType) {

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

    public void customizeForLinearLayout(LinearLayout linearLayout,
            BKUIPrefComponents.BKActivityLinearLayoutTypes linearLayoutTypes) {

    }

    public void customizeForOptionsSeparatorView(View view) {

    }
}
