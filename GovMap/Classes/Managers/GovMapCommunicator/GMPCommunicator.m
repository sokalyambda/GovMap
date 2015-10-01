//
//  GMPCommunicator.m
//  GovMapInteraction
//
//  Created by Pavlo on 8/28/15.
//  Copyright (c) 2015 Pavlo. All rights reserved.
//

#import "GMPBaseNavigationController.h"

#import "GMPCommunicator.h"

#import "GMPCadastre.h"

#import "GMPCommunicatorDelegate.h"

#import "GMPAlertService.h"
#import "GMPReachabilityService.h"

static NSString *const kStyleNotVisible = @"none";
static NSString *const kURLString = @"http://www.govmap.gov.il";
static NSInteger const kSearchHTMLFrameIndex = 13;
static NSInteger const kAttemtsAmountForDataRetrieving = 30;

@interface GMPCommunicator () <UIWebViewDelegate, GMPCommunicatorDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSURLRequest *loadGovMapRequest;

@property (copy, nonatomic) RequestCadasterCompletionBlock requestCadasterCompletionBlock;
@property (copy, nonatomic) RequestAddressCompletionBlock requestAddressCompletionBlock;

@property (assign, readwrite, nonatomic) NSInteger loadedHTMLFramesCounter;

@property (copy, nonatomic) NSString *address;
@property (strong, nonatomic) GMPCadastre *cadastralInfo;

@property (assign, nonatomic) BOOL isDisrupted;

@end

@implementation GMPCommunicator

#pragma mark - Accessors

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
        _address = @"";
        
        NSURL *url = [NSURL URLWithString:kURLString];
        _loadGovMapRequest = [NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:10];
        
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
    if ([self.delegate respondsToSelector:@selector(communicatorDidStartLoadingContent:)]) {
        [self.delegate communicatorDidStartLoadingContent:self];
    }
    
    self.loadedHTMLFramesCounter = 0;
    _isReadyForRequests = NO;
    [self.webView loadRequest:self.loadGovMapRequest];
}

- (void)disruptCurrentRequest
{
    self.isDisrupted = YES;
    [self clearTableResultsFromLink];
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
    
    self.address = @"";
    self.cadastralInfo = nil;
}

#pragma mark - Requesting data with address
#pragma mark - Public

- (void)requestCadastralNumbersWithAddress:(NSString *)address
                           completionBlock:(RequestCadasterCompletionBlock)completionBlock
{
    if (!completionBlock || !address) {
        return;
    }
    
    if (!self.isReadyForRequests) {
        if ([self.delegate respondsToSelector:@selector(communicatorWasNotReadyForRequest:)]) {
            [self.delegate communicatorWasNotReadyForRequest:self];
        }
        return;
    }
    
    // Asynch dispatch to prevent crash when making this request from block (not a main thread)
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self clearTableResultsFromLink];
        
        _isReadyForRequests = NO;
        self.requestCadasterCompletionBlock = completionBlock;
        self.address = address;
        
        NSString *jsSetTextFieldValue = [NSString stringWithFormat:
                                         @"document.getElementById('tbSearchWord').value = '%@'", address];
        
        
        [self.webView stringByEvaluatingJavaScriptFromString:jsSetTextFieldValue];
        [self.webView stringByEvaluatingJavaScriptFromString:@"FS_Search()"];
        
        if (!self.isDisrupted) {
            [self performSelector:@selector(fillTextFieldWithAddress) withObject:self afterDelay:2.0];
        } else {
            _isReadyForRequests = YES;
            self.isDisrupted = NO;
        }
    });
}

#pragma mark - Private

