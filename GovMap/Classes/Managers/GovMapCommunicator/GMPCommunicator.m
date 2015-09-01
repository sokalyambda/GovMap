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
static NSInteger const kAttemtsAmountForDataRetrieving = 20;

@interface GMPCommunicator () <UIWebViewDelegate, GMPCommunicatorDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSURLRequest *loadGovMapRequest;
@property (copy, nonatomic) RequestCadasterCompletionBlock requestCadasterCompletionBlock;
@property (copy, nonatomic) RequestAddressCompletionBlock requestAddressCompletionBlock;

@property (assign, readwrite, nonatomic) NSInteger loadedHTMLFramesCounter;

@end

@implementation GMPCommunicator

#pragma mark - Lifecycle

+ (instancetype)sharedInstance
{
    static GMPCommunicator *sharedCommunicator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCommunicator = [[GMPCommunicator alloc] init];
    });
    
    return sharedCommunicator;
}

- (instancetype)init
{
    if (self = [super init]) {
        _isReadyForRequests = NO;
        _loadedHTMLFramesCounter = 0;
        
        NSURL *url = [NSURL URLWithString:kURLString];
        _loadGovMapRequest = [NSURLRequest requestWithURL:url];
        
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        
        self.delegate = self;
    }
    return self;
}

#pragma mark - Public

/**
 *  Load all govmap.gov.il data
 */
- (void)loadContent
{
    self.loadedHTMLFramesCounter = 0;
    _isReadyForRequests = NO;
    [self.webView loadRequest:self.loadGovMapRequest];
}

#pragma mark - Private

/**
 *  Clear data so the next request wont get info from the previous one
 */
- (void)clearTableResultsFromLink
{
    [self.webView stringByEvaluatingJavaScriptFromString:
     @"document.getElementById('divTableResultsFromLink').innerText = ''"];
    [self.webView stringByEvaluatingJavaScriptFromString:
     @"document.getElementById('tdFSTableResultsFromLink').innerText = ''"];
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
    [self performSelector:@selector(fillTextFieldWithAddress) withObject:self afterDelay:0.5];

}

#pragma mark - Private

- (void)fillTextFieldWithAddress
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('lnkFindBlockByAddress').click()"];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkInnerTextForCadastre:) userInfo:@0 repeats:YES];
}

- (void)checkInnerTextForCadastre:(NSTimer *)timer
{
    static NSInteger timerFireCounter = 0;
    
    NSString *cadastralData = [self.webView stringByEvaluatingJavaScriptFromString:
                               @"document.getElementById('divTableResultsFromLink').innerText"];
    
    if (cadastralData.length) {
        // We're done
        [timer invalidate];
        _isReadyForRequests = YES;
        timerFireCounter = 0;
        
        NSArray *cadastalNumbersWithText = [cadastralData componentsSeparatedByString:@","];
        NSString *majorNumber = [[((NSString *)cadastalNumbersWithText[0]) componentsSeparatedByCharactersInSet:
                                  [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        NSString *minorNumber = [[((NSString *)cadastalNumbersWithText[1]) componentsSeparatedByCharactersInSet:
                                  [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        
        self.requestCadasterCompletionBlock([GMPCadastre cadastreWithMajor:majorNumber.integerValue minor:minorNumber.integerValue]);
        
        [self clearTableResultsFromLink];
    }
    else {
        NSLog(@"Unsuccessful attempt to retrieve cadastral numbers :( Trying again...");
        
        if (timerFireCounter++ == kAttemtsAmountForDataRetrieving) {
            [timer invalidate];
            _isReadyForRequests = YES;
            timerFireCounter = 0;
            
            if ([self.delegate respondsToSelector:@selector(communicatorDidFailToRetrieveCadastralNumbers:)]) {
                [self.delegate communicatorDidFailToRetrieveCadastralNumbers:self];
            }
            
            self.requestCadasterCompletionBlock(nil);
        }
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
    [self performSelector:@selector(fillTextFieldWithCadastralString) withObject:self afterDelay:0.5];
}

#pragma mark - Private

- (void)fillTextFieldWithCadastralString
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('lnkFindAddressByBlock').click()"];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkInnerTextForAddress:) userInfo:@0 repeats:YES];
}

- (void)checkInnerTextForAddress:(NSTimer *)timer
{
    static NSInteger timerFireCounter = 0;
    
    NSString *address = [self.webView stringByEvaluatingJavaScriptFromString:
                               @"document.getElementById('tdFSTableResultsFromLink').innerText"];
    NSArray *characters = [address componentsSeparatedByString:@"\n"];
    
    if (![characters.firstObject isEqualToString:@""]) {
        // We're done here
        _isReadyForRequests = YES;
        [timer invalidate];
        
        self.requestAddressCompletionBlock(address);
        
        [self clearTableResultsFromLink];
    }
    else {
        NSLog(@"Unsuccessful attempt to retrieve address :( Trying again...");
        
        if (timerFireCounter++ == kAttemtsAmountForDataRetrieving) {
            [timer invalidate];
            _isReadyForRequests = YES;
            timerFireCounter = 0;
            
            if ([self.delegate respondsToSelector:@selector(communicatorDidFailToRetrieveAddress:)]) {
                [self.delegate communicatorDidFailToRetrieveAddress:self];
            }
            
            self.requestAddressCompletionBlock(@"Empty address");
        }
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
    [self loadContent];
}

- (void)communicatorDidFinishLoadingContent:(GMPCommunicator *)communicator
{
    NSLog(@"Finished loading valuable data");
}

- (void)communicatorWasNotReadyForRequest:(GMPCommunicator *)communicator
{
    NSLog(@"Communicator was not ready for requests");
}

- (void)communicatorDidFailToRetrieveCadastralNumbers:(GMPCommunicator *)communicator
{
    NSLog(@"Failed attempt to retrieve cadastral numbers");
}

- (void)communicatorDidFailToRetrieveAddress:(GMPCommunicator *)communicator
{
    NSLog(@"Failed attempt to retrieve address");
}

@end
