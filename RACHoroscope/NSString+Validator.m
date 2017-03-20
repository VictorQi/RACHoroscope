//
//  NSString+Validator.m
//  RACHoroscope
//
//  Created by v.q on 2017/3/20.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import "NSString+Validator.h"

@implementation NSString (Validator)

- (BOOL)isValidPeopleNameOrCityName; {
    if (self == nil) { return NO; }

    NSError *error = nil;
    NSRegularExpression *regex =
    [NSRegularExpression
     regularExpressionWithPattern:@"^\\w+( \\w+\\.?)*$"
     options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (error) {
        NSLog(@"Validator Error in Name: %@", error);
        return NO;
    }
    
    NSUInteger length = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    return length > 2 && [regex matchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, length)].count > 0;
}

- (BOOL)isValidEmailAddress {
    if (self == nil) { return NO; }
    
    NSError *error = nil;
    NSRegularExpression *regex =
    [NSRegularExpression
     regularExpressionWithPattern:@"^\\S+@\\S+\\.\\S+$"
     options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (error) {
        NSLog(@"Validator Error in Email: %@", error);
        return NO;
    }
    
    NSUInteger length = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    return [regex matchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, length)].count > 0;
}
@end