- (void)fillTextFieldWithAddress
{
    if (self.isDisrupted) {
        self.isDisrupted = NO;
        _isReadyForRequests = YES;
        return;
    }
    
    NSArray *parsedStrings;
    
    NSString *searchButtonStyle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('trFSFindGushUrl').getAttribute('style')"];
    NSLog(@"Search button style: %@", searchButtonStyle);
    
    parsedStrings = [searchButtonStyle componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    searchButtonStyle = [parsedStrings.lastObject componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";"]].firstObject;
    
    NSLog(@"Search button style: %@", searchButtonStyle);
    
    NSString *sugjestionsTableStyle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('trFSSearchParams').getAttribute('style')"];
    
    parsedStrings = [sugjestionsTableStyle componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    sugjestionsTableStyle = [parsedStrings.lastObject componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";"]].firstObject;
    
    NSLog(@"Table view style: %@", sugjestionsTableStyle);
    
    // In some cases we don't want to proceed even if address is kind of correct
    if ([searchButtonStyle isEqualToString:kStyleNotVisible] ||
        ![sugjestionsTableStyle isEqualToString:kStyleNotVisible]) {
        _isReadyForRequests = YES;
        self.requestCadasterCompletionBlock(nil);
    } else {
        [self.webView stringByEvaluatingJavaScriptFromString:@"FSS_FindBlockForAddress()"];
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkInnerTextForCadastre:) userInfo:@0 repeats:YES];
    }
}

