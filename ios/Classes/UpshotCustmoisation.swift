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
    var registrar:FlutterPluginRegistrar?
    
    func getJsonfromdata() -> [String: Any]? {
        
        if let data = customiseData, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            return json
        }
        return nil
    }
    
    func getJsonUsing(key: String) -> [String: Any]? {
        
        if let mainJson = getJsonfromdata(), mainJson.keys.contains(key) {
            return mainJson[key] as? [String: Any]
        }
        return nil
    }
    
    func getImage(imageName: String, extn: String) -> UIImage? {
        
        if let reg = registrar {
            let fileKey = reg.lookupKey(forAsset: "assets/images/\(imageName).\(extn)")
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
    
    func preferences(for imageView: UIImageView!, of activityType: BKActivityType, andType activityImage: BKActivityImageType) {
        
        if let json = getJsonUsing(key: "image") {
            switch activityImage {
            case .backgroundImage:
                if let bgImageJson = json["bg"] as? [String: Any],
                   let image = getImage(imageName: bgImageJson["name"] as? String ?? "", extn: bgImageJson["ext"] as? String ?? "") {
                    imageView.image = image
                    imageView.contentMode = .scaleAspectFit
                }
            case .checkboxImage:
                if let checkbox_defJson = json["checkbox_def"] as? [String: Any] ,
                   let defimage = getImage(imageName: checkbox_defJson["name"] as? String ?? "", extn: checkbox_defJson["ext"]  as? String ?? "") {
                    imageView.image = defimage
                }
                if let checkbox_selJson = json["checkbox_sel"] as? [String: Any] ,
                   let selimage = getImage(imageName: checkbox_selJson["name"] as? String ?? "", extn: checkbox_selJson["ext"] as? String ?? "") {
                    imageView.highlightedImage = selimage
                }
                
                
            case .radioImage:
                if let radio_defJson = json["radio_def"] as? [String: Any] ,
                   let defimage = getImage(imageName: radio_defJson["name"] as? String ?? "", extn: radio_defJson["ext"]  as? String ?? "") {
                    imageView.image = defimage
                }
                if let radio_selJson = json["radio_sel"] as? [String: Any] ,
                   let selimage = getImage(imageName: radio_selJson["name"] as? String ?? "", extn: radio_selJson["ext"] as? String ?? "") {
                    imageView.highlightedImage = selimage
                }
            case .portraitLogo, .landscapeLogo:
                
                if let logoJson = json["logo"] as? [String: Any] ,
                   let logoImage = getImage(imageName: logoJson["name"] as? String ?? "", extn: logoJson["ext"] as? String ?? "") {
                    imageView.image = logoImage
                }
            default:
                break
            }
        }
    }
    
    func setButtonPreferences(data: [String: Any], button: UIButton) {
        
        if let bgcolor = data["bgColor"] as? String, !bgcolor.isEmpty {
            button.backgroundColor = hexStringToUIColor(hex: bgcolor)
        }
        
        if let tColor = data["tColor"] as? String, !tColor.isEmpty {
            button.setTitleColor(hexStringToUIColor(hex: tColor), for: .normal)
            button.setTitleColor(hexStringToUIColor(hex: tColor), for: .selected)
            button.setTitleColor(hexStringToUIColor(hex: tColor), for: .highlighted)
        }
        
        if let fStyle = data["fStyle"] as? String, !fStyle.isEmpty, let fSize = data["fSize"] as? Int {
            loadFonts(with: fStyle)
            if let font = UIFont(name: fStyle, size: CGFloat(fSize)) {
                button.titleLabel?.font = font
            }
        }
        
        if let borderColor = data["borderColor"] as? String, !borderColor.isEmpty {
            button.layer.borderWidth = 1.0
            button.layer.borderColor = hexStringToUIColor(hex: borderColor).cgColor
        }
    }
    
    func setLablePreferences(data: [String: Any], label: UILabel) {
        
        if let tColor = data["tColor"] as? String, !tColor.isEmpty {
            label.textColor = hexStringToUIColor(hex: tColor)
        }
        if let fStyle = data["fStyle"] as? String, !fStyle.isEmpty, let fSize = data["fSize"] as? Int {
            loadFonts(with: fStyle)
            if let font = UIFont(name: fStyle, size: CGFloat(fSize)) {
                label.font = font
            }
        }
    }
    
    func preferences(for button: UIButton!, of activityType: BKActivityType, andType activityButton: BKActivityButtonType) {
        
        if let json = getJsonUsing(key: "button") {
            
            switch activityButton {
                
            case .continueButton:
                if let cButton = json["continue"] as? [String: Any] {
                    setButtonPreferences(data: cButton, button: button)
                }
            case .previousButton:
                if let cButton = json["prev"] as? [String: Any] {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.setButtonPreferences(data: cButton, button: button)
                    }
                }
            case .nextButton:
                if let cButton = json["next"] as? [String: Any] {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.setButtonPreferences(data: cButton, button: button)
                    }
                }
                
            case .ratingDislikeButton:
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if let mainJson = self.getJsonUsing(key: "image"),
                       let dislike_defJson = mainJson["dislike_def"] as? [String: Any] ,
                       let defimage = self.getImage(imageName: dislike_defJson["name"] as? String ?? "", extn: dislike_defJson["ext"]  as? String ?? "") {
                        button.setImage(defimage, for: .normal)
                    }
                    if let mainJson = self.getJsonUsing(key: "image"),
                       let dislike_selJson = mainJson["dislike_sel"] as? [String: Any] ,
                       let selimage = self.getImage(imageName: dislike_selJson["name"] as? String ?? "", extn: dislike_selJson["ext"] as? String ?? "") {
                        button.setImage(selimage, for: .selected)
                        button.setImage(selimage, for: .highlighted)
                    }
                }
            case .ratingLikeButton:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if let mainJson = self.getJsonUsing(key: "image"),
                       let like_defJson = mainJson["like_def"] as? [String: Any] ,
                       let defimage = self.getImage(imageName: like_defJson["name"] as? String ?? "", extn: like_defJson["ext"]  as? String ?? "") {
                        button.setImage(defimage, for: .normal)
                    }
                    if let mainJson = self.getJsonUsing(key: "image"),
                       let like_selJson = mainJson["like_sel"] as? [String: Any] ,
                       let selimage = self.getImage(imageName: like_selJson["name"] as? String ?? "", extn: like_selJson["ext"] as? String ?? "") {
                        button.setImage(selimage, for: .selected)
                        button.setImage(selimage, for: .highlighted)
                    }
                }
            case .skipButton:
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if let mainJson = self.getJsonUsing(key: "image"),
                       let skipJson = mainJson["skip"] as? [String: Any] ,
                       let skipimage = self.getImage(imageName: skipJson["name"] as? String ?? "", extn: skipJson["ext"]  as? String ?? "") {
                        button.setImage(skipimage, for: .normal)
                        button.setImage(skipimage, for: .highlighted)
                        button.setImage(skipimage, for: .selected)
                    }
                }
            case .ratingYesButton:
                if let cButton = json["yes"] as? [String: Any] {
                    setButtonPreferences(data: cButton, button: button)
                }
            case .ratingNoButton:
                if let cButton = json["no"] as? [String: Any] {
                    setButtonPreferences(data: cButton, button: button)
                }
            case .submitButton:
                if let cButton = json["submit"] as? [String: Any] {
                    setButtonPreferences(data: cButton, button: button)
                }
            default:
                break
            }
        }
    }
    
    func preferences(for label: UILabel!, of activityType: BKActivityType, andType activityLabel: BKActivityLabelType) {
        
        if let json = getJsonUsing(key: "label") {
            
            switch activityLabel {
                
            case .headerLabel:
                if let header = json["header"] as? [String: Any] {
                    setLablePreferences(data:header , label: label)
                }
            case .descriptionLabel:
                if let desc = json["desc"] as? [String: Any] {
                    setLablePreferences(data:desc , label: label)
                }
            case .barGraphOptionsLabel,
                    .barGraphUserLabel,
                    .legendLabel,
                    .maxValueTitleLabel,
                    .minValueTitleLabel,
                    .sliderMinValueLabel,
                    .sliderScoreLabel,
                    .sliderMaxValueLabel,
                    .optionLabel:
                if let option = json["option"] as? [String: Any] {
                    setLablePreferences(data:option , label: label)
                }
            case .questionLabel:
                if let question = json["question"] as? [String: Any] {
                    setLablePreferences(data:question , label: label)
                }
            case .thankyouLabel:
                if let thanks = json["thanks"] as? [String: Any] {
                    setLablePreferences(data:thanks , label: label)
                }
            case .thankyouAppStoreHint:
                if let appstoreHint = json["appstoreHint"] as? [String: Any] {
                    setLablePreferences(data:appstoreHint , label: label)
                }
            default:
                break
            }
        }
    }
    
    func preferences(forGraphColor graphType: BKGraphType, graphColors block: (([Any]?) -> Void)!) {
        
        if let json = getJsonUsing(key: "color"), let graph = json["graph"] as? [String] {
            
            var colors: [UIColor] = []
            for color in graph {
                if color.isEmpty {
                    return
                }
                colors.append(hexStringToUIColor(hex: color))
            }
            if colors.count == 5 {
                block(colors)
            }
        }
    }
    
    func preferences(forRatingActivity activityType: BKActivityType, andType activityRating: BKActivityRatingType, withImages block: (([Any]?, [Any]?) -> Void)!) {
        
        if let json = getJsonUsing(key: "image") {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
            }
            if activityRating == .starRating {
                
                var defimage: UIImage?
                var selimage: UIImage?
                
                if let star_defJson = json["star_def"] as? [String: Any] {
                    defimage = self.getImage(imageName: star_defJson["name"] as? String ?? "", extn: star_defJson["ext"]  as? String ?? "")
                }
                if let star_selJson = json["start_sel"] as? [String: Any] {
                    selimage = self.getImage(imageName: star_selJson["name"] as? String ?? "", extn: star_selJson["ext"]  as? String ?? "")
                }
                if let def = defimage, let sel = selimage {
                    block([def,def,def,def,def], [sel,sel,sel,sel,sel])
                }
            }
            
            if activityRating == .emojiRating {
                
                if let veryGood_defJson = json["veryGood_def"] as? [String: Any],
                   let vgDef = getImage(imageName: veryGood_defJson["name"] as? String ?? "",
                                        extn: veryGood_defJson["ext"] as? String ?? ""),
                   
                    let good_defJson = json["good_def"] as? [String: Any],
                   let gDef = getImage(imageName: good_defJson["name"] as? String ?? "",
                                       extn: good_defJson["ext"] as? String ?? ""),
                   
                    let avg_defJson = json["avg_def"] as? [String: Any],
                   let avgDef = getImage(imageName: avg_defJson["name"] as? String ?? "",
                                       extn: avg_defJson["ext"] as? String ?? ""),
                   
                    let bad_defJson = json["bad_def"] as? [String: Any],
                   let bDef = getImage(imageName: bad_defJson["name"] as? String ?? "",
                                       extn: bad_defJson["ext"] as? String ?? ""),
                   let verybad_defJson = json["veryBad_def"] as? [String: Any],
                   
                    let vbDef = getImage(imageName: verybad_defJson["name"] as? String ?? "",
                                         extn: verybad_defJson["ext"] as? String ?? ""),
                   
                    let veryGood_selJson = json["veryGood_sel"] as? [String: Any],
                   let vgSel = getImage(imageName: veryGood_selJson["name"] as? String ?? "",
                                        extn: veryGood_selJson["ext"] as? String ?? ""),
                   
                    let good_selJson = json["good_sel"] as? [String: Any],
                   let gSel = getImage(imageName: good_selJson["name"] as? String ?? "",
                                       extn: good_selJson["ext"] as? String ?? ""),
                   
                    let avg_selJson = json["avg_sel"] as? [String: Any],
                   let avgSel = getImage(imageName: avg_selJson["name"] as? String ?? "",
                                         extn: avg_selJson["ext"] as? String ?? ""),
                   
                    let bad_selJson = json["bad_sel"] as? [String: Any],
                   let bSel = getImage(imageName: bad_selJson["name"] as? String ?? "",
                                       extn: bad_selJson["ext"] as? String ?? ""),
                   
                    let verybad_selJson = json["veryBad_sel"] as? [String: Any],
                   
                    let vbSel = getImage(imageName: verybad_selJson["name"] as? String ?? "",
                                         extn: verybad_selJson["ext"] as? String ?? "") {
                    block([vgDef, gDef, avgDef, bDef, vbDef], [vgSel, gSel, avgSel, bSel, vbSel])
                }
                
                
                
                
                
                
            }
        }
    }
    
    func preferences(for textView: UITextView!, of activityType: BKActivityType, andType viewType: BKActivityViewType) {
        
        if let json = getJsonUsing(key: "feedbackBox") {
            
            if let tColor = json["tColor"] as? String, !tColor.isEmpty {
                textView.textColor = hexStringToUIColor(hex: tColor)
            }
            
            if let fStyle = json["fStyle"] as? String, !fStyle.isEmpty, let fSize = json["fSize"] as? Int {
                
                if let font = UIFont(name: fStyle, size: CGFloat(fSize)) {
                    textView.font = font
                }
            }
            
            if let bgColor = json["bgColor"] as? String, !bgColor.isEmpty {
                textView.backgroundColor = hexStringToUIColor(hex: bgColor)
            }
            
            if let borderColor = json["borderColor"] as? String, !borderColor.isEmpty {
                textView.layer.borderColor = hexStringToUIColor(hex: borderColor).cgColor
                textView.layer.borderWidth = 1.0
            }
        }
    }
    
    func preferences(for textField: UITextField!, of activityType: BKActivityType, andType viewType: BKActivityViewType) {
        
        if let json = getJsonUsing(key: "feedbackBox") {
            
            if let tColor = json["tColor"] as? String, !tColor.isEmpty {
                textField.textColor = hexStringToUIColor(hex: tColor)
            }
            
            if let fStyle = json["fStyle"] as? String, !fStyle.isEmpty,  let fSize = json["fSize"] as? Int {
                
                if let font = UIFont(name: fStyle, size: CGFloat(fSize)) {
                    textField.font = font
                }
            }
            
            if let bgColor = json["bgColor"] as? String, !bgColor.isEmpty {
                textField.backgroundColor = hexStringToUIColor(hex: bgColor)
            }
            
            if let borderColor = json["borderColor"] as? String, !borderColor.isEmpty {
                textField.layer.borderColor = hexStringToUIColor(hex: borderColor).cgColor
                textField.layer.borderWidth = 1.0
            }
        }
    }
    
    func preferences(for slider: UISlider!, of activityType: BKActivityType) {
        
        if let imageJson = getJsonUsing(key: "image") {
            
            if let slider_minJson = imageJson["slider_min"] as? [String: Any],
               let min_image = getImage(imageName: slider_minJson["name"] as? String ?? "", extn: slider_minJson["ext"] as? String ?? "") {
                slider.setMinimumTrackImage(min_image, for: .normal)
            }
            
            if let slider_maxJson = imageJson["slider_max"] as? [String: Any],
               let max_image = getImage(imageName: slider_maxJson["name"] as? String ?? "", extn: slider_maxJson["ext"] as? String ?? "")  {
                slider.setMaximumTrackImage(max_image, for: .normal)
            }
            
            if let slider_thumbJson = imageJson["slider_thumb"] as? [String: Any],
               let thumb_image = getImage(imageName: slider_thumbJson["name"] as? String ?? "", extn: slider_thumbJson["ext"] as? String ?? "") {
                slider.setThumbImage(thumb_image, for: .normal)
                slider.setThumbImage(thumb_image, for: .highlighted)
            }
        }
    }
    
    func preferences(forUIColor color: BKBGColor!, of activityType: BKActivityType, colorType activityColor: BKActivityColorType, andButtonType isFloatButton: Bool) {
        
        if let json = getJsonUsing(key: "color") {
            let pagination = json["pagination"] as? [String: Any]
            switch activityColor {
            case .bgColor:
                if let bgColor = json["bgColor"] as? String, !bgColor.isEmpty {
                    color.backgroundColor = hexStringToUIColor(hex: bgColor)
                }
            case .pageTintColor:
                if let pagi = pagination, let defColor = pagi["def"] as? String, !defColor.isEmpty {
                    color.backgroundColor = hexStringToUIColor(hex: defColor)
                }
            case .currentPageTintColor:
                if let pagi = pagination, let currentColor = pagi["current"] as? String, !currentColor.isEmpty {
                    color.backgroundColor = hexStringToUIColor(hex: currentColor)
                }
            case .answeredPageTintColor:
                
                if let pagi = pagination, let answeredColor = pagi["answered"] as? String, !answeredColor.isEmpty {
                    color.backgroundColor = hexStringToUIColor(hex: answeredColor)
                }
            case .headerBGColor:
                if let headerColor = json["headerColor"] as? String, !headerColor.isEmpty {
                    if activityType == .trivia {
                        color.backgroundColor = hexStringToUIColor(hex: headerColor)
                    }
                }
            case .optionDefaultBorderColor:
                if let optionsBorder = json["optionsBorder"] as? [String: Any], let defcolor = optionsBorder["def"] as? String, !defcolor.isEmpty {
                    color.backgroundColor = hexStringToUIColor(hex: defcolor)
                }
                break
            case .optionSelectedBorderColor:
                if let optionsBorder = json["optionsBorder"] as? [String: Any], let selcolor = optionsBorder["sel"] as? String, !selcolor.isEmpty {
                    color.backgroundColor = hexStringToUIColor(hex: selcolor)
                }
                break
            default:
                break
            }
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.black
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
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
}
