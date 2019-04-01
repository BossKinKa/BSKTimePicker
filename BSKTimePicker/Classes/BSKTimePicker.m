//
//  BSKTimePicker.m
//  BSKTimePickerDemo
//
//  Created by jinke5 on 2018/10/16.
//  Copyright © 2018 jinke5. All rights reserved.
//

#import "BSKTimePicker.h"
#import "BSKTimePickerCell.h"

#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface BSKTimePicker() <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,assign) BSKTimePickerLevel level;
@property (nonatomic,strong) NSDate *defaultDate;
@property (nonatomic,strong) UICollectionView *collectionV;
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong) NSDate *date00;
@property (nonatomic,strong) NSDate *date24;
@property (nonatomic,strong) NSArray *timeStrArr;
@property (nonatomic,strong) NSDate *selectedDate;
@property (nonatomic,strong) NSDate *currentDate;

@property (nonatomic,assign) CGFloat  minCellWidth;
@property (nonatomic,assign) CGFloat  maxCellWidth;
@property (nonatomic,assign) CGFloat  cellWidth;

@property (nonatomic,assign) CGFloat  contentWidth;
@property (nonatomic,assign) CGFloat  headerWidth;
@property (nonatomic,assign) CGFloat  footerWidth;

@property (nonatomic,assign) NSInteger  cellNumber;

@end

@implementation BSKTimePicker

-(instancetype)initWithFrame:(CGRect)frame level:(BSKTimePickerLevel)level andDefaultDate:(NSDate *)defaultDate
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf4f4f4);
        
        _contentWidth = frame.size.width;
//        _level = level;
//        self.defaultDate = defaultDate;
        _ratio =1.0;
        
        [self judgeLevelDepandOnCellWidth];
        [self setupViewComponents];
    }
    
    return self;
}

-(void)setRatio:(float)ratio
{
//    if (_ratio<ratio+0.2 && _ratio>ratio-0.2) {
//        return;
//    }
    
    _ratio = ratio;
    
    if ([self judgeLevelDepandOnCellWidth]) {
        [self.collectionV reloadData];
        return;
    }else{
        [self.collectionV.collectionViewLayout invalidateLayout];
        [self.collectionV layoutIfNeeded];
    
        [[self.collectionV visibleCells]enumerateObjectsUsingBlock:^(__kindof BSKTimePickerCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj updateDuringZooming];
        }];
    }
    
    [self keepOriginalContentOffset];

    
//    CGFloat oriContentOffsetX = self.collectionV.contentOffset.x;
//
//    CGFloat toContentOffsetX = oriContentOffsetX*ratio/_ratio;
//
//    self.collectionV.contentOffset = CGPointMake(toContentOffsetX, 0);
//
//
//    _ratio = ratio;

    

    

    
//    self.flowLayout = nil;
//
//    [self.collectionV setCollectionViewLayout:self.flowLayout animated:YES];

    
//    self.collectionV.contentOffset = CGPointMake(self.collectionV.contentOffset.x*ratio/_ratio, 0);

//    [self decideLevelWithScale:_ratio];
    
//    CGFloat itemWidth = self.cellWidth;
//    CGFloat itemHeight = self.frame.size.height/2.0;
//
//    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(collectionViewReloadVisibleItems) object:nil];
//
//    [self performSelector:@selector(collectionViewReloadVisibleItems) withObject:nil afterDelay:0.15];
    

}

-(BOOL)judgeLevelDepandOnCellWidth
{
    if (self.cellWidth < self.minCellWidth) {
        if (self.level == BSKTimePickerLevelHour) {
            return NO;
        }
        self.level = self.level - 1;
        return YES;
    }
    
    switch (self.level) {
        case BSKTimePickerLevelSec:
        case BSKTimePickerLevelMin:
        case BSKTimePickerLevelHour:
        {
            if(self.cellWidth > self.minCellWidth*6){
                if (self.level == BSKTimePickerLevelSec) {
                    return NO;
                }
                self.level = self.level +1;
                return YES;
            }
        }
            break;
        case BSKTimePickerLevelTenSec:
        case BSKTimePickerLevelTenMin:
        {
            if(self.cellWidth > self.minCellWidth*10){
                if (self.level == BSKTimePickerLevelSec) {
                    return NO;
                }
                self.level = self.level+1;
                return YES;
            }
        }
            break;
    }
    return NO;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(timePickerWillStartDragging)]) {
        [self.delegate timePickerWillStartDragging];
    }
}

