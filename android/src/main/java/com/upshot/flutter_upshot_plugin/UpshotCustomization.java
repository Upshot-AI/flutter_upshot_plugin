package com.upshot.flutter_upshot_plugin;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.StateListDrawable;
import android.text.TextUtils;
import android.util.Log;
import android.util.TypedValue;
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
import com.brandkinesis.BrandKinesis;
import com.brandkinesis.activitymanager.BKActivityTypes;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import static com.brandkinesis.BKUIPrefComponents.BKActivityImageButtonTypes;
import static com.brandkinesis.BKUIPrefComponents.BKUICheckBox;

import androidx.core.content.res.ResourcesCompat;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.FlutterInjector;
import io.flutter.embedding.engine.loader.FlutterLoader;

public class UpshotCustomization {

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

    public void applyEditTextProperties(Context mContext, JSONObject submitButtonJsonObject, EditText editText) {
        applyFontAttribute(mContext, editText, submitButtonJsonObject);
        applyTextSizeAttribute(mContext, editText, submitButtonJsonObject);
        applyTextColorAttribute(mContext, editText, submitButtonJsonObject);
    }

    public void applyButtonProperties(Context context, JSONObject submitButtonJsonObject, Button button) {
        applyFontAttribute(context, button, submitButtonJsonObject);
        applyTextSizeAttribute(context, button, submitButtonJsonObject);
        applyTextColorAttribute(context, button, submitButtonJsonObject);
        applyBgColorAttribute(context, button, submitButtonJsonObject);
        applyBgImageAttribute(context, button, submitButtonJsonObject);

        GradientDrawable gd = new GradientDrawable();
        String borderColor = validateJsonString(submitButtonJsonObject, "borderColor");
        String bgColor = validateJsonString(submitButtonJsonObject, "bgColor");
        if (borderColor != null && !borderColor.isEmpty()) {
            gd.setStroke(3, Color.parseColor(borderColor));
            gd.setCornerRadius(8);
            gd.setColor(Color.parseColor(bgColor));
            button.setBackground(gd);
        }

    }

