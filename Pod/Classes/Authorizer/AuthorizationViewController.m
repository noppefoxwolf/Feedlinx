//
//  AuthorizationViewController.m
//  FDXOauth2Client
//
//  Created by Tomoya_Hirano on 7/16/27 H.
//  Copyright (c) 27 Heisei Tomoya_Hirano. All rights reserved.
//

#import "AuthorizationViewController.h"
#import "FDXUtil.h"

@interface AuthorizationViewController ()<UIWebViewDelegate,FDXOauth2Delegate>
@property UIWebView*webView;
@property FDXOauth2*oauth;
@end

@implementation AuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    self.oauth = [[FDXOauth2 alloc] initWithScope:@"https://sandbox.feedly.com"
                                         clientId:@"sandbox"
                                     clientSecret:@"A4143F56J75FGQY7TAJM"];
    self.oauth.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.oauth.authorizationURL]];
    
    self.title = @"Authorization";
    [self.navigationController setToolbarHidden:false animated:true];
    UIBarButtonItem*back = [[UIBarButtonItem alloc] initWithTitle:@" <  "
                                                            style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:@selector(backAction)];
    UIBarButtonItem*next = [[UIBarButtonItem alloc] initWithTitle:@"  >   "
                                                            style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:@selector(nextAction)];
    UIBarButtonItem*space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem*close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                          target:self
                                                                          action:@selector(closeAction)];
    self.toolbarItems = @[close,space,back,next];
}

- (void)backAction{
    [self.webView goBack];
}
- (void)nextAction{
    [self.webView goForward];
}
- (void)closeAction{
    if ([self.delegate respondsToSelector:@selector(didCloseAuthorizationViewController:)]) {
         [self.delegate didCloseAuthorizationViewController:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self checkAuthorize:request.URL.absoluteString];
    return true;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSString *failingURLString = [error.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey];
    [self checkAuthorize:failingURLString];
}

- (void)checkAuthorize:(NSString*)urlString{
    if ([urlString hasPrefix:@"http://localhost"]) {
        NSDictionary*params = [[NSURL URLWithString:urlString] dictionaryFromQueryString];
        if ([[params allKeys] containsObject:@"code"]) {
            [self.oauth requestAccessTokenWithAuthorizationCode:params[@"code"]];
            [self.webView stopLoading];
        }
    }
}

- (void)FDXOauth2Delegate:(FDXOauth2 *)oauth response:(NSDictionary *)response{
    FDXAccount*account = [FDXAccount accountWithStatus:response];
    if ([self.delegate respondsToSelector:@selector(authorizationViewController:didFinishUserAuthorize:)]) {
        [self.delegate authorizationViewController:self didFinishUserAuthorize:account];
    }
}

@end