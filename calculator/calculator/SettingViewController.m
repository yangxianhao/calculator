//
//  SettingViewController.m
//  calculator
//
//  Created by BC_design on 2017/6/23.
//  Copyright © 2017年 yangxianhao. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UITextField *equalResultTextField;
@property (weak, nonatomic) IBOutlet UITextField *shakeResultTextField;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.equalResultTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kEqualResult];
    self.shakeResultTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kShakeResult];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)close {
    [[NSUserDefaults standardUserDefaults] setObject:self.equalResultTextField.text forKey:kEqualResult];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:self.shakeResultTextField.text forKey:kShakeResult];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
