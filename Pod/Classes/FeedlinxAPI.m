//
//  FeedlinxAPI.m
//  Feedlinx
//
//  Created by Tomoya_Hirano on 7/10/27 H.
//  Copyright (c) 27 Heisei Tomoya_Hirano. All rights reserved.
//

#import "FeedlinxAPI.h"

@interface FeedlinxAPI()
@end

@implementation FeedlinxAPI
@synthesize account = _account;

- (instancetype)initWithAccount:(FDXAccount*)account{
    self = [super init];
    if (self) {
        _account = account;
    }
    return self;
}

+ (NSString *)versionString {
    return @"0.0.2";
}

+ (instancetype)feedryAPIWithAccount:(FDXAccount *)account{
    FeedlinxAPI*feedly = [[FeedlinxAPI alloc] initWithAccount:account];
    return feedly;
}

- (void)getRequestWithUrl:(NSString*)url
                   params:(NSDictionary*)params
                  successBlock:(void(^)(NSURLResponse *response,NSData*data))success
                  failuerBlock:(void(^)(NSError*error))failure{
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
    NSMutableArray*queryItems = [NSMutableArray array];
    for (NSString*key in params.allKeys) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:params[key]]];
    }
    components.queryItems = queryItems;

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    [request addValue:_account.access_token forHTTPHeaderField:@"Authorization"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (data) {
                                   success(response,data);
                               }else{
                                   failure(error);
                               }
                               
                           }];
}

- (void)postRequestWithUrl:(NSString*)url
                   params:(NSDictionary*)params
             successBlock:(void(^)(NSURLResponse *response,NSData*data))success
             failuerBlock:(void(^)(NSError*error))failure{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request addValue:_account.access_token forHTTPHeaderField:@"Authorization"];
    NSError *error = nil;
    NSData  *data = [NSJSONSerialization dataWithJSONObject:params options:2 error:&error];
    NSString *content = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [request setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (data) {
                                   success(response,data);
                               }else{
                                   failure(error);
                               }
                           }];
}

- (void)deleteRequestWithUrl:(NSString*)url
                    params:(NSDictionary*)params
              successBlock:(void(^)(NSURLResponse *response,NSData*data))success
              failuerBlock:(void(^)(NSError*error))failure{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [req setHTTPMethod:@"DELETE"];
    [req addValue:_account.access_token forHTTPHeaderField:@"Authorization"];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (data) {
                                   success(response,data);
                               }else{
                                   failure(error);
                               }
                           }];
}
#pragma mark - API

#pragma mark - Authentication


