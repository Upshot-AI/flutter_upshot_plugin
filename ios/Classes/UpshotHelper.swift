//
//  UpshotHelper.swift
//  Runner
//
//  Created by Vinod K on 8/4/21.
//

import Foundation
import Upshot

class UpshotHelper: NSObject {
    
    static var defaultHelper = UpshotHelper()
    
    var surveyThemeData: Data?
    var ratingThemeData: Data?
    var pollThemeData: Data?
    var triviaThemeData: Data?
    
    var customizationData: Data?
    var registrar:FlutterPluginRegistrar?

    let customisation = UpshotCustomisation()
    
    func initializeUpshotUsingConfigFile() {
        BrandKinesis.sharedInstance().initialize(withDelegate: self)
        setCustomisationData()
    }
    
    func initializeUsingOptions(options: [String: Any]) {

        let appId = options["appId"] ?? ""
        let ownerId = options["ownerId"] ?? ""
        let enableLocation = options["enableLocation"] ?? false
        let enableDebuglogs = options["enableDebuglogs"] ?? false
        let enableCrashlogs = options["enableCrashlogs"] ?? false
        
        if let initOptions = [BKApplicationID: appId,
                      BKApplicationOwnerID: ownerId,
                         BKEnableDebugLogs: enableDebuglogs,
                           BKFetchLocation: enableLocation,
                           BKExceptionHandler: enableCrashlogs] as? [String: Any] {
            
            BrandKinesis.sharedInstance().initialize(options: initOptions, delegate: self)
            setCustomisationData()                        
        }        
    }
    
    func setCustomisationData() {
        customisation.surveyThemeData = surveyThemeData
        customisation.ratingThemeData = ratingThemeData
        customisation.pollThemeData = pollThemeData
        customisation.triviaThemeData = triviaThemeData
        customisation.registrar = registrar
        BKUIPreferences.preferences().delegate = customisation
    }
    
    func terminate() {
        BrandKinesis.sharedInstance().terminate()
    }

    func dispatchInterval(interval: Int) {
        BrandKinesis.sharedInstance().dispatchInterval = TimeInterval(interval)
    }
    
    func updateUserDetails(details: [String: Any]) {
        
        buildUserDetails(details: details)
    }
    
