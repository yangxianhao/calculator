//
//  ViewController.m
//  calculator
//
//  Created by 杨先豪 on 2017/6/15.
//  Copyright © 2017年 yangxianhao. All rights reserved.
//

#import "ViewController.h"
#import "SettingViewController.h"
#import "NSString+Chinese.h"
#import <AudioToolbox/AudioToolbox.h>

#define kMaxLength 11

@interface ViewController () <UIAccelerometerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *timesBtn;
@property (weak, nonatomic) IBOutlet UIButton *divideBtn;

@property (nonatomic, strong) UIButton *selBtn;
@property (nonatomic, copy, readwrite) NSString *lastInputNumberStr;
@property (nonatomic, assign, getter=isClearResult) BOOL clearResult;
@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, strong) UIAccelerometer *accelerometer;
@property (nonatomic, assign, getter=isEnter) BOOL enter;
@property (nonatomic, strong) NSArray *subShakeResult;

@end

@implementation ViewController

- (NSArray *)subShakeResult
{
    if (!_subShakeResult) {
        _subShakeResult = [NSArray array];
    }
    return _subShakeResult;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 左右删除手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHeadView)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [self.headView addGestureRecognizer:swipe];
    // 后门入口
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadView)];
    [self.headView addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *shakeResult = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:kShakeResult];
    self.subShakeResult = [shakeResult componentsSeparatedByString:@"，"];
    if (shakeResult.length) {
        [self setupAccelerometer];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.accelerometer.updateInterval = MAXFLOAT;
}

#pragma mark - 后门入口
- (void)tapHeadView
{
    self.counter++;
    if (self.counter == 10) {
        SettingViewController *settingController = [[SettingViewController alloc] init];
        [self presentViewController:settingController animated:YES completion:^{
            self.counter = 0;
        }];
    }
}

#pragma mark - 左右扫手势
- (void)swipeHeadView
{
    if ([self.resultLabel.text isEqualToString:@"0"]) return;
    NSMutableString *tempStr = [NSMutableString stringWithString:self.resultLabel.text];
    [tempStr deleteCharactersInRange:NSMakeRange(tempStr.length - 1, 1)];
    if (tempStr.length == 0) {
        self.resultLabel.text = @"0";
    } else {
        self.resultLabel.text = tempStr;
    }
    [self adjustResultLabelSizeFontWithResultStr:self.resultLabel.text];
}

#pragma mark - xib action
- (IBAction)zero {
    if ([self.resultLabel.text isEqualToString:@"0"]) return;
    [self setupResultLabelWithText:@""];
    [self appendNumber:@"0"];
}

- (IBAction)one {
    [self setupResultLabelWithText:@""];
    [self appendNumber:@"1"];
}

- (IBAction)two {
    [self setupResultLabelWithText:@""];
    [self appendNumber:@"2"];
}

- (IBAction)three {
    [self setupResultLabelWithText:@""];
    [self appendNumber:@"3"];
}

- (IBAction)four {
    [self setupResultLabelWithText:@""];
    [self appendNumber:@"4"];
}

- (IBAction)five {
    [self setupResultLabelWithText:@""];
    [self appendNumber:@"5"];
}

- (IBAction)six {
    [self setupResultLabelWithText:@""];
    [self appendNumber:@"6"];
}

- (IBAction)seven {
    [self setupResultLabelWithText:@""];
    [self appendNumber:@"7"];
}

- (IBAction)eight {
    [self setupResultLabelWithText:@""];
    [self appendNumber:@"8"];
}

- (IBAction)nine {
    [self setupResultLabelWithText:@""];
    [self appendNumber:@"9"];
}

- (IBAction)point {
    if ([self.resultLabel.text containsString:@"."]) return;
    [self setupResultLabelWithText:@"0"];
    [self appendNumber:@"."];
}

- (void)setupResultLabelWithText:(NSString *)text
{
    if (self.isClearResult) {
        self.selBtn.selected = NO;
        self.resultLabel.text = text;
        self.clearResult = NO;
        [self adjustResultLabelSizeFontWithResultStr:self.resultLabel.text];
    }
}

#pragma mark - +
- (IBAction)add {
    self.lastInputNumberStr = self.resultLabel.text;
    self.selBtn.selected = NO;
    self.addBtn.selected = YES;
    self.selBtn = self.addBtn;
    self.clearResult = YES;
}

#pragma mark - -
- (IBAction)minus {
    self.lastInputNumberStr = self.resultLabel.text;
    self.selBtn.selected = NO;
    self.minusBtn.selected = YES;
    self.selBtn = self.minusBtn;
    self.clearResult = YES;
}

#pragma mark - *
- (IBAction)times {
    self.lastInputNumberStr = self.resultLabel.text;
    self.selBtn.selected = NO;
    self.timesBtn.selected = YES;
    self.selBtn = self.timesBtn;
    self.clearResult = YES;
}

