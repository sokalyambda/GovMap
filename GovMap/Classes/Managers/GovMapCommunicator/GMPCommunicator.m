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
static NSInteger const kSearchHTMLFrameIndex = 12;

@interface GMPCommunicator () <UIWebViewDelegate, GMPCommunicatorDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSURLRequest *loadGovMapRequest;
@property (copy, nonatomic) RequestCadasterCompletionBlock requestCadasterCompletionBlock;
@property (copy, nonatomic) RequestAddressCompletionBlock requestAddressCompletionBlock;

@property (assign, readwrite, nonatomic) NSInteger loadedHTMLFramesCounter;

@end

@implementation GMPCommunicator

#pragma mark - Public Static

+ (instancetype)sharedInstance:(UIWebView *)wv
{
    static GMPCommunicator *sharedCommunicator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCommunicator = [[GMPCommunicator alloc] initWithWV:wv];
    });
    
    return sharedCommunicator;
}

#pragma mark - Lifecycle

- (instancetype)initWithWV:(UIWebView *)wv
{
    if (self = [super init]) {
        _isReadyForRequests = NO;
        _loadedHTMLFramesCounter = 0;
        
        NSURL *url = [NSURL URLWithString:kURLString];
        _loadGovMapRequest = [NSURLRequest requestWithURL:url];
        
        //_webView = [[UIWebView alloc] init];
        _webView = wv;
        _webView.delegate = self;
        [_webView loadRequest:_loadGovMapRequest];
        
        self.delegate = self;
    }
    return self;
}

#pragma mark - Public

/**
 *  Reload all govmap.gov.il data
 */
- (void)reloadContent
{
    self.loadedHTMLFramesCounter = 0;
    _isReadyForRequests = NO;
    [self.webView loadRequest:self.loadGovMapRequest];
}

#pragma mark - Requesting data with address
#pragma mark - Public

- (void)requestCadastralNumbersWithAddress:(NSString *)address
                           completionBlock:(RequestCadasterCompletionBlock)completionBlock
{
#ifdef DEBUG
    address = @"מבצע נחשון 3 ראשון לציון";
#endif
    
    if (!completionBlock) {
        return;
    }
    
    if (!self.isReadyForRequests) {
        [self.delegate communicatorWasNotReadyForRequest:self];
        return;
    }
    
    _isReadyForRequests = NO;
    self.requestCadasterCompletionBlock = completionBlock;
    
    NSString *jsSetTextFieldValue = [NSString stringWithFormat:
                                     @"document.getElementById('tbSearchWord').value = '%@'", address];
    [self.webView stringByEvaluatingJavaScriptFromString:jsSetTextFieldValue];
    [self.webView stringByEvaluatingJavaScriptFromString:@"FS_Search()"];
    NSLog(@"%@", [self.webView stringByEvaluatingJavaScriptFromString:jsSetTextFieldValue]);
    NSLog(@"%@", [self.webView stringByEvaluatingJavaScriptFromString:@"FS_Search()"]);
    [self performSelector:@selector(fillTextField) withObject:self afterDelay:1.0];

}

#pragma mark - Private

- (void)fillTextField
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('lnkFindBlockByAddress').click()"];
    NSLog(@"%@", [self.webView stringByEvaluatingJavaScriptFromString:
     @"document.getElementById('lnkFindBlockByAddress').click()"]);
    
    [self performSelector:@selector(checkInnerText) withObject:self afterDelay:1.0];
}

