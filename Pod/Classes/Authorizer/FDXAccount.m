//
//  FDXAccount.m
//  FDXOauth2Client
//
//  Created by Tomoya_Hirano on 7/16/27 H.
//  Copyright (c) 27 Heisei Tomoya_Hirano. All rights reserved.
//

#import "FDXAccount.h"

@interface FDXAccount()
@property NSDictionary*status;
@end

@implementation FDXAccount

- (instancetype)initWithStatus:(NSDictionary*)status{
    self = [super init];
    if (self) {
        self.status = status;
        self.access_token = self.status[@"access_token"];
        self.account_id = self.status[@"account_id"];
        self.plan = self.status[@"plan"];
        self.refresh_token = self.status[@"refresh_token"];
        self.token_type = self.status[@"token_type"];
    }
    return self;
}

+ (instancetype)accountWithStatus:(NSDictionary *)status{
    FDXAccount*account = [[FDXAccount alloc] initWithStatus:status];
    return account;
}

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self) {
        self.access_token = [decoder decodeObjectForKey:@"access_token"];
        self.account_id = [decoder decodeObjectForKey:@"account_id"];
        self.plan = [decoder decodeObjectForKey:@"plan"];
        self.refresh_token = [decoder decodeObjectForKey:@"refresh_token"];
        self.token_type = [decoder decodeObjectForKey:@"token_type"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.access_token forKey:@"access_token"];
    [encoder encodeObject:self.account_id forKey:@"account_id"];
    [encoder encodeObject:self.plan forKey:@"plan"];
    [encoder encodeObject:self.refresh_token forKey:@"refresh_token"];
    [encoder encodeObject:self.token_type forKey:@"token_type"];
}


@end
