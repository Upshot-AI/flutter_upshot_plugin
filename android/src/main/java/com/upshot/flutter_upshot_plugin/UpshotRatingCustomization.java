package com.upshot.flutter_upshot_plugin;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
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
import com.brandkinesis.BKUIPrefComponents.BKActivityTextViewTypes;

import org.json.JSONObject;

import java.util.List;

import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

public class UpshotRatingCustomization extends UpshotCustomization {

    private Context mContext;
    private JSONObject ratingJson = null;

    private FlutterLoader flutterLoader;

    private FlutterPlugin.FlutterPluginBinding flutterBinding;

    public UpshotRatingCustomization(Context context, JSONObject ratingJson, FlutterLoader loader,
                                     FlutterPlugin.FlutterPluginBinding binding) {
        mContext = context;
        try {
            this.ratingJson = ratingJson;
            flutterLoader = loader;
            flutterBinding = binding;
        } catch (Exception e) {
            UpshotHelper.logException(e);
        }
    }

    public void customizeButton(Button button, BKUIPrefComponents.BKActivityButtonTypes buttonType) {

        if (ratingJson != null) {
            try {
                JSONObject buttonJson = (JSONObject) ratingJson.get("button");
                switch (buttonType) {
                    case BKACTIVITY_SUBMIT_BUTTON:
                        JSONObject submitButtonJson = (JSONObject) buttonJson.get("submit");
                        applyButtonProperties(mContext, submitButtonJson, button, flutterLoader, flutterBinding);
                        break;

                    case BKACTIVITY_RATING_YES_BUTTON:
                        JSONObject yesButtonJson = (JSONObject) buttonJson.get("yes");
                        applyButtonProperties(mContext, yesButtonJson, button, flutterLoader, flutterBinding);
                        break;

                    case BKACTIVITY_RATING_NO_BUTTON:
                        JSONObject noButtonJson = (JSONObject) buttonJson.get("no");
                        applyButtonProperties(mContext, noButtonJson, button, flutterLoader, flutterBinding);
                        break;
                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    @Override
    public void customizeTextView(BKActivityTextViewTypes textViewType, TextView textView) {
        super.customizeTextView(textViewType, textView);

        if (ratingJson != null) {
            try {
                JSONObject label_textJson = (JSONObject) ratingJson.get("label_text");
                JSONObject sliderJson = (JSONObject) ratingJson.get("slider");

                switch (textViewType) {
                    case BKACTIVITY_HEADER_TV:
                        JSONObject headerJson = (JSONObject) label_textJson.get("feedback_header");
                        applyTextViewProperties(headerJson, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_THANK_YOU_TV:
                        JSONObject thanksJson = (JSONObject) label_textJson.get("thankyou");
                        JSONObject imageJson = (JSONObject) ratingJson.get("image");
                        JSONObject colorJson = (JSONObject) ratingJson.get("color");

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
                    case BKACTIVITY_THANK_YOU_APPSTORE_HINT:
                        JSONObject appStoreHitJson = (JSONObject) label_textJson.get("appStoreHint");
                        applyTextViewProperties(appStoreHitJson, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_SLIDE_TEXT_TV:
                        JSONObject sliderScoreJson = (JSONObject) sliderJson.get("slider_score");
                        applyTextViewProperties(sliderScoreJson, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_SLIDE_MAX_TV:
                        JSONObject sliderMaxScoreJson = (JSONObject) sliderJson.get("slider_maxScore");
                        applyTextViewProperties(sliderMaxScoreJson, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_SLIDE_MIN_TV:
                        JSONObject sliderMinScoreJson = (JSONObject) sliderJson.get("slider_minScore");
                        applyTextViewProperties(sliderMinScoreJson, textView, flutterLoader, flutterBinding);
                        break;

                    case BKACTIVITY_SLIDE_MAX_LABEL_TV:
                        JSONObject sliderMaxTextJson = (JSONObject) sliderJson.get("slider_maxText");
                        applyTextViewProperties(sliderMaxTextJson, textView, flutterLoader, flutterBinding);
                        break;

                    case BKACTIVITY_SLIDE_MIN_LABEL_TV:
                        JSONObject sliderMinTextJson = (JSONObject) sliderJson.get("slider_minText");
                        applyTextViewProperties(sliderMinTextJson, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_QUESTION_TV:
                        JSONObject questionJson = (JSONObject) label_textJson.get("question");
                        applyTextViewProperties(questionJson, textView, flutterLoader, flutterBinding);
                        break;
                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    @Override
    public void customizeBGColor(BKUIPrefComponents.BKBGColors color,
                                 BKUIPrefComponents.BKActivityColorTypes colorType) {
        super.customizeBGColor(color, colorType);

        if (ratingJson != null) {
            try {
                JSONObject colorJson = (JSONObject) ratingJson.get("color");
                switch (colorType) {
                    case BKACTIVITY_BG_COLOR:
                        String bgColor = validateJsonString(colorJson, "background");
                        if (bgColor != null && !bgColor.isEmpty()) {
                            color.setColor(Color.parseColor(bgColor));
                        }
                        break;

                    case BKACTIVITY_SURVEY_HEADER_COLOR:
                        String headerBGColor = validateJsonString(colorJson, "headerBG");
                        if (headerBGColor != null && !headerBGColor.isEmpty()) {
                            color.setColor(Color.parseColor(headerBGColor));
                        }
                        break;

                    case BKACTIVITY_BOTTOM_COLOR:
                        String bottomBGColor = validateJsonString(colorJson, "bottomBG");
                        if (bottomBGColor != null && !bottomBGColor.isEmpty()) {
                            color.setColor(Color.parseColor(bottomBGColor));
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

        if (ratingJson != null) {

            try {
                JSONObject imageJson = (JSONObject) ratingJson.get("image");

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

    public void customizeImageView(ImageView imageView, BKUIPrefComponents.BKActivityImageViewType imageType) {
        super.customizeImageView(imageView, imageType);

        if (ratingJson != null) {
            try {
                JSONObject imageJson = (JSONObject) ratingJson.get("image");

                switch (imageType) {
                    case BACTIVITY_RATING_LIKE_BUTTON:
                        imageView.setImageResource(R.drawable.rating_like_selector);
                        break;
                    case BACTIVITY_RATING_DISLIKE_BUTTON:
                        imageView.setImageResource(R.drawable.rating_dislike_selector);
                        break;
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
    public void customizeSeekBar(BKUIPrefComponents.BKActivitySeekBarTypes seekBarTypes, SeekBar seekBar) {
        super.customizeSeekBar(seekBarTypes, seekBar);

        if (ratingJson != null) {
            try {
                JSONObject sliderJson = (JSONObject) ratingJson.get("slider");
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

        if (ratingJson != null) {
            try {
                JSONObject feedbackJson = (JSONObject) ratingJson.get("feedbackBox");

                switch (EditTextType) {
                    case BKACTIVITY_RATING_EDIT_TEXT:
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
    public void customizeRelativeLayout(BKUIPrefComponents.BKActivityRelativeLayoutTypes relativeLayoutTypes,
                                        RelativeLayout relativeLayout, boolean isFullScreen) {
        super.customizeRelativeLayout(relativeLayoutTypes, relativeLayout, isFullScreen);
        if (ratingJson != null) {

            try {
                JSONObject imageJson = (JSONObject) ratingJson.get("image");
                JSONObject colorJson = (JSONObject) ratingJson.get("color");
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

        if (ratingJson != null) {
            try {
                JSONObject buttonJson = (JSONObject) ratingJson.get("button");
                switch (buttonType) {
                    case BKACTIVITY_SKIP_BUTTON:
                        JSONObject skipButtonJson = (JSONObject) buttonJson.get("skip");
                        applySkipImage(mContext, skipButtonJson, button);
                        break;
                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }
}