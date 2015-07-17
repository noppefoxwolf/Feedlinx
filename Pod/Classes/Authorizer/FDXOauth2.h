//
//  FDXOauth2.h
//  FDXOauth2Client
//
//  Created by Tomoya_Hirano on 7/16/27 H.
//  Copyright (c) 27 Heisei Tomoya_Hirano. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FDXOauth2;
@protocol FDXOauth2Delegate <NSObject>
- (void)FDXOauth2Delegate:(FDXOauth2*)oauth response:(NSDictionary*)response;
@end

@interface FDXOauth2 : NSObject
- (id)initWithScope:(NSString*)scp clientId:(NSString *)cid clientSecret:(NSString*)csecret;
- (BOOL)authorized;
- (NSURL*)authorizationURL;
- (void)requestAccessTokenWithAuthorizationCode:(NSString*)code;
@property (nonatomic,assign)id<FDXOauth2Delegate>delegate;
@end
