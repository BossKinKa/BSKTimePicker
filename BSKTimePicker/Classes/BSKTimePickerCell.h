//
//  BSKTimePickerCell.h
//  BSKTimePickerDemo
//
//  Created by jinke5 on 2018/10/16.
//  Copyright © 2018 jinke5. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

typedef NS_ENUM(NSInteger,BSKTimePickerCellType) {
    BSKTimePickerCellTypeShort = 0,
    BSKTimePickerCellTypeLong
};

@interface BSKTimePickerCell : UICollectionViewCell
@property (nonatomic,copy,nullable) NSString *timeStr;
@property (nonatomic,assign) BSKTimePickerCellType type;

-(void)updateDuringZooming;

@end

NS_ASSUME_NONNULL_END
