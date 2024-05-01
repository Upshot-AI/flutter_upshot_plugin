package com.upshot.flutter_upshot_plugin;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.brandkinesis.BKUIPrefComponents;
import com.brandkinesis.BKUIPrefComponents.BKActivityButtonTypes;
import com.brandkinesis.BKUIPrefComponents.BKActivityTextViewTypes;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.List;

import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

public class UpshotOpinionPollCustomization extends UpshotCustomization {

    private Context mContext;
    private JSONObject opinionPollJson = null;
    private FlutterLoader flutterLoader;
    private FlutterPlugin.FlutterPluginBinding flutterBinding;

    public UpshotOpinionPollCustomization(Context context, JSONObject pollJSON, FlutterLoader loader,
            FlutterPlugin.FlutterPluginBinding binding) {
        mContext = context;
        try {
            opinionPollJson = pollJSON;
            flutterLoader = loader;
            flutterBinding = binding;
        } catch (Exception e) {
            UpshotHelper.logException(e);
        }
    }

    public void customizeRadioButton(BKUIPrefComponents.BKUICheckBox checkBox, boolean isCheckBox) {
        super.customizeRadioButton(checkBox, isCheckBox);

        if (opinionPollJson != null) {
            try {
                JSONObject imageJson = (JSONObject) opinionPollJson.get("image");

                Bitmap check_select = BitmapFactory.decodeResource(mContext.getResources(),
                        getIdentifier(mContext, getImageName(imageJson, "radio_sel")));

                Bitmap default_select = BitmapFactory.decodeResource(mContext.getResources(),
                        getIdentifier(mContext, validateJsonString(imageJson, "radio_def")));
                checkBox.setUnselectedCheckBox(default_select);
                checkBox.setSelectedCheckBox(check_select);
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    @Override
    public void customizeButton(Button button, BKActivityButtonTypes buttonType) {
        super.customizeButton(button, buttonType);

        if (opinionPollJson != null) {
            try {
                JSONObject buttonJson = (JSONObject) opinionPollJson.get("button");

                switch (buttonType) {
                    case BKACTIVITY_SUBMIT_BUTTON:
                        JSONObject submitButtonJsonObject = (JSONObject) buttonJson.get("submit");
                        applyButtonProperties(mContext, submitButtonJsonObject, button, flutterLoader, flutterBinding);
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

        if (opinionPollJson != null) {
            try {
                JSONObject label_textJson = (JSONObject) opinionPollJson.get("label_text");
                JSONObject graphJsonObject = (JSONObject) opinionPollJson.get("graph");

                switch (textViewType) {
                    case BKACTIVITY_QUESTION_TV:
                        JSONObject questionJson = (JSONObject) label_textJson.get("question");
                        applyTextViewProperties(questionJson, textView, flutterLoader, flutterBinding);
                        break;

                    case BKACTIVITY_THANK_YOU_TV:

                        JSONObject thanksJson = (JSONObject) label_textJson.get("thankyou");
                        JSONObject colorJson = (JSONObject) opinionPollJson.get("color");
                        JSONObject imageJson = (JSONObject) opinionPollJson.get("image");

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
                    case BKACTIVITY_QUESTION_OPTION_TV:
                        JSONObject optionJson = (JSONObject) label_textJson.get("option");
                        applyTextViewProperties(optionJson, textView, flutterLoader, flutterBinding);
                        break;
                    /* To customise graph legends */
                    case BKACTIVITY_LEGEND_TV:
                        String legendsColor = graphJsonObject.getString("legends");
                        if (!legendsColor.isEmpty()) {
                            textView.setTextColor(Color.parseColor(legendsColor));
                        }
                        break;
                    /* To customise bar graph Y axis header */
                    case BKACTIVITY_LEADER_BOARD_BAR_RESPONSES_TV:
                        String yAxis_HeaderColor = graphJsonObject.getString("yAxis_Header");
                        if (!yAxis_HeaderColor.isEmpty()) {
                            textView.setTextColor(Color.parseColor(yAxis_HeaderColor));
                        }
                        break;
                    /* To customise bar graph X axis header */
                    case BKACTIVITY_LEADER_BOARD_BAR_GRADES_TV:
                        String xAxis_HeaderColor = graphJsonObject.getString("xAxis_Header");
                        if (!xAxis_HeaderColor.isEmpty()) {
                            textView.setTextColor(Color.parseColor(xAxis_HeaderColor));
                        }
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

        if (opinionPollJson != null) {
            try {
                JSONObject colorJson = (JSONObject) opinionPollJson.get("color");
                JSONObject graphJson = (JSONObject) opinionPollJson.get("graph");
                switch (colorType) {
                    case BKACTIVITY_OPTION_DEF_BORDER:
                        String optionDefBorderColor = validateJsonString(colorJson, "option_def_border");
                        if (optionDefBorderColor != null && !optionDefBorderColor.isEmpty()) {
                            color.setColor(Color.parseColor(optionDefBorderColor));
                        }
                        break;
                    case BKACTIVITY_OPTION_SEL_BORDER:
                        String optionSelBorderColor = validateJsonString(colorJson, "option_sel_border");
                        if (optionSelBorderColor != null && !optionSelBorderColor.isEmpty()) {
                            color.setColor(Color.parseColor(optionSelBorderColor));
                        }
                        break;
                    case BKACTIVITY_BG_COLOR:
                        String bgColor = validateJsonString(colorJson, "background");
                        color.setColor(Color.parseColor(bgColor));
                        break;
                    case BKACTIVITY_SURVEY_HEADER_COLOR:
                        String headerColor = validateJsonString(colorJson, "headerBG");
                        color.setColor(Color.parseColor(headerColor));
                        break;

                    /* To customise Bar graph Y axis range */
                    case BKACTIVITY_YAXIS_TEXT_COLOR_COLOR:
                    case BKACTIVITY_XAXIS_TEXT_COLOR_COLOR: {
                        String yAxisColor = validateJsonString(graphJson, "yAxis");
                        if (yAxisColor != null && !yAxisColor.isEmpty()) {
                            color.setColor(Color.parseColor(yAxisColor));
                        }
                    }
                        break;
                    /* To customise Bar graph line */
                    case BKACTIVITY_YAXIS_COLOR:
                    case BKACTIVITY_XAXIS_COLOR:
                        String barGraphLine = validateJsonString(graphJson, "bar_line");
                        if (barGraphLine != null && !barGraphLine.isEmpty()) {
                            color.setColor(Color.parseColor(barGraphLine));
                        }
                        break;
                    case BKACTIVITY_PERCENTAGE_COLOR:
                        String percentageColor = validateJsonString(graphJson, "percentage");
                        if (percentageColor != null && !percentageColor.isEmpty()) {
                            color.setColor(Color.parseColor(percentageColor));
                        }

                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    public void customizeImageView(ImageView imageView, BKUIPrefComponents.BKActivityImageViewType imageType) {
        super.customizeImageView(imageView, imageType);

        if (opinionPollJson != null) {
            try {
                JSONObject imageJson = (JSONObject) opinionPollJson.get("image");
                switch (imageType) {
                    case BKACTIVITY_PORTRAIT_LOGO:
                    case BKACTIVITY_LANDSCAPE_LOGO:
                        String logo = getImageName(imageJson, "logo");
                        setImageToView(mContext, logo, imageView);
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
        if (opinionPollJson != null) {

            try {
                JSONObject imageJson = (JSONObject) opinionPollJson.get("image");
                JSONObject colorJson = (JSONObject) opinionPollJson.get("color");
                if (colorJson != null) {
                    String bgColor = validateJsonString(colorJson, "background");
                    if (bgColor != null && !bgColor.isEmpty()) {
                        relativeLayout.setBackgroundColor(Color.parseColor(bgColor));
                    }
                }
                switch (relativeLayoutTypes) {
                    case BKACTIVITY_BACKGROUND_IMAGE:
                        String bgImage = getImageName(imageJson, "background");
                        setImageToView(mContext, bgImage, relativeLayout);
                        break;
                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    @Override
    public void customizeForGraphColor(BKUIPrefComponents.BKGraphType graphType, List<Integer> colorsList) {
        super.customizeForGraphColor(graphType, colorsList);

        if (opinionPollJson != null) {
            try {
                JSONObject graphJson = (JSONObject) opinionPollJson.get("graph");
                switch (graphType) {
                    case BKACTIVITY_BAR_GRAPH:
                        colorsList.clear();

                        JSONArray barColors = graphJson.getJSONArray("barcolors");

                        for (int i = 0; i < barColors.length(); i++) {
                            colorsList.add(Color.parseColor(barColors.getString(i)));
                        }
                        break;
                    case BKACTIVITY_PIE_GRAPH:
                        colorsList.clear();
                        JSONArray pieColors = graphJson.getJSONArray("piecolors");
                        for (int i = 0; i < pieColors.length(); i++) {
                            colorsList.add(Color.parseColor(pieColors.getString(i)));
                        }
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

        if (opinionPollJson != null) {

            try {
                JSONObject buttonJson = (JSONObject) opinionPollJson.get("button");
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