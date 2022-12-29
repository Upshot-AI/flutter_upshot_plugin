import Flutter
import UIKit
import Upshot

public class SwiftFlutterUpshotPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterUpshotPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let fileKey = registrar.lookupKey(forAsset: "assets/UpshotCustomisation.json")
        let filePath =  Bundle.main.path(forResource: fileKey, ofType: nil)
        if let path = filePath {
            let fileUrl = URL(fileURLWithPath: path)
            let data = try? Data(contentsOf: fileUrl)
            UpshotHelper.defaultHelper.customizationData = data
            UpshotHelper.defaultHelper.registrar = registrar
        }
        
        let new_tutorial_json_key = registrar.lookupKey(forAsset: "assets/new_tutorial_json.json")
        let new_tutorial_json_filePath =  Bundle.main.path(forResource: new_tutorial_json_key, ofType: nil)
        if let path = new_tutorial_json_filePath {
            let fileUrl = URL(fileURLWithPath: path)
            let data = try? Data(contentsOf: fileUrl)
            UpshotHelper.defaultHelper.dummyTutorialData = data            
        }        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        switch call.method {
            
        case "initializeUpshotUsingConfigFile":
            UpshotHelper.defaultHelper.initializeUpshotUsingConfigFile()
            
        case "initializeUsingOptions":
            if let arguments = call.arguments as? [String: Any] {
                UpshotHelper.defaultHelper.initializeUsingOptions(options: arguments)
            }
            
        case "terminate":
            UpshotHelper.defaultHelper.terminate()
            
        case "sendUserDetails":
            if let payload = call.arguments as? [String: Any] {
                UpshotHelper.defaultHelper.updateUserDetails(details: payload)
            }
        case "getUserDetails":
            UpshotHelper.defaultHelper.getUserDetails()
            
        case "sendLogoutDetails":
            UpshotHelper.defaultHelper.sendLogoutDetails()
            
        case "sendDeviceToken":
            
            if let payload = call.arguments as? [String: Any] {
                let token = payload["token"] as? String ?? ""
                UpshotHelper.defaultHelper.updateDeviceToken(token: token)
            }
            
        case "sendPushClickDetails":
            
            if let payload = call.arguments as? [String: Any] {
                UpshotHelper.defaultHelper.updatePushClickDetails(payload: payload)
            }
        case "displayNotification":
            break
        case "getUserId":
            result(UpshotHelper.defaultHelper.getUserId())
            
        case "getSDKVersion":
            result(UpshotHelper.defaultHelper.getSDKVersion())
            
        case "createCustomEvent":
            
            if let arguments = call.arguments as? [String: Any],
               let eventName = arguments["eventName"] as? String,
               let params = arguments["data"] as? [String: Any],
               let isTimed = arguments["isTimed"] as? Bool {
                let eventId = UpshotHelper.defaultHelper.createCustomEvent(eventName: eventName, payload: params, isTimed: isTimed)
                result(eventId)
            }
            
        case "createPageViewEvent":
            if let pageName = call.arguments as? String {
                let eventId = UpshotHelper.defaultHelper.createPageViewEvent(pageName: pageName)
                result(eventId)
            }
            
        case "createAttributionEvent":
            if let payload = call.arguments as? [String: Any] {
                let eventId = UpshotHelper.defaultHelper.createAttributionEvent(payload: payload)
                result(eventId)
            }
            
        case "createLocationEvent":
            if let payload = call.arguments as? [String: Any] {
                UpshotHelper.defaultHelper.createLocationEvent(payload: payload)
            }
        case "setValueAndClose":
            if let arguments = call.arguments as? [String: Any],
               let eventId = arguments["eventId"] as? String,
               let payload = arguments["data"] as? [String: Any] {
                UpshotHelper.defaultHelper.setValueAndClose(payload: payload,eventId: eventId)
            }
        case "closeEventForId":
            if let eventId = call.arguments as? String {
                UpshotHelper.defaultHelper.closeEventForId(eventId: eventId)
            }
            
        case "dispatchEvents":
            
            if let timed = call.arguments as? Bool {
                UpshotHelper.defaultHelper.dispatchEvents(timed: timed)
            }
            
        case "showActivity":
            if let arguments = call.arguments as? [String: Any],
               let activityType = arguments["type"] as? Int,
               let type = BKActivityType.init(rawValue: activityType),
               let tag = arguments["tag"] as? String {
                UpshotHelper.defaultHelper.showActivity(activityType: type, tag: tag)
            }
        case "showActivityWithId":
            
            if let activityId = call.arguments as? String {
                UpshotHelper.defaultHelper.showActivityWithId(activityId: activityId)
            }
        case "removeTutorial":
            UpshotHelper.defaultHelper.removeTutorial()
            
        case "getBadges":
            UpshotHelper.defaultHelper.getUserBadges()
            
        case "getInboxDetails":
            UpshotHelper.defaultHelper.fetchInbox()
            
        case "fetchRewards":
            UpshotHelper.defaultHelper.fetchRewards()
            
        case "fetchRewardHistory":
            if let arguments = call.arguments as? [String: Any],
               let type = arguments["type"] as? Int,
               let historyType = BKRewardHistoryType.init(rawValue: type),
               let programId = arguments["programId"] as? String {
                UpshotHelper.defaultHelper.fetchRewardHistory(programId: programId, historyType: historyType)
            }
        case "fetchRewardRules":
            if let programId = call.arguments as? String {
                UpshotHelper.defaultHelper.fetchRewardRules(programId: programId)
            }
        case "redeemRewards":
            
            if let arguments = call.arguments as? [String: Any],
               let programId = arguments["programId"] as? String,
               let redeemAmount = arguments["redeemAmount"] as? Int,
               let transactionValue = arguments["transactionValue"] as? Int,
               let tag = arguments["tag"] as? String {
                UpshotHelper.defaultHelper.redeemRewards(programId: programId, transactionValue: transactionValue, redeemAmount: redeemAmount, tag: tag)
            }
        case "disableUser":
            if let isDisable = call.arguments as? Bool {
                UpshotHelper.defaultHelper.disableUser(shouldDisable: isDisable)
            }
        case "dispatchInterval":
            if let interval = call.arguments as? Int {
                UpshotHelper.defaultHelper.dispatchInterval(interval: interval)
            }
        case "getNotifications":
            
            if let data = call.arguments as? [String: Any] {
                let loadMore = data["loadMore"] as? Bool ?? false
                let limit = data["limit"] as? Int ?? 10
                UpshotHelper.defaultHelper.getNotifications(loadMore: loadMore, limit: limit)
            }
            
        case "showInboxScreen":
            
            if let details = call.arguments as? [String: Any] {
                UpshotHelper.defaultHelper.showInboxScreen(options: details)    
            }
        case "getUnreadNotificationsCount":
            
            let limit = call.arguments as? Int ?? 10
            UpshotHelper.defaultHelper.getUnreadNotificationsCount(limit: limit)

        case "activityShown_Internal":
            if let details = call.arguments as? [String: Any] {                
                UpshotHelper.defaultHelper.activityShown_Internal(payload: details)    
            }
        case "activitySkiped_Internal":
            if let details = call.arguments as? [String: Any] {                
                UpshotHelper.defaultHelper.activitySkiped_Internal(payload: details)    
            }
        case "activityDismiss_Internal":
            if let details = call.arguments as? [String: Any] {
                UpshotHelper.defaultHelper.activityDismiss_Internal(payload: details)    
            }
        case "activityRedirection_Internal":
            if let details = call.arguments as? [String: Any] {
                UpshotHelper.defaultHelper.activityRedirection_Internal(payload: details)    
            }
        case "setTechnologyType":
            UpshotHelper.defaultHelper.setTechnologyType()
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