- (void)checkInnerText
{
    NSString *cadastralData = [self.webView stringByEvaluatingJavaScriptFromString:
                               @"document.getElementById('divTableResultsFromLink').innerText"];
    
    if (!cadastralData.length) {
        NSArray *cadastalNumbersWithText = [cadastralData componentsSeparatedByString:@","];
        NSString *majorNumber = [[((NSString *)cadastalNumbersWithText[0]) componentsSeparatedByCharactersInSet:
                                  [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        NSString *minorNumber = [[((NSString *)cadastalNumbersWithText[1]) componentsSeparatedByCharactersInSet:
                                  [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        
        self.requestCadasterCompletionBlock([GMPCadastre cadastreWithMajor:majorNumber.integerValue minor:minorNumber.integerValue]);
        
        [self.webView stringByEvaluatingJavaScriptFromString:
         @"document.getElementById('divTableResultsFromLink').innerText = ''"];
    }
    else {
        NSLog(@"Empty cadastral data");
        self.requestCadasterCompletionBlock(nil);
    }
    
    _isReadyForRequests = YES;
}

#pragma mark - Requesting data with Cadastral Numbers
#pragma mark - Public

- (void)requestAddressWithCadastralNumbers:(GMPCadastre *)cadastralInfo
                           completionBlock:(RequestAddressCompletionBlock)completionBlock
{
    if (!completionBlock) {
        return;
    }
    
    if (!self.isReadyForRequests) {
        [self.delegate communicatorWasNotReadyForRequest:self];
        return;
    }

    NSString *cadastralString = [NSString stringWithFormat:@"גוש %ld, חלקה %ld", cadastralInfo.major, cadastralInfo.minor];
    
    _isReadyForRequests = NO;
    self.requestAddressCompletionBlock = completionBlock;
    
    NSString *jsSetTextFieldValue = [NSString stringWithFormat:
                                     @"document.getElementById('tbSearchWord').value = '%@'", cadastralString];
    [self.webView stringByEvaluatingJavaScriptFromString:jsSetTextFieldValue];
    [self.webView stringByEvaluatingJavaScriptFromString:@"FS_Search()"];
    [self performSelector:@selector(fillTextFieldWithCadastralString) withObject:self afterDelay:0.1];
}

#pragma mark - Private

- (void)fillTextFieldWithCadastralString
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('lnkFindAddressByBlock').click()"];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkInnerTextForAddress:) userInfo:@0 repeats:YES];
}

- (void)checkInnerTextForAddress:(NSTimer *)timer
{
    NSString *address = [self.webView stringByEvaluatingJavaScriptFromString:
                               @"document.getElementById('tdFSTableResultsFromLink').innerText"];
    NSArray *characters = [address componentsSeparatedByString:@"\n"];
    
    if (![characters.firstObject isEqualToString:@""]) {
        self.requestAddressCompletionBlock(address);
        
        _isReadyForRequests = YES;
        [timer invalidate];
        return;
    }
    else {
        self.requestAddressCompletionBlock(@"Empty address");
    }
}

#pragma mark - UIWebViewDelegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.loadedHTMLFramesCounter++ == kSearchHTMLFrameIndex) {
        _isReadyForRequests = YES;
        
        if ([self.delegate respondsToSelector:@selector(communicatorDidFinishLoadingContent:)]) {
            [self.delegate communicatorDidFinishLoadingContent:self];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (self.loadedHTMLFramesCounter++ < kSearchHTMLFrameIndex) {
        _isReadyForRequests = NO;
        [self.webView stopLoading];
        
        if ([self.delegate respondsToSelector:@selector(communicator:didFailLoadingContentWithFrameNumber:error:)]) {
            [self.delegate communicator:self didFailLoadingContentWithFrameNumber:self.loadedHTMLFramesCounter error:error];
        }
    }
}

#pragma mark - GMPCommunicatorDelegate methods

- (void)communicator:(GMPCommunicator *)communicator didFailLoadingContentWithFrameNumber:(NSInteger)frameNumber error:(NSError *)error
{
    NSLog(@"Failed to load data. Trying again...");
    [self reloadContent];
}

- (void)communicatorDidFinishLoadingContent:(GMPCommunicator *)communicator
{
    NSLog(@"Finished loading valuable data");
}

- (void)communicatorWasNotReadyForRequest:(GMPCommunicator *)communicator
{
    NSLog(@"Communicator was not ready for requests");
}

@end
