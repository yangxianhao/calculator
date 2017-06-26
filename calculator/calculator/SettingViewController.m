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
@property (weak, nonatomic) IBOutlet UITextView *shakeResultTextView;
@property (weak, nonatomic) IBOutlet UITextView *helpTextView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.equalResultTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kEqualResult];
    self.shakeResultTextView.text = [[NSUserDefaults standardUserDefaults] objectForKey:kShakeResult];
    self.helpTextView.text = @"\t如果上面小输入框没有字符串，此APP就是一个普通的计算器，可以进行普通加减乘除计算，如果小输入框有字符串，那么在按等号(=)的时候就会显示你输入的字符串。\n\t下面灰色背景输入框为你摇一摇显示的字符串，可以输入一段话，但是每句话一定要用中文逗号隔开，每句话最好不要超过10个汉字，表情占2个汉字，每摇一次的结果只会显示一句话，当显示成功的时候手机会有震动反馈，如果在摇的过程中一直没有震动反馈则表示没有显示成功，当显示完所有的句子按计算器左上角“AC”按钮再摇一摇就又可以从第一句话开始显示。\n\t当以上两个输入框输入完成之后直接点击左上角“关闭”按钮即可开始你的表演。\n\t此APP有数据缓存的功能，也就是说当你配置完以上两个输入框的内容，下次再进APP的时候不用重新配置两个输入框的内容。";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.helpTextView setContentOffset:CGPointMake(0, 0)];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)close {
    [[NSUserDefaults standardUserDefaults] setObject:self.equalResultTextField.text forKey:kEqualResult];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:self.shakeResultTextView.text forKey:kShakeResult];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