#pragma mark - /
- (IBAction)divide {
    self.lastInputNumberStr = self.resultLabel.text;
    self.selBtn.selected = NO;
    self.divideBtn.selected = YES;
    self.selBtn = self.divideBtn;
    self.clearResult = YES;
}

#pragma mark - =
- (IBAction)equal {
    NSString *equalResult = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:kEqualResult];
    if (equalResult.length) {
        self.resultLabel.text = equalResult;
    } else {
        if (self.selBtn == self.addBtn) {
            self.resultLabel.text = [NSString stringWithFormat:@"%zd", [self.lastInputNumberStr integerValue] + [self.resultLabel.text integerValue]];
        } else if (self.selBtn == self.minusBtn) {
            self.resultLabel.text = [NSString stringWithFormat:@"%zd", [self.lastInputNumberStr integerValue] - [self.resultLabel.text integerValue]];
        } else if (self.selBtn == self.timesBtn) {
            self.resultLabel.text = [NSString stringWithFormat:@"%zd", [self.lastInputNumberStr integerValue] * [self.resultLabel.text integerValue]];
        } else {
            self.resultLabel.text = [NSString stringWithFormat:@"%zd", [self.lastInputNumberStr integerValue] / [self.resultLabel.text integerValue]];
        }
    }
    [self adjustResultLabelSizeFontWithResultStr:self.resultLabel.text];
    self.selBtn = nil;
}

#pragma mark - c
- (IBAction)clear {
    self.selBtn.selected = NO;
    self.selBtn = nil;
    self.clearBtn.selected = NO;
    self.resultLabel.text = @"0";
    [self adjustResultLabelSizeFontWithResultStr:self.resultLabel.text];
}

- (IBAction)opposite {
    NSMutableString *tempStr = [NSMutableString stringWithString:self.resultLabel.text];
    if ([self.resultLabel.text containsString:@"-"]) {
        [tempStr deleteCharactersInRange:NSMakeRange(0, 1)];
    } else {
        [tempStr insertString:@"-" atIndex:0];
    }
    self.resultLabel.text = tempStr;
    [self adjustResultLabelSizeFontWithResultStr:self.resultLabel.text];
}

- (IBAction)percentage {
    self.resultLabel.text = [NSString stringWithFormat:@"%f", [self.resultLabel.text floatValue] / 100.0];
    // 剔除最后的0 重新赋值
    self.resultLabel.text = [self deleteLastZeroAndPointWithString:self.resultLabel.text];
    [self adjustResultLabelSizeFontWithResultStr:self.resultLabel.text];
}

#pragma mark - 添加数字
- (void)appendNumber:(NSString *)number
{
    if (self.resultLabel.text.length > (kMaxLength - 1)) return;
    if ([self.resultLabel.text isEqualToString:@"0"] && ![number isEqualToString:@"."]) {
        self.resultLabel.text = @"";
    }
    self.clearBtn.selected = YES;
    self.resultLabel.text = [self.resultLabel.text stringByAppendingString:number];
    [self adjustResultLabelSizeFontWithResultStr:self.resultLabel.text];
}

#pragma mark - 调整数字大小
- (void)adjustResultLabelSizeFontWithResultStr:(NSString *)resultStr
{
    if ([resultStr isChinese] || [resultStr includeChinese]) {
        [self.resultLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Thin" size:30]];
    } else {
        if (resultStr.length <= 6) {
            [self.resultLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Thin" size:80]];
        } else if (resultStr.length > 6 && resultStr.length <= 9) {
            [self.resultLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Thin" size:60]];
        } else {
            [self.resultLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Thin" size:45]];
        }
    }
}

#pragma mark - 修改状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 其他一些方法
#pragma mark 剔除最后的0
- (NSString *)deleteLastZeroAndPointWithString:(NSString *)string
{
    NSMutableString *tempStr = [NSMutableString stringWithString:string];
    for (NSInteger i = (string.length - 1); i > 0; i--) {
        unichar subChar = [string characterAtIndex:i];
        // 0-->48, .-->46
        if (subChar == 48 || subChar == 46) {
            [tempStr deleteCharactersInRange:NSMakeRange(i, 1)];
        } else {
            break;
        }
    }
    return tempStr;
}

#pragma mark - 初始化摇一摇加速剂
- (void)setupAccelerometer
{
    if (!self.accelerometer) {
        self.accelerometer = [UIAccelerometer sharedAccelerometer];
    }
    self.accelerometer.delegate = self;
    self.accelerometer.updateInterval = 1.0f;
}

static int i = 0;
#pragma mark - UIAccelerometerDelegate
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    CGFloat x = acceleration.x;
    CGFloat y = acceleration.y;
    CGFloat z = acceleration.z;
    CGFloat a = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));
    if (a < 1.5 && a > 0) {
        self.enter = YES;
    }
    if (self.isEnter && a > 4.0f && i < self.subShakeResult.count) {
        NSLog(@"i = %d", i);
        self.enter = NO;
        self.resultLabel.text = self.subShakeResult[i];
        [self adjustResultLabelSizeFontWithResultStr:self.resultLabel.text];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        i++;
    }
}

@end
