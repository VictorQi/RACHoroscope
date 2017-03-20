//
//  NSString+Validator.h
//  RACHoroscope
//
//  Created by v.q on 2017/3/20.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validator)
- (BOOL)isValidPeopleNameOrCityName;
- (BOOL)isValidEmailAddress;
@end
