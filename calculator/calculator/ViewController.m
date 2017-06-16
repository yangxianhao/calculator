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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

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
    
}

- (IBAction)clear {
    self.resultLabel.text = @"0";
    [self adjustResultLabelSizeFontWithResultStr:self.resultLabel.text];
}

- (IBAction)opposite {
    
}

- (IBAction)percentage {
    
}

- (void)appendNumber:(NSString *)number
{
    if (self.resultLabel.text.length > (kMaxLength - 1)) return;
    if ([self.resultLabel.text isEqualToString:@"0"] && ![number isEqualToString:@"."]) {
        self.resultLabel.text = @"";
    }
    self.resultLabel.text = [self.resultLabel.text stringByAppendingString:number];
    [self adjustResultLabelSizeFontWithResultStr:self.resultLabel.text];
}

- (void)adjustResultLabelSizeFontWithResultStr:(NSString *)resultStr
{
    if (resultStr.length <= 6) {
        [self.resultLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Thin" size:80]];
    } else if (resultStr.length > 6 && resultStr.length <= 9) {
        [self.resultLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Thin" size:60]];
    } else if (resultStr.length > 9 && resultStr.length <= 11) {
        [self.resultLabel setFont:[UIFont fontWithName:@".SFUIDisplay-Thin" size:50]];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
