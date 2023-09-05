//
//  UpshotCustmoisation.swift
//  flutter_upshot_plugin
//
//  Created by Vinod Kottamsu on 29/07/22.
//

import Foundation
import Upshot
import UIKit

class UpshotCustomisation: NSObject, BKUIPreferencesDelegate {
    
    var customiseData: Data?
    
    var surveyThemeData: Data?
    var ratingThemeData: Data?
    var pollThemeData: Data?
    var triviaThemeData: Data?
    
    var registrar:FlutterPluginRegistrar?
    
    func getJsonfromdata(type: BKActivityType) -> [String: Any]? {
        
        switch type {
        case .survey:
            
            if let data = surveyThemeData, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                return json
            }
        case .rating:
            if let data = ratingThemeData, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                return json
            }
        case .opinionPoll:
            if let data = pollThemeData, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                return json
            }
            
        case .trivia:
            if let data = triviaThemeData, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                return json
            }
        default:
            return nil
        }
        return nil
    }
    
    func getJsonUsing(key: String, mainJson: [String: Any]) -> [String: Any]? {
        
        if mainJson.keys.contains(key) {
            return mainJson[key] as? [String: Any]
        }
        return nil
    }
    
    func getImage(imageName: String) -> UIImage? {
        
        if let reg = registrar {
            let fileKey = reg.lookupKey(forAsset: "assets/images/\(imageName)")
            let filePath =  Bundle.main.path(forResource: fileKey, ofType: nil)
            if let path = filePath {
                let fileUrl = URL(fileURLWithPath: path)
                if let data = try? Data(contentsOf: fileUrl) {
                    return UIImage(data: data)
                }
            }
        }
        return nil
    }
    
    func loadFonts(with name: String) {
        
        let fileKey = registrar!.lookupKey(forAsset: "fonts/\(name).ttf")
        let filePath =  Bundle.main.path(forResource: fileKey, ofType: nil) ?? ""
        
        guard let fontData = NSData(contentsOfFile: filePath) else {
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            return
        }
        
        guard let font = CGFont(dataProvider) else {
            return
        }
        
        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(font, &errorRef) == false) {
            print("")
        }
    }
    
    func getColorFrom(hex: String, _ alpha: CGFloat = 1.0) -> UIColor {
        
        var modifiedString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        modifiedString = modifiedString.replacingOccurrences(of: "#", with: "")
        
        var rgbValue:UInt64 = 0
        Scanner(string: modifiedString).scanHexInt64(&rgbValue)
        
        if ((modifiedString.count) == 8) {
            
            return UIColor(
                red: CGFloat((rgbValue & 0xff000000) >> 24) / 255,
                green: CGFloat((rgbValue & 0x00ff0000) >> 16) / 255,
                blue: CGFloat((rgbValue & 0x0000ff00) >> 8) / 255,
                alpha: CGFloat(rgbValue & 0x000000ff) / 255)
            
        } else if ((modifiedString.count) == 6) {
            
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(alpha))
        }
        return UIColor.gray
    }
    
    func getFontByName(name: String) -> UIFont? {
        
        if let reg = registrar {
            let fileKey = reg.lookupKey(forAsset: "fonts/\(name)")
            let filePath =  Bundle.main.path(forResource: fileKey, ofType: nil) ?? ""
            if let fontdata = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
               let dataProvider = CGDataProvider(data: fontdata as CFData), let font = CGFont(dataProvider) {
                
                var errorRef: Unmanaged<CFError>? = nil
                
                if CTFontManagerRegisterGraphicsFont(font, &errorRef) == false {
                    
                }
            }
        }
        return nil
    }
    
    func setButtonPreferences(data: [String: Any], button: UIButton) {
        
        if let bgcolor = data["bgcolor"] as? String, !bgcolor.isEmpty {
            button.backgroundColor = getColorFrom(hex: bgcolor)
        }
        
        if let tColor = data["color"] as? String, !tColor.isEmpty {
            button.setTitleColor(getColorFrom(hex: tColor), for: .normal)
            button.setTitleColor(getColorFrom(hex: tColor), for: .selected)
            button.setTitleColor(getColorFrom(hex: tColor), for: .highlighted)
        }
        
        if let fStyle = data["font_name"] as? String, !fStyle.isEmpty, let fSize = data["size"] as? Int {
            loadFonts(with: fStyle)
            if let font = UIFont(name: fStyle, size: CGFloat(fSize)) {
                button.titleLabel?.font = font
            }
        }
        
        if let borderColor = data["border_color"] as? String, !borderColor.isEmpty {
            button.layer.borderWidth = 1.0
            button.layer.borderColor = getColorFrom(hex: borderColor).cgColor
        }
        
        if let image = data["image"] as? String, !image.isEmpty, let buttonImage = getImage(imageName: image) {
            
            button.setBackgroundImage(buttonImage, for: .normal)
            button.setBackgroundImage(buttonImage, for: .selected)
            button.setBackgroundImage(buttonImage, for: .highlighted)
        }
    }
    
    func setLablePreferences(data: [String: Any], label: UILabel) {
        
        if let tColor = data["color"] as? String, !tColor.isEmpty {
            label.textColor = getColorFrom(hex: tColor)
        }
        if let fStyle = data["font_name"] as? String, !fStyle.isEmpty, let fSize = data["size"] as? Int {
            loadFonts(with: fStyle)
            if let font = UIFont(name: fStyle, size: CGFloat(fSize)) {
                label.font = font
            }
        }
    }
    
    /** Customize Image Properties */
    func preferences(for imageView: UIImageView!, of activityType: BKActivityType, andType activityImage: BKActivityImageType) {
        
        imageView.contentMode = .scaleAspectFit
        
        switch activityType {
            
        case .survey:
            if let surveyJson =  getJsonfromdata(type: .survey),
               let json = getJsonUsing(key: "image", mainJson: surveyJson) {
                
                switch activityImage {
                case .backgroundImage:
                    if let bgImage = json["background"] as? String,
                       let image = getImage(imageName: bgImage) {
                        imageView.image = image
                        imageView.contentMode = .scaleToFill
                    }
                case .checkboxImage:
                    if let checkbox_defImage = json["checkbox_def"] as? String ,
                       let defimage = getImage(imageName: checkbox_defImage) {
                        imageView.image = defimage
                    }
                    if let checkbox_selImage = json["checkbox_sel"] as? String ,
                       let selimage = getImage(imageName: checkbox_selImage) {
                        imageView.highlightedImage = selimage
                    }
                    
                case .radioImage:
                    if let radio_defImage = json["radio_def"] as? String ,
                       let defimage = getImage(imageName: radio_defImage) {
                        imageView.image = defimage
                    }
                    if let radio_selImage = json["radio_sel"] as? String ,
                       let selimage = getImage(imageName: radio_selImage) {
                        imageView.highlightedImage = selimage
                    }
                case .portraitLogo, .landscapeLogo:
                    if let logoImage = json["logo"] as? String ,
                       let image = getImage(imageName: logoImage) {
                        imageView.image = image
                    }
                default:
                    break
                }
            }
        case .rating:
            if let ratingJson =  getJsonfromdata(type: .rating),
               let json = getJsonUsing(key: "image", mainJson: ratingJson) {
                
                switch activityImage {
                case .backgroundImage:
                    if let bgImage = json["background"] as? String,
                       let image = getImage(imageName: bgImage) {
                        imageView.image = image
                        imageView.contentMode = .scaleToFill
                    }
                case .portraitLogo, .landscapeLogo:
                    if let logoImage = json["logo"] as? String ,
                       let image = getImage(imageName: logoImage) {
                        imageView.image = image
                    }
                default:
                    break
                }
            }
        case .opinionPoll:
            if let pollJson =  getJsonfromdata(type: .opinionPoll),
               let json = getJsonUsing(key: "image", mainJson: pollJson) {
                
                switch activityImage {
                case .backgroundImage:
                    if let bgImage = json["background"] as? String,
                       let image = getImage(imageName: bgImage) {
                        imageView.image = image
                        imageView.contentMode = .scaleToFill
                    }
                    
                case .radioImage:
                    if let radio_defImage = json["radio_def"] as? String ,
                       let defimage = getImage(imageName: radio_defImage) {
                        imageView.image = defimage
                    }
                    if let radio_selImage = json["radio_sel"] as? String ,
                       let selimage = getImage(imageName: radio_selImage) {
                        imageView.highlightedImage = selimage
                    }
                case .portraitLogo, .landscapeLogo:
                    if let logoImage = json["logo"] as? String ,
                       let image = getImage(imageName: logoImage) {
                        imageView.image = image
                    }
                default:
                    break
                }
            }
        case .trivia:
            if let triviaJson =  getJsonfromdata(type: .trivia),
               let json = getJsonUsing(key: "image", mainJson: triviaJson) {
                
                switch activityImage {
                case .backgroundImage:
                    if let bgImage = json["background"] as? String,
                       let image = getImage(imageName: bgImage) {
                        imageView.image = image
                        imageView.contentMode = .scaleToFill
                    }
                case .checkboxImage:
                    if let checkbox_defImage = json["checkbox_def"] as? String ,
                       let defimage = getImage(imageName: checkbox_defImage) {
                        imageView.image = defimage
                    }
                    if let checkbox_selImage = json["checkbox_sel"] as? String ,
                       let selimage = getImage(imageName: checkbox_selImage) {
                        imageView.highlightedImage = selimage
                    }
                    
                case .radioImage:
                    if let radio_defImage = json["radio_def"] as? String ,
                       let defimage = getImage(imageName: radio_defImage) {
                        imageView.image = defimage
                    }
                    if let radio_selImage = json["radio_sel"] as? String ,
                       let selimage = getImage(imageName: radio_selImage) {
                        imageView.highlightedImage = selimage
                    }
                case .portraitLogo, .landscapeLogo:
                    if let logoImage = json["logo"] as? String ,
                       let image = getImage(imageName: logoImage) {
                        imageView.image = image
                    }
                default:
                    break
                }
            }
        default:
            break
        }
    }
    
    func preferences(for button: UIButton!, of activityType: BKActivityType, andType activityButton: BKActivityButtonType) {
        
        
        switch activityType {
            
        case .survey:
            
            if let surveyJson = getJsonfromdata(type: .survey),
               let json = getJsonUsing(key: "button", mainJson: surveyJson) {
                
                switch activityButton {
                    
                case .continueButton:
                    if let cButton = json["continue"] as? [String: Any] {
                        DispatchQueue.main.async {
                            self.setButtonPreferences(data: cButton, button: button)
                        }
                    }
                case .previousButton:
                    if let cButton = json["prev"] as? [String: Any] {
                        self.setButtonPreferences(data: cButton, button: button)
                    }
                case .nextButton:
                    if let cButton = json["next"] as? [String: Any] {
                        self.setButtonPreferences(data: cButton, button: button)
                    }
                    
                case .skipButton:
                    
                    if let skipJson = json["skip"] as? [String: Any] ,
                       let skipImage = skipJson["image"] as? String,
                       let image = self.getImage(imageName: skipImage) {
                        button.setImage(image, for: .normal)
                        button.setImage(image, for: .highlighted)
                        button.setImage(image, for: .selected)
                    }
                    
                case .submitButton:
                    if let cButton = json["submit"] as? [String: Any] {
                        self.setButtonPreferences(data: cButton, button: button)
                    }
                default:
                    break
                }
            }
        case .rating:
            if let ratingJson = getJsonfromdata(type: .rating),
               let json = getJsonUsing(key: "button", mainJson: ratingJson) {
                
                switch activityButton {
                    
                case .ratingDislikeButton:
                    
                        if let mainJson = self.getJsonUsing(key: "image", mainJson: ratingJson),
                           let dislike_defImage = mainJson["disLike_def"] as? String ,
                           let defimage = self.getImage(imageName: dislike_defImage) {
                            button.setImage(defimage, for: .normal)
                        }
                    
                        if let mainJson = self.getJsonUsing(key: "image", mainJson: ratingJson),
                           let dislike_selImage = mainJson["disLike_sel"] as? String ,
                           let selimage = self.getImage(imageName: dislike_selImage) {
                            button.setImage(selimage, for: .selected)
                            button.setImage(selimage, for: .highlighted)
                        }
                    
                case .ratingLikeButton:

                        if let mainJson = self.getJsonUsing(key: "image", mainJson: ratingJson),
                           let like_defImage = mainJson["like_def"] as? String ,
                           let defimage = self.getImage(imageName: like_defImage) {
                            button.setImage(defimage, for: .normal)
                        }
                        if let mainJson = self.getJsonUsing(key: "image", mainJson: ratingJson),
                           let like_selImage = mainJson["like_sel"] as? String ,
                           let selimage = self.getImage(imageName: like_selImage) {
                            button.setImage(selimage, for: .selected)
                            button.setImage(selimage, for: .highlighted)
                        }

                case .skipButton:
                    
                    if let skipJson = json["skip"] as? [String: Any] ,
                       let skipImage = skipJson["image"] as? String,
                       let image = self.getImage(imageName: skipImage) {
                        button.setImage(image, for: .normal)
                        button.setImage(image, for: .highlighted)
                        button.setImage(image, for: .selected)
                    }
                case .ratingYesButton:
                    if let cButton = json["yes"] as? [String: Any] {
                        self.setButtonPreferences(data: cButton, button: button)
                    }
                    
                case .ratingNoButton:
                    
                    if let cButton = json["no"] as? [String: Any] {
                        self.setButtonPreferences(data: cButton, button: button)
                    }
                    
                case .submitButton:
                    if let cButton = json["submit"] as? [String: Any] {
                        self.setButtonPreferences(data: cButton, button: button)
                    }
                default:
                    break
                }
            }
        case .opinionPoll:
            
            if let pollJson = getJsonfromdata(type: .opinionPoll),
               let json = getJsonUsing(key: "button", mainJson: pollJson) {
                
                switch activityButton {
                    
                case .skipButton:
                    
                    if let skipJson = json["skip"] as? [String: Any] ,
                       let skipImage = skipJson["image"] as? String,
                       let image = self.getImage(imageName: skipImage) {
                        button.setImage(image, for: .normal)
                        button.setImage(image, for: .highlighted)
                        button.setImage(image, for: .selected)
                    }
                    
                case .submitButton:
                    if let cButton = json["submit"] as? [String: Any] {
                        self.setButtonPreferences(data: cButton, button: button)
                    }
                default:
                    break
                }
            }
        case .trivia:
            if let triviaJson = getJsonfromdata(type: .trivia),
               let json = getJsonUsing(key: "button", mainJson: triviaJson) {
                
                switch activityButton {
                    
                case .continueButton:
                    if let cButton = json["continue"] as? [String: Any] {
                        self.setButtonPreferences(data: cButton, button: button)
                    }
                case .previousButton:
                    if let cButton = json["prev"] as? [String: Any] {
                        self.setButtonPreferences(data: cButton, button: button)
                    }
                case .nextButton:
                    if let cButton = json["next"] as? [String: Any] {
                        self.setButtonPreferences(data: cButton, button: button)
                    }
                    
                case .skipButton:
                    
                    if let skipJson = json["skip"] as? [String: Any] ,
                       let skipImage = skipJson["image"] as? String,
                       let image = self.getImage(imageName: skipImage) {
                        button.setImage(image, for: .normal)
                        button.setImage(image, for: .highlighted)
                        button.setImage(image, for: .selected)
                    }
                    
                case .submitButton:
                    if let cButton = json["submit"] as? [String: Any] {
                        self.setButtonPreferences(data: cButton, button: button)
                    }
                default:
                    break
                }
            }
        default:
            break
        }
    }
    
    func preferences(for label: UILabel!, of activityType: BKActivityType, andType activityLabel: BKActivityLabelType) {
        
        
        switch activityType {
            
        case .survey:
            
            if let surveyJson = getJsonfromdata(type: .survey),
               let json = getJsonUsing(key: "label_text", mainJson: surveyJson) {
                
                switch activityLabel {
                    
                case .headerLabel:
                    if let header = json["header"] as? [String: Any] {
                        setLablePreferences(data:header , label: label)
                    }
                case .descriptionLabel:
                    if let desc = json["desc"] as? [String: Any] {
                        setLablePreferences(data:desc , label: label)
                    }
                case .sliderScoreLabel:
                    if let sliderJson = surveyJson["slider"] as? [String: Any],
                        let slider_score = sliderJson["slider_score"] as? [String: Any] {
                        setLablePreferences(data:slider_score , label: label)
                    }
                case .sliderMinValueLabel:
                    
                    if  let sliderJson = surveyJson["slider"] as? [String: Any],
                        let slider_minScore = sliderJson["slider_minScore"] as? [String: Any] {
                        setLablePreferences(data:slider_minScore , label: label)
                    }
                case .sliderMaxValueLabel:
                    
                    if let sliderJson = surveyJson["slider"] as? [String: Any],
                        let slider_maxScore = sliderJson["slider_maxScore"] as? [String: Any] {
                        setLablePreferences(data:slider_maxScore , label: label)
                    }
                    
                case .minValueTitleLabel:
                    if let sliderJson = surveyJson["slider"] as? [String: Any],
                       let slider_minText = sliderJson["slider_minText"] as? [String: Any] {
                        setLablePreferences(data:slider_minText , label: label)
                    }
                case .maxValueTitleLabel:
                    if let sliderJson = surveyJson["slider"] as? [String: Any],
                       let slider_maxText = sliderJson["slider_maxText"] as? [String: Any] {
                        setLablePreferences(data:slider_maxText , label: label)
                    }
                    
                case .optionLabel:
                    if let option = json["option"] as? [String: Any] {
                        setLablePreferences(data:option , label: label)
                    }
                    
                case .questionLabel:
                    if let question = json["question"] as? [String: Any] {
                        setLablePreferences(data:question , label: label)
                    }
                case .thankyouLabel:
                    if let thanks = json["thankyou"] as? [String: Any] {
                        setLablePreferences(data:thanks , label: label)
                    }
                default:
                    break
                }
            }
        case .rating:
            
            if let ratingJson = getJsonfromdata(type: .rating),
               let json = getJsonUsing(key: "label_text", mainJson: ratingJson) {
                
                switch activityLabel {
                    
                case .headerLabel:
                    if let header = json["feedback_header"] as? [String: Any] {
                        setLablePreferences(data:header , label: label)
                    }
                    
                case .thankyouAppStoreHint:
                    if let header = json["appStoreHint"] as? [String: Any] {
                        setLablePreferences(data:header , label: label)
                    }
                    
                case .sliderScoreLabel:
                    if let sliderJson = ratingJson["slider"] as? [String: Any],
                        let slider_score = sliderJson["slider_score"] as? [String: Any] {
                        setLablePreferences(data:slider_score , label: label)
                    }
                case .sliderMinValueLabel:
                    
                    if let sliderJson = ratingJson["slider"] as? [String: Any],
                        let slider_minScore = sliderJson["slider_minScore"] as? [String: Any] {
                        setLablePreferences(data:slider_minScore , label: label)
                    }
                case .sliderMaxValueLabel:
                    
                    if let sliderJson = ratingJson["slider"] as? [String: Any],
                        let slider_maxScore = sliderJson["slider_maxScore"] as? [String: Any] {
                        setLablePreferences(data:slider_maxScore , label: label)
                    }
                    
                case .minValueTitleLabel:
                    if let sliderJson = ratingJson["slider"] as? [String: Any],
                        let slider_minText = sliderJson["slider_minText"] as? [String: Any] {
                        setLablePreferences(data:slider_minText , label: label)
                    }
                case .maxValueTitleLabel:
                    if let sliderJson = ratingJson["slider"] as? [String: Any],
                        let slider_maxText = sliderJson["slider_maxText"] as? [String: Any] {
                        setLablePreferences(data:slider_maxText , label: label)
                    }
                    
                case .questionLabel:
                    if let question = json["question"] as? [String: Any] {
                        setLablePreferences(data:question , label: label)
                    }
                case .thankyouLabel:
                    if let thanks = json["thankyou"] as? [String: Any] {
                        setLablePreferences(data:thanks , label: label)
                    }
                default:
                    break
                }
            }
            
        case .opinionPoll:
            
            if let pollJson = getJsonfromdata(type: .opinionPoll),
               let json = getJsonUsing(key: "label_text", mainJson: pollJson) {
                
                switch activityLabel {
                    
                case .optionLabel:
                    if let option = json["option"] as? [String: Any] {
                        setLablePreferences(data:option , label: label)
                    }
                    
                case .questionLabel:
                    if let question = json["question"] as? [String: Any] {
                        setLablePreferences(data:question , label: label)
                    }
                case .thankyouLabel:
                    if let thanks = json["thankyou"] as? [String: Any] {
                        setLablePreferences(data:thanks , label: label)
                    }
                case .barGraphOptionsLabel:
                    if let graphJson = getJsonUsing(key: "graph", mainJson: pollJson),
                       let xAxis_Header = graphJson["xAxis_Header"] as? String, !xAxis_Header.isEmpty {
                        label.textColor = getColorFrom(hex: xAxis_Header)
                    }
                    
                case .barGraphUserLabel:
                    if let graphJson = getJsonUsing(key: "graph", mainJson: pollJson),
                       let yAxis_Header = graphJson["yAxis_Header"] as? String,
                       !yAxis_Header.isEmpty {
                        label.textColor = getColorFrom(hex: yAxis_Header)
                    }
                case .legendLabel:
                    if let graphJson = getJsonUsing(key: "graph", mainJson: pollJson),
                       let legends = graphJson["legends"] as? String,
                       !legends.isEmpty {
                        label.textColor = getColorFrom(hex: legends)
                    }
                default:
                    break
                }
            }
        case .trivia:
            
            if let triviaJson = getJsonfromdata(type: .trivia),
               let json = getJsonUsing(key: "label_text", mainJson: triviaJson) {
                
                switch activityLabel {
                    
                case .headerLabel:
                    if let header = json["header"] as? [String: Any] {
                        setLablePreferences(data:header , label: label)
                    }
                case .descriptionLabel:
                    if let desc = json["desc"] as? [String: Any] {
                        setLablePreferences(data:desc , label: label)
                    }
                    
                case .triviaResultsLabel:
                    if let leaderboardJSON = triviaJson["leaderBoard"] as? [String: Any],
                       let result = leaderboardJSON["result"] as? [String: Any] {
                        setLablePreferences(data:result , label: label)
                    }
                case .scoreLabel:
                    if let score = json["score"] as? [String: Any] {
                        setLablePreferences(data:score , label: label)
                    }
                case .userScoreLabel:
                    if let leaderboardJSON = triviaJson["leaderBoard"] as? [String: Any],
                        let userScore = leaderboardJSON["userScore"] as? [String: Any] {
                        setLablePreferences(data:userScore , label: label)
                    }
                case .yourScoreLabel:
                    if let leaderboardJSON = triviaJson["leaderBoard"] as? [String: Any],
                       let yourScore = leaderboardJSON["yourScore"] as? [String: Any] {
                        setLablePreferences(data:yourScore , label: label)
                    }
                
                case .yourGradeLabel:
                    if let leaderboardJSON = triviaJson["leaderBoard"] as? [String: Any],
                       let yourScore = leaderboardJSON["yourGrade"] as? [String: Any] {
                        setLablePreferences(data:yourScore , label: label)
                    }
                
                case .userGradeLabel:
                    if let leaderboardJSON = triviaJson["leaderBoard"] as? [String: Any],
                       let yourScore = leaderboardJSON["userGrade"] as? [String: Any] {
                        setLablePreferences(data:yourScore , label: label)
                    }
                    
                case .barGraphOptionsLabel:
                    if let graphJson = getJsonUsing(key: "graph", mainJson: triviaJson),
                       let xAxis_Header = graphJson["xAxis_Header"] as? String, !xAxis_Header.isEmpty {
                        label.textColor = getColorFrom(hex: xAxis_Header)
                    }
                    
                case .barGraphUserLabel:
                    if let graphJson = getJsonUsing(key: "graph", mainJson: triviaJson),
                       let yAxis_Header = graphJson["yAxis_Header"] as? String,
                       !yAxis_Header.isEmpty {
                        label.textColor = getColorFrom(hex: yAxis_Header)
                    }
                case .legendLabel:
                    if let graphJson = getJsonUsing(key: "graph", mainJson: triviaJson),
                       let legends = graphJson["legends"] as? String,
                       !legends.isEmpty {
                        label.textColor = getColorFrom(hex: legends)
                    }
                                        
                case .triviaGraphCountLabel:
                    if let leaderboardJSON = triviaJson["leaderBoard"] as? [String: Any],
                       let triviaGraphCountLabel = leaderboardJSON["tabular_response_count"] as? [String: Any] {
                        setLablePreferences(data:triviaGraphCountLabel , label: label)
                    }
                case .triviaGraphGradeLabel:
                    if let leaderboardJSON = triviaJson["leaderBoard"] as? [String: Any],
                       let triviaGraphGradeLabel = leaderboardJSON["tabular_grade_range"] as? [String: Any] {
                        setLablePreferences(data:triviaGraphGradeLabel , label: label)
                    }
                case .triviaTabularGradeLabel:
                    if let leaderboardJSON = triviaJson["leaderBoard"] as? [String: Any],
                       let triviaTabularGradeLabel = leaderboardJSON["tabular_grade_header"] as? [String: Any] {
                        setLablePreferences(data:triviaTabularGradeLabel , label: label)
                    }
                case .triviaTabularResponsesLabel:
                    if let leaderboardJSON = triviaJson["leaderBoard"] as? [String: Any],
                       let triviaTabularResponsesLabel = leaderboardJSON["tabular_response_header"] as? [String: Any] {
                        setLablePreferences(data:triviaTabularResponsesLabel , label: label)
                    }                    
                    
                case .optionLabel:
                    if let option = json["option"] as? [String: Any] {
                        setLablePreferences(data:option , label: label)
                    }
                    
                case .questionLabel:
                    if let question = json["question"] as? [String: Any] {
                        setLablePreferences(data:question , label: label)
                    }
                case .thankyouLabel:
                    if let thanks = json["thankyou"] as? [String: Any] {
                        setLablePreferences(data:thanks , label: label)
                    }
                default:
                    break
                }
            }
        default:
            break
        }
    }
    
    func preferences(forGraphColor graphType: BKGraphType, graphColors block: (([Any]?) -> Void)!) {
        
        var mainJson: [String: Any] = [:]
        if let pollJSon = getJsonfromdata(type: .opinionPoll) {
            mainJson = pollJSon
        }
        
        if let triviaJSon = getJsonfromdata(type: .trivia) {
            mainJson = triviaJSon
        }
        
        if !mainJson.isEmpty,
           let json = getJsonUsing(key: "graph", mainJson: mainJson) {
            
            if graphType == .activityBarGraph {
                
                if  let barGraph = json["bar"] as? [String] {
                    var colors: [UIColor] = []
                    for color in barGraph {
                        if color.isEmpty {return}
                        colors.append(getColorFrom(hex: color))
                    }
                    if colors.count > 5 {
                        block(colors)
                    }
                }
            } else {
                if  let pieGraph = json["pie"] as? [String]  {
                    var colors: [UIColor] = []
                    for color in pieGraph {
                        if color.isEmpty {return}
                        colors.append(getColorFrom(hex: color))
                    }
                    if colors.count > 4 {
                        block(colors)
                    }
                }
            }
        }
    }
    
    func preferences(forRatingActivity activityType: BKActivityType, andType activityRating: BKActivityRatingType, withImages block: (([Any]?, [Any]?) -> Void)!) {
        
        switch activityType {
            
        case .survey:
            if let surveyJson = getJsonfromdata(type: .survey),
               let json = getJsonUsing(key: "image", mainJson: surveyJson) {
                
                if activityRating == .starRating {
                    
                    var defimage: UIImage?
                    var selimage: UIImage?
                    
                    if let star_defImage = json["star_def"] as? String {
                        defimage = self.getImage(imageName: star_defImage)
                    }
                    if let star_selImage = json["star_sel"] as? String {
                        selimage = self.getImage(imageName: star_selImage)
                    }
                    
                    if let def = defimage, let sel = selimage {
                        block([def,def,def,def,def], [sel,sel,sel,sel,sel])
                    }
                } else if activityRating == .emojiRating {
                    
                    if let veryGood_defImage = json["smiley_Vgood_def"] as? String,
                       let vgDef = self.getImage(imageName: veryGood_defImage),
                       
                        let good_defImage = json["smiley_good_def"] as? String,
                       let gDef = self.getImage(imageName: good_defImage),
                       
                        let avg_defImage = json["smiley_avg_def"] as? String,
                       let avgDef = self.getImage(imageName: avg_defImage),
                       
                        let bad_defImage = json["smiley_bad_def"] as? String,
                       let bDef = self.getImage(imageName: bad_defImage)
                        ,
                       let verybad_defImage = json["smiley_vbad_def"] as? String,
                       let vbDef = self.getImage(imageName: verybad_defImage),
                       
                        let veryGood_selImage = json["smiley_Vgood_sel"] as? String,
                       let vgSel = self.getImage(imageName: veryGood_selImage),
                       
                        let good_selImage = json["smiley_good_sel"] as? String,
                       let gSel = self.getImage(imageName: good_selImage),
                       
                        let avg_selImage = json["smiley_avg_sel"] as? String,
                       let avgSel = self.getImage(imageName: avg_selImage),
                       
                        let bad_selImage = json["smiley_bad_sel"] as? String,
                       let bSel = self.getImage(imageName: bad_selImage),
                       
                        let verybad_selImage = json["smiley_vbad_sel"] as? String,
                       let vbSel = self.getImage(imageName: verybad_selImage) {
                        block([vbDef,bDef,avgDef,gDef,vgDef],[vbSel,bSel,avgSel,gSel,vgSel])
                    }
                }
            }
        case .rating:
            
            if let ratingJson = getJsonfromdata(type: .rating),
               let json = getJsonUsing(key: "image", mainJson: ratingJson) {
                
                if activityRating == .starRating {
                    
                    var defimage: UIImage?
                    var selimage: UIImage?
                    
                    if let star_defImage = json["star_def"] as? String {
                        defimage = self.getImage(imageName: star_defImage)
                    }
                    if let star_selImage = json["star_sel"] as? String {
                        selimage = self.getImage(imageName: star_selImage)
                    }
                    
                    if let def = defimage, let sel = selimage {
                        block([def,def,def,def,def], [sel,sel,sel,sel,sel])
                    }
                } else if activityRating == .emojiRating {
                    
                    if let veryGood_defImage = json["smiley_Vgood_def"] as? String,
                       let vgDef = self.getImage(imageName: veryGood_defImage),
                       
                        let good_defImage = json["smiley_good_def"] as? String,
                       let gDef = self.getImage(imageName: good_defImage),
                       
                        let avg_defImage = json["smiley_avg_def"] as? String,
                       let avgDef = self.getImage(imageName: avg_defImage),
                       
                        let bad_defImage = json["smiley_bad_def"] as? String,
                       let bDef = self.getImage(imageName: bad_defImage)
                        ,
                       let verybad_defImage = json["smiley_vbad_def"] as? String,
                       let vbDef = self.getImage(imageName: verybad_defImage),
                       
                        let veryGood_selImage = json["smiley_Vgood_sel"] as? String,
                       let vgSel = self.getImage(imageName: veryGood_selImage),
                       
                        let good_selImage = json["smiley_good_sel"] as? String,
                       let gSel = self.getImage(imageName: good_selImage),
                       
                        let avg_selImage = json["smiley_avg_sel"] as? String,
                       let avgSel = self.getImage(imageName: avg_selImage),
                       
                        let bad_selImage = json["smiley_bad_sel"] as? String,
                       let bSel = self.getImage(imageName: bad_selImage),
                       
                        let verybad_selImage = json["smiley_vbad_sel"] as? String,
                       let vbSel = self.getImage(imageName: verybad_selImage) {
                        block([vgDef, gDef, avgDef, bDef, vbDef], [vgSel, gSel, avgSel, bSel, vbSel])
                    }
                }
            }
        default:
            break
        }
    }
    
    func preferences(for textView: UITextView!, of activityType: BKActivityType, andType viewType: BKActivityViewType) {
        
        switch activityType {
            
        case .survey:
            
            if let surveyJson = getJsonfromdata(type: .survey),
               let json = getJsonUsing(key: "feedbackBox", mainJson: surveyJson) {
                
                if let tColor = json["color"] as? String, !tColor.isEmpty {
                    textView.textColor = getColorFrom(hex: tColor)
                }
                
                if let fStyle = json["font_name"] as? String, !fStyle.isEmpty, let fSize = json["size"] as? Int {
                    
                    if let font = UIFont(name: fStyle, size: CGFloat(fSize)) {
                        textView.font = font
                    }
                }
                
                if let bgColor = json["bgcolor"] as? String, !bgColor.isEmpty {
                    textView.backgroundColor = getColorFrom(hex: bgColor)
                }
                
                if let borderColor = json["border_color"] as? String, !borderColor.isEmpty {
                    textView.layer.borderColor = getColorFrom(hex: borderColor).cgColor
                    textView.layer.borderWidth = 1.0
                }
            }
        case .rating:
            
            if let ratingJson = getJsonfromdata(type: .rating),
               let json = getJsonUsing(key: "feedbackBox", mainJson: ratingJson) {
                
                if let tColor = json["color"] as? String, !tColor.isEmpty {
                    textView.textColor = getColorFrom(hex: tColor)
                }
                
                if let fStyle = json["font_name"] as? String, !fStyle.isEmpty, let fSize = json["size"] as? Int {
                    
                    if let font = UIFont(name: fStyle, size: CGFloat(fSize)) {
                        textView.font = font
                    }
                }
                
                if let bgColor = json["bgcolor"] as? String, !bgColor.isEmpty {
                    textView.backgroundColor = getColorFrom(hex: bgColor)
                }
                
                if let borderColor = json["border_color"] as? String, !borderColor.isEmpty {
                    textView.layer.borderColor = getColorFrom(hex: borderColor).cgColor
                    textView.layer.borderWidth = 1.0
                }
            }
        default:
            break
            
        }
    }
    
    func preferences(for textField: UITextField!, of activityType: BKActivityType, andType viewType: BKActivityViewType) {
        
        switch activityType {
        case .survey:
            if let surveyJson = getJsonfromdata(type: .survey),
               let json = getJsonUsing(key: "feedbackBox", mainJson: surveyJson) {
                
                if let tColor = json["color"] as? String, !tColor.isEmpty {
                    textField.textColor = getColorFrom(hex: tColor)
                }
                
                if let fStyle = json["font_name"] as? String, !fStyle.isEmpty,  let fSize = json["size"] as? Int {
                    
                    if let font = UIFont(name: fStyle, size: CGFloat(fSize)) {
                        textField.font = font
                    }
                }
                
                if let bgColor = json["bgcolor"] as? String, !bgColor.isEmpty {
                    textField.backgroundColor = getColorFrom(hex: bgColor)
                }
                
                if let borderColor = json["border_color"] as? String, !borderColor.isEmpty {
                    textField.layer.borderColor = getColorFrom(hex: borderColor).cgColor
                    textField.layer.borderWidth = 1.0
                }
            }
        case .rating:
            if let ratingJson = getJsonfromdata(type: .rating),
               let json = getJsonUsing(key: "feedbackBox", mainJson: ratingJson) {
                
                if let tColor = json["color"] as? String, !tColor.isEmpty {
                    textField.textColor = getColorFrom(hex: tColor)
                }
                
                if let fStyle = json["font_name"] as? String, !fStyle.isEmpty,  let fSize = json["size"] as? Int {
                    
                    if let font = UIFont(name: fStyle, size: CGFloat(fSize)) {
                        textField.font = font
                    }
                }
                
                if let bgColor = json["bgcolor"] as? String, !bgColor.isEmpty {
                    textField.backgroundColor = getColorFrom(hex: bgColor)
                }
                
                if let borderColor = json["border_color"] as? String, !borderColor.isEmpty {
                    textField.layer.borderColor = getColorFrom(hex: borderColor).cgColor
                    textField.layer.borderWidth = 1.0
                }
            }
        default:
            break
        }
    }
    
    func preferences(for slider: UISlider!, of activityType: BKActivityType) {
        
        
        switch activityType {
        case .survey:
            if let surveyJson = getJsonfromdata(type: .survey),
               let sliderJson = getJsonUsing(key: "slider", mainJson: surveyJson) {
                
                if let slider_minImage = sliderJson["min_image"] as? String,
                   let min_image = getImage(imageName: slider_minImage) {
                    slider.setMinimumTrackImage(min_image, for: .normal)
                }
                
                if let slider_maxImage = sliderJson["max_image"] as? String,
                   let max_image = getImage(imageName: slider_maxImage)  {
                    slider.setMaximumTrackImage(max_image, for: .normal)
                }
                
                if let slider_thumbImage = sliderJson["thumb_image"] as? String,
                   let thumb_image = getImage(imageName: slider_thumbImage) {
                    slider.setThumbImage(thumb_image, for: .normal)
                    slider.setThumbImage(thumb_image, for: .highlighted)
                }
                
                if let min_color = sliderJson["min_color"] as? String, !min_color.isEmpty {
                    slider.minimumTrackTintColor = getColorFrom(hex: min_color)
                }
                
                if let max_color = sliderJson["max_color"] as? String, !max_color.isEmpty {
                    slider.maximumTrackTintColor = getColorFrom(hex: max_color)
                }
            }
        case .rating:
            if let ratingJson = getJsonfromdata(type: .rating),
               let sliderJson = getJsonUsing(key: "slider", mainJson: ratingJson) {
                
                if let slider_minImage = sliderJson["min_image"] as? String,
                   let min_image = getImage(imageName: slider_minImage) {
                    slider.setMinimumTrackImage(min_image, for: .normal)
                }
                
                if let slider_maxImage = sliderJson["max_image"] as? String,
                   let max_image = getImage(imageName: slider_maxImage)  {
                    slider.setMaximumTrackImage(max_image, for: .normal)
                }
                
                if let slider_thumbImage = sliderJson["thumb_image"] as? String,
                   let thumb_image = getImage(imageName: slider_thumbImage) {
                    slider.setThumbImage(thumb_image, for: .normal)
                    slider.setThumbImage(thumb_image, for: .highlighted)
                }
                
                if let min_color = sliderJson["min_color"] as? String, !min_color.isEmpty {
                    slider.minimumTrackTintColor = getColorFrom(hex: min_color)
                }
                
                if let max_color = sliderJson["max_color"] as? String, !max_color.isEmpty {
                    slider.maximumTrackTintColor = getColorFrom(hex: max_color)
                }
            }
        default:
            break
        }
    }
    
    func preferences(forUIColor color: BKBGColor!, of activityType: BKActivityType, colorType activityColor: BKActivityColorType, andButtonType isFloatButton: Bool) {
        
        
        switch activityType {
        case .survey:
            if let surveyJson = getJsonfromdata(type: .survey),
               let json = getJsonUsing(key: "color", mainJson: surveyJson) {
                
                switch activityColor {
                    
                case .headerBGColor:
                    if let headerColor = json["headerBG"] as? String, !headerColor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: headerColor)
                    }
                    
                case .bgColor, .bottomBGColor:
                    
                    if let bgColor = json["background"] as? String, !bgColor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: bgColor)
                    }
                    
                case .pageTintColor:
                    if let defColor = json["pagenationdots_def"] as? String, !defColor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: defColor)
                    }
                    
                case .currentPageTintColor:
                    if let currentColor = json["pagenationdots_current"] as? String, !currentColor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: currentColor)
                    }
                    
                case .answeredPageTintColor:
                    
                    if let answeredColor = json["pagenationdots_answered"] as? String, !answeredColor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: answeredColor)
                    }
                    
                    
                case .optionDefaultBorderColor:
                    if let defcolor = json["option_def_border"] as? String, !defcolor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: defcolor)
                    }
                    
                case .optionSelectedBorderColor:
                    if let selcolor = json["option_sel_border"] as? String, !selcolor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: selcolor)
                    }
                    
                default:
                    break
                }
            }
            
        case .rating:
            if let ratingJson = getJsonfromdata(type: .rating),
               let json = getJsonUsing(key: "color", mainJson: ratingJson) {
                
                switch activityColor {
                    
                case .headerBGColor:
                    if let headerColor = json["headerBG"] as? String, !headerColor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: headerColor)
                    }
                    
                case .bgColor, .bottomBGColor:
                    
                    if let bgColor = json["background"] as? String, !bgColor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: bgColor)
                    }
                default:
                    break
                }
            }
            
        case .opinionPoll:
            
            if let pollJson = getJsonfromdata(type: .opinionPoll),
               let json = getJsonUsing(key: "color", mainJson: pollJson) {
                
                switch activityColor {
                    
                case .headerBGColor:
                    if let headerColor = json["headerBG"] as? String, !headerColor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: headerColor)
                    }
                    
                case .bgColor, .bottomBGColor:
                    
                    if let bgColor = json["background"] as? String, !bgColor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: bgColor)
                    }
                    
                case .optionDefaultBorderColor:
                    if let defcolor = json["option_def_border"] as? String, !defcolor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: defcolor)
                    }
                    
                case .optionSelectedBorderColor:
                    if let selcolor = json["option_sel_border"] as? String, !selcolor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: selcolor)
                    }
                    
                case .graphLabelColor:
                    if  let graphJson = getJsonUsing(key: "graph", mainJson: pollJson),
                        let yAxisTextColor = graphJson["yAxis"] as? String, !yAxisTextColor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: yAxisTextColor)
                    }
                    
                case .percentageColor:
                    if let graphJson = getJsonUsing(key: "graph", mainJson: pollJson),
                       let percentageColor = graphJson["percentage"] as? String, !percentageColor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: percentageColor)
                    }
                    
                case .strokeColor:
                    if let graphJson = getJsonUsing(key: "graph", mainJson: pollJson),
                       let bar_line = graphJson["bar_line"] as? String, !bar_line.isEmpty {
                        color.backgroundColor = getColorFrom(hex: bar_line)
                    }
                    
                default:
                    break
                }
            }
            
        case .trivia:
            
            if let triviaJson = getJsonfromdata(type: .trivia),
               let json = getJsonUsing(key: "color", mainJson: triviaJson) {
                
                switch activityColor {
                    
                case .headerBGColor:
                    if let headerColor = json["headerBG"] as? String, !headerColor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: headerColor)
                    }
                    
                case .bgColor, .bottomBGColor:
                    
                    if let bgColor = json["background"] as? String, !bgColor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: bgColor)
                    }
                    
                case .optionDefaultBorderColor:
                    if let defcolor = json["option_def_border"] as? String, !defcolor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: defcolor)
                    }
                    
                case .optionSelectedBorderColor:
                    if let selcolor = json["option_sel_border"] as? String, !selcolor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: selcolor)
                    }
                    
                case .graphLabelColor:
                    if  let graphJson = getJsonUsing(key: "graph", mainJson: triviaJson),
                        let yAxisTextColor = graphJson["yAxis"] as? String, !yAxisTextColor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: yAxisTextColor)
                    }
                    
                case .percentageColor:
                    if let graphJson = getJsonUsing(key: "graph", mainJson: triviaJson),
                       let percentageColor = graphJson["percentage"] as? String, !percentageColor.isEmpty {
                        color.backgroundColor = getColorFrom(hex: percentageColor)
                    }
                    
                case .strokeColor:
                    if let graphJson = getJsonUsing(key: "graph", mainJson: triviaJson),
                       let bar_line = graphJson["bar_line"] as? String, !bar_line.isEmpty {
                        color.backgroundColor = getColorFrom(hex: bar_line)
                    }
                    
                default:
                    break
                }
            }
        default:
            break
        }
    }
}
