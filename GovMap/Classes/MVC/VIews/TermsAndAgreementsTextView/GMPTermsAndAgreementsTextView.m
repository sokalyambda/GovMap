//
//  GMPTermsAndAgreementsTextView.m
//  Relocate
//
//  Created by Pavlo on 10/22/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "GMPTermsAndAgreementsTextView.h"

static NSString *const kTermsAndAgreementsResourceName = @"TermsAndAgreements";

@implementation GMPTermsAndAgreementsTextView

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self loadTermsAndAgreements];
}

#pragma mark - Actions

- (void)loadTermsAndAgreements
{
    NSError *error = nil;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:kTermsAndAgreementsResourceName ofType:@"txt"];
    
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"Failed to read Terms and Agreements because: %@", error.localizedDescription);
    } else {
        self.text = content;
    }
}

@end
