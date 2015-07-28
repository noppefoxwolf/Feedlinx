//
//  FeedlinxUtility.m
//  Pods
//
//  Created by Tomoya_Hirano on 7/28/27 H.
//
//

#import "FeedlinxUtility.h"

@implementation FeedlinxUtility
+ (NSString*)cateroryIdWithAccountId:(NSString *)accountId label:(NSString *)label{
    NSString*format = [NSString stringWithFormat:@"user/%@/category/%@",accountId,label];
    return format;
}

+ (NSString*)feedIdWithUrl:(NSString *)url{
    NSString*format = [NSString stringWithFormat:@"feed/%@",url];
    return format;
}

+ (NSString*)tagIdWithAccountId:(NSString *)accountId label:(NSString *)label{
    NSString*format = [NSString stringWithFormat:@"user/%@/tag/%@",accountId,label];
    return format;
}

+ (NSString*)cateroryIdGlobalMustWithAccountId:(NSString*)accountId{
    return [self cateroryIdWithAccountId:accountId label:@"global.must"];
}
+ (NSString*)cateroryIdGlobalAllWithAccountId:(NSString*)accountId{
    return [self cateroryIdWithAccountId:accountId label:@"global.all"];
}
+ (NSString*)cateroryIdGlobalUncategorizedWithAccountId:(NSString*)accountId{
    return [self cateroryIdWithAccountId:accountId label:@"global.uncategorized"];
}

+ (NSString*)tagIdGlobalReadWithAccountId:(NSString*)accountId{
    return [self tagIdWithAccountId:accountId label:@"global.read"];
}
+ (NSString*)tagIdGlobalSavedWithAccountId:(NSString*)accountId{
    return [self tagIdWithAccountId:accountId label:@"global.saved"];
}

@end