#pragma mark - Categories
//https://developer.feedly.com/v3/categories/
/**Get the list of all categories*/
- (void)getCategoriesWithSuccessBlock:(void(^)(NSArray*categories))successBlock
                           errorBlock:(void(^)(NSError *error))errorBlock{
    NSString*url = [NSString stringWithFormat:@"%@%@",kOauth2ClientBaseUrl,kAPICategories];
    [self getRequestWithUrl:url
                     params:nil
               successBlock:^(NSURLResponse *response,NSData *data) {
                   NSError*error = nil;
                   NSArray*categories = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:0
                                                                            error:&error];
                   if (error) {
                       errorBlock(error);
                   }else{
                       successBlock(categories);
                   }
               } failuerBlock:^(NSError*error) {
                   errorBlock(error);
               }];
}
/**Change the label of an existing category*/
- (void)postCategoriesWithCategoryId:(NSString *)categoryId label:(NSString *)label SuccessBlock:(void (^)(NSArray *))successBlock errorBlock:(void (^)(NSError *))errorBlock{
    NSString* encodeString = [categoryId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    NSString*url = [NSString stringWithFormat:@"%@%@/%@",kOauth2ClientBaseUrl,kAPICategories,encodeString];
    [self postRequestWithUrl:url
                      params:@{@"label":label}
               successBlock:^(NSURLResponse *response,NSData *data) {
                   NSError*error = nil;
                   NSArray*categories = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
                   if (error) {
                       errorBlock(error);
                   }else{
                       successBlock(categories);
                   }
               } failuerBlock:^(NSError*error) {
                   errorBlock(error);
               }];
}

/**Delete a category*/
- (void)deleteCategoriesWithCategoryId:(NSString *)categoryId
                          SuccessBlock:(void (^)())successBlock
                            errorBlock:(void (^)(NSError *error))errorBlock{
    NSString* encodeString = [categoryId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    NSString*url = [NSString stringWithFormat:@"%@%@/%@",kOauth2ClientBaseUrl,kAPICategories,encodeString];
    [self deleteRequestWithUrl:url
                        params:nil
                  successBlock:^(NSURLResponse *response,NSData *data) {
                      successBlock();
                  } failuerBlock:^(NSError *error) {
                      errorBlock(error);
                  }];
}

#pragma mark - Dropbox
//https://developer.feedly.com/v3/dropbox/
/**Link Dropbox account (Pro only)*/
/**Unlink Dropbox account*/
/**Add an article in Dropbox (Pro only)*/
#pragma mark - Entries
//https://developer.feedly.com/v3/entries/
/**Get the content of an entry*/
- (void)getEntriesWithEntryId:(NSString *)entryId
                 SuccessBlock:(void (^)(NSDictionary *))successBlock
                   errorBlock:(void (^)(NSError *))errorBlock{
    NSString* encodeString = [entryId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    NSString*url = [NSString stringWithFormat:@"%@%@/%@",kOauth2ClientBaseUrl,kAPIEntries,encodeString];
    NSLog(@"%@",url);
    [self getRequestWithUrl:url
                     params:nil
               successBlock:^(NSURLResponse *response,NSData *data) {
                   NSError*error = nil;
                   NSDictionary*result = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:0
                                                                           error:&error];
                   if (error) {
                       errorBlock(error);
                   }else{
                       successBlock(result);
                   }
               } failuerBlock:^(NSError*error) {
                   errorBlock(error);
               }];
}
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
/**Get the list of unread counts*/
- (void)getMarkersCountWithAutorefresh:(BOOL)autoRefresh
                             newerThan:(NSString *)newerThan
                              streamId:(NSString *)streamId
                          SuccessBlock:(void (^)(NSDictionary*markersCount))successBlock
                            errorBlock:(void (^)(NSError *error))errorBlock{
    NSString*url = [NSString stringWithFormat:@"%@%@",kOauth2ClientBaseUrl,kAPIMarkersCounts];
    NSMutableDictionary*params = [NSMutableDictionary dictionary];
    [params setObject:autoRefresh?@"true":@"false" forKey:@"autoRefresh"];
    if (newerThan) [params setObject:newerThan forKey:@"newerThan"];
    if (streamId) [params setObject:streamId forKey:@"streamId"];
    
    [self getRequestWithUrl:url
                     params:params
               successBlock:^(NSURLResponse *response,NSData *data) {
                   NSError*error = nil;
                   NSDictionary*markersCount = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:&error];
                   if (error) {
                       errorBlock(error);
                   }else{
                       successBlock(markersCount);
                   }
               } failuerBlock:^(NSError*error) {
                   errorBlock(error);
               }];
}
/**Mark one or multiple articles as read*/
- (void)postMarkArticlesAsReadWithEntryIds:(NSArray *)entryIds
                              SuccessBlock:(void (^)())successBlock
                                errorBlock:(void (^)(NSError *))errorBlock{
    NSString*url = [NSString stringWithFormat:@"%@%@",kOauth2ClientBaseUrl,kAPIMarkers];
    NSMutableDictionary*params = [NSMutableDictionary dictionary];
    [params setObject:@"markAsRead" forKey:@"action"];
    [params setObject:@"entries" forKey:@"type"];
    [params setObject:entryIds forKey:@"entryIds"];
    [self postRequestWithUrl:url
                     params:params
               successBlock:^(NSURLResponse *response,NSData *data) {
                   successBlock();
               } failuerBlock:^(NSError*error) {
                   errorBlock(error);
               }];
}

/**Keep one or multiple articles as unread*/
- (void)postMarkArticlesAsUnReadWithEntryIds:(NSArray *)entryIds
                              SuccessBlock:(void (^)())successBlock
                                errorBlock:(void (^)(NSError *))errorBlock{
    NSString*url = [NSString stringWithFormat:@"%@%@",kOauth2ClientBaseUrl,kAPIMarkers];
    NSMutableDictionary*params = [NSMutableDictionary dictionary];
    [params setObject:@"keepUnread" forKey:@"action"];
    [params setObject:@"entries" forKey:@"type"];
    [params setObject:entryIds forKey:@"entryIds"];
    [self postRequestWithUrl:url
                      params:params
                successBlock:^(NSURLResponse *response,NSData *data) {
                    successBlock();
                } failuerBlock:^(NSError*error) {
                    errorBlock(error);
                }];
}
/**Mark a feed as read*/
- (void)postMarkFeedsAsReadWithFeedIds:(NSArray *)feedIds
                       lastReadEntryId:(NSString*)lastReadEntryId
                           SuccessBlock:(void (^)())successBlock
                             errorBlock:(void (^)(NSError *))errorBlock{
    NSString*url = [NSString stringWithFormat:@"%@%@",kOauth2ClientBaseUrl,kAPIMarkers];
    NSMutableDictionary*params = [NSMutableDictionary dictionary];
    [params setObject:@"markAsRead" forKey:@"action"];
    [params setObject:@"feeds" forKey:@"type"];
    if (lastReadEntryId) [params setObject:lastReadEntryId forKey:@"lastReadEntryId"];
    [params setObject:feedIds forKey:@"feedIds"];
    
    [self postRequestWithUrl:url
                      params:params
                successBlock:^(NSURLResponse *response,NSData *data) {
                    successBlock();
                } failuerBlock:^(NSError*error) {
                    errorBlock(error);
                }];
}
/**Mark a category as read*/
- (void)postMarkCategoriesAsReadWithCategoryIds:(NSArray *)categoryIds
                                lastReadEntryId:(NSString *)lastReadEntryId
                                   SuccessBlock:(void (^)())successBlock
                                     errorBlock:(void (^)(NSError *))errorBlock{
    NSString*url = [NSString stringWithFormat:@"%@%@",kOauth2ClientBaseUrl,kAPIMarkers];
    NSMutableDictionary*params = [NSMutableDictionary dictionary];
    [params setObject:@"markAsRead" forKey:@"action"];
    [params setObject:@"categories" forKey:@"type"];
    if (lastReadEntryId) [params setObject:lastReadEntryId forKey:@"lastReadEntryId"];
    [params setObject:categoryIds forKey:@"categoryIds"];
    
    [self postRequestWithUrl:url
                      params:params
                successBlock:^(NSURLResponse *response,NSData *data) {
                    successBlock();
                } failuerBlock:^(NSError*error) {
                    errorBlock(error);
                }];
}
/**Undo mark as read*/
- (void)postUndoMarkAsReadWithType:(NSString *)type
                               Ids:(NSArray *)ids
                      SuccessBlock:(void (^)())successBlock
                        errorBlock:(void (^)(NSError *))errorBlock{
    NSString*url = [NSString stringWithFormat:@"%@%@",kOauth2ClientBaseUrl,kAPIMarkers];
    NSMutableDictionary*params = [NSMutableDictionary dictionary];
    [params setObject:@"undoMarkAsRead" forKey:@"action"];
    [params setObject:type forKey:@"type"];
    NSString*idsKey = nil;
    if ([type hasPrefix:@"categories"]) {
        idsKey = @"categoryIds";
    }else if ([type hasPrefix:@"feeds"]){
        idsKey = @"feedIds";
    }
    if (idsKey) {
        [params setObject:ids forKey:idsKey];
    }
    [self postRequestWithUrl:url
                      params:params
                successBlock:^(NSURLResponse *response,NSData *data) {
                    successBlock();
                } failuerBlock:^(NSError*error) {
                    errorBlock(error);
                }];

}

/**Mark one or multiple articles as saved*/
- (void)postMarkArticlesAsSaveWithEntryIds:(NSArray *)entryIds
                              SuccessBlock:(void (^)())successBlock
                                errorBlock:(void (^)(NSError *))errorBlock{
    NSString*url = [NSString stringWithFormat:@"%@%@",kOauth2ClientBaseUrl,kAPIMarkers];
    NSMutableDictionary*params = [NSMutableDictionary dictionary];
    [params setObject:@"markAsSaved" forKey:@"action"];
    [params setObject:@"entries" forKey:@"type"];
    [params setObject:entryIds forKey:@"entryIds"];
    [self postRequestWithUrl:url
                      params:params
                successBlock:^(NSURLResponse *response,NSData *data) {
                    successBlock();
                } failuerBlock:^(NSError*error) {
                    errorBlock(error);
                }];
}
/**Mark one or multiple articles as unsaved*/
- (void)postMarkArticlesAsUnSaveWithEntryIds:(NSArray *)entryIds
                              SuccessBlock:(void (^)())successBlock
                                errorBlock:(void (^)(NSError *))errorBlock{
    NSString*url = [NSString stringWithFormat:@"%@%@",kOauth2ClientBaseUrl,kAPIMarkers];
    NSMutableDictionary*params = [NSMutableDictionary dictionary];
    [params setObject:@"markAsSaved" forKey:@"action"];
    [params setObject:@"entries" forKey:@"type"];
    [params setObject:entryIds forKey:@"entryIds"];
    [self postRequestWithUrl:url
                      params:params
                successBlock:^(NSURLResponse *response,NSData *data) {
                    successBlock();
                } failuerBlock:^(NSError*error) {
                    errorBlock(error);
                }];
}
/**Get the latest read operations (to sync local cache)*/
- (void)getLatestReadWithNewerThan:(NSString *)newerThan
                      SuccessBlock:(void (^)(NSDictionary*result))successBlock
                        errorBlock:(void (^)(NSError *))errorBlock{
    NSString*url = [NSString stringWithFormat:@"%@%@",kOauth2ClientBaseUrl,kAPIMarkers];
    NSMutableDictionary*params = [NSMutableDictionary dictionary];
    [params setObject:newerThan forKey:@"newerThan"];
    [self getRequestWithUrl:url
                     params:params
               successBlock:^(NSURLResponse *response, NSData *data) {
                   NSError*error = nil;
                   NSDictionary*result = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:0
                                                                           error:&error];
                   if (error) {
                       errorBlock(error);
                   }else{
                       successBlock(result);
                   }
               } failuerBlock:^(NSError *error) {
                   errorBlock(error);
               }];
}
/**Get the latest tagged entry ids*/
- (void)getLatestTaggedEntryIdsWithNewerThan:(NSString *)newerThan
                                SuccessBlock:(void (^)(NSDictionary*result))successBlock
                                  errorBlock:(void (^)(NSError *))errorBlock{
    NSString*url = [NSString stringWithFormat:@"%@%@",kOauth2ClientBaseUrl,kAPIMarkersTags];
    NSMutableDictionary*params = [NSMutableDictionary dictionary];
    [params setObject:newerThan forKey:@"newerThan"];
    [self getRequestWithUrl:url
                     params:params
               successBlock:^(NSURLResponse *response, NSData *data) {
                   NSError*error = nil;
                   NSDictionary*result = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:0
                                                                           error:&error];
                   if (error) {
                       errorBlock(error);
                   }else{
                       successBlock(result);
                   }
               } failuerBlock:^(NSError *error) {
                   errorBlock(error);
               }];
}


