//
//  GMPCommunicator.m
//  GovMapInteraction
//
//  Created by Pavlo on 8/28/15.
//  Copyright (c) 2015 Pavlo. All rights reserved.
//

#import "GMPCommunicator.h"

@implementation GMPCadastre

- (instancetype)initWithMajor:(int)major minor:(int)minor
{
    if (self = [super init]) {
        _major = major;
        _minor = minor;
    }
    return self;
}

+ (instancetype)cadastreWithMajor:(int)major minor:(int)minor
{
    return [[self alloc] initWithMajor:major minor:minor];
}

@end

static NSString *const kURLString = @"http://www.govmap.gov.il";
static int const kSearchHTMLFrameIndex = 13;

@interface GMPCommunicator () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSURLRequest *loadGovMapRequest;
@property (strong, nonatomic) void(^completionBlock)(GMPCadastre *, NSError*);

@property (readwrite, nonatomic) BOOL isGovMapContentLoaded;
@property (readwrite, nonatomic) int loadedHTMLFramesCounter;

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
        _isGovMapContentLoaded = NO;
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
                           completionBlock:(void(^)(GMPCadastre *cadastralInfo, NSError *error))completionBlock
{
#ifdef DEBUG
    address = @"מבצע נחשון 3 ראשון לציון";
#endif
    
    self.completionBlock = completionBlock;
    
    NSString *jsSetTextFieldValue = [NSString stringWithFormat:
                                     @"document.getElementById('tbSearchWord').value = '%@'", address];
    [self.webView stringByEvaluatingJavaScriptFromString:jsSetTextFieldValue];
    [self.webView stringByEvaluatingJavaScriptFromString:@"FS_Search()"];
    [self performSelector:@selector(fillTextField) withObject:self afterDelay:1.0];
}

#pragma mark - Private

- (void)fillTextField
{
    [self.webView stringByEvaluatingJavaScriptFromString:
     @"document.getElementById('lnkFindBlockByAddress').click()"];
    
    [self performSelector:@selector(checkInnerText) withObject:self afterDelay:1.0];
}

- (void)checkInnerText
{
    NSString *cadastralData = [self.webView stringByEvaluatingJavaScriptFromString:
                               @"document.getElementById('divTableResultsFromLink').innerText"];
    
    if (![cadastralData isEqualToString:@""]) {
        NSArray *cadastalNumbersWithText = [cadastralData componentsSeparatedByString:@","];
        NSString *majorNumber = [[((NSString *)cadastalNumbersWithText[0]) componentsSeparatedByCharactersInSet:
                                  [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        NSString *minorNumber = [[((NSString *)cadastalNumbersWithText[1]) componentsSeparatedByCharactersInSet:
                                  [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        
        self.completionBlock([GMPCadastre cadastreWithMajor:majorNumber.intValue minor:minorNumber.intValue], nil);
    }
    else {
        NSLog(@"Empty cadastral data");
        self.completionBlock(nil, nil);
    }
}

- (void)reloadContent
{
    self.isGovMapContentLoaded = NO;
    [self.webView loadRequest:self.loadGovMapRequest];
}

#pragma mark - UIWebViewDelegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (++self.loadedHTMLFramesCounter >= kSearchHTMLFrameIndex) {
        self.isGovMapContentLoaded = YES;
    }
}

@end