    func getUserDetails() {
        
        if let details = BrandKinesis.sharedInstance().getUserDetails(nil) as? [String: Any] {
            if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
                
                let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    upshotChannel.invokeMethod("upshotCurrentUserDetails", arguments: details)
                }
            }
        }
    }
    
    func sendLogoutDetails() {
        
        let userInfo = BKUserInfo()
        let externalId = BKExternalId()
        externalId.appuID = ""
        userInfo.externalId = externalId
        userInfo.build(completionBlock: nil)
    }
    
    func updateDeviceToken(token: String) {
        
        let userInfo = BKUserInfo()
        let externalId = BKExternalId()
        externalId.apnsID = token
        userInfo.externalId = externalId
        userInfo.build(completionBlock: nil)
    }
    
    func updatePushClickDetails(payload: [String: Any]) {
        
        BrandKinesis.sharedInstance().handlePushNotification(withParams: payload, withCompletionBlock: nil)
    }
    
    func getUserId() -> String {
        
        return BrandKinesis.sharedInstance().getUserId()
    }
    
    func getSDKVersion() -> String {
        
        return BrandKinesis.sharedInstance().version ?? ""
    }
    
    func createCustomEvent(eventName: String, payload: [String: Any], isTimed: Bool) -> String? {
        return BrandKinesis.sharedInstance().createEvent(eventName, params: payload, isTimed: isTimed)
    }
    
    func createPageViewEvent(pageName: String) -> String? {
        return BrandKinesis.sharedInstance().createEvent(BKPageViewNative, params: [BKCurrentPage: pageName], isTimed: true)
    }
    
    func createAttributionEvent(payload: [String: Any]) -> String? {
        return BrandKinesis.sharedInstance().createAttributionEvent(payload)
    }
    
    func createLocationEvent(payload: [String: Any]) {
        
        if let latitude = payload["latitude"] as? NSNumber,
           let longitude = payload["longitude"] as? NSNumber {
            
            let lat = CGFloat(truncating: latitude)
            let longi = CGFloat(truncating: longitude)
            BrandKinesis.sharedInstance().createLocationEvent(lat, longitude: longi)
        }
    }
    
    func setValueAndClose(payload: [String: Any], eventId: String) {
        BrandKinesis.sharedInstance().setValueAndClose(payload, forEvent: eventId)
    }
    
    func closeEventForId(eventId: String) {
        BrandKinesis.sharedInstance().closeEvent(forID: eventId)
    }
    
    func dispatchEvents(timed: Bool) {
        BrandKinesis.sharedInstance().dispatchEvents(withTimedEvents: timed, completionBlock: nil)
    }
    
    func showActivity(activityType: BKActivityType, tag: String) {                       
        BrandKinesis.sharedInstance().showActivity(with: activityType, andTag: tag)
    }
    
    func showActivityWithId(activityId: String) {
        BrandKinesis.sharedInstance().showActivity(withActivityId: activityId)
    }
    
    func removeTutorial() {
        BrandKinesis.sharedInstance().removeTutorials()
    }
    
    func getUserBadges() {
        
        var userBadge:[String: Any] = [:]
        if let badges = BrandKinesis.sharedInstance().getUserBadges() as? [String: Any],
           let inactive_list = badges["inactive_list"] as? [[String: Any]],
           let active_list = badges["active_list"] as? [[String: Any]] {
            
            var activeBadges:[[String: Any]] = []
            var inactiveBadges:[[String: Any]] = []
            
            
            inactive_list.forEach { inactivePayload in
                
                var newInactivePayload = inactivePayload
                if let badgeImage = inactivePayload["badgeImage"] as? UIImage,
                   let name = inactivePayload["badge"] as? String {
                    newInactivePayload["image"] = writeImageToTemp(image:badgeImage, name:name)
                    newInactivePayload.removeValue(forKey: "badgeImage")
                }
                inactiveBadges.append(newInactivePayload)
            }
            
            active_list.forEach { activePayload in
                
                var newActivePayload = activePayload
                if let badgeImage = activePayload["badgeImage"] as? UIImage,
                   let name = activePayload["badge"] as? String {
                    newActivePayload["image"] = writeImageToTemp(image:badgeImage, name:name)
                    newActivePayload.removeValue(forKey: "badgeImage")
                }
                activeBadges.append(newActivePayload)
            }
            userBadge["active_list"] = activeBadges
            userBadge["inactive_list"] = inactiveBadges
        }
        if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
            
            let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                upshotChannel.invokeMethod("upshotBadgesData", arguments: userBadge)
            }
        }
    }
    
    func fetchInbox() {
        
        BrandKinesis.sharedInstance().fetchInboxInfo { inboxDetails in
            if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
                
                let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    if let details = inboxDetails as? [[String: Any]] {
                        var newInbox: [[String: Any]] = []
                        details.forEach { payload in
                            var newPayload: [String: Any] = [:]
                            if let camName = payload["name"] as? String,
                               let activities = payload["activities"] as? [[String: Any]],
                               var activity = activities.first {
                                                                
                                if let insertionTime = activity["date"] as? Date {
                                    let insertionTimeStamp = insertionTime.timeIntervalSince1970
                                    activity["date"] = Double(insertionTimeStamp)
                                }
                                if let expiryTime = activity["expiry"] as? Date {
                                    let expiryTimeStamp = expiryTime.timeIntervalSince1970
                                    activity["expiry"] = Double(expiryTimeStamp)
                                }
                                newPayload["name"] = camName
                                newPayload["activities"] = [activity]
                                newInbox.append(newPayload)
                            }
                        }
                        let data: [String: Any] = ["data":newInbox]
                        upshotChannel.invokeMethod("upshotCampaignDetails", arguments: data)
                    }
                }
            }
        }
    }
    
    func fetchRewards() {
        
        BrandKinesis.sharedInstance().getRewardsStatus(completionBlock: { response, error in
            if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
                
                let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
                
                var rewards: [String : Any] =  [:]
                if let res = response as? [String: Any] {
                    rewards = ["status": "Success", "response": self.jsonToString(json: res) ?? ""]
                }
                if let err = error {
                    rewards = ["status": "Fail", "errorMessage": err]
                }
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    upshotChannel.invokeMethod("upshotRewardsResponse", arguments: rewards)
                }
            }
        })
    }
    
    func fetchRewardHistory(programId: String, historyType: BKRewardHistoryType) {
        
        BrandKinesis.sharedInstance().getRewardHistory(forProgramId: programId, with: historyType) { response, error in
            
            if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
                
                let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
                
                var history: [String : Any] =  [:]
                if let res = response as? [String: Any] {
                    history = ["status": "Success", "response": self.jsonToString(json: res) ?? ""]
                }
                if let err = error {
                    history = ["status": "Fail", "errorMessage": err]
                }
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    upshotChannel.invokeMethod("upshotRewardHistoryResponse", arguments: history)
                }
            }
        }
    }
    
    func fetchRewardRules(programId: String) {
        
        BrandKinesis.sharedInstance().getRewardDetails(forProgramId: programId) { response, error in
            
            if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
                
                let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
                
                var rules: [String : Any] =  [:]
                if let res = response as? [String: Any] {
                    rules = ["status": "Success", "response": self.jsonToString(json: res)  ?? ""]
                }
                if let err = error {
                    rules = ["status": "Fail", "errorMessage": err]
                }
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    upshotChannel.invokeMethod("upshotRewardRulesResponse", arguments: rules)
                }
            }
        }
    }
    
    func redeemRewards(programId: String, transactionValue: Int, redeemAmount: Int, tag: String) {
        
        BrandKinesis.sharedInstance().redeemRewards(withProgramId: programId, transactionValue: transactionValue, redeemAmout: redeemAmount, tag: tag) { response, error in
            
            if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
                
                let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
                
                var redeemStatus: [String : Any] =  [:]
                if let res = response as? [String: Any] {
                    redeemStatus = ["status": "Success", "response": self.jsonToString(json: res) ?? ""]
                }
                if let err = error {
                    redeemStatus = ["status": "Fail", "errorMessage": err]
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    upshotChannel.invokeMethod("upshotRedeemRewardsResponse", arguments: redeemStatus)
                }
            }
        }
    }
    
    func getNotifications(loadMore: Bool, limit: Int) {
        
        BrandKinesis.sharedInstance().getNotificationsWith(limit, loadmore: loadMore) { response, errorMessage in
            if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
                
                let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
                
                var notificationStatus: [String : Any] =  [:]
                if let res = response as? [String: Any],
                   let streakArray = res["data"] as? [[String: Any]],
                   let jsonString = self.jsonArrayToString(json: streakArray) {
                    notificationStatus = ["status": "Success", "response":  jsonString]
                } else {
                    notificationStatus = ["status": "Fail", "errorMessage": "something went wrong.."]
                }
                if let err = errorMessage {
                    notificationStatus = ["status": "Fail", "errorMessage": err]
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    upshotChannel.invokeMethod("upshotGetNotifications", arguments: notificationStatus)
                }
            }
        }
    }
    
    func fetchStreaks() {
        
        BrandKinesis.sharedInstance().getStreaksData { response, error in
            
            if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
                
                let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
                
                var streakData: [String : Any] =  [:]
                if let res = response as? [String: Any],
                    let streaksArray = res["data"] as? [[String: Any]],
                    let jsonString = self.jsonArrayToString(json: streaksArray) {
                    streakData = ["response":  jsonString]
                } else {
                    streakData = ["status": "Fail", "errorMessage": "something went wrong..."]
                }
                if let err = error {
                    streakData = ["status": "Fail", "errorMessage": err]
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    upshotChannel.invokeMethod("upshotStreakResponse", arguments: streakData)
                }
            }
        }
    }

    func activityShown_Internal(payload: [String: Any]) {
        BrandKinesis.sharedInstance().activityPresentedCallback(payload)
    }

    func activitySkiped_Internal(payload: [String: Any]) {
        BrandKinesis.sharedInstance().activitySkipCallback(payload)
    }

    func activityDismiss_Internal(payload: [String: Any]) {
        BrandKinesis.sharedInstance().activityRespondCallback(payload)
    }

    func activityRedirection_Internal(payload: [String: Any]) {
        BrandKinesis.sharedInstance().activityRedirectionCallback(payload)
    }
    
    func writeImageToTemp(image: UIImage, name: String) -> String {
        
        let tempPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
        let filePath = tempPath?.appending(name) ?? ""
        let url = URL(fileURLWithPath: filePath)
        try? image.pngData()?.write(to: url)
        return filePath
    }
    
    
    func buildUserDetails(details: [String: Any]) {
        
        let userInfo = BKUserInfo()
        let externalId = BKExternalId()
        let dob = BKDob()
        
        var others: [String: Any] = [:]
        
        if let lat = details["lat"] as? Double, let lng = details["lng"] as? Double {
            let location = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
            userInfo.location = location
        }
        
        for key in details.keys {
            
            let type = getInfoTypeForKey(key: key)
            
            if type == "BKDob" {
                dob.setValue(details[key], forKey: key)
                
            } else if type == "BKExternalId" {
                externalId.setValue(details[key], forKey: key)
                
            } else if type == "UserInfo" {
                userInfo.setValue(details[key], forKey: key)
                
            } else {
                others[key] = details[key]
            }
        }
        
        userInfo.others = others
        userInfo.externalId = externalId
        userInfo.dateOfBirth = dob
        userInfo.build { status, error in
            if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {                
                let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    upshotChannel.invokeMethod("upshotProfileUpdatingStatus", arguments: status)                    
                }
            }
        }
    }
    
    func getInfoTypeForKey(key: String) -> String {
        
        let externalIdKeys = ["appuID",
                              "facebookID",
                              "twitterID",
                              "foursquareID",
                              "linkedinID",
                              "googleplusID",
                              "enterpriseUID",
                              "advertisingID",
                              "instagramID",
                              "pinterest"]
        
        let dobKeys = ["year", "month", "day"]
        
        let userInfoKeys = ["lastName",
                            "middleName",
                            "firstName",
                            "language",
                            "occupation",
                            "qualification",
                            "maritalStatus",
                            "phone",
                            "localeCode",
                            "userName",
                            "email",
                            "age",
                            "gender",
                            "email_opt",
                            "sms_opt",
                            "push_opt",
                            "data_opt",
                            "ip_opt"]
        
        if externalIdKeys.contains(key) {
            return "BKExternalId"
        }
        
        if dobKeys.contains(key) {
            return "BKDob"
        }
        
        if userInfoKeys.contains(key) {
            return "UserInfo"
        }
        return "Others"
    }

    func disableUser() {
        
        BrandKinesis.sharedInstance().disableUser() { (status, error) in
            if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
                
                let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    upshotChannel.invokeMethod("upshotUserStateCompletion", arguments: status)
                }
            }
        }
    }
    
    func showInboxScreen(options: [String: Any]) {
        BrandKinesis.sharedInstance().showInboxController(options)
    }

    func getUnreadNotificationsCount(inboxType: Int) {
     
       let type = BKInboxMessageType(rawValue: inboxType) ?? .OnlyPushNotifications
        
        BrandKinesis.sharedInstance().getUnreadNotificationsCount(with: type) { count in
            if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
                
                let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    let response: [String : Any] =  ["count":count]
                    upshotChannel.invokeMethod("upshotUnreadNotificationsCount", arguments: response)
                }
            }
        }
    }
    
    func updateNotificationReadStatus(notificationId: String) {
        BrandKinesis.sharedInstance().updatePushNotificationReadStatus(notificationId) { status, error in
            if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
                
                let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    let response: [String : Any] =  ["status":status, "error": error ?? ""];
                    upshotChannel.invokeMethod("updateNotificationReadStatus", arguments: response)
                }
            }
        }
    }
    
    func setTechnologyType() {
        BrandKinesis.sharedInstance().setTechnologyType("flutter")
    }

    func registerForPushNotifications() {
        
        if #available(iOS 10.0, *) {
            
            var delegate = UIApplication.shared.delegate
            if (delegate != nil) {
                
                let notificationCenter = UNUserNotificationCenter.current()
                notificationCenter.requestAuthorization(options: [.badge, .alert, .sound]) { status, error in
                    if status == true {
                        DispatchQueue.main.async {
                            if let notificationCenterDelegate = delegate as? UNUserNotificationCenterDelegate {
                                notificationCenter.delegate = notificationCenterDelegate
                            }
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            }
        }
    }
    
    func jsonToString(json: [String: Any]) -> String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let jsonString = String(data: data, encoding: .utf8)
            return jsonString
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    func jsonArrayToString(json: [[String: Any]]) -> String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let jsonString = String(data: data, encoding: .utf8)
            return jsonString
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }    
    
    func getContentHeight(data: [String: Any]) {
        
        if let content = data["text"] as? String,
           let contentData = content.data(using: .unicode),
           let mutableString = try? NSMutableAttributedString(data: contentData, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.unicode.rawValue], documentAttributes: nil) {
            let fontName = data["fontName"] as? String ?? ""
            let fontSize = data["fontSize"] as? Int ?? 14
            var font = UIFont.systemFont(ofSize: CGFloat(fontSize))
            if let cFont = UIFont(name: fontName, size: CGFloat(fontSize)) {
        font = cFont
    }
        let width = UIScreen.main.bounds.width * 0.9 - 40
            let height = NSString(string: mutableString.string).boundingRect(with: CGSize(width: width,height:Double.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
        if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController{
        let upshotChannel=FlutterMethodChannel(name:"flutter_upshot_plugin_internal",binaryMessenger:controller.binaryMessenger)
        upshotChannel.invokeMethod("webViewHeight", arguments: height)
        
    }
            
        }
        
    }
}

extension UpshotHelper: BrandKinesisDelegate {
    
    func brandKinesisAuthentication(_ brandKinesis: BrandKinesis, withStatus status: Bool, error: Error?) {
        
        let userDefaults = UserDefaults.standard
        if let token = userDefaults.value(forKey: "upshot_token") as? String {
            updateDeviceToken(token: token)
        }
        
        if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
            
            let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
            
            let s = status ? "Success" : "Fail"
            var authStatus = ["status": s, "errorMessage": ""] as [String : Any]
            if !status {
                authStatus = ["status": s, "errorMessage": error?.localizedDescription ?? "No Error"] as [String : Any]
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                upshotChannel.invokeMethod("upshotAuthenticationStatus", arguments: authStatus)
            }
        }
    }
    
    func brandKinesisActivityDidAppear(_ brandKinesis: BrandKinesis, for activityType: BKActivityType) {
        
        if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
            
            let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
            let activityPayload = ["activityType": activityType.rawValue] as [String : Any]
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                upshotChannel.invokeMethod("upshotActivityDidAppear", arguments: activityPayload)
            }
        }
    }
    
    func brandKinesisActivityDidDismiss(_ brandKinesis: BrandKinesis, for activityType: BKActivityType) {
        
        if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
            
            let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
            let activityPayload = ["activityType": activityType.rawValue] as [String : Any]
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                upshotChannel.invokeMethod("upshotActivityDidDismiss", arguments: activityPayload)
            }
        }
    }
    func brandKinesisActivitySkipped(_ brandKinesis: BrandKinesis, for activityType: BKActivityType) {
        
        if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
            
            let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
            let activityPayload = ["activityType": activityType.rawValue] as [String : Any]
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                upshotChannel.invokeMethod("upshotActivitySkip", arguments: activityPayload)
            }
        }
    }
    
    func brandKinesisActivity(_ activityType: BKActivityType, performedActionWithParams params: [AnyHashable : Any]) {
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
                
                let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
                
                if let _  = params["deepLink"] as? String, let _ = params["deepLink_keyValue"] as? [String: Any] {                    
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        upshotChannel.invokeMethod("upshotActivityDeeplink", arguments: params)
                    }
                    
                } else if let deepLink  = params["deepLink"] as? String, params.count == 1 {
                    let activityPayload = ["activityType": activityType.rawValue, "deepLink": deepLink] as [String : Any]
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        upshotChannel.invokeMethod("upshotActivityDeeplink", arguments: activityPayload)
                    }
                    
                } else if let data = params["deepLink_keyValue"] as? [String: Any] {
                    let activityPayload = ["activityType": activityType.rawValue, "deepLink_keyValue": self.jsonToString(json: data) ?? ""] as [String : Any]
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        upshotChannel.invokeMethod("upshotActivityDeeplink", arguments: activityPayload)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        upshotChannel.invokeMethod("upshotActivityDeeplink", arguments: params)
                    }
                }
            }
        }
    }
    
    func brandkinesisErrorLoadingActivity(_ brandkinesis: BrandKinesis, withError error: Error?) {
        
        if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
            
            let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
            let activityPayload = ["error": error?.localizedDescription ?? ""] as [String : Any]
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                upshotChannel.invokeMethod("upshotActivityError", arguments: activityPayload)
            }
        }
    }
    
    func brandkinesisCampaignDetailsLoaded() {
        UpshotHelper.defaultHelper.showActivity(activityType: .any, tag: "Upshot_loaded")
    }
    
    func brandKinesisInboxActivityPresented() {
        if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
            
            let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
            let activityPayload: [String: Any] = [:]
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                upshotChannel.invokeMethod("upshotInboxActivityPresented", arguments: activityPayload)
            }
        }
    }
    
    func brandKinesisInboxActivityDismissed() {
        if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
            
            let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: controller.binaryMessenger)
            let activityPayload: [String: Any] = [:]
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                upshotChannel.invokeMethod("upshotInboxActivityDismiss", arguments: activityPayload)
            }
        }
    }
    
    func brandKinesisInteractiveTutorialInfo(forPlugin jsonString: String) {
        
        if let controller : FlutterViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
            let upshotChannel = FlutterMethodChannel(name: "flutter_upshot_plugin_internal", binaryMessenger: controller.binaryMessenger)
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                upshotChannel.invokeMethod("upshot_interactive_tutoInfo", arguments: jsonString)                
            }
        }
    }
}

extension NSAttributedString {
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return boundingBox.height
    }

}


