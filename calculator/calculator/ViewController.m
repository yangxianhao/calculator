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
#import "GEStatusBar.h"
#import "UIView+YXH.h"

#define kMaxLength 11
#define kStatusBarHeight 20
#define kDuration 0.5
#define kRandomColor [UIColor colorWithRed:gRandomInRange(0, 255)/255.0f green:gRandomInRange(0, 255)/255.0f blue:gRandomInRange(0, 255)/255.0f alpha:1.0f]
#define gRandomInRange(__startIndex, __endIndex) (int)(arc4random_uniform((u_int32_t)(__endIndex-__startIndex+1)) + __startIndex) // __startIndex ~ __endIndex

typedef void(^GCDOperation)();

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
@property (nonatomic, strong) UIView *statusBar;
@property (assign, nonatomic) CGPoint volecity;
@property (nonatomic, strong) dispatch_source_t timer;

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
    
    // 获取状态条
    self.statusBar = [GEStatusBar statusBar];
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

- (void)identicalStatusBar
{
    self.statusBar.origin = CGPointZero;
    self.statusBar.backgroundColor = [UIColor clearColor];
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
    if (self.timer) {
        dispatch_cancel(self.timer);
    }
    i = 0;
    self.selBtn.selected = NO;
    self.selBtn = nil;
    self.clearBtn.selected = NO;
    self.resultLabel.text = @"0";
    [self identicalStatusBar];
    self.accelerometer.updateInterval = 1.0f;
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
//    NSLog(@"%s", __func__);
    CGFloat x = acceleration.x;
    CGFloat y = acceleration.y;
    CGFloat z = acceleration.z;
    CGFloat a = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));
    // 摇一摇间隔
    if (a < 1.5 && a > 0) {
        self.enter = YES;
    }
    // 移动statusBar
    if (i == self.subShakeResult.count) {
        _volecity.y += (acceleration.y * 0.5);
        self.statusBar.y -= _volecity.y;
        if (self.statusBar.y < 0) {
            self.statusBar.y = 0;
            _volecity.y *= -0.5;
        }
        if (CGRectGetMaxY(self.statusBar.frame) > self.view.height) {
            self.statusBar.y = self.view.height - kStatusBarHeight;
            _volecity.y *= -0.5;
        }
    }
    // 显示字符串
    if (self.isEnter && a > 4.0f && i < self.subShakeResult.count) {
        NSLog(@"i = %d", i);
        self.enter = NO;
        self.resultLabel.text = self.subShakeResult[i];
        [self adjustResultLabelSizeFontWithResultStr:self.resultLabel.text];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        i++;
        if (i == self.subShakeResult.count) {
            i--;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                i++;
                self.accelerometer.updateInterval = 1 / 60.0;
                self.timer = [self getGCDTimerWithOperation:^{
                    self.statusBar.backgroundColor = kRandomColor;
                }];
                if (self.timer) {
                    dispatch_resume(self.timer);
                }
            });
        }
    }
}

- (dispatch_source_t)getGCDTimerWithOperation:(GCDOperation)operation
{
    //0.创建队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    //1.创建GCD中的定时器
    /*
     第一个参数:创建source的类型 DISPATCH_SOURCE_TYPE_TIMER:定时器
     第二个参数:0
     第三个参数:0
     第四个参数:队列
     */
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //2.设置时间等
    /*
     第一个参数:定时器对象
     第二个参数:DISPATCH_TIME_NOW 表示从现在开始计时
     第三个参数:间隔时间 GCD里面的时间 纳秒
     第四个参数:精准度(表示允许的误差,0表示绝对精准)
     */
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, kDuration * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //3.要调用的任务
    dispatch_source_set_event_handler(timer, operation);
    return timer;
}

@end
