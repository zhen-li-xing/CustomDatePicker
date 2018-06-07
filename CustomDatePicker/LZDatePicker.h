//
//  LZDatePicker.h
//  CustomDatePicker
//
//  Created by 李震 on 2018/5/31.
//  Copyright © 2018年 李震. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , LZDatePickerMode)
{
    /** 显示时/分 */
    LZDatePickerModeTime  = 1 ,
    /** 显示年月日 */
    LZDatePickerModeDate,
    /** 显示年月日时分 */
    LZDatePickerModeDateAndTime,
    /** 显示月日时分 */
    LZDatePickerModeCurrentYear,
};

/** 屏幕宽度 */
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
/** 屏幕高度 */
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
/** 16进制颜色值转换成UIColor */
#define kHex(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0x00FF00) >> 8))/255.0 blue:((float)(value & 0x0000FF))/255.0 alpha:1.f]

@interface LZDatePicker : UIView


/** 选择要显示的样式 */
@property (nonatomic,assign)LZDatePickerMode datePickerMode;

/** 开始时选中的时间,默认是当前时间 */
@property (nonatomic,strong)NSDate * date;

/** 需要显示多少年  默认50年 */
@property (nonatomic,assign)NSInteger maxYearShow;

/** 显示视图 */
- (void)pickerShowWithBlock:(void(^)(NSDate * date))block;

@end