//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    self.selectedDate = [NSDate dateWithTimeInterval:(scrollView.contentOffset.x/(scrollView.contentSize.width-self.frame.size.width))*24*3600 sinceDate:self.date00];
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat percent = scrollView.contentOffset.x/(scrollView.contentSize.width-self.frame.size.width);

    self.currentDate = [NSDate dateWithTimeIntervalSince1970:(self.date00.timeIntervalSince1970 + percent*(self.date24.timeIntervalSince1970-self.date00.timeIntervalSince1970))];
    
    if (scrollView.tracking ||
        scrollView.decelerating ||
        scrollView.dragging)
    {
        if ([self.delegate respondsToSelector:@selector(timePickerScrollDraggingTimeInterval:)])
        {
            [self.delegate timePickerScrollDraggingTimeInterval:self.currentDate.timeIntervalSince1970];
            self.selectedDate = self.currentDate;
        }
    }
//    self.selectedDate = [NSDate dateWithTimeInterval:(scrollView.contentOffset.x/scrollView.contentSize.width)*24*3600 sinceDate:self.date00];
    
}

-(void)keepOriginalContentOffset
{
    
    CGFloat ratio = ((self.selectedDate.timeIntervalSince1970-self.date00.timeIntervalSince1970)/(24*3600));
    
    CGPoint toPoint = CGPointMake((ratio*(self.collectionV.contentSize.width-self.frame.size.width)), 0);
    
    [self.collectionV setContentOffset:toPoint animated:NO];
}


-(void)collectionViewReloadVisibleItems
{
//    [self.collectionV reloadItemsAtIndexPaths:self.collectionV.indexPathsForVisibleItems];
    [self.collectionV reloadData];
}

-(void)decideLevelWithScale:(float)scale
{
    if (scale<=2){
        self.level = BSKTimePickerLevelHour;
    }else if (2<scale&&scale<=6){
        self.level = BSKTimePickerLevelTenMin;
    }else if (6<scale&&scale<=6*10){
        self.level = BSKTimePickerLevelMin;
    }else if (6*10<scale&&scale<=6*10*6){
        self.level = BSKTimePickerLevelTenSec;
    }else if (6*10*6<scale&&scale<=6*10*6*10){
        self.level = BSKTimePickerLevelSec;
    }else{
        self.level = BSKTimePickerLevelSec;
    }
}

//-(void)setLevel:(BSKTimePickerLevel)level
//{
//    if (level==_level) {
//        return;
//    }
//    _level = level;
//    NSLog(@"swithTolevel:%ld",level);
//    [self.collectionV reloadData];
//}

-(void)setupViewComponents
{
    [self addSubview:self.collectionV];
}

-(NSInteger)cellNumber
{
    switch (self.level) {
        case BSKTimePickerLevelSec:
            _cellNumber = 24*6*10*6*10;
            break;
        case BSKTimePickerLevelTenSec:
            _cellNumber = 24*6*10*6;
            break;
        case BSKTimePickerLevelMin:
            _cellNumber = 24*6*10;
            break;
        case BSKTimePickerLevelTenMin:
            _cellNumber = 24*6;
            break;
        case BSKTimePickerLevelHour:
            _cellNumber = 24;
            break;
    }
    return _cellNumber;
}

-(CGFloat)minCellWidth
{
    return 4.0;
}

-(CGFloat)maxCellWidth
{
    return 8.0;
}

-(CGFloat)cellWidth
{
    _cellWidth = self.contentWidth/self.cellNumber;
    
    if (_cellWidth<self.minCellWidth && self.level == 0) {
        return self.minCellWidth;
    }

    return _cellWidth;
}

-(CGFloat)contentWidth
{
    _contentWidth = self.bounds.size.width * self.ratio;
    return _contentWidth;
}

#pragma mark - collection view delegate


