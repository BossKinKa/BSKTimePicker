//
//  BSKTimePicker.h
//  BSKTimePickerDemo
//
//  Created by jinke5 on 2018/10/16.
//  Copyright © 2018 jinke5. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKTimePickerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,BSKTimePickerLevel) {
    BSKTimePickerLevelHour = 0,
    BSKTimePickerLevelTenMin,
    BSKTimePickerLevelMin,
    BSKTimePickerLevelTenSec,
    BSKTimePickerLevelSec
};

@interface BSKTimePicker : UIView

-(instancetype)initWithFrame:(CGRect)frame level:(BSKTimePickerLevel)level andDefaultDate:(NSDate*)defaultDate;

@property (nonatomic,assign) float  ratio;//range:1-3600;

@property (nonatomic,weak) id<BSKTimePickerProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
