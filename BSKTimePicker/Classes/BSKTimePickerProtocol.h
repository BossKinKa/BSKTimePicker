//
//  BSKTimePickerProtocol.h
//  BSKTimePickerDemo
//
//  Created by jinke5 on 2018/10/17.
//  Copyright © 2018 jinke5. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BSKTimePickerProtocol <NSObject>

@optional

- (void)timePickerWillStartDragging;

- (void)timePickerScrollDraggingTimeInterval:(NSTimeInterval)time;

- (void)timePickerScrollStoppedTimeInterval:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
