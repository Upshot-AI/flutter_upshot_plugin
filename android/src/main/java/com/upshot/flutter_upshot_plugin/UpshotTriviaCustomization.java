package com.upshot.flutter_upshot_plugin;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.brandkinesis.BKUIPrefComponents;
import com.brandkinesis.BKUIPrefComponents.BKActivityButtonTypes;
import com.brandkinesis.BKUIPrefComponents.BKActivityColorTypes;
import com.brandkinesis.BKUIPrefComponents.BKActivityTextViewTypes;
import com.brandkinesis.BKUIPrefComponents.BKBGColors;

import java.util.List;

import static com.brandkinesis.BKUIPrefComponents.BKUICheckBox;

import org.json.JSONArray;
import org.json.JSONObject;

import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

public class UpshotTriviaCustomization extends UpshotCustomization {
    private Context mContext;
    private JSONObject mJsonObject = null;

    private FlutterLoader flutterLoader;

    private FlutterPlugin.FlutterPluginBinding flutterBinding;

    public UpshotTriviaCustomization(Context context, JSONObject triviaJSON, FlutterLoader loader, FlutterPlugin.FlutterPluginBinding binding) {
        mContext = context;
        try {
            mJsonObject = triviaJSON;
            flutterLoader = loader;
            flutterBinding = binding;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void customizeForLinearLayout(LinearLayout linearLayout, BKUIPrefComponents.BKActivityLinearLayoutTypes linearLayoutTypes) {
        super.customizeForLinearLayout(linearLayout, linearLayoutTypes);
        switch (linearLayoutTypes) {
            case BKACTIVITY_BACKGROUND_IMAGE:
                linearLayout.setBackgroundColor(Color.TRANSPARENT);
                break;
        }
    }

    @Override
    public void customizeForOptionsSeparatorView(View view) {
        super.customizeForOptionsSeparatorView(view);
        view.setBackgroundColor(Color.RED);
    }

    /**
     * customizeTextView is used to customize the TextView
     */
    @Override
    public void customizeTextView(BKActivityTextViewTypes textViewType, TextView textView) {
        super.customizeTextView(textViewType, textView);

        if (mJsonObject != null) {

            try {
                JSONObject label_textJsonObject = (JSONObject) mJsonObject.get("label_text");

                switch (textViewType) {
                    case BKACTIVITY_HEADER_TV:
                        JSONObject header = (JSONObject) label_textJsonObject.get("header");
                        applyTextViewProperties(mContext, header, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_TRIVIA_DESC_TV:
                        JSONObject desc = (JSONObject) label_textJsonObject.get("desc");
                        applyTextViewProperties(mContext, desc, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_QUESTION_TV:
                        JSONObject question = (JSONObject) label_textJsonObject.get("question");
                        applyTextViewProperties(mContext, question, textView, flutterLoader, flutterBinding);
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
                    case BKACTIVITY_QUESTION_OPTION_TV:
                    case BKACTIVITY_OPTION_TV:
                        JSONObject option = (JSONObject) label_textJsonObject.get("option");
                        applyTextViewProperties(mContext, option, textView, flutterLoader, flutterBinding);
                        break;


                    case BKACTIVITY_SCORE_TV:
                        JSONObject option_score = (JSONObject) label_textJsonObject.get("score");
                        applyTextViewProperties(mContext, option_score, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_LEADER_BOARD_TITLE_TV: {
                        JSONObject leaderBoardJSON = (JSONObject) mJsonObject.get("leaderBoard");
                        JSONObject option_result = (JSONObject) leaderBoardJSON.get("result");
                        applyTextViewProperties(mContext, option_result, textView, flutterLoader, flutterBinding);
                    }
                    break;
                    case BKACTIVITY_LEADER_BOARD_SCORE_VALUE_TV: {
                        JSONObject leaderBoardJSON = (JSONObject) mJsonObject.get("leaderBoard");
                        JSONObject option_result = (JSONObject) leaderBoardJSON.get("yourScore");
                        applyTextViewProperties(mContext, option_result, textView, flutterLoader, flutterBinding);
                    }
                    break;
                    case BKACTIVITY_LEADER_BOARD_GRADE_VALUE_TV: {
                        JSONObject leaderBoardJSON = (JSONObject) mJsonObject.get("leaderBoard");
                        JSONObject option_yourGrade = (JSONObject) leaderBoardJSON.get("yourGrade");
                        applyTextViewProperties(mContext, option_yourGrade, textView, flutterLoader, flutterBinding);
                    }
                    break;
                    case BKACTIVITY_LEADER_BOARD_SCORE_TV: {
                        JSONObject leaderBoardJSON = (JSONObject) mJsonObject.get("leaderBoard");
                        JSONObject option_userScore = (JSONObject) leaderBoardJSON.get("userScore");
                        applyTextViewProperties(mContext, option_userScore, textView, flutterLoader, flutterBinding);
                    }
                    break;

                    case BKACTIVITY_LEADER_BOARD_GRADE_TV: {
                        JSONObject leaderBoardJSON = (JSONObject) mJsonObject.get("leaderBoard");
                        JSONObject option_userGrade = (JSONObject) leaderBoardJSON.get("userGrade");
                        applyTextViewProperties(mContext, option_userGrade, textView, flutterLoader, flutterBinding);
                    }
                    break;
                    case BKACTIVITY_LEADER_BOARD_BAR_RESPONSES_TV:
                    case BKACTIVITY_TRIVIA_GRADE_HEADER_TABLE_TV:
                    case BKACTIVITY_TRIVIA_RESPONSE_HEADER_TABLE_TV:
                        JSONObject option_userText = (JSONObject) label_textJsonObject.get("graph_users_text");
                        applyTextViewProperties(mContext, option_userText, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_LEADER_BOARD_BAR_GRADES_TV:
                        JSONObject option_optionsText = (JSONObject) label_textJsonObject.get("graph_options_text");
                        applyTextViewProperties(mContext, option_optionsText, textView, flutterLoader, flutterBinding);
                        break;
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * customizeForGraphColor is used to customize Bar and Pie Colors
     */
    @Override
    public void customizeForGraphColor(BKUIPrefComponents.BKGraphType graphType, List<Integer> colorsList) {
        super.customizeForGraphColor(graphType, colorsList);

        if (mJsonObject != null) {
            try {
                JSONObject buttonJsonObject = (JSONObject) mJsonObject.get("graph");

                switch (graphType) {
                    case BKACTIVITY_BAR_GRAPH:
                        colorsList.clear();
                        JSONArray barColors = buttonJsonObject.getJSONArray("bar");
                        if (barColors.length() == 5) {
                            for (int i = 0; i < barColors.length(); i++) {
                                colorsList.add(Color.parseColor(barColors.getString(i)));
                            }
                        }
                        break;
                    case BKACTIVITY_PIE_GRAPH:
                        colorsList.clear();
                        JSONArray pieColors = buttonJsonObject.getJSONArray("pie");
                        if (pieColors.length() == 5) {
                            for (int i = 0; i < pieColors.length(); i++) {
                                colorsList.add(Color.parseColor(pieColors.getString(i)));
                            }
                        }
                        break;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * customizeButton is used to customize Prev, Next....Buttons
     */
    @Override
    public void customizeButton(Button button, BKActivityButtonTypes buttonType) {
        super.customizeButton(button, buttonType);

        if (mJsonObject != null) {
            try {
                JSONObject buttonJsonObject = (JSONObject) mJsonObject.get("button");

                switch (buttonType) {
                    case BKACTIVITY_SUBMIT_BUTTON:
                        JSONObject submitButtonJsonObject = (JSONObject) buttonJsonObject.get("submit");
                        applyButtonProperties(mContext, submitButtonJsonObject, button, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_TRIVIA_CONTINUE_BUTTON:
                        JSONObject continueButtonJsonObject = (JSONObject) buttonJsonObject.get("continue");
                        applyButtonProperties(mContext, continueButtonJsonObject, button, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_TRIVIA_NEXT_BUTTON:
                        JSONObject nextButtonJsonObject = (JSONObject) buttonJsonObject.get("next");
                        applyButtonProperties(mContext, nextButtonJsonObject, button, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_TRIVIA_PREVIOUS_BUTTON:
                        JSONObject prevButtonJsonObject = (JSONObject) buttonJsonObject.get("prev");
                        applyButtonProperties(mContext, prevButtonJsonObject, button, flutterLoader, flutterBinding);
                        break;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * customizeBGColor is used to Customize BG Color
     */
    @Override
    public void customizeBGColor(BKBGColors color, BKActivityColorTypes colorType) {
        super.customizeBGColor(color, colorType);

        if (mJsonObject != null) {
            try {
                JSONObject jsonObject = (JSONObject) mJsonObject.get("color");

                switch (colorType) {

                    case BKACTIVITY_TRIVIA_HEADER_COLOR:
                    case BKACTIVITY_TRIVIA_TITLE_COLOR:
                        String headerBG = validateJsonString(jsonObject, "headerBG");
                        if (headerBG != null && !headerBG.isEmpty()) {
                            color.setColor(Color.parseColor(headerBG));
                        }
                        break;

                    case BKACTIVITY_BG_COLOR:
                    case BKACTIVITY_BOTTOM_COLOR:
                        String bgColor = validateJsonString(jsonObject, "background");
                        if (bgColor != null && !bgColor.isEmpty()) {
                            color.setColor(Color.parseColor(bgColor));
                        }
                        break;

                    case BKACTIVITY_OPTION_DEF_BORDER:
                        String option_borderColor = validateJsonString(jsonObject, "option_def_border");
                        if (option_borderColor != null && !option_borderColor.isEmpty()) {
                            color.setColor(Color.parseColor(option_borderColor));
                        }
                        break;
                    case BKACTIVITY_OPTION_SEL_BORDER:
                        String option_sel_borderColor = validateJsonString(jsonObject, "option_sel_border");
                        if (option_sel_borderColor != null && !option_sel_borderColor.isEmpty()) {
                            color.setColor(Color.parseColor(option_sel_borderColor));
                        }
                        break;

                    case BKACTIVITY_PAGINATION_BORDER_COLOR:
                        String pagenationdots_current = validateJsonString(jsonObject, "pagenationdots_current");
                        if (pagenationdots_current != null && !pagenationdots_current.isEmpty()) {
                            color.setColor(Color.parseColor(pagenationdots_current));
                        }
                        break;
                    case BKACTIVITY_PAGINATION_ANSWERED_COLOR:
                        String pagenationdots_answered = validateJsonString(jsonObject, "pagenationdots_answered");
                        if (pagenationdots_answered != null && !pagenationdots_answered.isEmpty()) {
                            color.setColor(Color.parseColor(pagenationdots_answered));
                        }
                        break;

                    case BKACTIVITY_PAGINATION_DEFAULT_COLOR:
                        String pagenationdots_def = validateJsonString(jsonObject, "pagenationdots_def");
                        if (pagenationdots_def != null && !pagenationdots_def.isEmpty()) {
                            color.setColor(Color.parseColor(pagenationdots_def));
                        }
                        break;

                    case BKACTIVITY_TRIVIA_GRADE_COLOR:
                        JSONObject label_textJsonObject = (JSONObject) mJsonObject.get("label_text");
                        JSONObject header = (JSONObject) label_textJsonObject.get("tabular_response");

                        String optionColor = validateJsonString(header, "color");
                        if (optionColor != null && !optionColor.isEmpty()) {
                            color.setColor(Color.parseColor(optionColor));
                        }
                        break;
                    case BKACTIVITY_XAXIS_TEXT_COLOR_COLOR:
                    case BKACTIVITY_YAXIS_TEXT_COLOR_COLOR:
                        String percentageText = validateJsonString(jsonObject, "percentageText");
                        if (percentageText != null && !percentageText.isEmpty()) {
                            color.setColor(Color.parseColor(percentageText));
                        }
                        break;
                    case BKACTIVITY_YAXIS_COLOR:
                    case BKACTIVITY_XAXIS_COLOR:
                        String barGraphLine = validateJsonString(jsonObject, "barGraphLine");
                        if (barGraphLine != null && !barGraphLine.isEmpty()) {
                            color.setColor(Color.parseColor(barGraphLine));
                        }
                        break;
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * customizeRadioButton is used to customize Radio and CheckBox image
     */
    public void customizeRadioButton(BKUICheckBox checkBox, boolean isCheckBox) {

        if (mJsonObject != null) {
            try {
                JSONObject imageJsonObject = (JSONObject) mJsonObject.get("image");
                Bitmap check_select, default_select;
                if (isCheckBox) {

                    String checkbox_sel_ImageName = imageJsonObject.getString("checkbox_sel");
                    String checkbox_def_ImageName = imageJsonObject.getString("checkbox_def");
                    check_select = getImageFromAssets(flutterLoader, checkbox_sel_ImageName, flutterBinding);
                    default_select = getImageFromAssets(flutterLoader, checkbox_def_ImageName, flutterBinding);

                    check_select = BitmapFactory.decodeResource(mContext.getResources(), getIdentifier(mContext, validateJsonString(imageJsonObject, "checkbox_sel")));
                    if (check_select != null) {
                        checkBox.setSelectedCheckBox(check_select);
                    }

                    if (default_select != null) {
                        checkBox.setUnselectedCheckBox(default_select);
                    }
//                    default_select = BitmapFactory.decodeResource(mContext.getResources(), getIdentifier(mContext, validateJsonString(imageJsonObject, "checkbox_def")));

                } else {

                    String radio_def_ImageName = imageJsonObject.getString("radio_def");
                    String radio_sel_ImageName = imageJsonObject.getString("radio_sel");
                    check_select = getImageFromAssets(flutterLoader, radio_sel_ImageName, flutterBinding);
                    default_select = getImageFromAssets(flutterLoader, radio_def_ImageName, flutterBinding);
//                    default_select = BitmapFactory.decodeResource(mContext.getResources(), getIdentifier(mContext, validateJsonString(imageJsonObject, "radio_def")));
//                    check_select = BitmapFactory.decodeResource(mContext.getResources(), getIdentifier(mContext, validateJsonString(imageJsonObject, "radio_sel")));
                    if (check_select != null) {
                        checkBox.setSelectedCheckBox(check_select);

                    }
                    if (default_select != null) {
                        checkBox.setUnselectedCheckBox(default_select);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * customizeImageView is used to Customize Logo
     */
    @Override
    public void customizeImageView(ImageView imageView, BKUIPrefComponents.BKActivityImageViewType imageType) {
        super.customizeImageView(imageView, imageType);

        switch (imageType) {
            case BKACTIVITY_PORTRAIT_LOGO:
                if (mJsonObject != null) {
                    {
                        try {
                            JSONObject imageJsonObject = (JSONObject) mJsonObject.get("image");
                            String imageName = imageJsonObject.getString("logo");
                            setImageToView(mContext, imageName, imageView, flutterLoader, flutterBinding);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }
        }
    }

    /**
     * CustomizeRelativeLayout is used to apply Background Color and Image For the Actions
     */
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
                        String imageName = validateJsonString(jImageBg, "background");
                        setImageToView(mContext,imageName, relativeLayout, flutterLoader, flutterBinding);
                        break;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * To Customize Skip Button
     */
    @Override
    public void customizeImageButton(ImageButton button, BKUIPrefComponents.BKActivityImageButtonTypes buttonType) {
        super.customizeImageButton(button, buttonType);

        if (mJsonObject != null) {
            try {
                JSONObject buttonJsonObject = (JSONObject) mJsonObject.get("button");
                switch (buttonType) {
                    case BKACTIVITY_SKIP_BUTTON:
                        JSONObject skipJson = (JSONObject) buttonJsonObject.get("skip");
                        String imageName = skipJson.getString("image");
                        setImageToView(mContext, imageName, button, flutterLoader, flutterBinding);
                        break;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}

