//
//  DataUtils.m
//  juliye-iphone
//
//  Created by 洪聪 on 15/1/19.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

/********************** NSDate Utils ***********************/
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval formatter:(NSString *)formatter
{
    NSDate *createdDate = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    return [self stringFromDate:createdDate formatter:formatter];
}

+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setPMSymbol:@"下午"];
    [dateFormatter setAMSymbol:@"上午"];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if ([formatter isEqual:@"yyyy-MM-dd a HH:mm"]) {
        [dateFormatter setPMSymbol:@"下午"];
        [dateFormatter setAMSymbol:@"上午"];
    }else if ([formatter isEqual:@"yyyy年MM月dd日 a HH:mm"]){
        [dateFormatter setPMSymbol:@"下午"];
        [dateFormatter setAMSymbol:@"上午"];
    }else if ([formatter isEqual:@" a HH:mm"]) {
        [dateFormatter setPMSymbol:@"下午"];
        [dateFormatter setAMSymbol:@"上午"];
    }
    
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:dateString];
}

@end
