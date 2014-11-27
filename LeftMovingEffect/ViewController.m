//
//  ViewController.m
//  LeftMovingEffect
//
//  Created by Seungpill Baik on 2014. 11. 26..
//  Copyright (c) 2014년 retix. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize panHandler = _panHandler;
@synthesize settingMenuView = _settingMenuView;
@synthesize contentsView = _contentsView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.panHandler = [[PanGestureHandler alloc] init];
    
    self.contentsView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.contentsView];
    
    self.settingMenuView = [[SettingMenuView alloc] initWithFrame:self.view.bounds];
    self.settingMenuView.center = CGPointMake(-CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    self.settingMenuView.delegate = self;
    [self.contentsView addSubview:self.settingMenuView];

    UIView *mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    mainView.backgroundColor = [UIColor lightGrayColor];
    [self.contentsView addSubview:mainView];
    
    [self.panHandler setMainView:mainView withLeftView:self.settingMenuView];
    [self.panHandler enable:YES];


    
}

- (void) selectIndex:(SELECT_TYPE)selectType {
    NSLog(@"selectType : %d", selectType);
}


@end