#pragma mark - Microsoft
//https://developer.feedly.com/v3/microsoft/
/**Link Microsoft Account*/
/**Unlink Windows Live account*/
/**Retrieve the list of OneNote notebook sections (Pro only)*/
/**Add an article in OneNote (Pro only)*/
#pragma mark - Mixes
//https://developer.feedly.com/v3/mixes/
/**Get a mix of the most engaging content available in a stream*/
- (void)getMixesContentWithStreamId:(NSString *)streamId
                              count:(NSString *)count
                         unreadOnly:(BOOL)unreadOnly
                              hours:(NSString *)hours
                          newerThan:(NSString *)newerThan
                           backfill:(BOOL)backfill
                             locale:(NSString *)locale
                       successBlock:(void (^)(NSDictionary *))successBlock
                         errorBlock:(void (^)(NSError *))errorBlock{
    NSString* encodeString = [streamId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    NSString*url = [NSString stringWithFormat:@"%@%@/%@/contents",kOauth2ClientBaseUrl,kAPIMixes,encodeString];
    NSMutableDictionary*params = [NSMutableDictionary dictionary];
    if (count) [params setObject:count forKey:@"count"];
    [params setObject:unreadOnly?@"true":@"false" forKey:@"unreadOnly"];
    if (hours) [params setObject:hours forKey:@"hours"];
    if (newerThan) [params setObject:newerThan forKey:@"newerThan"];
    [params setObject:backfill?@"true":@"false" forKey:@"backfill"];
    if (locale) [params setObject:locale forKey:@"locale"];
    
    [self getRequestWithUrl:url
                     params:params
               successBlock:^(NSURLResponse *response,NSData *data) {
                   NSError*error = nil;
                   NSDictionary*result = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:0
                                                                           error:&error];
                   if (error) {
                       errorBlock(error);
                   }else{
                       successBlock(result);
                   }
               } failuerBlock:^(NSError*error) {
                   errorBlock(error);
               }];
}
#pragma mark - OPML
//https://developer.feedly.com/v3/opml/
/**Export the user’s subscriptions as an OPML file*/
- (void)getOPMLXMLWithSuccessBlock:(void (^)(NSString *))successBlock
                        errorBlock:(void (^)(NSError *))errorBlock{
    NSString*url = [NSString stringWithFormat:@"%@%@",kOauth2ClientBaseUrl,kAPIOPML];
    [self getRequestWithUrl:url
                     params:nil
               successBlock:^(NSURLResponse *response,NSData *data) {
                   NSString*xmlString = [[NSString alloc] initWithData:data
                                                              encoding:NSUTF8StringEncoding];
                   successBlock(xmlString);
               } failuerBlock:^(NSError*error) {
                   errorBlock(error);
               }];
}
/**Import an OPML*/
- (void)postOPMLImportWithXMLFilePath:(NSString *)path finishBlock:(void (^)())finish{
    NSData *sampleData = [NSData dataWithContentsOfFile:path];
    //送信先URL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOauth2ClientBaseUrl,kAPIOPML]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    //multipart/form-dataのバウンダリ文字列生成
    CFUUIDRef uuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, uuid);
    CFRelease(uuid);
    NSString *boundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
    
    //アップロードする際のパラメーター名
    NSString *parameter = @"opml";
    
    //アップロードするファイルの名前
    NSString *fileName = [[path componentsSeparatedByString:@"/"] lastObject];
    
    //アップロードするファイルの種類
    NSString *contentType = @"text/xml";
    
    NSMutableData *postBody = [NSMutableData data];
    
    //HTTPBody
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",parameter,fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", contentType] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:sampleData];
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //リクエストヘッダー
    NSString *header = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:_account.access_token forHTTPHeaderField:@"Authorization"];
    [request addValue:header forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postBody];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               finish();
                           }];
}

