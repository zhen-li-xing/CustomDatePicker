//
//  ViewController.m
//  CustomDatePicker
//
//  Created by 李震 on 2018/5/31.
//  Copyright © 2018年 李震. All rights reserved.
//

#import "ViewController.h"
#import "LZDatePicker.h"

@interface ViewController ()

/**  */
@property (nonatomic,strong)LZDatePicker * datePicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor yellowColor];
}
- (IBAction)showTime:(id)sender
{
    self.datePicker.datePickerMode = LZDatePickerModeDateAndTime;
    [self.datePicker pickerShowWithBlock:^(NSDate *date) {
        NSLog(@"%@",date);
        NSString * timeStr = [self toDateStringWithDate:date formatter:@"yyyy-MM-dd HH:mm"];
        NSLog(@"%@",timeStr);
    }];
}

- (IBAction)showOnlyTime:(id)sender
{
    self.datePicker.datePickerMode = LZDatePickerModeTime;
    [self.datePicker pickerShowWithBlock:^(NSDate *date) {
        NSLog(@"%@",date);
        NSString * timeStr = [self toDateStringWithDate:date formatter:@"HH:mm"];
        NSLog(@"%@",timeStr);
    }];
}
- (IBAction)showDate:(id)sender
{
    self.datePicker.datePickerMode = LZDatePickerModeDate;
    [self.datePicker pickerShowWithBlock:^(NSDate *date) {
        NSLog(@"%@",date);
        NSString * timeStr = [self toDateStringWithDate:date formatter:@"yyyy-MM-dd"];
        NSLog(@"%@",timeStr);
    }];
}
- (IBAction)showshortTime:(id)sender {
    self.datePicker.datePickerMode = LZDatePickerModeCurrentYear;
    [self.datePicker pickerShowWithBlock:^(NSDate *date) {
        NSLog(@"%@",date);
        NSString * timeStr = [self toDateStringWithDate:date formatter:@"yyyy-MM-dd"];
        NSLog(@"%@",timeStr);
    }];
}

#pragma mark -- 根据NSDate生成日期字符串
- (NSString*)toDateStringWithDate:(NSDate*)date formatter:(NSString*)formatter
{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:formatter];
    return [formate stringFromDate:date];
}

- (LZDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [LZDatePicker new];
    }
    return _datePicker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
