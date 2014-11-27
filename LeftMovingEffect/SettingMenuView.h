//
//  SettingMenuView.h
//  Intelegram
//
//  Created by Seungpill Baik on 2014. 10. 23..
//  Copyright (c) 2014년 retix. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    SELECTTYPE1 = 0,
    SELECTTYPE2,
    SELECTTYPE3,
    SELECTTYPE4,
    SELECTTYPE5,
}SELECT_TYPE;

@protocol SettingMenuViewDelegate<NSObject>
- (void) selectIndex:(SELECT_TYPE) selectType;
@end

@interface SettingMenuView : UIView

@property (nonatomic) id<SettingMenuViewDelegate> delegate;

@end
