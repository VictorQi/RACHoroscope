//
//  ViewController.m
//  RACHoroscope
//
//  Created by v.q on 2017/3/12.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import "ViewController.h"
#import "MainViewModel.h"
#import "UIView+MyUtils.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (nonatomic, strong) NSNumber *gender;

@property (nonatomic, strong) MainViewModel *viewModel;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) { return nil; }
    
    self.viewModel = [[MainViewModel alloc] init];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeLayerBorderWidth:1.0];
    
    [self bind];
}

- (void)bind {
    RAC(self.viewModel, name) = self.nameTextField.rac_textSignal;
    RAC(self.viewModel, email) = self.emailTextField.rac_textSignal;
    RAC(self.viewModel, city) = self.cityTextField.rac_textSignal;
    RAC(self.viewModel, date) =
    [[[[self.datePicker
        rac_signalForControlEvents:UIControlEventValueChanged]
       startWith:self.datePicker]
      map:^NSDate* (UIDatePicker *picker) {
          return picker.date;
      }]  distinctUntilChanged];
    
    RAC(self.nameTextField, layerBorderColor) = self.viewModel.nameColorSignal;
    RAC(self.emailTextField, layerBorderColor) = self.viewModel.emailColorSignal;
    RAC(self.cityTextField, layerBorderColor) = self.viewModel.cityColorSignal;
    RAC(self.datePicker, layerBorderColor) = self.viewModel.dateColorSignal;
    
    self.womanButton.rac_command = self.viewModel.womanCommand;
    self.manButton.rac_command = self.viewModel.manCommand;
    
    @weakify(self);
    [RACObserve(self.viewModel, gender)
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
    
    self.checkButton.rac_command = self.viewModel.checkCommand;
    
    /* 这步非常慢，性能很差。 */
    [self.viewModel.checkCommand.executionSignals
     subscribeNext:^(RACSignal * _Nullable subscribeSignal) {
         [subscribeSignal
          subscribeCompleted:^{
              @strongify(self);
              [self showAlertWithTitle:@"Horoscope" message:@"You will have a wonderful day!"];
          }];
     }];
}

- (void)initializeLayerBorderWidth:(CGFloat)width {
    self.nameTextField.layer.borderWidth = width;
    self.emailTextField.layer.borderWidth = width;
    self.cityTextField.layer.borderWidth = width;
    self.datePicker.layer.borderWidth = width;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertcontroller =
    [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction =
    [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
    [alertcontroller addAction:dismissAction];
    
    [self presentViewController:alertcontroller animated:YES completion:nil];
}

@end
