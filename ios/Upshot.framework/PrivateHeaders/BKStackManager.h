//
//  BKStackManager.h
//  BrandKinesis
//
//  Created by [x]cube LABS on 10/04/15.
//  Copyright (c) 2015 [x]cube LABS. All rights reserved.
//




#import <Foundation/Foundation.h>
#import "BKAdsView.h"

@interface BKStackManager : NSObject


+ (BKStackManager *)sharedManager;

- (void)insertIntoAdsStackForView:(BKAdsView *)promotionView
                           andTag:(NSString *)tag;

- (NSError *)insertIntoAdsStackForFullScreenTag:(NSString *)tag;

- (void)removeViewForTag:(NSString *)tag
                    type:(BKActivityType)activityType;

- (void)clearStackedAdsWithType:(BKActivityType)activityType;

- (void)replaceCurrentTag:(NSString *)mCurrentTag
             withGivenTag:(NSString *)givenTag
          forActivityType:(BKActivityType)acitivtyType;

- (void)insertAdunit:(BKAdUnitInfo *)adUnit
             forView:(BKAdsView *)view;

- (void)removeViewForTempStack:(BKAdsView *)adsView;

// Simple Stack
- (BKAdsView *)getPromotionsViewFortag:(NSString *)adTag
                               andType:(BKActivityType)type;

// Compound Stack
- (BKAdsView *)fetchAdViewForTag:(NSString *)adTag
                         andType:(BKActivityType)activityType;

- (BOOL)isKeyAvailabelInAdsStack:(NSString *)key;

- (NSString *)getModifiedTagForType:(BKActivityType)activityType
                          andForTag:(NSString *)tag;

/*!
 @brief  This will insert all activity ids into stack this is used to manage activities like Survey, Rating, Opinion Poll, ids, etc
 
 @param activityId activityId to insert
 */
- (void)insertActivityIds:(NSString *)activityId;


- (NSArray *)getDownloadRequestedStackForActivityId:(NSString *)activityID;

/*!
 @brief Stores all the activity ids requested by the developer and checks if the activity bundle is downloaded or not, if the activity is downloading or completed downloading it will send a delegate once the download is completed
 
 @param activityId activityId
 */
- (void)insertRequestedActivitiy:(NSString *)activityId forTag:(NSString *)tag;

/*!
 @brief remove once the activity is downloaded or a call back is being hit
 
 @param activityId activityId
 */
- (void)removeDownloadActivityStackObject:(NSString *)activityId;


/*!
 @brief  This will clear all activity id in that stack
 */
- (void)clearActivityIdStack;


- (NSArray *)getDownloadActivityStack;

/*!
 @brief  This will fetch all the activity ids saved in the stack
 
 @return Activity ids
 */
- (NSArray *)getActivityIds;


- (NSArray *)getActivityPresentedStack;

- (NSArray *)getBadgesStack;

- (void)setBadgeStack:(NSString *)activityId;

- (void)removeActivityFromPresentedStackWithID:(NSString *)activityId;

- (void)removeBadgesStackWithId:(NSString *)activityId;

- (void)addActivityToPresentedStackWithID:(NSString *)activityId;

- (NSSet *)serverMessageIds;

- (void)insertServerMessageId:(NSString *)messageId;

- (void)deleteServerMessageId:(NSString *)messageId;

@end
