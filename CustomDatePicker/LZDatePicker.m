//
//  LZDatePicker.m
//  CustomDatePicker
//
//  Created by 李震 on 2018/5/31.
//  Copyright © 2018年 李震. All rights reserved.
//

#import "LZDatePicker.h"
#import "AppDelegate.h"


@interface LZDatePicker ()
<UIPickerViewDelegate,
UIPickerViewDataSource>

/******* 年 *******/
/** 选择年视图 */
@property (nonatomic,strong)UIPickerView * yearPicker;
/** 年视图数据源 */
@property (nonatomic,strong)NSMutableArray * yearDataArr;
/** 当前选中的年 */
@property (nonatomic,assign)NSInteger yearSelectIndex;

/******* 月 *******/
/** 选择月视图 */
@property (nonatomic,strong)UIPickerView * monthPicker;
/** 月视图数据源 */
@property (nonatomic,strong)NSMutableArray * monthDataArr;
/** 当前选中的月份 */
@property (nonatomic,assign)NSInteger monthSelectIndex;

/******* 日 *******/
/** 选择日视图 */
@property (nonatomic,strong)UIPickerView * dayPicker;
/** 日视图数据源 */
@property (nonatomic,strong)NSMutableArray * dayDataArr;
/** 当前选中的日期 */
@property (nonatomic,assign)NSInteger daySelectIndex;

/******* 时 *******/
/** 选择时视图 */
@property (nonatomic,strong)UIPickerView * hourPicker;
/** 时视图数据源 */
@property (nonatomic,strong)NSMutableArray * hourDataArr;
/** 当前选中的时 */
@property (nonatomic,assign)NSInteger hourSelectIndex;

/******* 分 *******/
/** 选择分视图 */
@property (nonatomic,strong)UIPickerView * minutePicker;
/** 分视图数据源 */
@property (nonatomic,strong)NSMutableArray * minuteDataArr;
/** 当前选中的分 */
@property (nonatomic,assign)NSInteger minuteSelectIndex;

/******* 单位 *******/
/** 年 */
@property (nonatomic,strong)UILabel * yearLabel;
/** 月 */
@property (nonatomic,strong)UILabel * monthLabel;
/** 日 */
@property (nonatomic,strong)UILabel * dayLabel;
/** 时 */
@property (nonatomic,strong)UILabel * hourLabel;
/** 分 */
@property (nonatomic,strong)UILabel * minuteLabel;

/** 空视图 */
@property (nonatomic,strong)UIView * emptyView;

/** 顶部 暂停与取消按钮 */
@property (nonatomic,strong)UIView * topView;
/** 回调 */
@property (nonatomic,copy)void(^selectBlock)(NSDate *);

/** 选中的横线 */
@property (nonatomic,strong)UIView * topLine, * bottomLine;

@end

#define kPickerHeight 216.f

@implementation LZDatePicker

