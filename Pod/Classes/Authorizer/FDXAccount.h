//
//  FDXAccount.h
//  FDXOauth2Client
//
//  Created by Tomoya_Hirano on 7/16/27 H.
//  Copyright (c) 27 Heisei Tomoya_Hirano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDXAccount : NSObject<NSCoding>
+ (instancetype)accountWithStatus:(NSDictionary*)status;
@property NSString*access_token;
@property NSString*account_id;
@property NSString*plan;
@property NSString*refresh_token;
@property NSString*token_type;
@end
