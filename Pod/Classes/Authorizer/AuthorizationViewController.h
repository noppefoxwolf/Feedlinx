//
//  AuthorizationViewController.h
//  FDXOauth2Client
//
//  Created by Tomoya_Hirano on 7/16/27 H.
//  Copyright (c) 27 Heisei Tomoya_Hirano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDXOauth2.h"
#import "FDXAccount.h"

@class AuthorizationViewController;
@protocol AuthorizationViewControllerDelegate <NSObject>
- (void)authorizationPageController:(AuthorizationViewController *)controller
             didFinishUserAuthorize:(FDXAccount *)account;
@end

@interface AuthorizationViewController : UIViewController
@property (nonatomic,assign)id<AuthorizationViewControllerDelegate>delegate;
@end
