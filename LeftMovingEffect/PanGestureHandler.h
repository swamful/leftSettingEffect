//
//  PanGestureHandler.h
//  Intelegram
//
//  Created by Seungpill Baik on 2014. 10. 22..
//  Copyright (c) 2014년 retix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PanGestureHandler : NSObject <UIGestureRecognizerDelegate> {
    UIView *_mainView;
    UIView *_leftView;
    BOOL _enable;
    

    CGPoint _beforePosition;
}

@property (nonatomic) UIPanGestureRecognizer *panGesture;
@property (nonatomic) UIToolbar *dimmedView;
- (void) setMainView:(UIView *) mainView withLeftView:(UIView *) leftView;
- (void) enable:(BOOL) enable;
@end
