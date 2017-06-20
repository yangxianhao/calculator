//
//  ViewController.m
//  calculator
//
//  Created by 杨先豪 on 2017/6/15.
//  Copyright © 2017年 yangxianhao. All rights reserved.
//

#import "ViewController.h"

#define kMaxLength 11

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UIView *headView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHeadView)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [self.headView addGestureRecognizer:swipe];
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
    [self appendNumber:@"0"];
}

- (IBAction)one {
    [self appendNumber:@"1"];
}

- (IBAction)two {
    [self appendNumber:@"2"];
}

- (IBAction)three {
    [self appendNumber:@"3"];
}

- (IBAction)four {
    [self appendNumber:@"4"];
}

- (IBAction)five {
    [self appendNumber:@"5"];
}

- (IBAction)six {
    [self appendNumber:@"6"];
}

- (IBAction)seven {
    [self appendNumber:@"7"];
}

- (IBAction)eight {
    [self appendNumber:@"8"];
}

- (IBAction)nine {
    [self appendNumber:@"9"];
}

- (IBAction)point {
    [self appendNumber:@"."];
}

- (IBAction)add {
    
}

- (IBAction)minus {
    
}

- (IBAction)times {
    
}

- (IBAction)divide {
    
    
}

- (IBAction)equal {
    self.resultLabel.text = @"";
    [self adjustResultLabelSizeFontWithResultStr:self.resultLabel.text];
}

- (IBAction)clear {
    self.clearBtn.selected = NO;
    self.resultLabel.text = @"0";
    [self adjustResultLabelSizeFontWithResultStr:self.resultLabel.text];
}

- (IBAction)opposite {
    
}

- (IBAction)percentage {
    
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
    if (resultStr.length <= 6) {
        [self.resultLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Thin" size:80]];
    } else if (resultStr.length > 6 && resultStr.length <= 9) {
        [self.resultLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Thin" size:60]];
    } else {
        [self.resultLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Thin" size:45]];
    }
}

#pragma mark - 修改状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
