//
//  PrefixLable.m
//  juliye-iphone
//
//  Created by lixiao on 15/1/20.
//  Copyright (c) 2015年 zlycare. All rights reserved.
//

#import "PrefixLable.h"

@implementation PrefixLable

-(void)setPrefix:(NSString *)prefix
{
    _prefix = prefix;
    [super setText:prefix];
}

-(void)setText:(NSString *)text
{
    self.content = text;
    if(!self.prefix){
        [super setText:text];
        return;
    }
    [super setText:[NSString stringWithFormat:@"%@%@",self.prefix,text]];
}

- (NSString *)contentText
{
    return self.content;
}

@end
