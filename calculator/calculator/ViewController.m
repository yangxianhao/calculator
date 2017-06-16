//
//  ViewController.m
//  calculator
//
//  Created by 杨先豪 on 2017/6/15.
//  Copyright © 2017年 yangxianhao. All rights reserved.
//

#import "ViewController.h"

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
}

- (IBAction)opposite {
    
}

- (IBAction)percentage {
    
}

- (void)appendNumber:(NSString *)number
{
    if ([self.resultLabel.text isEqualToString:@"0"] && ![number isEqualToString:@"."]) {
        self.resultLabel.text = @"";
    }
    NSString *tempStr = self.resultLabel.text;
    self.resultLabel.text = [tempStr stringByAppendingString:number];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
