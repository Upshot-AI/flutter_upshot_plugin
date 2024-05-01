package com.upshot.flutter_upshot_plugin;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.SeekBar;
import android.widget.TextView;

import androidx.core.content.ContextCompat;

import com.brandkinesis.BKUIPrefComponents;
import com.brandkinesis.BKUIPrefComponents.BKActivityButtonTypes;
import com.brandkinesis.BKUIPrefComponents.BKActivityColorTypes;
import com.brandkinesis.BKUIPrefComponents.BKActivityTextViewTypes;
import com.brandkinesis.BKUIPrefComponents.BKBGColors;

import org.json.JSONObject;

import java.util.List;

import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

public class UpshotSurveyCustomization extends UpshotCustomization {
    Context mContext;
    private JSONObject surveyJson = null;
    private FlutterLoader flutterLoader;

    private FlutterPlugin.FlutterPluginBinding flutterBinding;

    public UpshotSurveyCustomization(Context context, JSONObject surveyJSON, FlutterLoader loader,
                                     FlutterPlugin.FlutterPluginBinding binding) {
        mContext = context;
        try {
            surveyJson = surveyJSON;
            flutterLoader = loader;
            flutterBinding = binding;
        } catch (Exception e) {
            UpshotHelper.logException(e);
        }
    }

