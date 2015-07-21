//
//  FeedlinxAPI.h
//  Feedlinx
//
//  Created by Tomoya_Hirano on 7/10/27 H.
//  Copyright (c) 27 Heisei Tomoya_Hirano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDXAccount.h"
//for Feedly Oauth2(sandbox)
//account type
static NSString * const kOauth2ClientAccountType = @"Feedly";
//clientId
static NSString * const kOauth2ClientClientId = @"sandbox";
//Client Secret
static NSString * const kOauth2ClientClientSecret = @"A4143F56J75FGQY7TAJM";
//Redirect Url
static NSString * const kOauth2ClientRedirectUrl = @"http://localhost";
//base url
static NSString * const kOauth2ClientBaseUrl = @"https://sandbox.feedly.com";
//static NSString * const kOauth2ClientBaseUrl = @"https://cloud.feedly.com";
//auth url
static NSString * const kOauth2ClientAuthUrl = @"/v3/auth/auth";
//token url
static NSString * const kOauth2ClientTokenUrl = @"/v3/auth/token";
//categories
static NSString * const kAPICategories = @"/v3/categories";
//markers/counts
static NSString * const kAPIMarkersCounts = @"/v3/markers/counts";
//markers
static NSString * const kAPIMarkers = @"/v3/markers";
///v3/opml
static NSString * const kAPIOPML = @"/v3/opml";
///v3/feeds/
static NSString * const kAPIFeeds = @"/v3/feeds";
///v3/streams/
static NSString * const kAPIStream = @"/v3/streams";
///v3/shorten/entries/
static NSString * const kAPIShortenEntries = @"/v3/shorten/entries";
///v3/entries/
static NSString * const kAPIEntries = @"/v3/entries";
///v3/profile
static NSString * const kAPIProfile = @"/v3/profile";
///v3/mixes/
static NSString * const kAPIMixes = @"/v3/mixes";
///v3/subscriptions
static NSString * const kAPISubscriptions = @"/v3/subscriptions";
//scope url
static NSString * const kOauth2ClientScopeUrl = @"https://cloud.feedly.com/subscriptions";
///v3/twitter/auth
static NSString * const kAPITwitterAuth = @"/v3/twitter/auth";

@interface FeedlinxAPI : NSObject
+ (instancetype)feedryAPIWithAccount:(FDXAccount*)account;

@property (nonatomic,readonly)FDXAccount*account;

#pragma mark - Authentication


#pragma mark - Categories
//https://developer.feedly.com/v3/categories/
//実装検証済み
/**Get the list of all categories*/
- (void)getCategoriesWithSuccessBlock:(void(^)(NSArray*categories))successBlock
                           errorBlock:(void(^)(NSError *error))errorBlock;
//実装検証済み
/**Change the label of an existing category*/
- (void)postCategoriesWithCategoryId:(NSString*)categoryId
                               label:(NSString*)label
                        SuccessBlock:(void(^)(NSArray*categories))successBlock
                          errorBlock:(void(^)(NSError *error))errorBlock;
//実装検証済み
/**Delete a category*/
- (void)deleteCategoriesWithCategoryId:(NSString*)categoryId
                          SuccessBlock:(void(^)())successBlock
                            errorBlock:(void(^)(NSError *error))errorBlock;

#pragma mark - Dropbox
//https://developer.feedly.com/v3/dropbox/
/**Link Dropbox account (Pro only)*/
/**Unlink Dropbox account*/
/**Add an article in Dropbox (Pro only)*/
#pragma mark - Entries
//https://developer.feedly.com/v3/entries/
/**Get the content of an entry*/
- (void)getEntriesWithEntryId:(NSString*)entryId
                 SuccessBlock:(void(^)(NSDictionary*result))successBlock
                   errorBlock:(void(^)(NSError *error))errorBlock;

/**Get the content for a dynamic list of entries*/
#pragma mark - Evernote
//https://developer.feedly.com/v3/evernote/
/**Link Evernote account*/
/**Unlink Evernote account*/
/**Get a list of Evernote notebooks (Pro only)*/
/**Save an article as a note (Pro only)*/
#pragma mark - Facebook
//https://developer.feedly.com/v3/facebook/
/**Link Facebook account*/
/**Unlink Facebook account*/
/**Get suggested feeds*/
#pragma mark - Feeds
//https://developer.feedly.com/v3/feeds/
/**Get the metadata about a specific feed*/
/**Get the metadata for a list of feeds*/
#pragma mark - Markers
//https://developer.feedly.com/v3/markers/
//実装検証済み
/**Get the list of unread counts*/
- (void)getMarkersCountWithAutorefresh:(BOOL)autoRefresh
                             newerThan:(NSString*)newerThan
                              streamId:(NSString*)streamId
                         SuccessBlock:(void(^)(NSDictionary*markersCount))successBlock
                           errorBlock:(void(^)(NSError *error))errorBlock;
//実装検証済み
/**Mark one or multiple articles as read*/
- (void)postMarkArticlesAsReadWithEntryIds:(NSArray*)entryIds
                              SuccessBlock:(void(^)())successBlock
                                errorBlock:(void(^)(NSError *error))errorBlock;
/**Keep one or multiple articles as unread*/
- (void)postMarkArticlesAsUnReadWithEntryIds:(NSArray*)entryIds
                                SuccessBlock:(void(^)())successBlock
                                  errorBlock:(void(^)(NSError *error))errorBlock;
