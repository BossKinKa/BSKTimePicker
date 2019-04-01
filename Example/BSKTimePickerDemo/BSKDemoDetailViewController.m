//
//  BSKDemoDetailViewController.m
//  BSKTimePickerDemo
//
//  Created by jinke5 on 2018/10/16.
//  Copyright © 2018 jinke5. All rights reserved.
//

#import "BSKDemoDetailViewController.h"
#import <BSKTimePicker/BSKTimePicker.h>

@interface BSKDemoDetailViewController () <BSKTimePickerProtocol>

@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) BSKTimePicker *timePicker;

@property (nonatomic,strong) UILabel *timeLabel;

@end

@implementation BSKDemoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.timePicker];
    [self.view addSubview:self.slider];
    [self.view addSubview:self.timeLabel];
    
    UIView *cursorV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 120)];
    cursorV.backgroundColor = [UIColor redColor];
    
    cursorV.center = self.timePicker.center;
    
    [self.view addSubview:cursorV];
    
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)sliderValueChanged:(UISlider*)slider
{
    
    CGFloat sliderValue = slider.value;
    
    CGFloat ratio = slider.value *60*6;
    
    self.timePicker.ratio = ratio;
}

-(UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc]initWithFrame:CGRectMake(60, 320, 280, 40)];
    }
    return _slider;
}

-(BSKTimePicker *)timePicker
{
    if (!_timePicker) {
        _timePicker = [[BSKTimePicker alloc]initWithFrame:CGRectMake(20, 200, 335, 100) level:BSKTimePickerLevelHour andDefaultDate:[NSDate date]];
        _timePicker.delegate = self;
    }
    return _timePicker;
}

-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 400, 200, 20)];
        _timeLabel.text = @"00:00:00";
    }
    return _timeLabel;
}

-(void)timePickerScrollDraggingTimeInterval:(NSTimeInterval)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    dateFormatter.dateFormat = @"HH:mm:ss";
    
    self.timeLabel.text = [NSString stringWithFormat:@"Current Time:%@",[dateFormatter stringFromDate:date]];
}

@end
