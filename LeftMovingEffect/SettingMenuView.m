//
//  SettingMenuView.m
//  Intelegram
//
//  Created by Seungpill Baik on 2014. 10. 23..
//  Copyright (c) 2014년 retix. All rights reserved.
//

#import "SettingMenuView.h"

@implementation SettingMenuView
@synthesize delegate = _delegate;
CGFloat btnWidth = 200;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeMenuView];
        
    }
    return self;
}

- (void) setCenter:(CGPoint)center {
    [super setCenter:center];
    if (center.x == CGRectGetWidth(self.frame) * 0.5) {
        [self beginAni];
    } else if (center.x == -CGRectGetWidth(self.frame) * 0.5) {
        for (UIView *v in [self subviews]) {
            v.frame = CGRectMake(-btnWidth-30, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
        }

    }
}

- (void) beginAni {
    int i = 0;
    for (UIView *v in [self subviews]) {
        [UIView animateWithDuration:0.24 delay:0.1 + 0.1 *i++ options:0 animations:^{
            v.frame = CGRectMake(30, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
        } completion:nil];
    }
    
}

- (void) selectBtn:(UIButton *) btn {
    [_delegate selectIndex:(SELECT_TYPE)btn.tag];
}

- (void) makeMenuView {
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(-btnWidth, CGRectGetHeight(self.bounds) * 0.5 - 120 + 60 *i, btnWidth, 40);
        switch (i) {
            case 0:
                [btn setTitle:@"setting1" forState:UIControlStateNormal];
                break;
            case 1:
                [btn setTitle:@"setting2" forState:UIControlStateNormal];
                break;
            case 2:
                [btn setTitle:@"setting4" forState:UIControlStateNormal];
                break;
            case 3:
                [btn setTitle:@"setting5" forState:UIControlStateNormal];
                break;
            case 4:
                [btn setTitle:@"setting6" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        btn.tag = i;
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [[btn titleLabel] setFont:[UIFont fontWithName:@"Menlo-Italic" size:25]];
        [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:btn];
    }
}

@end
