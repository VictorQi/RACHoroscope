//
//  MainViewModel.h
//  RACHoroscope
//
//  Created by v.q on 2017/3/21.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainViewModel : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *email;
@property (nonatomic, copy, readonly) NSString *city;
/// Wrapped With BOOL Value,
/// @(YES) -> Male, @(NO) -> Female, nil -> Unselected
@property (nonatomic, strong, readonly) NSNumber *gender;
@property (nonatomic, strong, readonly) NSDate *date;

@property (nonatomic, strong, readonly) RACSignal<UIColor *> *nameColorSignal;
@property (nonatomic, strong, readonly) RACSignal<UIColor *> *emailColorSignal;
@property (nonatomic, strong, readonly) RACSignal<UIColor *> *cityColorSignal;
@property (nonatomic, strong, readonly) RACSignal<UIColor *> *dateColorSignal;

@property (nonatomic, strong, readonly) RACCommand *womanCommand;
@property (nonatomic, strong, readonly) RACCommand *manCommand;
@property (nonatomic, strong, readonly) RACCommand *checkCommand;

@end
