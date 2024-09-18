package com.upshot.flutter_upshot_plugin;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.view.View;
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
    private JSONObject triviaJson = null;

    private FlutterLoader flutterLoader;

    private FlutterPlugin.FlutterPluginBinding flutterBinding;

    public UpshotTriviaCustomization(Context context, JSONObject triviaJSON, FlutterLoader loader,
            FlutterPlugin.FlutterPluginBinding binding) {
        mContext = context;
        try {
            triviaJson = triviaJSON;
            flutterLoader = loader;
            flutterBinding = binding;
        } catch (Exception e) {
            UpshotHelper.logException(e);
        }
    }

    @Override
    public void customizeForLinearLayout(LinearLayout linearLayout,
            BKUIPrefComponents.BKActivityLinearLayoutTypes linearLayoutTypes) {
        super.customizeForLinearLayout(linearLayout, linearLayoutTypes);
        if (triviaJson != null) {
            switch (linearLayoutTypes) {
                case BKACTIVITY_BACKGROUND_IMAGE:
                    linearLayout.setBackgroundColor(Color.TRANSPARENT);
                    break;
            }
        }
    }

    @Override
    public void customizeForOptionsSeparatorView(View view) {
        super.customizeForOptionsSeparatorView(view);
    }

    /**
     * customizeTextView is used to customize the TextView
     */
    @Override
    public void customizeTextView(BKActivityTextViewTypes textViewType, TextView textView) {
        super.customizeTextView(textViewType, textView);

        if (triviaJson != null) {

            try {
                JSONObject label_textJson = (JSONObject) triviaJson.get("label_text");
                JSONObject leaderBoardJson = (JSONObject) triviaJson.get("leaderBoard");
                JSONObject graphJson = (JSONObject) triviaJson.get("graph");

                switch (textViewType) {
                    case BKACTIVITY_HEADER_TV:
                        JSONObject header = (JSONObject) label_textJson.get("header");
                        applyTextViewProperties(header, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_TRIVIA_DESC_TV:
                        JSONObject desc = (JSONObject) label_textJson.get("desc");
                        applyTextViewProperties(desc, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_QUESTION_TV:
                        JSONObject question = (JSONObject) label_textJson.get("question");
                        applyTextViewProperties(question, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_THANK_YOU_TV:

                        JSONObject thanksJson = (JSONObject) label_textJson.get("thankyou");
                        JSONObject colorJson = (JSONObject) triviaJson.get("color");
                        JSONObject imageJson = (JSONObject) triviaJson.get("image");

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
                    case BKACTIVITY_QUESTION_OPTION_TV:
                    case BKACTIVITY_OPTION_TV:
                        JSONObject option = (JSONObject) label_textJson.get("option");
                        applyTextViewProperties(option, textView, flutterLoader, flutterBinding);
                        break;

                    case BKACTIVITY_SCORE_TV:
                        JSONObject option_score = (JSONObject) label_textJson.get("score");
                        applyTextViewProperties(option_score, textView, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_LEADER_BOARD_TITLE_TV: {
                        JSONObject option_result = (JSONObject) leaderBoardJson.get("result");
                        applyTextViewProperties(option_result, textView, flutterLoader, flutterBinding);
                    }
                        break;
                    case BKACTIVITY_LEADER_BOARD_SCORE_VALUE_TV: {
                        JSONObject option_result = (JSONObject) leaderBoardJson.get("yourScore");
                        applyTextViewProperties(option_result, textView, flutterLoader, flutterBinding);
                    }
                        break;
                    case BKACTIVITY_LEADER_BOARD_GRADE_VALUE_TV: {
                        JSONObject option_yourGrade = (JSONObject) leaderBoardJson.get("yourGrade");
                        applyTextViewProperties(option_yourGrade, textView, flutterLoader, flutterBinding);
                    }
                        break;
                    case BKACTIVITY_LEADER_BOARD_SCORE_TV: {
                        JSONObject option_userScore = (JSONObject) leaderBoardJson.get("userScore");
                        applyTextViewProperties(option_userScore, textView, flutterLoader, flutterBinding);
                    }
                        break;

                    case BKACTIVITY_LEADER_BOARD_GRADE_TV: {
                        JSONObject option_userGrade = (JSONObject) leaderBoardJson.get("userGrade");
                        applyTextViewProperties(option_userGrade, textView, flutterLoader, flutterBinding);
                    }
                        break;
                    case BKACTIVITY_LEADER_BOARD_BAR_RESPONSES_TV:
                        String yAxis_HeaderColor = graphJson.getString("yAxis_Header");
                        if (!yAxis_HeaderColor.isEmpty()) {
                            textView.setTextColor(Color.parseColor(yAxis_HeaderColor));
                        }
                        break;
                    case BKACTIVITY_LEGEND_TV:
                        String legendsColor = graphJson.getString("legends");
                        if (!legendsColor.isEmpty()) {
                            textView.setTextColor(Color.parseColor(legendsColor));
                        }
                        break;

                    case BKACTIVITY_LEADER_BOARD_BAR_GRADES_TV:
                        String xAxis_HeaderColor = graphJson.getString("xAxis_Header");
                        if (!xAxis_HeaderColor.isEmpty()) {
                            textView.setTextColor(Color.parseColor(xAxis_HeaderColor));
                        }
                        break;
                    /* User Responses Header Text */
                    case BKACTIVITY_TRIVIA_RESPONSE_HEADER_TABLE_TV:
                        JSONObject option_userText = (JSONObject) leaderBoardJson.get("tabular_response_header");
                        applyTextViewProperties(option_userText, textView, flutterLoader, flutterBinding);
                        break;

                    /* Tabular List Responses Text */
                    case BKACTIVITY_TRIVIA_RESPONSE_DATA_TABLE_TV: {
                        JSONObject tabular_response_header = (JSONObject) leaderBoardJson
                                .get("tabular_response_count");
                        applyTextViewProperties(tabular_response_header, textView, flutterLoader, flutterBinding);
                    }
                        break;
                    /* User Grade Header Text */
                    case BKACTIVITY_TRIVIA_GRADE_HEADER_TABLE_TV:
                        JSONObject tabularResponseHeader = (JSONObject) leaderBoardJson.get("tabular_grade_header");
                        applyTextViewProperties(tabularResponseHeader, textView, flutterLoader, flutterBinding);
                        break;
                    /* Tabular List Grade Range Text */
                    case BKACTIVITY_TRIVIA_GRADE_DATA_TABLE_TV:
                        JSONObject tabular_grade_range = (JSONObject) leaderBoardJson.get("tabular_grade_range");
                        applyTextViewProperties(tabular_grade_range, textView, flutterLoader, flutterBinding);
                        break;
                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    /**
     * customizeForGraphColor is used to customize Bar and Pie Colors
     */
    @Override
    public void customizeForGraphColor(BKUIPrefComponents.BKGraphType graphType, List<Integer> colorsList) {
        super.customizeForGraphColor(graphType, colorsList);

        if (triviaJson != null) {
            try {
                JSONObject graphJson = (JSONObject) triviaJson.get("graph");

                switch (graphType) {
                    case BKACTIVITY_BAR_GRAPH:
                        colorsList.clear();
                        JSONArray barColors = graphJson.getJSONArray("bar");
                        if (barColors.length() == 5) {
                            for (int i = 0; i < barColors.length(); i++) {
                                colorsList.add(Color.parseColor(barColors.getString(i)));
                            }
                        }
                        break;
                    case BKACTIVITY_PIE_GRAPH:
                        colorsList.clear();
                        JSONArray pieColors = graphJson.getJSONArray("pie");
                        if (pieColors.length() == 5) {
                            for (int i = 0; i < pieColors.length(); i++) {
                                colorsList.add(Color.parseColor(pieColors.getString(i)));
                            }
                        }
                        break;
                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    /**
     * customizeButton is used to customize Prev, Next....Buttons
     */
    @Override
    public void customizeButton(Button button, BKActivityButtonTypes buttonType) {
        super.customizeButton(button, buttonType);

        if (triviaJson != null) {
            try {
                JSONObject buttonJson = (JSONObject) triviaJson.get("button");

                switch (buttonType) {
                    case BKACTIVITY_SUBMIT_BUTTON:
                        JSONObject submitButtonJsonObject = (JSONObject) buttonJson.get("submit");
                        applyButtonProperties(mContext, submitButtonJsonObject, button, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_TRIVIA_CONTINUE_BUTTON:
                        JSONObject continueButtonJsonObject = (JSONObject) buttonJson.get("continue");
                        applyButtonProperties(mContext, continueButtonJsonObject, button, flutterLoader,
                                flutterBinding);
                        break;
                    case BKACTIVITY_TRIVIA_NEXT_BUTTON:
                        JSONObject nextButtonJsonObject = (JSONObject) buttonJson.get("next");
                        applyButtonProperties(mContext, nextButtonJsonObject, button, flutterLoader, flutterBinding);
                        break;
                    case BKACTIVITY_TRIVIA_PREVIOUS_BUTTON:
                        JSONObject prevButtonJsonObject = (JSONObject) buttonJson.get("prev");
                        applyButtonProperties(mContext, prevButtonJsonObject, button, flutterLoader, flutterBinding);
                        break;
                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    /**
     * customizeBGColor is used to Customize BG Color
     */
    @Override
    public void customizeBGColor(BKBGColors color, BKActivityColorTypes colorType) {
        super.customizeBGColor(color, colorType);

        if (triviaJson != null) {
            try {
                JSONObject colorJson = (JSONObject) triviaJson.get("color");
                JSONObject graphJsonObject = (JSONObject) triviaJson.get("graph");

                switch (colorType) {

                    case BKACTIVITY_TRIVIA_HEADER_COLOR:
                    case BKACTIVITY_TRIVIA_TITLE_COLOR:
                        String headerBG = validateJsonString(colorJson, "headerBG");
                        if (headerBG != null && !headerBG.isEmpty()) {
                            color.setColor(Color.parseColor(headerBG));
                        }
                        break;

                    case BKACTIVITY_BG_COLOR:
                    case BKACTIVITY_BOTTOM_COLOR:
                        String bgColor = validateJsonString(colorJson, "background");
                        if (bgColor != null && !bgColor.isEmpty()) {
                            color.setColor(Color.parseColor(bgColor));
                        }
                        break;

                    case BKACTIVITY_OPTION_DEF_BORDER:
                        String option_borderColor = validateJsonString(colorJson, "option_def_border");
                        if (option_borderColor != null && !option_borderColor.isEmpty()) {
                            color.setColor(Color.parseColor(option_borderColor));
                        }
                        break;
                    case BKACTIVITY_OPTION_SEL_BORDER:
                        String option_sel_borderColor = validateJsonString(colorJson, "option_sel_border");
                        if (option_sel_borderColor != null && !option_sel_borderColor.isEmpty()) {
                            color.setColor(Color.parseColor(option_sel_borderColor));
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

                    case BKACTIVITY_TRIVIA_GRADE_COLOR:
                        JSONObject leaderBoardJson = (JSONObject) triviaJson.get("leaderBoard");
                        JSONObject header = (JSONObject) leaderBoardJson.get("tabular_response");
                        String optionColor = validateJsonString(header, "color");
                        if (optionColor != null && !optionColor.isEmpty()) {
                            color.setColor(Color.parseColor(optionColor));
                        }
                        break;
                    case BKACTIVITY_XAXIS_TEXT_COLOR_COLOR:
                    case BKACTIVITY_YAXIS_TEXT_COLOR_COLOR:
                        String yAxisColor = validateJsonString(graphJsonObject, "yAxis");
                        if (yAxisColor != null && !yAxisColor.isEmpty()) {
                            color.setColor(Color.parseColor(yAxisColor));
                        }
                        break;
                    case BKACTIVITY_YAXIS_COLOR:
                    case BKACTIVITY_XAXIS_COLOR:
                        String barGraphLine = validateJsonString(graphJsonObject, "bar_line");
                        if (barGraphLine != null && !barGraphLine.isEmpty()) {
                            color.setColor(Color.parseColor(barGraphLine));
                        }
                        break;
                    case BKACTIVITY_PERCENTAGE_COLOR:
                        String percentageColor = validateJsonString(graphJsonObject, "percentage");
                        if (percentageColor != null && !percentageColor.isEmpty()) {
                            color.setColor(Color.parseColor(percentageColor));
                        }
                }

            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    /**
     * customizeRadioButton is used to customize Radio and CheckBox image
     */
    public void customizeRadioButton(BKUICheckBox checkBox, boolean isCheckBox) {

        if (triviaJson != null) {
            try {
                JSONObject imageJson = (JSONObject) triviaJson.get("image");
                if (isCheckBox) {

                    String checkbox_sel_ImageName = getImageName(imageJson, "checkbox_sel");
                    String checkbox_def_ImageName = getImageName(imageJson, "checkbox_def");

                    Bitmap check_select = BitmapFactory.decodeResource(mContext.getResources(),
                            getIdentifier(mContext, checkbox_sel_ImageName));
                    Bitmap default_select = BitmapFactory.decodeResource(mContext.getResources(),
                            getIdentifier(mContext, checkbox_def_ImageName));

                    if (check_select != null) {
                        checkBox.setSelectedCheckBox(check_select);
                    }

                    if (default_select != null) {
                        checkBox.setUnselectedCheckBox(default_select);
                    }
                } else {
                    String radio_def_ImageName = getImageName(imageJson, "radio_def");
                    String radio_sel_ImageName = getImageName(imageJson, "radio_sel");
                    Bitmap default_select = BitmapFactory.decodeResource(mContext.getResources(),
                            getIdentifier(mContext, radio_def_ImageName));
                    Bitmap check_select = BitmapFactory.decodeResource(mContext.getResources(),
                            getIdentifier(mContext, radio_sel_ImageName));
                    if (check_select != null) {
                        checkBox.setSelectedCheckBox(check_select);
                    }
                    if (default_select != null) {
                        checkBox.setUnselectedCheckBox(default_select);
                    }
                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
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
            case BKACTIVITY_LANDSCAPE_LOGO:
                if (triviaJson != null) {
                    try {
                        JSONObject imageJson = (JSONObject) triviaJson.get("image");
                        String imageName = getImageName(imageJson, "logo");
                        setImageToView(mContext, imageName, imageView);
                    } catch (Exception e) {
                        UpshotHelper.logException(e);
                    }
                }
        }
    }

    /**
     * CustomizeRelativeLayout is used to apply Background Color and Image For the
     * Actions
     */
    @Override
    public void customizeRelativeLayout(BKUIPrefComponents.BKActivityRelativeLayoutTypes relativeLayoutTypes,
            RelativeLayout relativeLayout, boolean isFullScreen) {
        super.customizeRelativeLayout(relativeLayoutTypes, relativeLayout, isFullScreen);

        if (triviaJson != null) {
            try {
                JSONObject imageJson = (JSONObject) triviaJson.get("image");
                JSONObject colorJson = (JSONObject) triviaJson.get("color");
                if (colorJson != null) {
                    String bgColor = validateJsonString(colorJson, "background");
                    if (bgColor != null && !bgColor.isEmpty()) {
                        relativeLayout.setBackgroundColor(Color.parseColor(bgColor));
                    }
                }
                switch (relativeLayoutTypes) {
                    case BKACTIVITY_BACKGROUND_IMAGE:
                        String imageName = getImageName(imageJson, "background");
                        setImageToView(mContext, imageName, relativeLayout);
                        break;
                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }

    /**
     * To Customize Skip Button
     */
    @Override
    public void customizeImageButton(ImageButton button, BKUIPrefComponents.BKActivityImageButtonTypes buttonType) {
        super.customizeImageButton(button, buttonType);

        if (triviaJson != null) {
            try {
                JSONObject buttonJson = (JSONObject) triviaJson.get("button");
                switch (buttonType) {
                    case BKACTIVITY_SKIP_BUTTON:
                        JSONObject skipJson = (JSONObject) buttonJson.get("skip");
                        applySkipImage(mContext, skipJson, button);
                        break;
                }
            } catch (Exception e) {
                UpshotHelper.logException(e);
            }
        }
    }
}
