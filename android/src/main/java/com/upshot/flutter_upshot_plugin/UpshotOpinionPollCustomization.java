package com.upshot.flutter_upshot_plugin;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.view.View;
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

public class UpshotOpinionPollCustomization extends UpshotCustomization {

    private Context mContext;
    private JSONObject mJsonObject = null;
    public UpshotOpinionPollCustomization(Context context, JSONObject pollJSON) {
        mContext = context;
        try {
            mJsonObject = pollJSON;//new JSONObject(loadJSONFromAsset(context, "UpshotPollTheme.json"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void customizeRadioButton(BKUIPrefComponents.BKUICheckBox checkBox, boolean isCheckBox) {
        super.customizeRadioButton(checkBox, isCheckBox);
        if (mJsonObject != null) {
            try {
                JSONObject imageJsonObject = (JSONObject) mJsonObject.get("image");
                Bitmap check_select, default_select;

                check_select = BitmapFactory.decodeResource(mContext.getResources(), getIdentifier(mContext, validateJsonString(imageJsonObject, "radio_sel")));
                checkBox.setSelectedCheckBox(check_select);

                default_select = BitmapFactory.decodeResource(mContext.getResources(), getIdentifier(mContext, validateJsonString(imageJsonObject, "radio_def")));
                checkBox.setUnselectedCheckBox(default_select);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void customizeButton(Button button, BKActivityButtonTypes buttonType) {
        super.customizeButton(button, buttonType);

        if (mJsonObject != null) {

            try {
                JSONObject buttonJsonObject = (JSONObject) mJsonObject.get("button");

                switch (buttonType) {
                    case BKACTIVITY_SUBMIT_BUTTON:
                        JSONObject submitButtonJsonObject = (JSONObject) buttonJsonObject.get("submit");
                        applyButtonProperties(mContext, submitButtonJsonObject, button);
                        break;
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void customizeTextView(BKActivityTextViewTypes textViewType, TextView textView) {
        super.customizeTextView(textViewType, textView);

        if (mJsonObject != null) {
            try {
                JSONObject label_textJsonObject = (JSONObject) mJsonObject.get("label_text");
                switch (textViewType) {
                    case BKACTIVITY_QUESTION_TV:
                        JSONObject question = (JSONObject) label_textJsonObject.get("question");
                        applyTextViewProperties(mContext, question, textView);
                        break;

                    case BKACTIVITY_THANK_YOU_TV:
                        JSONObject thanksJsonObject = (JSONObject) label_textJsonObject.get("thankyou");
                        applyTextViewProperties(mContext, thanksJsonObject, textView);
                        JSONObject colorJsonObject = (JSONObject) mJsonObject.get("color");
                        if (colorJsonObject != null) {
                            String bgColor = validateJsonString(colorJsonObject, "background");
                            if (bgColor != null && !bgColor.isEmpty()) {
                                textView.setBackgroundColor(Color.parseColor(bgColor));
                            }
                        }
                        break;

                    case BKACTIVITY_OPTION_TV:
                    case BKACTIVITY_QUESTION_OPTION_TV:
                        JSONObject option = (JSONObject) label_textJsonObject.get("option");
                        applyTextViewProperties(mContext, option, textView);
                        break;
                    case BKACTIVITY_LEGEND_TV:
                        JSONObject graph_legends = (JSONObject) label_textJsonObject.get("graph_legends");
                        applyTextViewProperties(mContext, graph_legends, textView);
                        break;
                    case BKACTIVITY_LEADER_BOARD_BAR_RESPONSES_TV:
                        JSONObject option_response = (JSONObject) label_textJsonObject.get("graph_users_text");
                        applyTextViewProperties(mContext, option_response, textView);
                        break;
                    case BKACTIVITY_LEADER_BOARD_BAR_GRADES_TV:
                        JSONObject bar_option = (JSONObject) label_textJsonObject.get("graph_options_text");
                        applyTextViewProperties(mContext, bar_option, textView);
                        break;
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    @Override
    public void customizeBGColor(BKUIPrefComponents.BKBGColors color, BKUIPrefComponents.BKActivityColorTypes colorType) {
        super.customizeBGColor(color, colorType);

        if (mJsonObject != null) {
            try {
                JSONObject jsonObject = (JSONObject) mJsonObject.get("color");
                switch (colorType) {
                    case BKACTIVITY_OPTION_DEF_BORDER:
                        String bgColor = validateJsonString(jsonObject, "option_def_border");
                        if (bgColor != null && !bgColor.isEmpty()) {
                            color.setColor(Color.parseColor(bgColor));
                        }
                        break;
                    case BKACTIVITY_OPTION_SEL_BORDER:
                        String bgColor_sel = validateJsonString(jsonObject, "option_sel_border");
                        if (bgColor_sel != null && !bgColor_sel.isEmpty()) {
                            color.setColor(Color.parseColor(bgColor_sel));
                        }
                        break;
                    case BKACTIVITY_BG_COLOR:
                        String bgColor_bg = validateJsonString(jsonObject, "background");
                        color.setColor(Color.parseColor(bgColor_bg));
                        break;
                    case BKACTIVITY_SURVEY_HEADER_COLOR:
                        String headerBG = validateJsonString(jsonObject, "headerBG");
                        color.setColor(Color.parseColor(headerBG));
                        break;
                    case BKACTIVITY_XAXIS_COLOR:
                    case BKACTIVITY_XAXIS_TEXT_COLOR_COLOR:
                    case BKACTIVITY_YAXIS_TEXT_COLOR_COLOR:
                    case BKACTIVITY_YAXIS_COLOR:
                        String percentageText = validateJsonString(jsonObject, "percentageText");
                        color.setColor(Color.parseColor(percentageText));
                        break;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void customizeImageView(ImageView imageView, BKUIPrefComponents.BKActivityImageViewType imageType) {
        super.customizeImageView(imageView, imageType);

        if (mJsonObject != null) {
            try {
                JSONObject jImageBg = (JSONObject) mJsonObject.get("image");
                switch (imageType) {
                    case BKACTIVITY_PORTRAIT_LOGO:
                        String bgData = validateJsonString(jImageBg, "logo");
                        applyImageProperties(mContext, bgData, imageView);
                        break;
                    case BKACTIVITY_LANDSCAPE_LOGO:
                        String landscapeBackground = validateJsonString(jImageBg, "landscapeLogo");
                        applyImageProperties(mContext, landscapeBackground, imageView);
                        break;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void customizeRelativeLayout(BKUIPrefComponents.BKActivityRelativeLayoutTypes relativeLayoutTypes, RelativeLayout relativeLayout, boolean isFullScreen) {
        super.customizeRelativeLayout(relativeLayoutTypes, relativeLayout, isFullScreen);
        if (mJsonObject != null) {

            try {
                JSONObject jImageBg = (JSONObject) mJsonObject.get("image");
                JSONObject colorJsonObject = (JSONObject) mJsonObject.get("color");
                if (colorJsonObject != null) {
                    String bgColor = validateJsonString(colorJsonObject, "background");
                    if (bgColor != null && !bgColor.isEmpty()) {
                        relativeLayout.setBackgroundColor(Color.parseColor(bgColor));
                    }
                }
                switch (relativeLayoutTypes) {
                    case BKACTIVITY_BACKGROUND_IMAGE:
                        String bgData = validateJsonString(jImageBg, "background");

                        applyRelativeLayoutProperties(mContext, bgData, relativeLayout);
                        break;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void customizeForGraphColor(BKUIPrefComponents.BKGraphType graphType, List<Integer> colorsList) {
        super.customizeForGraphColor(graphType, colorsList);

        if (mJsonObject != null) {
            try {
                JSONObject buttonJsonObject = (JSONObject) mJsonObject.get("graph");
                switch (graphType) {
                    case BKACTIVITY_BAR_GRAPH:
                        colorsList.clear();

                        JSONArray jsonArray = buttonJsonObject.getJSONArray("barcolors");

                        for (int i = 0; i < jsonArray.length(); i++) {
                            colorsList.add(Color.parseColor(jsonArray.getString(i)));
                        }
                        break;
                    case BKACTIVITY_PIE_GRAPH:
                        colorsList.clear();
                        JSONArray piecolors = buttonJsonObject.getJSONArray("piecolors");
                        for (int i = 0; i < piecolors.length(); i++) {
                            colorsList.add(Color.parseColor(piecolors.getString(i)));
                        }

                        break;
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void customizeImageButton(ImageButton button, BKUIPrefComponents.BKActivityImageButtonTypes buttonType) {
        super.customizeImageButton(button, buttonType);

        if (mJsonObject != null) {

            try {
                JSONObject buttonJsonObject = (JSONObject) mJsonObject.get("button");

                switch (buttonType) {
                    case BKACTIVITY_SKIP_BUTTON:
                        JSONObject submitButtonJsonObject = (JSONObject) buttonJsonObject.get("skip");
                        applyImageButtonProperties(mContext, submitButtonJsonObject, button);
                        break;
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}