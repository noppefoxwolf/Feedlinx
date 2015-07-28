//
//  FDXViewController.m
//  Feedlinx
//
//  Created by hirano_tomoya on 07/17/2015.
//  Copyright (c) 2015 hirano_tomoya. All rights reserved.
//

#import "FDXViewController.h"
#import "Feedlinx.h"
#import "FDXAccount.h"
#import "AuthorizationViewController.h"
#import "APITestUtility.h"

@interface FDXViewController ()<AuthorizationViewControllerDelegate>

@end

@implementation FDXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSUserDefaults*df = [NSUserDefaults standardUserDefaults];
    FDXAccount*account = [NSKeyedUnarchiver unarchiveObjectWithData:[df objectForKey:@"account"]];
    if(account) {// 一度はOAuth認証を通した場合
//        [self testAPI:account];
        [[[APITestUtility alloc] initWithAccount:account] exec];
    } else {// 一度もOAuth認証を通っていない場合
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            AuthorizationViewController*vc = [[AuthorizationViewController alloc] initWithScope:@"https://sandbox.feedly.com"
                                                                                       clientId:@"sandbox"
                                                                                   clientSecret:@"A4143F56J75FGQY7TAJM"];
            UINavigationController*nc = [[UINavigationController alloc] initWithRootViewController:vc];
            vc.delegate = self;
            [self presentViewController:nc animated:true completion:nil];
        });
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


- (void)testAPI:(FDXAccount*)account{
    FeedlinxAPI*feedly = [FeedlinxAPI feedryAPIWithAccount:account];
    NSString*stream = [NSString stringWithFormat:@"user/%@/category/global.all",account.account_id];
    [feedly getStreamContentWithStreamId:stream
                                   count:@"1"
                                  ranked:nil
                              unreadOnly:true
                               newerThan:nil
                            continuation:nil
                            SuccessBlock:^(NSDictionary *stream) {
                                NSLog(@"%@",stream[@"items"][0]);
                               [feedly postMarkArticlesAsReadWithEntryIds:@[stream[@"items"][0][@"id"]]
                                                             SuccessBlock:^{
                                                                 
                                                             } errorBlock:^(NSError *error) {
                                                                 
                                                             }];
                            } errorBlock:^(NSError *error) {
                                
                            }];
}

#pragma mark - AuthorizationViewControllerDelegate
- (void)authorizationViewController:(AuthorizationViewController *)controller didFinishUserAuthorize:(FDXAccount *)account{
    [controller dismissViewControllerAnimated:true completion:^{
        NSData*data = [NSKeyedArchiver archivedDataWithRootObject:account];
        NSUserDefaults*df = [NSUserDefaults standardUserDefaults];
        [df setObject:data forKey:@"account"];
        [df synchronize];
        [self testAPI:account];
    }];
}

- (void)didCloseAuthorizationViewController:(AuthorizationViewController *)controller{
    [controller dismissViewControllerAnimated:true completion:nil];
}


@end
