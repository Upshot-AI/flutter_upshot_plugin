import Flutter
import UIKit
import Upshot

public class SwiftFlutterUpshotPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel = FlutterMethodChannel(name: "flutter_upshot_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterUpshotPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
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
            let userDetails = UpshotHelper.defaultHelper.getUserDetails()
            result(userDetails)
            
        case "sendLogoutDetails":
            UpshotHelper.defaultHelper.sendLogoutDetails()
            
        case "sendDeviceToken":
            if let token = call.arguments as? String {
                UpshotHelper.defaultHelper.updateDeviceToken(token: token)
            }
            
        case "sendPushClickDetails":
            
            if let payload = call.arguments as? [String: Any] {
                UpshotHelper.defaultHelper.updatePushClickDetails(payload: payload)
            }
            
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
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
