//
//  BSKTimePickerCell.m
//  BSKTimePickerDemo
//
//  Created by jinke5 on 2018/10/16.
//  Copyright © 2018 jinke5. All rights reserved.
//

#import "BSKTimePickerCell.h"
#import <Masonry/Masonry.h>


@interface BSKTimePickerCell()
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIView *lineLayer;
@end

@implementation BSKTimePickerCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self setupViewComponents];
    
    return self;
}

-(void)setupViewComponents
{
    [self.contentView addSubview:self.lineLayer];
}

-(UIView *)lineLayer
{
    if (!_lineLayer) {
        _lineLayer = [[UIView alloc]init];
        _lineLayer.frame = CGRectMake((self.frame.size.width-1)/2.0, 0, 1, 10);
        _lineLayer.backgroundColor = UIColorFromRGB(0x8d8d8d);
    }
    return _lineLayer;
}

-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = UIColorFromRGB(0x8d8d8d);
    }
    return _timeLabel;
}

-(void)updateDuringZooming
{
        self.timeLabel.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height*3/4.0);
    
        switch (self.type) {
            case BSKTimePickerCellTypeShort:
            {
                self.lineLayer.frame = CGRectMake((self.frame.size.width-1)/2.0, 0, 1, 10);
            }
                break;
            case BSKTimePickerCellTypeLong:
            {
                self.lineLayer.frame = CGRectMake((self.frame.size.width-1)/2.0, 0, 1, 20);
            }
        }
//    [self.contentView layoutIfNeeded];
}

-(void)setTimeStr:(NSString *)timeStr
{
    _timeStr = timeStr;
    self.timeLabel.text = timeStr;
    if (timeStr.length) {
        if (!self.timeLabel.superview) {
            if (timeStr.length>5) {
                self.timeLabel.font = [UIFont systemFontOfSize:12.0];
                self.timeLabel.textColor = [UIColor grayColor];
                [self.timeLabel sizeToFit];

            }else{
                self.timeLabel.font = [UIFont systemFontOfSize:13.0];
                [self.timeLabel sizeToFit];
                self.timeLabel.textColor = UIColorFromRGB(0x8d8d8d);
            }
            self.timeLabel.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height*3/4.0);
            [self.contentView addSubview:self.timeLabel];

        }
    }else{
        if (self.timeLabel.superview) {
            [self.timeLabel removeFromSuperview];
        }
    }
}

-(void)setType:(BSKTimePickerCellType)type
{
    _type = type;
    switch (type) {
        case BSKTimePickerCellTypeShort:
        {
            self.lineLayer.frame = CGRectMake((self.frame.size.width-1)/2.0, 0, 1, 10);
        }
            break;
        case BSKTimePickerCellTypeLong:
        {
            self.lineLayer.frame = CGRectMake((self.frame.size.width-1)/2.0, 0, 1, 20);
        }
        default:
            break;
    }
}

@end
