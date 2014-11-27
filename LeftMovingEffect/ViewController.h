//
//  ViewController.h
//  LeftMovingEffect
//
//  Created by Seungpill Baik on 2014. 11. 26..
//  Copyright (c) 2014년 retix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanGestureHandler.h"
#import "SettingMenuView.h"

@interface ViewController : UIViewController <SettingMenuViewDelegate>

@property (nonatomic) UIView *contentsView;
@property (nonatomic) SettingMenuView *settingMenuView;
@property (nonatomic) PanGestureHandler *panHandler;

@end

