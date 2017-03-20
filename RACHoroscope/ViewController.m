//
//  ViewController.m
//  RACHoroscope
//
//  Created by v.q on 2017/3/12.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Validator.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (strong, nonatomic) NSNumber *gender;
@end

@implementation ViewController

UIColor * _Nullable(^validToColor)(NSNumber * _Nullable) =
^(NSNumber * _Nullable valid) {
    return valid.boolValue ? [UIColor greenColor] : [UIColor clearColor];
};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeLayerBorderWidth:1.0];
    
    RACSignal<NSNumber *> *nameSignal =
    [self.nameTextField.rac_textSignal
     map:^NSNumber * _Nullable(NSString * _Nullable value) {
         return @([value isValidPeopleNameOrCityName]);
     }];
    
    RACSignal<NSNumber *> *emailSignal =
    [self.emailTextField.rac_textSignal
     map:^NSNumber * _Nullable(NSString * _Nullable value) {
         return @([value isValidEmailAddress]);
     }];
    
    RACSignal<NSNumber *> *citySignal =
    [self.cityTextField.rac_textSignal
     map:^NSNumber * _Nullable(NSString * _Nullable value) {
         return @([value isValidPeopleNameOrCityName]);
     }];
    
    RACSignal<NSNumber *> *dateSignal =
    [[[self.datePicker rac_signalForControlEvents:UIControlEventValueChanged]
      startWith:self.datePicker]
     map:^NSNumber *(UIDatePicker * picker) {
         BOOL validDate = [picker.date timeIntervalSinceDate:[NSDate dateWithTimeIntervalSinceNow:0]] < 0;
         return @(validDate);
     }];
    
    RACSignal<NSNumber *> *womanSignal =
    [[[self.womanButton rac_signalForControlEvents:UIControlEventTouchUpInside]
      map:^NSNumber *(UIButton *button __unused) {
          self.gender = @(NO);
          return @(YES);
      }]
     startWith:@(NO)];
    
    RACSignal<NSNumber *> *manSignal =
    [[[self.manButton rac_signalForControlEvents:UIControlEventTouchUpInside]
      map:^NSNumber *(UIButton * button __unused) {
          self.gender = @(YES);
          return @(YES);
      }]
     startWith:@(NO)];
    
    RACSignal<NSNumber *> *genderSignal =
    [RACSignal
     combineLatest:@[womanSignal, manSignal]
     reduce:^NSNumber *(NSNumber *woman, NSNumber *man) {
         return @(woman.boolValue || man.boolValue);
     }];
    
    [[nameSignal map:validToColor]
     subscribeNext:^(UIColor * _Nullable color) {
         self.nameTextField.layer.borderColor = color.CGColor;
     }];
    
    [[emailSignal map:validToColor]
     subscribeNext:^(UIColor * _Nullable color) {
         self.emailTextField.layer.borderColor = color.CGColor;
     }];
    
    [[citySignal map:validToColor]
     subscribeNext:^(UIColor *color) {
         self.cityTextField.layer.borderColor = color.CGColor;
     }];
    
    [[[dateSignal map:validToColor]
      skip:1]
     subscribeNext:^(UIColor *color) {
         self.datePicker.layer.borderColor = color.CGColor;
     }];
    
    RACSignal<NSNumber *> *finalSignal =
    [[RACSignal
      combineLatest:@[nameSignal, emailSignal, citySignal, genderSignal, dateSignal]]
     map:^NSNumber *(RACTuple *inputs) {
         return @([inputs.rac_sequence all:^BOOL(NSNumber * _Nullable value) {
             return value.boolValue;
         }]);
     }];
    
    RAC(self.checkButton, enabled) = finalSignal;
    
    @weakify(self);
    [RACObserve(self, gender)
     subscribeNext:^(NSNumber * _Nullable x) {
         @strongify(self);
         if (x == nil) {
             self.womanButton.selected = NO;
             self.manButton.selected = NO;
         } else if (x.boolValue == YES) {
             self.womanButton.selected = NO;
             self.manButton.selected = YES;
         } else if (x.boolValue == NO) {
             self.womanButton.selected = YES;
             self.manButton.selected = NO;
         }
     }];
}

- (void)initializeLayerBorderWidth:(CGFloat)width {
    self.nameTextField.layer.borderWidth = width;
    self.emailTextField.layer.borderWidth = width;
    self.cityTextField.layer.borderWidth = width;
    self.datePicker.layer.borderWidth = width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