    private  Bitmap getBitmapImageFromAssets(Context context, JSONObject imageJson) {
        try {
            FlutterLoader loader = FlutterInjector.instance().flutterLoader();
            String key = loader.getLookupKeyForAsset("assets/images/" + validateJsonString(imageJson, "name") +"."+validateJsonString(imageJson, "ext"));
            InputStream istr = context.getAssets().open(key);
            Bitmap bitmap = BitmapFactory.decodeStream(istr);
            istr.close();
            return  bitmap;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    private void setImageResourceToView(Context context, String bgImage, View view) {
        if (!TextUtils.isEmpty(bgImage)) {

            int resourceId = getIdentifier(context, bgImage);
            if (resourceId > 0) {
                if (view instanceof ImageButton) {
                    ((ImageButton) view).setImageResource(resourceId);
                } else if (view instanceof ImageView) {
                    ((ImageView) view).setImageResource(resourceId);
                }
            }
        }
    }
    private void setImageDrawableToView(Context context, Drawable bgImage, View view) {
        if (bgImage != null) {
            if (view instanceof ImageButton) {
                ((ImageButton) view).setImageDrawable(bgImage);
            } else if (view instanceof ImageView) {
                ((ImageView) view).setImageDrawable(bgImage);
            }
        }
    }

    private void applyImageResourceAttribute(Context context, View view, JSONObject jsonObject) {
        String bgImage = validateJsonString(jsonObject, "image");
        setImageResourceToView(context, bgImage, view);
    }

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

    private void applyBgImageAttribute(Context context, View view, JSONObject jsonObject) {
        String bgImage = validateJsonString(jsonObject, "image");
        setBgToView(context, bgImage, view);
    }

    private void setBgToView(Context context, String bgImage, View view) {
        if (!TextUtils.isEmpty(bgImage)) {

            int resourceId = getIdentifier(context, bgImage);
            if (resourceId > 0) {
                view.setBackgroundResource(resourceId);
            }
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
        String bgcolor = validateJsonString(jsonObject, "bgColor");
        if (!TextUtils.isEmpty(bgcolor)) {
            try {
                view.setBackgroundColor(Color.parseColor(bgcolor));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void applyTextColorAttribute(Context context, View view, JSONObject jsonObject) {
        String text_color = validateJsonString(jsonObject, "tColor");
        if (!TextUtils.isEmpty(text_color)) {
            try {
                if (view instanceof Button) {
                    ((Button) view).setTextColor(Color.parseColor(text_color));
                } else if (view instanceof TextView) {
                    ((TextView) view).setTextColor(Color.parseColor(text_color));
                } else if (view instanceof EditText) {
                    ((EditText) view).setTextColor(Color.parseColor(text_color));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void applyTextSizeAttribute(Context context, View view, JSONObject jsonObject) {
        int font_size = validateJsonInt(jsonObject, "fSize");
        try {
            if (view instanceof Button) {
                ((Button) view).setTextSize(font_size);
            } else if (view instanceof TextView) {
                ((TextView) view).setTextSize(font_size);
            } else if (view instanceof EditText) {
                ((EditText) view).setTextSize(font_size);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void applyFontAttribute(Context context, View view, JSONObject jsonObject) {
        String font_name = validateJsonString(jsonObject, "fStyle");
        if (!TextUtils.isEmpty(font_name)) {
            try {
                FlutterLoader loader = FlutterInjector.instance().flutterLoader();
                String key = loader.getLookupKeyForAsset("fonts/" + font_name + ".ttf");
                System.out.println("The key is"+key);
                Typeface typeface = Typeface.createFromAsset(context.getAssets(), key);
                if (view instanceof Button) {
                    ((Button) view).setTypeface(typeface);
                } else if (view instanceof TextView) {
                    ((TextView) view).setTypeface(typeface);
                } else if (view instanceof EditText) {
                    ((EditText) view).setTypeface(typeface);
                }
            } catch (Exception e) {
                Log.d("font_name",font_name);
                e.printStackTrace();
            }
        }
    }

    private Bitmap getBitmap(Context context, int id) {
        return BitmapFactory.decodeResource(context.getResources(), id);
    }

    public void setCustomizationData(JSONObject mJsonObject, BrandKinesis bkInstance, Context mContext) {
        if (mJsonObject != null) {

            BKUIPrefComponents bkuiPrefComponents = new BKUIPrefComponents() {
                @Override
                public void setPreferencesForRelativeLayout(RelativeLayout relativeLayout, BKActivityTypes bkActivityTypes, BKActivityRelativeLayoutTypes bkActivityRelativeLayoutTypes, boolean b) {

                }

                @Override
                public void setPreferencesForImageButton(ImageButton imageButton, BKActivityTypes bkActivityTypes, BKActivityImageButtonTypes bkActivityImageButtonTypes) {
                    if (mJsonObject != null) {

                        try {
                            JSONObject imageJsonObject = (JSONObject) mJsonObject.get("image");
                            switch (bkActivityImageButtonTypes) {
                                case BKACTIVITY_SKIP_BUTTON:
                                    JSONObject skipJsonObject = (JSONObject) imageJsonObject.get("skip");
                                    String skipIcon = validateJsonString(skipJsonObject, "name");
                                    setImageResourceToView(mContext, skipIcon, imageButton);
                                    break;
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                }

                @Override
                public void setPreferencesForButton(Button button, BKActivityTypes bkActivityTypes, BKActivityButtonTypes bkActivityButtonTypes) {
                    try {
                        JSONObject buttonJsonObject = (JSONObject) mJsonObject.get("button");
                        switch (bkActivityButtonTypes) {
                            case BKACTIVITY_TRIVIA_CONTINUE_BUTTON:
                            case BKACTIVITY_SURVEY_CONTINUE_BUTTON:
                                JSONObject continueButtonJsonObject = (JSONObject) buttonJsonObject.get("continue");
                                applyButtonProperties(mContext, continueButtonJsonObject, button);
                                break;
                            case BKACTIVITY_TRIVIA_PREVIOUS_BUTTON:
                            case BKACTIVITY_SURVEY_PREVIOUS_BUTTON:
                                JSONObject prevButtonJsonObject = (JSONObject) buttonJsonObject.get("prev");
                                applyButtonProperties(mContext, prevButtonJsonObject, button);
                                break;
                            case BKACTIVITY_TRIVIA_NEXT_BUTTON:
                            case BKACTIVITY_SURVEY_NEXT_BUTTON:
                                JSONObject nextButtonJsonObject = (JSONObject) buttonJsonObject.get("next");
                                applyButtonProperties(mContext, nextButtonJsonObject, button);
                                break;
                            case BKACTIVITY_SUBMIT_BUTTON:
                                JSONObject submitButtonJsonObject = (JSONObject) buttonJsonObject.get("submit");
                                applyButtonProperties(mContext, submitButtonJsonObject, button);
                                break;

                            case BKACTIVITY_RATING_YES_BUTTON:
                                JSONObject yesButtonJsonObject = (JSONObject) buttonJsonObject.get("yes");
                                applyButtonProperties(mContext, yesButtonJsonObject, button);
                                break;

                            case BKACTIVITY_RATING_NO_BUTTON:
                                JSONObject noButtonJsonObject = (JSONObject) buttonJsonObject.get("no");
                                applyButtonProperties(mContext, noButtonJsonObject, button);
                                break;
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

                @Override
                public void setPreferencesForTextView(TextView textView, BKActivityTypes bkActivityTypes, BKActivityTextViewTypes bkActivityTextViewTypes) {
                    try {
                        JSONObject label_textJsonObject = (JSONObject) mJsonObject.get("label");
                        switch (bkActivityTextViewTypes) {
                            case BKACTIVITY_HEADER_TV:
                                JSONObject header = (JSONObject) label_textJsonObject.get("header");
                                applyTextViewProperties(mContext, header, textView);
                                break;
                            case BKACTIVITY_TRIVIA_DESC_TV:
                            case BKACTIVITY_SURVEY_DESC_TV:
                                JSONObject desc = (JSONObject) label_textJsonObject.get("desc");
                                applyTextViewProperties(mContext, desc, textView);
                                break;
                            case BKACTIVITY_QUESTION_TV:
                                JSONObject question = (JSONObject) label_textJsonObject.get("question");
                                applyTextViewProperties(mContext, question, textView);
                                break;
                            case BKACTIVITY_QUESTION_OPTION_TV:
                            case BKACTIVITY_OPTION_TV:
                                JSONObject option = (JSONObject) label_textJsonObject.get("option");
                                applyTextViewProperties(mContext, option, textView);
                                break;
                            case BKACTIVITY_THANK_YOU_APPSTORE_HINT:
                                JSONObject appStoreJsonObject = (JSONObject) label_textJsonObject.get("appStoreHint");
                                applyTextViewProperties(mContext, appStoreJsonObject, textView);
                                break;

                            case BKACTIVITY_THANK_YOU_TV:
                                JSONObject thanksJsonObject = (JSONObject) label_textJsonObject.get("thanks");
                                applyTextViewProperties(mContext, thanksJsonObject, textView);
                                break;
                        }

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

                @Override
                public void setPreferencesForImageView(ImageView imageView, BKActivityTypes bkActivityTypes, BKActivityImageViewType bkActivityImageViewType) {
                    if (mJsonObject != null) {
                        try {
                            JSONObject jImageBg = (JSONObject) mJsonObject.get("image");

                            switch (bkActivityImageViewType) {
                                case BACTIVITY_RATING_LIKE_BUTTON:
                                    JSONObject likeJsonObject = (JSONObject) mJsonObject.get("like_def");
                                    String likeDefIcon = validateJsonString(likeJsonObject, "name");

                                    JSONObject likeSelJsonObject = (JSONObject) mJsonObject.get("like_sel");
                                    String likeSelIcon = validateJsonString(likeSelJsonObject, "name");

                                    StateListDrawable liked = new StateListDrawable();
                                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
                                        int[] sFocusedSelected = {android.R.attr.state_focused, android.R.attr.state_selected, android.R.attr.state_pressed};

                                        Drawable likeSelected = mContext.getDrawable(getIdentifier(mContext, likeSelIcon));
                                        liked.addState(sFocusedSelected, likeSelected);

                                        Drawable likeUnselected = mContext.getDrawable(getIdentifier(mContext, likeDefIcon));

                                        liked.addState(new int[]{}, likeUnselected);
                                    }


                                    setImageDrawableToView(mContext, liked, imageView);

                                    break;
                                case BACTIVITY_RATING_DISLIKE_BUTTON:

                                    JSONObject unlikeJsonObject = (JSONObject) mJsonObject.get("dislike_def");
                                    String unlikeDefIcon = validateJsonString(unlikeJsonObject, "name");

                                    JSONObject unlikeSelJsonObject = (JSONObject) mJsonObject.get("dislike_sel");
                                    String unlikeSelIcon = validateJsonString(unlikeSelJsonObject, "name");

                                    StateListDrawable unliked = new StateListDrawable();
                                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
                                        int[] sFocusedSelected = {android.R.attr.state_focused, android.R.attr.state_selected, android.R.attr.state_pressed};

                                        Drawable likeSelected = mContext.getDrawable(getIdentifier(mContext, unlikeSelIcon));
                                        unliked.addState(sFocusedSelected, likeSelected);

                                        Drawable likeUnselected = mContext.getDrawable(getIdentifier(mContext, unlikeDefIcon));

                                        unliked.addState(new int[]{}, likeUnselected);
                                    }
                                    setImageDrawableToView(mContext, unliked, imageView);
                                    break;
                                case BKACTIVITY_PORTRAIT_LOGO:
                                    JSONObject logoJsonObject = (JSONObject) mJsonObject.get("logo");
                                    String bgData = validateJsonString(logoJsonObject, "name");
                                    applyImageProperties(mContext, bgData, imageView);
                                    break;
                                case BKACTIVITY_LANDSCAPE_LOGO:
                                    JSONObject landscapeLogoJsonObject = (JSONObject) mJsonObject.get("logo");
                                    String landscapeBackground = validateJsonString(jImageBg, "name");
                                    applyImageProperties(mContext, landscapeBackground, imageView);
                                    break;
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                }

                @Override
                public void setPreferencesForOptionsSeparatorView(View view, BKActivityTypes bkActivityTypes) {

                }

                @Override
                public void setCheckBoxRadioSelectorResource(BKUICheckBox bkuiCheckBox, BKActivityTypes bkActivityTypes, boolean isCheckBox) {

                    if (mJsonObject != null) {
                        try {
                            JSONObject buttonJsonObject = (JSONObject) mJsonObject.get("image");


                            if (isCheckBox) {
                                JSONObject chkSelJsonObject = (JSONObject) buttonJsonObject.get("checkbox_sel");
                                Bitmap check_select = BitmapFactory.decodeResource(mContext.getResources(), getIdentifier(mContext, validateJsonString(chkSelJsonObject, "name")));
                                bkuiCheckBox.setSelectedCheckBox(check_select);

                                JSONObject chkDefJsonObject = (JSONObject) buttonJsonObject.get("checkbox_def");
                                Bitmap default_select = BitmapFactory.decodeResource(mContext.getResources(), getIdentifier(mContext, validateJsonString(chkDefJsonObject, "name")));
                                bkuiCheckBox.setUnselectedCheckBox(default_select);
                            } else {
                                JSONObject radioJsonObject = (JSONObject) buttonJsonObject.get("radio_sel");
                                Bitmap check_select = BitmapFactory.decodeResource(mContext.getResources(), getIdentifier(mContext, validateJsonString(radioJsonObject, "name")));
                                bkuiCheckBox.setSelectedCheckBox(check_select);

                                JSONObject radioDefJsonObject = (JSONObject) buttonJsonObject.get("radio_def");
                                Bitmap default_select = BitmapFactory.decodeResource(mContext.getResources(), getIdentifier(mContext, validateJsonString(radioDefJsonObject, "name")));
                                bkuiCheckBox.setUnselectedCheckBox(default_select);
                            }

                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
//                    if (mJsonObject != null) {
//                        try {
//                            JSONObject buttonJsonObject = (JSONObject) mJsonObject.get("image");
//                            if (isCheckBox) {
//                                JSONObject chkSelJsonObject = (JSONObject) buttonJsonObject.get("checkbox_sel");
//                                JSONObject chkDefJsonObject = (JSONObject) buttonJsonObject.get("checkbox_def");
//                                if (getBitmapImageFromAssets(mContext, chkSelJsonObject) != null) {
//                                    Bitmap chbitmap = getBitmapImageFromAssets(mContext, chkSelJsonObject);
//
//                                    int currentBitmapWidth = chbitmap.getWidth();
//                                    int currentBitmapHeight = chbitmap.getHeight();
//
//                                    int ivWidth = 30;
//                                    int ivHeight = 30;
//                                    int newWidth = ivWidth;
//                                    int newHeight = (int) Math.floor((double) currentBitmapHeight *( (double) newWidth / (double) currentBitmapWidth));
//
//                                    Bitmap newbitMap = Bitmap.createScaledBitmap(chbitmap, newWidth, newHeight, true);
//                                    bkuiCheckBox.setSelectedCheckBox(newbitMap);
//
////                                    bkuiCheckBox.setSelectedCheckBox(getBitmapImageFromAssets(mContext, chkSelJsonObject));
//                                }
//                                if (getBitmapImageFromAssets(mContext, chkDefJsonObject) != null) {
//                                    bkuiCheckBox.setUnselectedCheckBox(getBitmapImageFromAssets(mContext, chkDefJsonObject));
//                                }
//                            } else {
//                                JSONObject radioJsonObject = (JSONObject) buttonJsonObject.get("radio_sel");
//                                JSONObject radioDefJsonObject = (JSONObject) buttonJsonObject.get("radio_def");
//
//                                if (getBitmapImageFromAssets(mContext, radioJsonObject) != null) {
//                                    bkuiCheckBox.setSelectedCheckBox(getBitmapImageFromAssets(mContext, radioJsonObject));
//                                }
//                                if (getBitmapImageFromAssets(mContext, radioDefJsonObject) != null) {
//                                    bkuiCheckBox.setUnselectedCheckBox(getBitmapImageFromAssets(mContext, radioDefJsonObject));
//                                }
//                            }
//                        } catch (JSONException e) {
//                            e.printStackTrace();
//                        }
//                    }
                }

                @Override
                public void setRatingSelectorResource(List<Bitmap> selectedRatingList, List<Bitmap> unselectedRatingList, BKActivityTypes bkActivityTypes, BKActivityRatingTypes bkActivityRatingTypes) {
                    try {
                        JSONObject buttonJsonObject = (JSONObject) mJsonObject.get("image");

                        switch (bkActivityRatingTypes) {
                            case BKACTIVITY_STAR_RATING:
                                JSONObject starJsonObject = (JSONObject) buttonJsonObject.get("star_def");
                                JSONObject starSelJsonObject = (JSONObject) buttonJsonObject.get("start_sel");

                                Bitmap selected = BitmapFactory.decodeResource(mContext.getResources(),
                                        getIdentifier(mContext, validateJsonString(starSelJsonObject, "name")));
                                Bitmap unselected = BitmapFactory.decodeResource(mContext.getResources(),
                                        getIdentifier(mContext, validateJsonString(starJsonObject, "name")));
                                if (selected != null && unselected != null) {
                                    selectedRatingList.add(selected);
                                    unselectedRatingList.add(unselected);
                                }
                                break;

                            case BKACTIVITY_EMOJI_RATING:
                                JSONObject veryGood_defJsonObject = (JSONObject) buttonJsonObject.get("veryGood_def");
                                JSONObject good_defJsonObject = (JSONObject) buttonJsonObject.get("good_def");
                                JSONObject avg_defJsonObject = (JSONObject) buttonJsonObject.get("avg_def");
                                JSONObject bad_defJsonObject = (JSONObject) buttonJsonObject.get("bad_def");
                                JSONObject veryBad_defJsonObject = (JSONObject) buttonJsonObject.get("veryBad_def");

                                JSONObject veryGood_selJsonObject = (JSONObject) buttonJsonObject.get("veryGood_sel");
                                JSONObject good_selJsonObject = (JSONObject) buttonJsonObject.get("good_sel");
                                JSONObject avg_selJsonObject = (JSONObject) buttonJsonObject.get("avg_sel");
                                JSONObject bad_selJsonObject = (JSONObject) buttonJsonObject.get("bad_sel");
                                JSONObject veryBad_selJsonObject = (JSONObject) buttonJsonObject.get("veryBad_sel");

                                Bitmap smiley_vbad_def = getBitmap(mContext, getIdentifier(mContext, validateJsonString(veryBad_defJsonObject, "name")));
                                Bitmap smiley_bad_def = getBitmap(mContext, getIdentifier(mContext, validateJsonString(bad_defJsonObject, "name")));
                                Bitmap smiley_avg_def = getBitmap(mContext, getIdentifier(mContext, validateJsonString(avg_defJsonObject, "name")));
                                Bitmap smiley_good_def = getBitmap(mContext, getIdentifier(mContext, validateJsonString(good_defJsonObject, "name")));
                                Bitmap smiley_Vgood_def = getBitmap(mContext, getIdentifier(mContext, validateJsonString(veryGood_defJsonObject, "name")));

                                Bitmap smiley_vbad_sel = getBitmap(mContext, getIdentifier(mContext, validateJsonString(veryBad_selJsonObject, "vbSel")));
                                Bitmap smiley_bad_sel = getBitmap(mContext, getIdentifier(mContext, validateJsonString(bad_selJsonObject, "bSel")));
                                Bitmap smiley_avg_sel = getBitmap(mContext, getIdentifier(mContext, validateJsonString(avg_selJsonObject, "avgSel")));
                                Bitmap smiley_good_sel = getBitmap(mContext, getIdentifier(mContext, validateJsonString(good_selJsonObject, "gSel")));
                                Bitmap smiley_Vgood_sel = getBitmap(mContext, getIdentifier(mContext, validateJsonString(veryGood_selJsonObject, "vgSel")));

                                if (smiley_vbad_def == null || smiley_bad_def == null || smiley_avg_def == null || smiley_good_def == null || smiley_Vgood_def == null ||
                                        smiley_vbad_sel == null || smiley_bad_sel == null || smiley_avg_sel == null || smiley_good_sel == null || smiley_Vgood_sel == null) {
                                    return;
                                }

                                unselectedRatingList.add(smiley_vbad_def);
                                unselectedRatingList.add(smiley_bad_def);
                                unselectedRatingList.add(smiley_avg_def);
                                unselectedRatingList.add(smiley_good_def);
                                unselectedRatingList.add(smiley_Vgood_def);

                                selectedRatingList.add(smiley_vbad_sel);
                                selectedRatingList.add(smiley_bad_sel);
                                selectedRatingList.add(smiley_avg_sel);
                                selectedRatingList.add(smiley_good_sel);
                                selectedRatingList.add(smiley_Vgood_sel);
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

                @Override
                public void setPreferencesForUIColor(BKBGColors bkbgColors, BKActivityTypes bkActivityTypes, BKActivityColorTypes bkActivityColorTypes) {
                    if (mJsonObject != null) {

                        try {
                            JSONObject jsonObject = (JSONObject) mJsonObject.get("color");

                            switch (bkActivityColorTypes) {
                                case BKACTIVITY_OPTION_SEL_BORDER: {
                                    JSONObject optionsBorder = (JSONObject) jsonObject.get("optionsBorder");

                                    String bgColor = validateJsonString(optionsBorder, "sel");
                                    if (bgColor != null && !bgColor.isEmpty()) {
                                        bkbgColors.setColor(Color.parseColor(bgColor));
                                    }
                                }
                                break;
                                case BKACTIVITY_BG_COLOR:
                                    String bgColor = validateJsonString(jsonObject, "bgColor");
                                    if (bgColor != null && !bgColor.isEmpty()) {
                                        bkbgColors.setColor(Color.parseColor(bgColor));
                                    }
                                    break;
                                case BKACTIVITY_SURVEY_HEADER_COLOR:
                                    String headerBG = validateJsonString(jsonObject, "headheaderColorerBG");
                                    if (headerBG != null && !headerBG.isEmpty()) {
                                        bkbgColors.setColor(Color.parseColor(headerBG));
                                    }

                                    break;
                                case BKACTIVITY_PAGINATION_BORDER_COLOR:
                                    JSONObject pagination = (JSONObject) jsonObject.get("pagination");
                                    String pagenationdots_current = validateJsonString(pagination, "current");
                                    if (pagenationdots_current != null && !pagenationdots_current.isEmpty()) {
                                        bkbgColors.setColor(Color.parseColor(pagenationdots_current));
                                    }
                                    break;
                                case BKACTIVITY_PAGINATION_ANSWERED_COLOR:
                                    JSONObject pagination1 = (JSONObject) jsonObject.get("pagination");
                                    String pagenationdots_answered = validateJsonString(pagination1, "answered");
                                    if (pagenationdots_answered != null && !pagenationdots_answered.isEmpty()) {
                                        bkbgColors.setColor(Color.parseColor(pagenationdots_answered));
                                    }
                                    break;
                                case BKACTIVITY_PAGINATION_DEFAULT_COLOR:

                                    JSONObject pagination2 = (JSONObject) jsonObject.get("pagination");
                                    String pagenationdots_def = validateJsonString(pagination2, "def");
                                    if (pagenationdots_def != null && !pagenationdots_def.isEmpty()) {
                                        bkbgColors.setColor(Color.parseColor(pagenationdots_def));
                                    }
                                    break;
                            }

                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                }

                @Override
                public void setPreferencesForGraphColor(BKGraphType bkGraphType, List<Integer> list, BKActivityTypes bkActivityTypes) {

                }

                @Override
                public int getPositionPercentageFromBottom(BKActivityTypes bkActivityTypes, BKViewType bkViewType) {
                    return 0;
                }

                @Override
                public void setPreferencesForSeekBar(SeekBar seekBar, BKActivityTypes bkActivityTypes, BKActivitySeekBarTypes bkActivitySeekBarTypes) {

                }

                @Override
                public void setPreferencesForEditText(EditText editText, BKActivityTypes bkActivityTypes, BKActivityEditTextTypes bkActivityEditTextTypes) {
                    if (mJsonObject != null) {
                        try {

                            switch (bkActivityEditTextTypes) {
                                case BKACTIVITY_RATING_EDIT_TEXT:
                                default:
                                    JSONObject inputFieldJsonObject = (JSONObject) mJsonObject.get("feedbackBox");
                                    GradientDrawable gd = new GradientDrawable();
                                    String borderColor = validateJsonString(inputFieldJsonObject, "borderColor");
                                    String bgColor = validateJsonString(inputFieldJsonObject, "bgColor");
                                    if (borderColor != null && !borderColor.isEmpty()) {
                                        gd.setStroke(3, Color.parseColor(borderColor));
                                        gd.setCornerRadius(8);
                                    }
                                    if (!bgColor.isEmpty()) {
                                        gd.setColor(Color.parseColor(bgColor));
                                    }
                                    editText.setBackground(gd);
                                    applyEditTextProperties(mContext, inputFieldJsonObject, editText);
                                    break;
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                }

                @Override
                public void setPreferencesForLinearLayout(LinearLayout linearLayout, BKActivityTypes bkActivityTypes, BKActivityLinearLayoutTypes bkActivityLinearLayoutTypes) {

                }
            };
            bkInstance.setUIPreferences(bkuiPrefComponents);
        }
    }
}
