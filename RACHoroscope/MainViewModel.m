//
//  MainViewModel.m
//  RACHoroscope
//
//  Created by v.q on 2017/3/21.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import "MainViewModel.h"
#import "NSString+Validator.h"

@interface MainViewModel ()

@property (nonatomic, strong) RACSignal<UIColor *> *nameColorSignal;
@property (nonatomic, strong) RACSignal<UIColor *> *emailColorSignal;
@property (nonatomic, strong) RACSignal<UIColor *> *cityColorSignal;
@property (nonatomic, strong) RACSignal<UIColor *> *dateColorSignal;

@property (nonatomic, strong) RACCommand *womanCommand;
@property (nonatomic, strong) RACCommand *manCommand;
@property (nonatomic, strong) RACCommand *checkCommand;

@property (nonatomic, strong) NSNumber *gender;

@property (nonatomic, strong) RACSignal<NSNumber *> *finalSignal;

@end

@implementation MainViewModel

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }
    
    [self initialize];
    
    return self;
}

- (void)initialize {
    UIColor * _Nullable(^validToColor)(NSNumber * _Nullable) =
    ^(NSNumber * _Nullable valid) {
        return valid.boolValue ? [UIColor greenColor] : [UIColor clearColor];
    };
    
    RACSignal<NSNumber *> *nameValidSignal =
    [[RACObserve(self, name)
      map:^NSNumber* (NSString *value) {
          return @([value isValidPeopleNameOrCityName]);
      }] distinctUntilChanged];
    
    RACSignal<NSNumber *> *emailValidSignal =
    [[RACObserve(self, email)
      map:^NSNumber* (NSString *value) {
          return @([value isValidEmailAddress]);
      }] distinctUntilChanged];
    
    RACSignal<NSNumber *> *cityValidSignal =
    [[RACObserve(self, city)
      map:^NSNumber* (NSString *value) {
          return @([value isValidPeopleNameOrCityName]);
      }] distinctUntilChanged];
    
    RACSignal<NSNumber *> *dateValidSignal =
    [RACObserve(self, date)
     map:^NSNumber* (NSDate *date) {
         return @([date timeIntervalSinceDate:[NSDate dateWithTimeIntervalSinceNow:0]] < 0);
     }];
    
    self.nameColorSignal = [nameValidSignal map:validToColor];
    self.emailColorSignal = [emailValidSignal map:validToColor];
    self.cityColorSignal = [cityValidSignal map:validToColor];
    self.dateColorSignal = [dateValidSignal map:validToColor];
    
    @weakify(self);
    
    self.womanCommand =
    [[RACCommand alloc]
     initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
         return [RACSignal defer:^RACSignal * _Nonnull{
             @strongify(self)
             self.gender = @(NO);
             return [RACSignal return:@(YES)];
         }];
     }];
    RACSignal *womanSignal = [[self.womanCommand.executionSignals switchToLatest] startWith:@(NO)];
    
    self.manCommand =
    [[RACCommand alloc]
     initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
         return [RACSignal defer:^RACSignal * _Nonnull{
             @strongify(self);
             self.gender = @(YES);
             return [RACSignal return:@(YES)];
         }];
     }];
    RACSignal *manSignal = [[self.manCommand.executionSignals switchToLatest] startWith:@(NO)];
    
    RACSignal *genderSignal =
    [RACSignal
     combineLatest:@[
                     womanSignal,
                     manSignal
                     ]
     reduce:^NSNumber* (NSNumber *woman, NSNumber *man) {
         return @(woman.boolValue || man.boolValue);
     }];
    
    self.finalSignal =
    [[RACSignal
      combineLatest:@[
                      nameValidSignal,
                      emailValidSignal,
                      cityValidSignal,
                      dateValidSignal,
                      genderSignal
                      ]]
     map:^NSNumber* (RACTuple *inputs) {
         return @([inputs.rac_sequence
                   all:^BOOL(NSNumber * _Nullable value) {
                       return value.boolValue;
                   }]);
     }];
}

- (RACCommand *)checkCommand {
    if (!_checkCommand) {
        _checkCommand =
        [[RACCommand alloc]
         initWithEnabled:self.finalSignal
         signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
             return [RACSignal defer:^RACSignal * _Nonnull{
                 return [RACSignal empty];
             }];
         }];
    }
    return _checkCommand;
}

@end
