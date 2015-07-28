//
//  APITestUtility.h
//  Feedlinx
//
//  Created by Tomoya_Hirano on 7/28/27 H.
//  Copyright (c) 27 Heisei hirano_tomoya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Feedlinx.h"
#import "FDXAccount.h"

@interface APITestUtility : NSObject
- (instancetype)initWithAccount:(FDXAccount*)account;
- (void)exec;
@end