#pragma mark - Preferences
//https://developer.feedly.com/v3/preferences/
/**Get the preferences of the user*/

/**Update the preferences of the user*/

#pragma mark - Profile
//https://developer.feedly.com/v3/profile/
/**Get the profile of the user*/
- (void)getProfileWithSuccessBlock:(void(^)(NSDictionary*profile))successBlock
                        errorBlock:(void(^)(NSError *error))errorBlock{
    NSString*url = [NSString stringWithFormat:@"%@%@",kOauth2ClientBaseUrl,kAPIProfile];
    [self getRequestWithUrl:url
                     params:nil
               successBlock:^(NSURLResponse *response,NSData *data) {
                   NSError*error = nil;
                   NSDictionary*profile = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:0
                                                                            error:&error];
                   if (error) {
                       errorBlock(error);
                   }else{
                       successBlock(profile);
                   }
               } failuerBlock:^(NSError*error) {
                   errorBlock(error);
               }];
}
/**Update the profile of the user*/

#pragma mark - Search
//https://developer.feedly.com/v3/search/
/**Find feeds based on title, url or #topic*/

/**Search the content of a stream*/

#pragma mark - Short URL
//https://developer.feedly.com/v3/shorten/
/**Create a shortened URL for an entry*/
- (void)getShortURLWithEntryId:(NSString *)entryId
                  SuccessBlock:(void (^)(NSDictionary *))successBlock
                    errorBlock:(void (^)(NSError *))errorBlock{
    NSString* encodeString = [entryId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    NSString*url = [NSString stringWithFormat:@"%@%@/%@",kOauth2ClientBaseUrl,kAPIShortenEntries,encodeString];
    [self getRequestWithUrl:url
                     params:nil
               successBlock:^(NSURLResponse *response,NSData *data) {
                   NSError*error = nil;
                   NSDictionary*result = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:0
                                                                           error:&error];
                   if (error) {
                       errorBlock(error);
                   }else{
                       successBlock(result);
                   }
               } failuerBlock:^(NSError*error) {
                   errorBlock(error);
               }];
}


