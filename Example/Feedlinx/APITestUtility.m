//
//  APITestUtility.m
//  Feedlinx
//
//  Created by Tomoya_Hirano on 7/28/27 H.
//  Copyright (c) 27 Heisei hirano_tomoya. All rights reserved.
//

#import "APITestUtility.h"


@interface APITestUtility (){
    FeedlinxAPI*api;
    NSString*baseId;
}
@end
@implementation APITestUtility

- (instancetype)initWithAccount:(FDXAccount *)account{
    self = [super init];
    if (self) {
        api = [FeedlinxAPI feedryAPIWithAccount:account];
        baseId = account.account_id;
    }
    return self;
}

- (void)categories{
    //o
    [api getCategoriesWithSuccessBlock:^(NSArray *categories) {
        NSLog(@"%@",categories);
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    //o
    [api postCategoriesWithCategoryId:[FeedlinxUtility cateroryIdWithAccountId:baseId label:@"Sample2"]
                                label:@"sample_renamed"
                         SuccessBlock:^{
                             NSLog(@"200");
                         } errorBlock:^(NSError *error) {
                             NSLog(@"%@",error.localizedDescription);
                         }];
    //
    [api deleteCategoriesWithCategoryId:[FeedlinxUtility cateroryIdWithAccountId:baseId label:@"Sample1"]
                           SuccessBlock:^ {
                               NSLog(@"200");
                           }errorBlock:^(NSError *error) {
                               NSLog(@"%@",error.localizedDescription);
                           }];
}

- (void)OPML{
    //o
    [api getOPMLXMLWithSuccessBlock:^(NSString*xmlString) {
        NSLog(@"%@",xmlString);
    }errorBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    //o
    NSString*path = [[NSBundle mainBundle] pathForResource:@"sample1" ofType:@"xml"];
    [api postOPMLImportWithXMLFilePath:path
                          successBlock:^{
                              NSLog(@"ok");
                          } errorBlock:^(NSError *error) {
                              NSLog(@"%@",error.localizedDescription);
                          }];
}

- (void)exec{
    [self categories];
//    [self OPML];
    return;
#pragma mark - Entries
    //https://developer.feedly.com/v3/entries/
    /**Get the content of an entry*/
    [api getEntriesWithEntryId:@"" 
SuccessBlock:^(NSDictionary*result) {}
errorBlock:^(NSError *error) {}];
    
    /**Get the content for a dynamic list of entries*/
    
#pragma mark - Feeds
    //https://developer.feedly.com/v3/feeds/
    /**Get the metadata about a specific feed*/
    [api getFeedMetadataWithFeedId:@"" 
SuccessBlock:^(NSDictionary*responce) {}
errorBlock:^(NSError *error) {}];
    /**Get the metadata for a list of feeds*/
    
#pragma mark - Markers
    //https://developer.feedly.com/v3/markers/
    //実装検証済み
    /**Get the list of unread counts*/
    [api getMarkersCountWithAutorefresh:@"" 
newerThan:@"" 
streamId:@"" 
SuccessBlock:^(NSDictionary*markersCount) {}
errorBlock:^(NSError *error) {}];
    //実装検証済み
    /**Mark one or multiple articles as read*/
    [api postMarkArticlesAsReadWithEntryIds:@[] 
SuccessBlock:^ {}
errorBlock:^(NSError *error) {}];
    /**Keep one or multiple articles as unread*/
    [api postMarkArticlesAsUnReadWithEntryIds:@[] 
SuccessBlock:^ {}
errorBlock:^(NSError *error) {}];
    /**Mark a feed as read*/
    [api postMarkFeedsAsReadWithFeedIds:@[] 
lastReadEntryId:@"" 
SuccessBlock:^ {}
errorBlock:^(NSError *error) {}];
    /**Mark a category as read*/
    [api postMarkCategoriesAsReadWithCategoryIds:@[] 
lastReadEntryId:@"" 
SuccessBlock:^ {}
errorBlock:^(NSError *error) {}];
    /**Undo mark as read*/
    [api postUndoMarkAsReadWithType:@"" 
Ids:@[] 
SuccessBlock:^ {}
errorBlock:^(NSError *error) {}];
    /**Mark one or multiple articles as saved*/
    [api postMarkArticlesAsSaveWithEntryIds:@[] 
SuccessBlock:^{}
errorBlock:^(NSError *error) {}];
    /**Mark one or multiple articles as unsaved*/
    [api postMarkArticlesAsUnSaveWithEntryIds:@[] 
SuccessBlock:^{}
errorBlock:^(NSError *error) {}];
    /**Get the latest read operations (to sync local cache)*/
    [api getLatestReadWithNewerThan:@"" 
SuccessBlock:^(NSDictionary*result) {}
errorBlock:^(NSError *error) {}];
    /**Get the latest tagged entry ids*/
    [api getLatestTaggedEntryIdsWithNewerThan:@"" 
SuccessBlock:^(NSDictionary*result) {}
errorBlock:^(NSError *error) {}];
    
#pragma mark - Mixes
    //https://developer.feedly.com/v3/mixes/
    /**Get a mix of the most engaging content available in a stream*/
    [api getMixesContentWithStreamId:@"" count:@"" 
unreadOnly:false 
hours:@"" 
newerThan:@"" 
backfill:false 
locale:@"" 
successBlock:^(NSDictionary*result) {}
errorBlock:^(NSError *error) {}];
    

    
#pragma mark - Preferences
    //https://developer.feedly.com/v3/preferences/
    /**Get the preferences of the user*/
    [api getPreferencesWithSuccessBlock:^(NSDictionary*result) {}
errorBlock:^(NSError *error) {}];
    /**Update the preferences of the user*/
    [api postPreferencesWithPreference:@{}
successBlock:^ {}
errorBlock:^(NSError *error) {}];;
#pragma mark - Profile
    //https://developer.feedly.com/v3/profile/
    //実装検証済み
    /**Get the profile of the user*/
    [api getProfileWithSuccessBlock:^(NSDictionary*profile) {}
errorBlock:^(NSError *error) {}];
    /**Update the profile of the user*/
    [api postProfileWithEmail:@"" 
givenName:@"" 
familyName:@"" 
picture:@"" 
gender:false 
locale:@"" 
twitter:@"" 
facebook:@"" 
successBlock:^(NSDictionary*result) {}
errorBlock:^(NSError *error) {}];
    
#pragma mark - Search
    //https://developer.feedly.com/v3/search/
    /**Find feeds based on title, url or #topic*/
    [api getSearchFeedsWithQuery:@"" 
count:@"" 
locale:@"" 
SuccessBlock:^(NSDictionary *status) {}
errorBlock:^(NSError *error) {}];
    /**Search the content of a stream*/
    [api getSearchContentsWithStreamId:@"" 
query:@"" 
count:@"" 
newerThan:@"" 
continuation:@"" 
fields:@"" 
embedded:@"" 
engagement:@"" 
locale:@"" 
SuccessBlock:^(NSDictionary *status) {}
errorBlock:^(NSError *error) {}];
    
#pragma mark - Short URL
    //https://developer.feedly.com/v3/shorten/
    /**Create a shortened URL for an entry*/
    //検証中
    [api getShortURLWithEntryId:@"" 
SuccessBlock:^(NSDictionary*result) {}
errorBlock:^(NSError *error) {}];
    
#pragma mark - Streams
    //https://developer.feedly.com/v3/streams/
    //実装済み
    /**Get a list of entry ids for a specific stream*/
    [api getStreamIdsWithStreamId:@"" 
count:@"" 
ranked:@"" 
unreadOnly:false 
newerThan:@"" 
continuation:@"" 
SuccessBlock:^(NSDictionary*stream) {}
errorBlock:^(NSError *error) {}];
    //実装検証済み
    /**Get the content of a stream*/
    [api getStreamContentWithStreamId:@"" 
count:@"" 
ranked:@"" 
unreadOnly:false 
newerThan:@"" 
continuation:@"" 
SuccessBlock:^(NSDictionary*stream) {}
errorBlock:^(NSError *error) {}];
    
#pragma mark - Subscriptions
    //https://developer.feedly.com/v3/subscriptions/
    //実装検証済み
    /**Get the user’s subscriptions*/
    [api getSubscriptionsWithSuccessBlock:^(NSArray *result) {}
errorBlock:^(NSError *error) {}];
    /*
     * Subscribe to a feed
     * Update an existing subscription
     */
    [api postSubscriptionWithStatus:@{}
successBlock:^(NSArray *result) {}
errorBlock:^(NSError *error) {}];
    
    /**Update multiple subscriptions*/
    [api postSubscriptionsWithStatuses:@[] 
successBlock:^(NSArray *result) {}
errorBlock:^(NSError *error) {}];
    /**Unsubscribe from a feed*/
    [api deleteSubscriptionWithFeedId:@"" 
successBlock:^(NSArray *result) {}
errorBlock:^(NSError *error) {}];
    /**Unsubscribe from multiple feeds*/
    [api deleteSubscriptionWithFeedIds:@[] 
successBlock:^(NSArray *result) {}
errorBlock:^(NSError *error) {}];
    
#pragma mark - Tags
    //https://developer.feedly.com/v3/tags/
    /**Get the list of tags created by the user.*/
    [api getListOfTagsByUserWithSuccessBlock:^(NSArray *result) {}
errorBlock:^(NSError *error) {}];
    /**Tag an existing entry*/
    [api putTagExistingEntryWithEntryId:@"" 
SuccessBlock:^ {}
errorBlock:^(NSError *error) {}];
    
    /**Tag multiple entries*/
    [api putTagExistingEntryWithTagIds:@[] 
entryId:@""
SuccessBlock:^{}
errorBlock:^(NSError *error) {}];
    /**Change a tag label*/
    [api postChangeTagLabelWithTagId:@"" 
label:@"" 
SuccessBlock:^{}
errorBlock:^(NSError *error) {}];
    /**Untag multiple entries*/
    [api deleteUntagTagIds:@[] 
entryIds:@[] 
SuccessBlock:^{}
errorBlock:^(NSError *error) {}];
    
    /**Delete tags*/
    [api deleteTagsWithTagIds:@[] 
successBlock:^{}
errorBlock:^(NSError *error) {}];
}

@end
