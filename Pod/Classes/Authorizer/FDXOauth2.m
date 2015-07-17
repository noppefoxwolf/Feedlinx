//
//  FDXOauth2.m
//  FDXOauth2Client
//
//  Created by Tomoya_Hirano on 7/16/27 H.
//  Copyright (c) 27 Heisei Tomoya_Hirano. All rights reserved.
//

#import "FDXOauth2.h"
#import "FDXUtil.h"

@interface FDXOauth2 ()
@property NSString*scope;
@property NSString*clientId;
@property NSString*clientSecret;
@property NSString*accessToken;
@end

@implementation FDXOauth2

- (instancetype)initWithScope:(NSString *)scp clientId:(NSString *)cid clientSecret:(NSString *)csecret{
    self = [super init];
    if (self) {
        self.scope = scp;
        self.clientId = cid;
        self.clientSecret = csecret;
    }
    return self;
}

- (BOOL)authorized {
    return self.accessToken ? YES : NO;
}

- (NSURL*)authorizationURL{
    //https://developer.feedly.com/v3/auth/
    NSString*base = @"https://sandbox.feedly.com";
    NSString*api  = @"/v3/auth/auth";
    NSDictionary*params = @{@"response_type":@"code",
                            @"client_id":self.clientId,
                            @"redirect_uri":@"http://localhost",
                            @"scope":@"https://cloud.feedly.com/subscriptions"};
    NSMutableString*url = [NSMutableString string];
    [url appendString:base];
    [url appendString:api];
    [url appendString:@"?"];
    NSCharacterSet* chars = [NSCharacterSet alphanumericCharacterSet];
    for (NSString*key in params.allKeys) {
        NSString*param = [NSString stringWithFormat:@"%@=%@&",
                          key,
                          [params[key] stringByAddingPercentEncodingWithAllowedCharacters:chars]];
        [url appendString:param];
    }
    return [NSURL URLWithString:url];
}

- (void)requestAccessTokenWithAuthorizationCode:(NSString *)code{
    NSMutableString*url = [NSMutableString string];
    NSString*base = @"https://sandbox.feedly.com";
    NSString*api = @"/v3/auth/token";
    NSDictionary *params = @{@"client_id":self.clientId,
                            @"client_secret":self.clientSecret,
                            @"grant_type":@"authorization_code",
                            @"redirect_uri":@"http://localhost:8080",
                            @"code":code};
    [url appendString:base];
    [url appendString:api];
    NSError*error=nil;
    NSData*data=[NSJSONSerialization dataWithJSONObject:params options:2 error:&error];
    NSString*jsonstr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPMethod:@"POST"];
    NSLog(@"%@",jsonstr);
    [req setHTTPBody:[jsonstr dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSLog(@"responce");
                               if (data) {
                                   NSError*JSONError = nil;
                                   NSDictionary*result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&JSONError];
                                   if (JSONError) {
                                       return;
                                   }
                                   if ([[result allKeys] containsObject:@"access_token"]) {
                                       [self.delegate FDXOauth2Delegate:self
                                                               response:result];
                                   }
                               } else {
                               }
                           }];
    
}

@end