- (void)checkInnerTextForCadastre:(NSTimer *)timer
{
    static NSInteger timerFireCounter = 0;
    
    if (self.isDisrupted) {
        [timer invalidate];
        self.isDisrupted = NO;
        _isReadyForRequests = YES;
        return;
    }
    
    NSString *cadastralData = [self.webView stringByEvaluatingJavaScriptFromString:
                               @"document.getElementById('divTableResultsFromLink').innerText"];
    
    if (cadastralData.length) {
        // We're done
        [timer invalidate];
        _isReadyForRequests = YES;
        timerFireCounter = 0;
        
        [self.webView stringByEvaluatingJavaScriptFromString:@"FSS_ShowNewSearch(true)"];
        
        NSArray *cadastalNumbersWithText = [cadastralData componentsSeparatedByString:@","];
        NSString *majorNumber = [[((NSString *)cadastalNumbersWithText[0]) componentsSeparatedByCharactersInSet:
                                  [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        NSString *minorNumber = [[((NSString *)cadastalNumbersWithText[1]) componentsSeparatedByCharactersInSet:
                                  [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        
        self.requestCadasterCompletionBlock([GMPCadastre cadastreWithMajor:majorNumber.integerValue minor:minorNumber.integerValue]);
    }
    else {
        if (timerFireCounter++ == kAttemtsAmountForDataRetrieving) {
            [self.webView stringByEvaluatingJavaScriptFromString:@"FSS_ShowNewSearch(true)"];
            
            [timer invalidate];
            _isReadyForRequests = YES;
            timerFireCounter = 0;
            
            if ([self.delegate respondsToSelector:@selector(communicator:didFailToRetrieveCadastralNumbersWithAddress:)]) {
                [self.delegate communicator:self didFailToRetrieveCadastralNumbersWithAddress:self.address];
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
    if (!completionBlock || !cadastralInfo) {
        return;
    }
    
    if (!self.isReadyForRequests) {
        if ([self.delegate respondsToSelector:@selector(communicatorWasNotReadyForRequest:)]) {
            [self.delegate communicatorWasNotReadyForRequest:self];
        }
        return;
    }
    
    // Asynch dispatch to prevent crash when making this request from block (not a main thread)
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self clearTableResultsFromLink];
        
        self.cadastralInfo = cadastralInfo;
        
        NSString *cadastralString = [NSString stringWithFormat:@"גוש %ld, חלקה %ld", cadastralInfo.major, cadastralInfo.minor];
        _isReadyForRequests = NO;
        self.requestAddressCompletionBlock = completionBlock;
        
        NSString *jsSetTextFieldValue = [NSString stringWithFormat:
                                         @"document.getElementById('tbSearchWord').value = '%@'", cadastralString];
        [self.webView stringByEvaluatingJavaScriptFromString:jsSetTextFieldValue];
        [self.webView stringByEvaluatingJavaScriptFromString:@"FS_Search()"];
        
        if (!self.isDisrupted) {
            [self performSelector:@selector(fillTextFieldWithCadastralString) withObject:self afterDelay:1.0];
        } else {
            _isReadyForRequests = YES;
            self.isDisrupted = NO;
        }
    });
}

#pragma mark - Private

- (void)fillTextFieldWithCadastralString
{
    //[self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('lnkFindAddressByBlock').click()"];
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"FSS_FindAddressForBlock()"];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkInnerTextForAddress:) userInfo:@0 repeats:YES];
}

- (void)checkInnerTextForAddress:(NSTimer *)timer
{
    static NSInteger timerFireCounter = 0;

    if (self.isDisrupted) {
        [timer invalidate];
        _isReadyForRequests = YES;
        self.isDisrupted = NO;
        return;
    }
    
    // We can get more than 1 address. If we do then return only first one.
    NSString *response = [self.webView stringByEvaluatingJavaScriptFromString:
                               @"document.getElementById('tdFSTableResultsFromLink').innerText"];
    NSArray *addresses = [response componentsSeparatedByString:@"\n"];
    NSArray *firstAddressCharacters = [addresses.firstObject componentsSeparatedByString:@"\n"];
    
    if (![firstAddressCharacters.firstObject isEqualToString:@""]) {
        // We're done here
        _isReadyForRequests = YES;
        timerFireCounter = 0;
        [timer invalidate];
        
        self.requestAddressCompletionBlock(addresses.firstObject);
    }
    else {
        
        if (timerFireCounter++ == kAttemtsAmountForDataRetrieving) {
            [timer invalidate];
            _isReadyForRequests = YES;
            timerFireCounter = 0;
            
            if ([self.delegate respondsToSelector:@selector(communicator:didFailToRetrieveAddressWithCadastre:)]) {
                [self.delegate communicator:self didFailToRetrieveAddressWithCadastre:self.cadastralInfo];
            }
            
            self.requestAddressCompletionBlock(nil);
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
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
    if (self.loadedHTMLFramesCounter++ < kSearchHTMLFrameIndex) {
        _isReadyForRequests = NO;
        [self.webView stopLoading];
        
        if ([self.delegate respondsToSelector:@selector(communicator:didFailLoadingContentWithFrameNumber:error:)]) {
            [self.delegate communicator:self didFailLoadingContentWithFrameNumber:self.loadedHTMLFramesCounter error:error];
        }
    }
}

#pragma mark - GMPCommunicatorDelegate methods

- (void)communicatorDidStartLoadingContent:(GMPCommunicator *)communicator
{
    NSLog(@"Communicator did start loading content...");
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
}

- (void)communicator:(GMPCommunicator *)communicator didFailLoadingContentWithFrameNumber:(NSInteger)frameNumber error:(NSError *)error
{
    NSLog(@"Communicator did fail loading content");
    
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
    
    GMPBaseNavigationController *baseNavController = (GMPBaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentController = baseNavController.viewControllers.lastObject;

    [GMPAlertService showInfoAlertControllerWithTitle:error.localizedDescription
                                           andMessage:LOCALIZED([NSString stringWithFormat:@"Error occurred while trying to connect to govmap. Trying again..."])
                                        forController:currentController
                                       withCompletion:^{
                                           [[GMPCommunicator sharedInstance] loadContent];
                                       }];
}

- (void)communicator:(GMPCommunicator *)communicator didFailToRetrieveAddressWithCadastre:(GMPCadastre *)cadastre
{
    NSLog(@"Failed to retrieve address");
}

- (void)communicator:(GMPCommunicator *)communicator didFailToRetrieveCadastralNumbersWithAddress:(NSString *)address
{
    NSLog(@"Failed to retrive cadastral numbers");
}

- (void)communicatorDidFinishLoadingContent:(GMPCommunicator *)communicator
{
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
    NSLog(@"Finished loading valuable data");
}

- (void)communicatorWasNotReadyForRequest:(GMPCommunicator *)communicator
{
    NSLog(@"Communicator was not ready for requests");
}

@end