#pragma mark - Streams
//https://developer.feedly.com/v3/streams/
/**Get a list of entry ids for a specific stream*/
- (void)getStreamIdsWithStreamId:(NSString *)streamId
                           count:(NSString *)count
                          ranked:(NSString *)ranked
                      unreadOnly:(BOOL)unreadOnly
                       newerThan:(NSString *)newerThan
                    continuation:(NSString *)continuation
                    SuccessBlock:(void (^)(NSDictionary *))successBlock
                      errorBlock:(void (^)(NSError *))errorBlock{
    NSString* encodeString = [streamId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    NSString*url = [NSString stringWithFormat:@"%@%@/%@/ids",kOauth2ClientBaseUrl,kAPIStream,encodeString];
    NSMutableDictionary*params = [NSMutableDictionary dictionary];
    if (count) [params setObject:count forKey:@"count"];
    if (ranked) [params setObject:ranked forKey:@"ranked"];
    [params setObject:unreadOnly?@"true":@"false" forKey:@"unreadOnly"];
    if (newerThan) [params setObject:newerThan forKey:@"newerThan"];
    if (continuation) [params setObject:continuation forKey:@"continuation"];
    [self getRequestWithUrl:url
                     params:params
               successBlock:^(NSURLResponse *response,NSData *data) {
                   NSError*error = nil;
                   NSDictionary*result = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:0
                                                                            error:&error];
                   if (error) {
                       errorBlock(error);
                   }else{
                       successBlock(result);
                   }
               } failuerBlock:^(NSError*error) {
                   errorBlock(error);
               }];
}