#pragma mark - collection view datasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cellNumber + 1 ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BSKTimePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"timeCell" forIndexPath:indexPath];
    
    NSInteger numberOfItems = self.cellNumber;
    NSInteger rate = (self.timeStrArr.count-1)/numberOfItems;
    
    CGSize fontSize = [@"00:00:00" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}];
    
    CGFloat itemWidth = self.cellWidth;

    BOOL longType = YES;
    BOOL showStr = NO;
    
    switch (self.level) {
        case BSKTimePickerLevelSec:
        case BSKTimePickerLevelMin:
        {
            longType = (indexPath.row%10==0);
            if (fontSize.width>itemWidth*10) {
                if (fontSize.width>itemWidth*20) {
                    showStr = ((indexPath.row%40)==0);
                }else{
                    showStr = ((indexPath.row%20)==0);
                }
            }else{
                showStr = (indexPath.row%10==0);
            }
        }
            break;
        case BSKTimePickerLevelTenSec:
        case BSKTimePickerLevelHour:
        case BSKTimePickerLevelTenMin:
        {
            longType = (indexPath.row%6==0);
            if (fontSize.width>itemWidth*6) {
                if (fontSize.width>itemWidth*12) {
                    showStr = ((indexPath.row%24)==0);
                }else{
                    showStr = ((indexPath.row%12)==0);
                }
            }else{
                showStr = (indexPath.row%6==0);
            }
        }
            break;
        default:
            break;
    }
    
    if (longType) {
        cell.type = BSKTimePickerCellTypeLong;
    }else{
        cell.type = BSKTimePickerCellTypeShort;
    }
    
    if (showStr) {
        cell.timeStr = self.timeStrArr[indexPath.row*rate];
    }else{
        cell.timeStr = nil;
    }
    
//    cell.startTime = [NSDate dateWithTimeIntervalSince1970:(self.date00.timeIntervalSince1970+w*(indexPath.row-0.5))];
//    cell.stopTime = [NSDate dateWithTimeIntervalSince1970:(self.date00.timeIntervalSince1970+w*(indexPath.row+0.5))];
//    cell.markArr = [self arrayMixWithRecordsWithCellStartTime:cell.startTime andStopTime:cell.stopTime];
    
//    cell.backgroundColor =  (indexPath.row % 2) ? [UIColor colorWithRed:0.7 green:0 blue:0 alpha:1.0] : [UIColor colorWithRed:0 green:0 blue:0.7 alpha:1.0];
//
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemHeight = self.frame.size.height/2.0;
    return CGSizeMake(self.cellWidth, itemHeight);;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.frame.size.width/2.0-self.cellWidth/2.0, self.frame.size.height/2.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(self.frame.size.width/2.0-self.cellWidth/2.0, self.frame.size.height/2.0);
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return CGFLOAT_MIN;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return CGFLOAT_MIN;
//}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
    }else{
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFooter" forIndexPath:indexPath];
    }

    return reusableView;
    
}

-(UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        CGFloat itemWidth = self.minCellWidth;
        CGFloat itemHeight = self.frame.size.height/2.0;
        
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.estimatedItemSize = CGSizeMake(itemWidth, itemHeight);
        
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
    }
    return _flowLayout;
}

-(UICollectionView *)collectionV
{
    if (!_collectionV) {
        
        _collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2.0, self.frame.size.width, self.frame.size.height/2.0) collectionViewLayout:self.flowLayout];
        
        _collectionV.showsHorizontalScrollIndicator = NO;
        _collectionV.backgroundColor = UIColorFromRGB(0xf4f4f4);
//        _collectionV.backgroundColor = [UIColor yellowColor];
        _collectionV.dataSource = self;
        _collectionV.delegate = self;
        
        [_collectionV registerClass:[BSKTimePickerCell class] forCellWithReuseIdentifier:@"timeCell"];
        [_collectionV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader"];
        [_collectionV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFooter"];
    }
    return _collectionV;
}

-(NSArray*)timeStrArr
{
    if (!_timeStrArr) {
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1000];
        
        for (int i=0; i<24; i++) {
            for (int j=0; j<60; j++) {
                NSString *timeStr = [NSString stringWithFormat:@"%02d:%02d",i,j];
                [arr addObject:timeStr];
                for (int k=1; k<60; k++) {
                    NSString *secTimeStr = [NSString stringWithFormat:@"%02d:%02d:%02d",i,j,k];
                    [arr addObject:secTimeStr];
                }
            }
        }
        [arr addObject:@"24:00"];
        _timeStrArr = [arr copy];
    }
    
    return _timeStrArr;
}

-(NSDate *)date00
{
    if (!_date00) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
        NSDate *fileDate00 = [calendar dateFromComponents:components];
        _date00 = fileDate00;
    }
    return _date00;
}

-(NSDate *)date24
{
    if (!_date24) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
        NSDate *fileDate00 = [calendar dateFromComponents:components];
        NSDate *fileDate24 = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:fileDate00 options:0];
        _date24 = fileDate24;
    }
    return _date24;
}

@end
