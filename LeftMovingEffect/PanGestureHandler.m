//
//  PanGestureHandler.m
//  Intelegram
//
//  Created by Seungpill Baik on 2014. 10. 22..
//  Copyright (c) 2014년 retix. All rights reserved.
//

#import "PanGestureHandler.h"

#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)
#define RADIANS_TO_DEGREE(ANGLE) (ANGLE * 180) / M_PI

@implementation PanGestureHandler
@synthesize panGesture = _panGesture;
@synthesize dimmedView = _dimmedView;
const float yThreshold = 300;

- (id) init {
    self = [super init];
    if (self) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        self.panGesture.delegate = self;
        
        self.dimmedView = [[UIToolbar alloc] initWithFrame:CGRectZero];
        self.dimmedView.translucent = YES;
        self.dimmedView.barStyle = UIBarStyleBlackTranslucent;
        self.dimmedView.alpha = 0.0f;
        
        
        
    }
    return self;
}

- (void) setMainView:(UIView *) mainView withLeftView:(UIView *) leftView {
    _mainView = mainView;
    _leftView = leftView;
    
    self.dimmedView.frame = _mainView.bounds;
}

- (void) enable:(BOOL) enable {
    _enable = enable;
    if (_enable) {
        [_mainView.superview addGestureRecognizer:self.panGesture];
        [_mainView addSubview:self.dimmedView];
    } else {
        [_mainView.superview removeGestureRecognizer:self.panGesture];
        [self.dimmedView removeFromSuperview];

    }
    
}

- (void) setPannigVal:(CGFloat) value {
    _dimmedView.alpha = value;
    CGFloat scale = 1 - value;
    _mainView.layer.transform = CATransform3DScale([self getTransForm3DIdentity], scale, scale, scale);
    _mainView.layer.transform = CATransform3DRotate(_mainView.layer.transform, DEGREES_TO_RADIANS(-value * 60), 0, 1, 0);
    _mainView.layer.position = CGPointMake(CGRectGetMidX(_mainView.superview.frame) + value * yThreshold, _mainView.center.y);
}

- (CATransform3D) getTransForm3DIdentity {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = - 1.0f/ 1000.0f;
    return transform;
}


- (void) handlePan:(UIPanGestureRecognizer *)rec {
    CGPoint location = [rec locationInView:rec.view];
    
    
    CGFloat deltaX = (location.x - _beforePosition.x) * 0.004;
    if (rec.state == UIGestureRecognizerStateBegan) {
        self.dimmedView.hidden = NO;
    } else if (rec.state == UIGestureRecognizerStateChanged) {
        [self setPannigVal:MAX(0, MIN(0.35,_dimmedView.alpha + deltaX))];
        _leftView.center = CGPointMake(- CGRectGetWidth(_leftView.bounds) * 0.5 + CGRectGetWidth(_leftView.bounds)*(_dimmedView.alpha / 0.35), _leftView.center.y);

    } else {
        CGPoint velo = [rec velocityInView:rec.view];
        CGFloat duration = MIN(0.25, 50 / fabsf(velo.x));
        if (_dimmedView.alpha != 0.0f && _dimmedView.alpha != 0.5f) {
            if (_dimmedView.alpha <= 0.18) {
                [UIView animateWithDuration:duration animations:^{
                    [self setPannigVal:0.0f];
                    _leftView.center = CGPointMake(-CGRectGetWidth(_leftView.bounds) * 0.5, _leftView.center.y);
                } completion:^(BOOL finished) {
                    self.dimmedView.hidden = YES;
                }];
            } else {
                [self handleFinishAnimation:duration];
                [UIView animateWithDuration:duration animations:^{
                    _leftView.center = CGPointMake(CGRectGetWidth(_leftView.bounds) * 0.5, _leftView.center.y);
                    _dimmedView.alpha = 0.35f;
                }];
            }
        }
        
    }
    _beforePosition = location;
}

- (void) handleFinishAnimation:(CGFloat) duration {
    CGFloat scale = 1 - 0.35;
    CGFloat curScale = [[_mainView.layer valueForKeyPath:@"transform.scale"] floatValue];
    CGFloat curDegree = [[_mainView.layer valueForKeyPath:@"transform.rotation.y"] floatValue];

    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:curScale];
    scaleAnimation.toValue = [NSNumber numberWithFloat:scale];
    scaleAnimation.duration = duration;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:curDegree];
    rotateAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(-0.35 * 60)];
    rotateAnimation.duration = duration;
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *yPositionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    yPositionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(_mainView.superview.frame) + 0.35 * yThreshold, _mainView.center.y)];
    yPositionAnimation.duration = duration;
    yPositionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    
    CAAnimationGroup *aniGroup = [CAAnimationGroup animation];
    aniGroup.animations = [NSArray arrayWithObjects:scaleAnimation, rotateAnimation, yPositionAnimation, nil];
    aniGroup.duration = duration;
    aniGroup.delegate = self;
    aniGroup.fillMode = kCAFillModeForwards;
    aniGroup.removedOnCompletion = NO;
    [aniGroup setValue:[NSString stringWithFormat:@"openAni"] forKey:@"anim"];
    aniGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_mainView.layer addAnimation:aniGroup forKey:@"endAni"];
    
    _mainView.layer.transform = CATransform3DScale(_mainView.layer.transform, scale / curScale, scale / curScale, scale / curScale);
    _mainView.layer.transform = CATransform3DRotate(_mainView.layer.transform, DEGREES_TO_RADIANS(-0.35 * 60) - curDegree, 0, 1, 0);
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

    if ([[anim valueForKey:@"anim"] isEqualToString:@"openAni"]) {
        _mainView.layer.position = CGPointMake(CGRectGetMidX(_mainView.superview.frame) + 0.35 * yThreshold, _mainView.center.y);
    }
    [_mainView.layer removeAllAnimations];
}

@end
