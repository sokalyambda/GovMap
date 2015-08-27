//
//  NSString+ContainsString.m
//
//  Created by konstantin on 16/05/2012.
//  Copyright (c) 2012 KTTSoft. All rights reserved.
//

#import "NSString+ContainsString.h"

@implementation NSString (ContainsString)

- (BOOL)containsSubString:(NSString*)patternStr
{
    if (self.length == 0) {
        return NO;
    }
    
    if (patternStr.length == 0) {
        return YES;
    }
    
    NSRange range = [self rangeOfString:patternStr options:NSCaseInsensitiveSearch];
    return range.location != NSNotFound;
}

@end