- (instancetype)init
{
    if (self = [super init]) {
        self.maxYearShow = 50;
        self.datePickerMode = LZDatePickerModeDateAndTime;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -- pickerView 代理事件
/** 多少个分区 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
/** 每个分区的行数 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger numOfRow = 0;
    switch (pickerView.tag) {
        case 101:
            numOfRow = self.yearDataArr.count;
            break;
        case 102:
            numOfRow = self.monthDataArr.count;
            break;
        case 103:
            numOfRow = self.dayDataArr.count;
            break;
        case 104:
            numOfRow = self.hourDataArr.count;
            break;
        case 105:
            numOfRow = self.minuteDataArr.count;
            break;
            
        default:
            break;
    }
    return numOfRow;
}
/** 每一行显示的数据 */
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    pickerView.showsSelectionIndicator = NO;
    NSString * title = @"";
    switch (pickerView.tag) {
        case 101:
            title = self.yearDataArr[row];
            break;
        case 102:
            title = self.monthDataArr[row];
            break;
        case 103:
            title = self.dayDataArr[row];
            break;
        case 104:
            title = self.hourDataArr[row];
            break;
        case 105:
            title = self.minuteDataArr[row];
            break;
            
        default:
            break;
    }
    
    UILabel * label = [UILabel new];
    label.font = [UIFont systemFontOfSize:15.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    return label;
}
/** 选中事件 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 101:
            self.yearSelectIndex = [self.yearDataArr[row] integerValue];
            [self creatDayDataSource];
            [self.dayPicker reloadAllComponents];
            break;
        case 102:
            self.monthSelectIndex = [self.monthDataArr[row] integerValue];
            [self creatDayDataSource];
            [self.dayPicker reloadAllComponents];
            break;
        case 103:
            self.daySelectIndex = [self.dayDataArr[row] integerValue];
            break;
        case 104:
            self.hourSelectIndex = [self.hourDataArr[row] integerValue];
            break;
        case 105:
            self.minuteSelectIndex = [self.minuteDataArr[row] integerValue];
            break;
            
        default:
            break;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50.f;
}

#pragma mark -- 设置选中的数据
- (void)setPickerSelect
{
    [_yearPicker selectRow:self.maxYearShow/2 inComponent:0 animated:YES];
    [_monthPicker selectRow:self.monthSelectIndex-1 inComponent:0 animated:YES];
    [_dayPicker selectRow:self.daySelectIndex-1 inComponent:0 animated:YES];
    [_hourPicker selectRow:self.hourSelectIndex inComponent:0 animated:YES];
    [_minutePicker selectRow:self.minuteSelectIndex inComponent:0 animated:YES];
}

#pragma mark -- 按钮点击事件
- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == 10001) {
        [self pickerHidden];
    }else{
        [self pickerHidden];
        
        NSString * selectStr = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",(long)self.yearSelectIndex,(long)self.monthSelectIndex,(long)self.daySelectIndex,(long)self.hourSelectIndex,(long)self.minuteSelectIndex];
        NSString * formatter = @"yyyy-MM-dd HH:mm";
        
        NSDate * date = [self toTimestampWithDate:selectStr formatter:formatter];
        if (self.selectBlock) {
            self.selectBlock(date);
        }
    }
}
#pragma mark -- 根据日期字符串生成NSDate
- (NSDate *)toTimestampWithDate:(NSString *)currentDate formatter:(NSString *)formatter
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatter];
    NSDate* date = [format dateFromString:currentDate];
    return date;
}

#pragma mark -- 显示视图
- (void)pickerShowWithBlock:(void (^)(NSDate *))block
{
    self.selectBlock = block;
    [self initDataSource];
    self.frame = CGRectMake(0, kDeviceHeight - kPickerHeight - 44.f, kDeviceWidth, kDeviceHeight);
    self.emptyView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - kPickerHeight - 44.f);
    [self addSubview:self.topView];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:self];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:self.emptyView];
    
    
    switch (self.datePickerMode) {
        case LZDatePickerModeTime:
            [self setAutoLayouWithTime];
            break;
        case LZDatePickerModeDate:
            [self setAutoLayoutWithDate];
            break;
        case LZDatePickerModeDateAndTime:
            [self setAutoLayoutWithAll];
            break;
        case LZDatePickerModeCurrentYear:
            [self setAutoLayoutWithCurrenYear];
            break;
        default:
            [self setAutoLayoutWithAll];
            break;
    }
    
    self.topLine.frame = CGRectMake(0, 44.f + 81.f, kDeviceWidth, 1);
    [self addSubview:self.topLine];
    self.bottomLine.frame = CGRectMake(0, 44.f + 84.f + 50.f, kDeviceWidth, 1);
    [self addSubview:self.bottomLine];
    
    [self setPickerSelect];
}
#pragma mark -- 设置显示月日时分的视图
- (void)setAutoLayoutWithCurrenYear
{
    [self addSubview:self.monthPicker];
    [self addSubview:self.dayPicker];
    [self addSubview:self.hourPicker];
    [self addSubview:self.minutePicker];
    
    [self addSubview:self.monthLabel];
    [self addSubview:self.dayLabel];
    [self addSubview:self.hourLabel];
    [self addSubview:self.minuteLabel];
    
    CGFloat scale = kDeviceWidth/320;
    CGFloat pickerY = 44.f;
    CGFloat pickerW = kDeviceWidth/4;
    CGFloat prckerH = 216.f;
    
    self.monthPicker.frame = CGRectMake(0, pickerY, pickerW, prckerH);
    self.monthLabel.frame = CGRectMake(pickerW - 20.f*scale, pickerY + 99.f ,20.f, 18.f);
    
    self.dayPicker.frame = CGRectMake(pickerW, pickerY, pickerW, prckerH);
    self.dayLabel.frame = CGRectMake(pickerW*2 - 20.f*scale, pickerY + 99.f ,20.f, 18.f);
    
    self.hourPicker.frame = CGRectMake(pickerW*2, pickerY, pickerW, prckerH);
    self.hourLabel.frame = CGRectMake(pickerW*3 - 20.f*scale, pickerY + 99.f ,20.f, 18.f);
    
    self.minutePicker.frame = CGRectMake(pickerW*3, pickerY, pickerW, prckerH);
    self.minuteLabel.frame = CGRectMake(pickerW*4 - 20.f*scale, pickerY + 99.f ,20.f, 18.f);
}
#pragma mark -- 设置显示时分的视图
- (void)setAutoLayouWithTime
{
    [self addSubview:self.hourPicker];
    [self addSubview:self.minutePicker];
    
    [self addSubview:self.hourLabel];
    [self addSubview:self.minuteLabel];
    
    CGFloat scale = kDeviceWidth/320;
    CGFloat pickerY = 44.f;
    CGFloat pickerW = kDeviceWidth/2;
    CGFloat prckerH = kPickerHeight;
    
    self.hourPicker.frame = CGRectMake(0, pickerY, pickerW, prckerH);
    self.hourLabel.frame = CGRectMake(pickerW - 50.f*scale, pickerY + 99.f ,20.f, 18.f);
    
    self.minutePicker.frame = CGRectMake(pickerW - 50.f*scale, pickerY, pickerW, prckerH);
    self.minuteLabel.frame = CGRectMake(pickerW*2 - 100.f*scale, pickerY + 99.f ,20.f, 18.f);
    
}
#pragma mark -- 设置显示年月日的视图
- (void)setAutoLayoutWithDate
{
    [self addSubview:self.yearPicker];
    [self addSubview:self.monthPicker];
    [self addSubview:self.dayPicker];
    
    [self addSubview:self.yearLabel];
    [self addSubview:self.monthLabel];
    [self addSubview:self.dayLabel];
    
    CGFloat scale = kDeviceWidth/320;
    CGFloat pickerY = 44.f;
    CGFloat pickerW = kDeviceWidth/3;
    CGFloat prckerH = kPickerHeight;
    
    self.yearPicker.frame = CGRectMake(0, pickerY, pickerW, prckerH);
    self.yearLabel.frame = CGRectMake(pickerW - 15.f*scale, pickerY + 99.f ,20.f, 18.f);
    
    self.monthPicker.frame = CGRectMake(pickerW, pickerY, pickerW, prckerH);
    self.monthLabel.frame = CGRectMake(pickerW*2 - 25.f*scale, pickerY + 99.f ,20.f, 18.f);
    
    self.dayPicker.frame = CGRectMake(pickerW*2, pickerY, pickerW, prckerH);
    self.dayLabel.frame = CGRectMake(pickerW*3 - 30.f*scale, pickerY + 99.f ,20.f, 18.f);
    
}

#pragma mark -- 设置显示年月日时分的视图
- (void)setAutoLayoutWithAll
{
    [self addSubview:self.yearPicker];
    [self addSubview:self.monthPicker];
    [self addSubview:self.dayPicker];
    [self addSubview:self.hourPicker];
    [self addSubview:self.minutePicker];
    
    [self addSubview:self.yearLabel];
    [self addSubview:self.monthLabel];
    [self addSubview:self.dayLabel];
    [self addSubview:self.hourLabel];
    [self addSubview:self.minuteLabel];
    
    CGFloat scale = kDeviceWidth/320;
    CGFloat pickerY = 44.f;
    CGFloat prckerH = kPickerHeight;
    
    self.yearPicker.frame = CGRectMake(0, pickerY, 75.f*scale, prckerH);
    self.yearLabel.frame = CGRectMake(65.f*scale, pickerY + 99.f ,20.f, 18.f);
    
    self.monthPicker.frame = CGRectMake(75.f*scale, pickerY, 55.f*scale, prckerH);
    self.monthLabel.frame = CGRectMake(120.f*scale, pickerY + 99.f ,20.f, 18.f);
    
    self.dayPicker.frame = CGRectMake(130.f*scale, pickerY, 55.f*scale, prckerH);
    self.dayLabel.frame = CGRectMake(175*scale, pickerY + 99.f ,20.f, 18.f);
    
    self.hourPicker.frame = CGRectMake(185.f*scale, pickerY, 55.f*scale, prckerH);
    self.hourLabel.frame = CGRectMake(230.f*scale, pickerY + 99.f ,20.f, 18.f);
    
    self.minutePicker.frame = CGRectMake(240.f*scale, pickerY, 55.f*scale, prckerH);
    self.minuteLabel.frame = CGRectMake(285.f*scale, pickerY + 99.f ,20.f, 18.f);
}

#pragma mark -- 隐藏视图
- (void)pickerHidden
{
    for (UIPickerView * picker in self.subviews) {
        [picker removeFromSuperview];
    }
    for (UILabel * label in self.subviews) {
        [label removeFromSuperview];
    }
    [self.emptyView removeFromSuperview];
    [self.topView removeFromSuperview];
    [self removeFromSuperview];
    self.date = nil;
}

#pragma mark -- 初始化数据源
- (void)initDataSource
{
    [self saveInitSelectIndex];
    
    [self createYearDataSource];
    
    [self creatMonthDataSource];
    
    [self creatDayDataSource];
}

#pragma mark -- 根据年月返回每月天数
- (NSInteger)getDayWithYear:(NSInteger)year month:(NSInteger)month
{
    NSInteger lastDay = 1;
    
    switch (month) {
        case 1:
            lastDay = 31;
            break;
        case 2:
            if (year % 400 == 0) {
                lastDay = 29;
            } else {
                if (year % 100 != 0 && year %4 == 0) {
                    lastDay = 29;
                } else {
                    lastDay = 28;
                }
            }
            break;
        case 3:
            lastDay = 31;
            break;
        case 4:
            lastDay = 30;
            break;
        case 5:
            lastDay = 31;
            break;
        case 6:
            lastDay = 30;
            break;
        case 7:
            lastDay = 31;
            break;
        case 8:
            lastDay = 31;
            break;
        case 9:
            lastDay = 30;
            break;
        case 10:
            lastDay = 31;
            break;
        case 11:
            lastDay = 30;
            break;
        case 12:
            lastDay = 31;
            break;
            
        default:
            break;
    }
    
    return lastDay;
}

#pragma mark -- 初始化天数数据源
- (void)creatDayDataSource
{
    NSInteger lastDay = [self getDayWithYear:self.yearSelectIndex month:self.monthSelectIndex];
    
    if (self.daySelectIndex > lastDay) {
        self.daySelectIndex = lastDay;
    }
    
    [self.dayDataArr removeAllObjects];
    for (int i = 0; i < lastDay; i ++) {
        [self.dayDataArr addObject:[NSString stringWithFormat:@"%02d",i+1]];
    }
}

#pragma mark -- 初始化月份数据源
- (void)creatMonthDataSource
{
    [self.monthDataArr removeAllObjects];
    for (int i=0; i<12; i++) {
        [self.monthDataArr addObject:[NSString stringWithFormat:@"%02d",i+1]];
    }
}

#pragma mark -- 根据当前年生成年份数据源
- (void)createYearDataSource
{
    [self.yearDataArr removeAllObjects];
    NSInteger firstYear = self.yearSelectIndex - (self.maxYearShow * .5f);
    NSInteger endYear = self.yearSelectIndex + (self.maxYearShow * .5f) - 1;
    for (NSInteger i = firstYear; i < endYear; i ++) {
        [self.yearDataArr addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
}

#pragma mark -- 保存初始选中值
- (void)saveInitSelectIndex
{
    self.yearSelectIndex = [self getDateComponentWithDate:self.date].year;
    self.monthSelectIndex = [self getDateComponentWithDate:self.date].month;
    self.daySelectIndex = [self getDateComponentWithDate:self.date].day;
    self.hourSelectIndex = [self getDateComponentWithDate:self.date].hour;
    self.minuteSelectIndex = [self getDateComponentWithDate:self.date].minute;
}

#pragma mark -- 根据日期获取时分秒
- (NSDateComponents *)getDateComponentWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unitFlags fromDate:date];
}

#pragma mark -- 创建 UIPickerView 视图
- (UIPickerView *)creatPickerViewWithTag:(NSInteger)tag
{
    UIPickerView * picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    picker.delegate = self;
    picker.dataSource = self;
    picker.tag = tag;
    
    return picker;
}

#pragma mark -- 懒加载视图
- (UIPickerView *)yearPicker
{
    if (!_yearPicker) {
        _yearPicker = [self creatPickerViewWithTag:101];
    }
    return _yearPicker;
}
- (UIPickerView *)monthPicker
{
    if (!_monthPicker) {
        _monthPicker = [self creatPickerViewWithTag:102];
    }
    return _monthPicker;
}
- (UIPickerView *)dayPicker
{
    if (!_dayPicker) {
        _dayPicker = [self creatPickerViewWithTag:103];
    }
    return _dayPicker;
}
- (UIPickerView *)hourPicker
{
    if (!_hourPicker) {
        _hourPicker = [self creatPickerViewWithTag:104];
    }
    return _hourPicker;
}
- (UIPickerView *)minutePicker
{
    if (!_minutePicker) {
        _minutePicker = [self creatPickerViewWithTag:105];
    }
    return _minutePicker;
}

#pragma mark -- 懒加载数据源
- (NSMutableArray *)yearDataArr
{
    if (!_yearDataArr) {
        _yearDataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _yearDataArr;
}
- (NSMutableArray *)monthDataArr
{
    if (!_monthDataArr) {
        _monthDataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _monthDataArr;
}
- (NSMutableArray *)dayDataArr
{
    if (!_dayDataArr) {
        _dayDataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dayDataArr;
}
- (NSMutableArray *)hourDataArr
{
    if (!_hourDataArr) {
        _hourDataArr = [NSMutableArray arrayWithCapacity:0];
        
        for(int i=0; i<24; i++){
            [_hourDataArr addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    return _hourDataArr;
}
- (NSMutableArray *)minuteDataArr
{
    if (!_minuteDataArr) {
        _minuteDataArr = [NSMutableArray arrayWithCapacity:0];
        
        for(int i=0; i<60; i++){
            [_minuteDataArr addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    return _minuteDataArr;
}
#pragma mark -- 懒加载时间单位
- (UILabel *)yearLabel
{
    if (!_yearLabel) {
        _yearLabel = [self createLabelWithTitle:@"年"];
    }
    return _yearLabel;
}
- (UILabel *)monthLabel
{
    if (!_monthLabel) {
        _monthLabel = [self createLabelWithTitle:@"月"];
    }
    return _monthLabel;
}
- (UILabel *)dayLabel
{
    if (!_dayLabel) {
        _dayLabel = [self createLabelWithTitle:@"日"];
    }
    return _dayLabel;
}
- (UILabel *)hourLabel
{
    if (!_hourLabel) {
        _hourLabel = [self createLabelWithTitle:@"时"];
    }
    return _hourLabel;
}
- (UILabel *)minuteLabel
{
    if (!_minuteLabel) {
        _minuteLabel = [self createLabelWithTitle:@"分"];
    }
    return _minuteLabel;
}

- (UILabel *)createLabelWithTitle:(NSString *)title
{
    UILabel * label = [UILabel new];
    label.text = title;
    label.font = [UIFont systemFontOfSize:15.f];
    return label;
}

- (UIView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [UIView new];
        
        [_emptyView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerHidden)]];
    }
    return _emptyView;
}

- (NSDate *)date
{
    if (!_date) {
        _date = [NSDate date];
    }
    return _date;
}

#pragma mark -- 顶部视图
- (UIView *)topView
{
    if (!_topView) {
        _topView = [UIView new];
        _topView.frame = CGRectMake(0, 0, kDeviceWidth, 44.f);
        
        CGFloat btnW = 35.f;
        CGFloat btnH = 22.f;
        UIButton * cancelBtn = [self creatBtnWithTitle:@"取消" color:kHex(0x333333) tag:10001];
        cancelBtn.frame = CGRectMake(30.f, 11.f, btnW, btnH);
        UIButton * confirmBtn = [self creatBtnWithTitle:@"确定" color:kHex(0x22B589) tag:10002];
        confirmBtn.frame = CGRectMake(self.frame.size.width - btnW - 30.f, 11.f, btnW, btnH);
        
        [_topView addSubview:cancelBtn];
        [_topView addSubview:confirmBtn];
        
        
        UIView * lineView = [UIView new];
        lineView.backgroundColor = kHex(0xECECEC);
        lineView.frame = CGRectMake(0, 43.f, self.frame.size.width, 1.f);
        [_topView addSubview:lineView];
    }
    return _topView;
}
- (UIButton *)creatBtnWithTitle:(NSString *)title color:(UIColor *)color tag:(NSInteger)tag
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.tag = tag;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIView *)topLine
{
    if (!_topLine) {
        _topLine = [UIView new];
        _topLine.backgroundColor = kHex(0xECECEC);
    }
    return _topLine;
}
- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = kHex(0xECECEC);
    }
    return _bottomLine;
}



@end
