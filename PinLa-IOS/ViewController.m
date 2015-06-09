//
//  ViewController.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/2.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "ViewController.h"
#import "HexView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HexView *hex = [[HexView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) image:[UIImage imageNamed:@"loading"] withCoverage:nil];
    [self.view addSubview:hex];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