/**Mark a feed as read*/
- (void)postMarkFeedsAsReadWithFeedIds:(NSArray*)feedIds
                       lastReadEntryId:(NSString*)lastReadEntryId
                           SuccessBlock:(void(^)())successBlock
                             errorBlock:(void(^)(NSError *error))errorBlock;
/**Mark a category as read*/
- (void)postMarkCategoriesAsReadWithCategoryIds:(NSArray*)categoryIds
                                lastReadEntryId:(NSString*)lastReadEntryId
                                   SuccessBlock:(void(^)())successBlock
                                     errorBlock:(void(^)(NSError *error))errorBlock;
/**Undo mark as read*/

/**Mark one or multiple articles as saved*/
/**Mark one or multiple articles as unsaved*/
/**Get the latest read operations (to sync local cache)*/
/**Get the latest tagged entry ids*/
#pragma mark - Microsoft
//https://developer.feedly.com/v3/microsoft/
/**Link Microsoft Account*/
/**Unlink Windows Live account*/
/**Retrieve the list of OneNote notebook sections (Pro only)*/
/**Add an article in OneNote (Pro only)*/
#pragma mark - Mixes
//https://developer.feedly.com/v3/mixes/
/**Get a mix of the most engaging content available in a stream*/
- (void)getMixesContentWithStreamId:(NSString*)streamId count:(NSString*)count//3to20
                         unreadOnly:(BOOL)unreadOnly
                              hours:(NSString*)hours
                          newerThan:(NSString*)newerThan
                           backfill:(BOOL)backfill
                             locale:(NSString*)locale
                       successBlock:(void(^)(NSDictionary*result))successBlock
                         errorBlock:(void(^)(NSError *error))errorBlock;

#pragma mark - OPML
//https://developer.feedly.com/v3/opml/
//実装検証済み
/**Export the user’s subscriptions as an OPML file*/
- (void)getOPMLXMLWithSuccessBlock:(void(^)(NSString*xmlString))successBlock
                        errorBlock:(void(^)(NSError *error))errorBlock;
//実装検証済み
/**Import an OPML*/
- (void)postOPMLImportWithXMLFilePath:(NSString *)path finishBlock:(void (^)())finish;

#pragma mark - Preferences
//https://developer.feedly.com/v3/preferences/
/**Get the preferences of the user*/

/**Update the preferences of the user*/

#pragma mark - Profile
//https://developer.feedly.com/v3/profile/
//実装検証済み
/**Get the profile of the user*/
- (void)getProfileWithSuccessBlock:(void(^)(NSDictionary*profile))successBlock
                        errorBlock:(void(^)(NSError *error))errorBlock;
/**Update the profile of the user*/
#pragma mark - Search
//https://developer.feedly.com/v3/search/
/**Find feeds based on title, url or #topic*/

/**Search the content of a stream*/

#pragma mark - Short URL
//https://developer.feedly.com/v3/shorten/
/**Create a shortened URL for an entry*/
//検証中
- (void)getShortURLWithEntryId:(NSString*)entryId
                  SuccessBlock:(void(^)(NSDictionary*result))successBlock
                    errorBlock:(void(^)(NSError *error))errorBlock;

#pragma mark - Streams
//https://developer.feedly.com/v3/streams/
//実装済み
/**Get a list of entry ids for a specific stream*/
- (void)getStreamIdsWithStreamId:(NSString*)streamId
                           count:(NSString*)count
                          ranked:(NSString*)ranked//newest of oldest
                      unreadOnly:(BOOL)unreadOnly
                       newerThan:(NSString*)newerThan
                    continuation:(NSString*)continuation
                    SuccessBlock:(void(^)(NSDictionary*stream))successBlock
                      errorBlock:(void(^)(NSError *error))errorBlock;
//実装検証済み
/**Get the content of a stream*/
- (void)getStreamContentWithStreamId:(NSString*)streamId
                               count:(NSString*)count
                              ranked:(NSString*)ranked//newest of oldest
                          unreadOnly:(BOOL)unreadOnly
                           newerThan:(NSString*)newerThan
                        continuation:(NSString*)continuation
                        SuccessBlock:(void(^)(NSDictionary*stream))successBlock
                          errorBlock:(void(^)(NSError *error))errorBlock;

#pragma mark - Subscriptions
//https://developer.feedly.com/v3/subscriptions/
//実装検証済み
/**Get the user’s subscriptions*/
- (void)getSubscriptionsWithSuccessBlock:(void(^)(NSArray *result))successBlock
                              errorBlock:(void(^)(NSError *error))errorBlock;
/**Subscribe to a feed*/


/**Update an existing subscription*/

/**Update multiple subscriptions*/

/**Unsubscribe from a feed*/

/**Unsubscribe from multiple feeds*/

#pragma mark - Tags
//https://developer.feedly.com/v3/tags/
/**Get the list of tags created by the user.*/

/**Tag an existing entry*/

/**Tag multiple entries*/

/**Change a tag label*/

/**Untag multiple entries*/

/**Delete tags*/

#pragma mark - Twitter
//https://developer.feedly.com/v3/twitter/
/**Link Twitter account*/
//非実装
//- (void)getLinktwitterAccountWithRedirectUri:(NSString*)redirectUri
//                                SuccessBlock:(void (^)(NSArray *))successBlock
//                                  errorBlock:(void (^)(NSError *))errorBlock;
/**Unlink Twitter account*/

/**Get suggested feeds*/

/**Get suggested feeds (alternate version)*/


#pragma mark - undocumented API

@end