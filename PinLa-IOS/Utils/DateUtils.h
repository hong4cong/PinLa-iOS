//
//  DataUtils.h
//  juliye-iphone
//
//  Created by 洪聪 on 15/1/19.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval formatter:(NSString *)formatter;

+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter;

+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter;
@end
