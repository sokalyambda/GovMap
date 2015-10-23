//
//  GMPGovMapWebViewController.m
//  Relocate
//
//  Created by Pavlo on 10/13/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "GMPGovMapWebViewController.h"

static NSString * const kGovMapURLString = @"http://govmap.gov.il";

@interface GMPGovMapWebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation GMPGovMapWebViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *URL = [NSURL URLWithString:kGovMapURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [self.webView loadRequest:request];
    
    self.webView.scalesPageToFit = YES;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self fillSearchFieldWithAddress];
}

#pragma mark - Actions

- (void)fillSearchFieldWithAddress
{
    NSString *jsString = [NSString stringWithFormat:@"document.getElementById('tbSearchWord').value = '%@'", self.address];
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
}

@end
