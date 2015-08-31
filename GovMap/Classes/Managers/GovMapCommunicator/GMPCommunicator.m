//
//  GMPCommunicator.m
//  GovMapInteraction
//
//  Created by Pavlo on 8/28/15.
//  Copyright (c) 2015 Pavlo. All rights reserved.
//

#import "GMPCommunicator.h"
#import "GMPCadastre.h"
#import "GMPCommunicatorDelegate.h"

static NSString *const kURLString = @"http://www.govmap.gov.il";
static NSInteger const kSearchHTMLFrameIndex = 13;

@interface GMPCommunicator () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSURLRequest *loadGovMapRequest;
@property (copy, nonatomic) CommunicatorCompletionBlock completionBlock;

@property (assign, readwrite, nonatomic) BOOL isReadyForRequests;
@property (assign, readwrite, nonatomic) NSInteger loadedHTMLFramesCounter;

@end

@implementation GMPCommunicator

#pragma mark - Public Static

+ (instancetype)sharedInstance
{
    static GMPCommunicator *sharedCommunicator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCommunicator = [[GMPCommunicator alloc] init];
    });
    
    return sharedCommunicator;
}

#pragma mark - Lifecycle

- (instancetype)init
{
    if (self = [super init]) {
        _isReadyForRequests = NO;
        _loadedHTMLFramesCounter = 0;
        
        NSURL *url = [NSURL URLWithString:kURLString];
        _loadGovMapRequest = [NSURLRequest requestWithURL:url];
        
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        [_webView loadRequest:_loadGovMapRequest];
    }
    return self;
}

#pragma mark - Public

- (void)requestCadastralNumbersWithAddress:(NSString *)address
                           completionBlock:(CommunicatorCompletionBlock)completionBlock
{
#ifdef DEBUG
    address = @"מבצע נחשון 3 ראשון לציון";
#endif
    
    self.completionBlock = completionBlock;
    
    NSString *jsSetTextFieldValue = [NSString stringWithFormat:
                                     @"document.getElementById('tbSearchWord').value = '%@'", address];
    NSLog([self.webView stringByEvaluatingJavaScriptFromString:jsSetTextFieldValue]);
    NSLog([self.webView stringByEvaluatingJavaScriptFromString:@"FS_Search()"]);
    [self performSelector:@selector(fillTextField) withObject:self afterDelay:1.0];
}

/**
 *  Reload all govmap.gov.il data
 */
- (void)reloadContent
{
    self.loadedHTMLFramesCounter = 0;
    self.isReadyForRequests = NO;
    [self.webView loadRequest:self.loadGovMapRequest];
}

#pragma mark - Private

- (void)fillTextField
{
    NSLog([self.webView stringByEvaluatingJavaScriptFromString:
     @"document.getElementById('lnkFindBlockByAddress').click()"]);
    
    [self performSelector:@selector(checkInnerText) withObject:self afterDelay:1.0];
}

- (void)checkInnerText
{
    if (!self.completionBlock) {
        return;
    }
    
    NSString *cadastralData = [self.webView stringByEvaluatingJavaScriptFromString:
                               @"document.getElementById('divTableResultsFromLink').innerText"];
    
    if (cadastralData.length != 0) {
        NSArray *cadastalNumbersWithText = [cadastralData componentsSeparatedByString:@","];
        NSString *majorNumber = [[((NSString *)cadastalNumbersWithText[0]) componentsSeparatedByCharactersInSet:
                                  [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        NSString *minorNumber = [[((NSString *)cadastalNumbersWithText[1]) componentsSeparatedByCharactersInSet:
                                  [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        
        self.completionBlock([GMPCadastre cadastreWithMajor:majorNumber.integerValue minor:minorNumber.integerValue], nil);
    }
    else {
        NSLog(@"Empty cadastral data");
        self.completionBlock(nil, nil);
    }
}

#pragma mark - UIWebViewDelegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (++self.loadedHTMLFramesCounter >= kSearchHTMLFrameIndex) {
        self.isReadyForRequests = YES;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    ++self.loadedHTMLFramesCounter;
    
    if ([self.delegate respondsToSelector:@selector(communicator:didFailToLoadContentWithFrameNumber:error:)]) {
        [self.delegate communicator:self
didFailToLoadContentWithFrameNumber:self.loadedHTMLFramesCounter
                              error:error];
    }
}

@end