/**Get the content of a stream*/
- (void)getStreamContentWithStreamId:(NSString *)streamId
                               count:(NSString *)count
                              ranked:(NSString *)ranked
                          unreadOnly:(BOOL)unreadOnly
                           newerThan:(NSString *)newerThan
                        continuation:(NSString *)continuation
                        SuccessBlock:(void (^)(NSDictionary *))successBlock
                          errorBlock:(void (^)(NSError *))errorBlock{
    
    NSString* encodeString = [streamId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    NSString*url = [NSString stringWithFormat:@"%@%@/%@/contents",kOauth2ClientBaseUrl,kAPIStream,encodeString];
    NSMutableDictionary*params = [NSMutableDictionary dictionary];
    if (count) [params setObject:count forKey:@"count"];
    if (ranked) [params setObject:ranked forKey:@"ranked"];
    [params setObject:unreadOnly?@"true":@"false" forKey:@"unreadOnly"];
    if (newerThan) [params setObject:newerThan forKey:@"newerThan"];
    if (continuation) [params setObject:continuation forKey:@"continuation"];
    [self getRequestWithUrl:url
                     params:params
               successBlock:^(NSURLResponse *response,NSData *data) {
                   NSError*error = nil;
                   NSDictionary*profile = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:0
                                                                            error:&error];
                   if (error) {
                       errorBlock(error);
                   }else{
                       successBlock(profile);
                   }
               } failuerBlock:^(NSError*error) {
                   errorBlock(error);
               }];
}

#pragma mark - Subscriptions
//https://developer.feedly.com/v3/subscriptions/
/**Get the user’s subscriptions*/
- (void)getSubscriptionsWithSuccessBlock:(void (^)(NSArray *))successBlock
                              errorBlock:(void (^)(NSError *))errorBlock{
    NSString*url = [NSString stringWithFormat:@"%@%@",kOauth2ClientBaseUrl,kAPISubscriptions];
    [self getRequestWithUrl:url
                     params:nil
               successBlock:^(NSURLResponse *response,NSData *data) {
                   NSError*error = nil;
                   NSArray*res = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&error];
                   if (error) {
                       errorBlock(error);
                   }else{
                       successBlock(res);
                   }
               } failuerBlock:^(NSError*error) {
                   errorBlock(error);
               }];
}

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
//                                  errorBlock:(void (^)(NSError *))errorBlock{
//    NSString*url = [NSString stringWithFormat:@"%@%@",kOauth2ClientBaseUrl,kAPITwitterAuth];
//    [self getRequestWithUrl:url
//                     params:@{@"redirectUri":redirectUri}
//               successBlock:^(NSURLResponse *response,NSData *data) {
//                   NSLog(@"%@",response.URL.absoluteString);
//                   if ([(NSHTTPURLResponse*)response statusCode]!=200) {
//                   }else{
//                   }
//               } failuerBlock:^(NSError*error) {
//               }];
//}
/**Unlink Twitter account*/

/**Get suggested feeds*/

/**Get suggested feeds (alternate version)*/


#pragma mark - undocumented API

@end
