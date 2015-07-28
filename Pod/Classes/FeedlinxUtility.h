//
//  FeedlinxUtility.h
//  Pods
//
//  Created by Tomoya_Hirano on 7/28/27 H.
//
//

#import <Foundation/Foundation.h>

@interface FeedlinxUtility : NSObject

//Resource Ids
+ (NSString*)cateroryIdWithAccountId:(NSString*)accountId label:(NSString*)label;
+ (NSString*)cateroryIdGlobalMustWithAccountId:(NSString*)accountId;
+ (NSString*)cateroryIdGlobalAllWithAccountId:(NSString*)accountId;
+ (NSString*)cateroryIdGlobalUncategorizedWithAccountId:(NSString*)accountId;

+ (NSString*)feedIdWithUrl:(NSString*)url;

+ (NSString*)tagIdWithAccountId:(NSString*)accountId label:(NSString*)label;
+ (NSString*)tagIdGlobalReadWithAccountId:(NSString*)accountId;
+ (NSString*)tagIdGlobalSavedWithAccountId:(NSString*)accountId;

@end