    public void customizeRadioButton(BKUIPrefComponents.BKUICheckBox checkBox, boolean isCheckBox) {
        super.customizeRadioButton(checkBox, isCheckBox);

        if (surveyJson != null) {
            try {
                JSONObject imageJson = (JSONObject) surveyJson.get("image");

                if (isCheckBox) {
                    Bitmap check_select, default_select;
                    check_select = BitmapFactory.decodeResource(mContext.getResources(),
                            getIdentifier(mContext, getImageName(imageJson, "checkbox_sel")));
                    checkBox.setSelectedCheckBox(check_select);

                    default_select = BitmapFactory.decodeResource(mContext.getResources(),
                            getIdentifier(mContext, getImageName(imageJson, "checkbox_def")));
                    checkBox.setUnselectedCheckBox(default_select);
                } else {
                    Bitmap check_select, default_select;
                    check_select = BitmapFactory.decodeResource(mContext.getResources(),
                            getIdentifier(mContext, getImageName(imageJson, "radio_sel")));
                    checkBox.setSelectedCheckBox(check_select);

                    default_select = BitmapFactory.decodeResource(mContext.getResources(),
                            getIdentifier(mContext, getImageName(imageJson, "radio_def")));
                    checkBox.setUnselectedCheckBox(default_select);
                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    @Override
    public void customizeSeekBar(BKUIPrefComponents.BKActivitySeekBarTypes seekBarTypes, SeekBar seekBar) {
        super.customizeSeekBar(seekBarTypes, seekBar);

        if (surveyJson != null) {

            try {
                JSONObject sliderJson = (JSONObject) surveyJson.get("slider");
                String minColor = validateJsonString(sliderJson, "min_color");
                String maxColor = validateJsonString(sliderJson, "max_color");
                Drawable bitmapDrawable;

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {

                    if (minColor != null && !minColor.isEmpty()) {
                        seekBar.setProgressBackgroundTintList(ColorStateList.valueOf(Color.parseColor(minColor)));
                    }
                    if (maxColor != null && !maxColor.isEmpty()) {
                        seekBar.setProgressTintList(ColorStateList.valueOf(Color.parseColor(maxColor)));
                    }
                    bitmapDrawable = ContextCompat.getDrawable(mContext,
                            getIdentifier(mContext, getImageName(sliderJson, "thumb_image")));
                    if (bitmapDrawable != null) {
                        seekBar.setThumb(bitmapDrawable);
                    }
                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    @Override
    public void customizeEditText(BKUIPrefComponents.BKActivityEditTextTypes EditTextType, EditText editText) {
        super.customizeEditText(EditTextType, editText);

        if (surveyJson != null) {
            try {
                JSONObject feedbackJson = (JSONObject) surveyJson.get("feedbackBox");

                switch (EditTextType) {
                    case BKACTIVITY_SURVEY_EDIT_TEXT:
                    default:
                        applyEditTextProperties(feedbackJson, editText, flutterLoader, flutterBinding);
                        break;
                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    @Override
    public void customizeButton(Button button, BKActivityButtonTypes buttonType) {
        super.customizeButton(button, buttonType);

        if (surveyJson != null) {

            try {
                JSONObject buttonJson = (JSONObject) surveyJson.get("button");

                switch (buttonType) {
                    case BKACTIVITY_SUBMIT_BUTTON:
                        JSONObject submitButtonJsonObject = (JSONObject) buttonJson.get("submit");
                        applyButtonProperties(mContext, submitButtonJsonObject, button, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_SURVEY_CONTINUE_BUTTON:
                        JSONObject continueButtonJsonObject = (JSONObject) buttonJson.get("continue");
                        applyButtonProperties(mContext, continueButtonJsonObject, button, flutterLoader,
                                flutterBinding);
                        break;
                    case BKACTIVITY_SURVEY_NEXT_BUTTON:
                        JSONObject nextButtonJsonObject = (JSONObject) buttonJson.get("next");
                        applyButtonProperties(mContext, nextButtonJsonObject, button, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_SURVEY_PREVIOUS_BUTTON:
                        JSONObject prevButtonJsonObject = (JSONObject) buttonJson.get("prev");
                        applyButtonProperties(mContext, prevButtonJsonObject, button, flutterLoader, flutterBinding);
                        break;
                }

            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    @Override
    public void customizeBGColor(BKBGColors color, BKActivityColorTypes colorType) {
        super.customizeBGColor(color, colorType);

        if (surveyJson != null) {

            try {
                JSONObject colorJson = (JSONObject) surveyJson.get("color");

                switch (colorType) {
                    case BKACTIVITY_OPTION_DEF_BORDER:
                        String bgColor = validateJsonString(colorJson, "option_def_border");
                        if (bgColor != null && !bgColor.isEmpty()) {
                            color.setColor(Color.parseColor(bgColor));
                        }

                        break;
                    case BKACTIVITY_OPTION_SEL_BORDER:
                        String bgColor_sel = validateJsonString(colorJson, "option_sel_border");
                        if (bgColor_sel != null && !bgColor_sel.isEmpty()) {
                            color.setColor(Color.parseColor(bgColor_sel));
                        }

                        break;
                    case BKACTIVITY_BG_COLOR:
                        String bgColor_bg = validateJsonString(colorJson, "background");
                        if (bgColor_bg != null && !bgColor_bg.isEmpty()) {
                            color.setColor(Color.parseColor(bgColor_bg));
                        }
                        break;
                    case BKACTIVITY_SURVEY_HEADER_COLOR:
                        String headerBG = validateJsonString(colorJson, "headerBG");
                        if (headerBG != null && !headerBG.isEmpty()) {
                            color.setColor(Color.parseColor(headerBG));
                        }

                        break;
                    case BKACTIVITY_BOTTOM_COLOR:
                        String bottomBG = validateJsonString(colorJson, "bottomBG");
                        if (bottomBG != null && !bottomBG.isEmpty()) {
                            color.setColor(Color.parseColor(bottomBG));
                        }
                        break;
                    case BKACTIVITY_PAGINATION_BORDER_COLOR:
                        String pagenationdots_current = validateJsonString(colorJson, "pagenationdots_current");
                        if (pagenationdots_current != null && !pagenationdots_current.isEmpty()) {
                            color.setColor(Color.parseColor(pagenationdots_current));
                        }
                        break;
                    case BKACTIVITY_PAGINATION_ANSWERED_COLOR:
                        String pagenationdots_answered = validateJsonString(colorJson, "pagenationdots_answered");
                        if (pagenationdots_answered != null && !pagenationdots_answered.isEmpty()) {
                            color.setColor(Color.parseColor(pagenationdots_answered));
                        }
                        break;
                    case BKACTIVITY_PAGINATION_DEFAULT_COLOR:
                        String pagenationdots_def = validateJsonString(colorJson, "pagenationdots_def");
                        if (pagenationdots_def != null && !pagenationdots_def.isEmpty()) {
                            color.setColor(Color.parseColor(pagenationdots_def));
                        }
                        break;
                }

            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    @Override
    public void customizeRating(List<Bitmap> selectedRatingList, List<Bitmap> unselectedRatingList,
                                BKUIPrefComponents.BKActivityRatingTypes ratingType) {
        super.customizeRating(selectedRatingList, unselectedRatingList, ratingType);

        if (surveyJson != null) {

            try {
                JSONObject imageJson = (JSONObject) surveyJson.get("image");

                switch (ratingType) {
                    case BKACTIVITY_STAR_RATING:
                        Bitmap selected = BitmapFactory.decodeResource(mContext.getResources(),
                                getIdentifier(mContext, getImageName(imageJson, "star_sel")));
                        Bitmap unselected = BitmapFactory.decodeResource(mContext.getResources(),
                                getIdentifier(mContext, getImageName(imageJson, "star_def")));

                        if (selected != null && unselected != null) {
                            selectedRatingList.add(selected);
                            unselectedRatingList.add(unselected);
                        }
                        break;

                    case BKACTIVITY_EMOJI_RATING:

                        Bitmap veryBad_def = getBitmap(
                                getIdentifier(mContext, getImageName(imageJson, "smiley_vbad_def")));
                        Bitmap bad_def = getBitmap(getIdentifier(mContext, getImageName(imageJson, "smiley_bad_def")));
                        Bitmap avg_def = getBitmap(getIdentifier(mContext, getImageName(imageJson, "smiley_avg_def")));
                        Bitmap good_def = getBitmap(
                                getIdentifier(mContext, getImageName(imageJson, "smiley_good_def")));
                        Bitmap vGood_def = getBitmap(
                                getIdentifier(mContext, getImageName(imageJson, "smiley_Vgood_def")));

                        Bitmap veryBad_sel = getBitmap(
                                getIdentifier(mContext, getImageName(imageJson, "smiley_vbad_sel")));
                        Bitmap bad_sel = getBitmap(getIdentifier(mContext, getImageName(imageJson, "smiley_bad_sel")));
                        Bitmap avg_sel = getBitmap(getIdentifier(mContext, getImageName(imageJson, "smiley_avg_sel")));
                        Bitmap good_sel = getBitmap(
                                getIdentifier(mContext, getImageName(imageJson, "smiley_good_sel")));
                        Bitmap vGood_sel = getBitmap(
                                getIdentifier(mContext, getImageName(imageJson, "smiley_Vgood_sel")));

                        if (veryBad_sel != null && veryBad_def != null &&
                                bad_def != null && bad_sel != null &&
                                avg_sel != null && avg_def != null &&
                                good_sel != null && good_def != null &&
                                vGood_sel != null && vGood_def != null) {

                            unselectedRatingList.add(veryBad_def);
                            unselectedRatingList.add(bad_def);
                            unselectedRatingList.add(avg_def);
                            unselectedRatingList.add(good_def);
                            unselectedRatingList.add(vGood_def);

                            selectedRatingList.add(veryBad_sel);
                            selectedRatingList.add(bad_sel);
                            selectedRatingList.add(avg_sel);
                            selectedRatingList.add(good_sel);
                            selectedRatingList.add(veryBad_sel);
                        }
                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    private Bitmap getBitmap(int id) {

        return BitmapFactory.decodeResource(mContext.getResources(), id);
    }

    @Override
    public void customizeTextView(BKActivityTextViewTypes textViewType, TextView textView) {
        super.customizeTextView(textViewType, textView);

        if (surveyJson != null) {

            try {
                JSONObject label_textJson = (JSONObject) surveyJson.get("label_text");
                JSONObject sliderJson = (JSONObject) surveyJson.get("slider");
                switch (textViewType) {
                    case BKACTIVITY_HEADER_TV:
                        JSONObject header = (JSONObject) label_textJson.get("header");
                        applyTextViewProperties(header, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_SURVEY_DESC_TV:
                        JSONObject desc = (JSONObject) label_textJson.get("desc");
                        applyTextViewProperties(desc, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_SLIDE_TEXT_TV:
                        JSONObject slider_score = (JSONObject) sliderJson.get("slider_score");
                        applyTextViewProperties(slider_score, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_SLIDE_MAX_TV:
                        JSONObject slider_maxScore = (JSONObject) sliderJson.get("slider_maxScore");
                        applyTextViewProperties(slider_maxScore, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_SLIDE_MIN_TV:
                        JSONObject slider_minScore = (JSONObject) sliderJson.get("slider_minScore");
                        applyTextViewProperties(slider_minScore, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_SLIDE_MAX_LABEL_TV:
                        JSONObject slider_maxText = (JSONObject) sliderJson.get("slider_maxText");
                        applyTextViewProperties(slider_maxText, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_SLIDE_MIN_LABEL_TV:
                        JSONObject slider_minText = (JSONObject) sliderJson.get("slider_minText");
                        applyTextViewProperties(slider_minText, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_QUESTION_TV:
                        JSONObject question = (JSONObject) label_textJson.get("question");
                        applyTextViewProperties(question, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_THANK_YOU_TV:
                        JSONObject thanksJson = (JSONObject) label_textJson.get("thankyou");
                        JSONObject imageJson = (JSONObject) surveyJson.get("image");
                        JSONObject colorJson = (JSONObject) surveyJson.get("color");
                        applyTextViewProperties(thanksJson, textView, flutterLoader, flutterBinding);

                        if (colorJson != null) {
                            String bgColor = validateJsonString(colorJson, "background");
                            if (bgColor != null && !bgColor.isEmpty()) {
                                textView.setBackgroundColor(Color.parseColor(bgColor));
                            }
                        }
                        if (imageJson != null) {
                            String bgData = getImageName(imageJson, "background");
                            setImageToView(mContext, bgData, textView);
                        }
                        break;
                    case BKACTIVITY_OPTION_TV:
                        JSONObject option = (JSONObject) label_textJson.get("option");
                        applyTextViewProperties(option, textView, flutterLoader, flutterBinding);
                        break;
                }

            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    public void customizeImageView(ImageView imageView, BKUIPrefComponents.BKActivityImageViewType imageType) {
        super.customizeImageView(imageView, imageType);

        if (surveyJson != null) {
            try {
                JSONObject imageJson = (JSONObject) surveyJson.get("image");

                switch (imageType) {
                    case BKACTIVITY_PORTRAIT_LOGO:
                    case BKACTIVITY_LANDSCAPE_LOGO:
                        String bgData = getImageName(imageJson, "logo");
                        setImageToView(mContext, bgData, imageView);
                        break;
                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    @Override
    public void customizeRelativeLayout(BKUIPrefComponents.BKActivityRelativeLayoutTypes relativeLayoutTypes,
                                        RelativeLayout relativeLayout, boolean isFullScreen) {
        super.customizeRelativeLayout(relativeLayoutTypes, relativeLayout, isFullScreen);

        if (surveyJson != null) {

            try {
                JSONObject imageJson = (JSONObject) surveyJson.get("image");
                JSONObject colorJson = (JSONObject) surveyJson.get("color");
                if (colorJson != null) {
                    String bgColor = validateJsonString(colorJson, "background");
                    if (bgColor != null && !bgColor.isEmpty()) {
                        relativeLayout.setBackgroundColor(Color.parseColor(bgColor));
                    }
                }
                switch (relativeLayoutTypes) {
                    case BKACTIVITY_BACKGROUND_IMAGE:
                        String bgData = getImageName(imageJson, "background");
                        setImageToView(mContext, bgData, relativeLayout);
                        break;
                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    @Override
    public void customizeImageButton(ImageButton button, BKUIPrefComponents.BKActivityImageButtonTypes buttonType) {
        super.customizeImageButton(button, buttonType);

        if (surveyJson != null) {

            try {
                JSONObject buttonJson = (JSONObject) surveyJson.get("button");
                switch (buttonType) {
                    case BKACTIVITY_SKIP_BUTTON:
                        JSONObject submitButtonJsonObject = (JSONObject) buttonJson.get("skip");
                        applySkipImage(mContext, submitButtonJsonObject, button);
                        break;
                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }
}