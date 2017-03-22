//
//  FeelingViewController.m
//  RACHoroscope
//
//  Created by v.q on 2017/3/22.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import "FeelingViewController.h"

@interface FeelingViewController ()

@property (weak, nonatomic) IBOutlet UIStepper *passionStepper;
@property (weak, nonatomic) IBOutlet UISlider *happinessSlider;
@property (weak, nonatomic) IBOutlet UISwitch *happySwitch;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@end

@implementation FeelingViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) { return nil; }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RACChannelTerminal *happinessSliderChannel =
    [self.happinessSlider rac_newValueChannelWithNilValue:@(0)];
    
    RACChannelTerminal *happySwitchChannel =
    [self.happySwitch rac_newOnChannel];
    
    RACSignal *happyChannelTerminal =
    [happySwitchChannel map:^NSNumber * _Nullable(NSNumber * _Nullable value) {
        if (value.boolValue) {
            return @(0.75);
        }
        return @(0.25);
    }];
    [happyChannelTerminal subscribe:happinessSliderChannel];
    
    RACSignal *happinessChannelTerminal =
    [happinessSliderChannel map:^NSNumber * _Nullable(NSNumber * _Nullable value) {
        return @(value != nil && value.doubleValue >= 0.5);
    }];
    [happinessChannelTerminal subscribe:happySwitchChannel];
    
    @weakify(self);
    [[self.passionStepper
     rac_signalForControlEvents:UIControlEventValueChanged]
    subscribeNext:^(UIStepper * _Nullable stepper) {
        @strongify(self);
        self.imageHeight.constant = (CGFloat)stepper.value;
    }];
    
    [[self.checkButton
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton * _Nullable button __unused) {
         @strongify(self);
         [self showAlertController];
     }];
}

- (void)showAlertController {
    UIAlertController *alertc = [UIAlertController alertControllerWithTitle:@"Horoscope" message:@"You will have a wonderful day!" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertc animated:YES completion:nil];
}

@end
