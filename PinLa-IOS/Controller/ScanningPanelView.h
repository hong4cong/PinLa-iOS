//
//  ScanningPanelView.h
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/18.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "UAModalPanel.h"

@interface ScanningPanelView : UAModalPanel<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSArray* arr_data;

@end
