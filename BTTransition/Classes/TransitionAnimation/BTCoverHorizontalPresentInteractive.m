//
//  BTCoverHorizontalPresentInteractive.m
//  BTTransition
//
//  Created by leishen on 2020/2/5.
//

#import "BTCoverHorizontalPresentInteractive.h"


@interface BTCoverHorizontalPresentInteractive ()
@property (nonatomic, assign) CGFloat percent;
@property (nonatomic, assign) CGPoint speed;
@end

@implementation BTCoverHorizontalPresentInteractive

- (void)addPanGestureToViewController:(UIViewController*)viewController{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    pan.delegate = self;
    [viewController.view addGestureRecognizer:pan];
}


//处理UIScrollView上的手势和侧滑返回手势的冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[BTCoverHorizontalPresentInteractive class]] || [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return YES;
    }
    
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        if (otherGestureRecognizer.view.tag == 888888) {
            UIScrollView *scrollView = (UIScrollView *)otherGestureRecognizer.view;
            if (scrollView.contentOffset.x == 0) {
                return YES;
            }
        }
    }
    return NO;
}

//触发之后是否响应手势事件
//处理侧滑返回与UISlider的拖动手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

- (void)endAnimation {
    BOOL should = YES;
    if ([self.delegate respondsToSelector:@selector(shouldDismissForInteractive:)]) {
        should = [self.delegate shouldDismissForInteractive:self];
    }
    if (should==NO) {
        [self cancelInteractiveTransition];
        if ([self.delegate respondsToSelector:@selector(cancelPresentForInteractive:)]) {
            [self.delegate cancelPresentForInteractive:self];
        }
        return;
    }
    if (_percent > 0.1 || _speed.x > 800) {
        [self finishInteractiveTransition];
    }else{
        [self cancelInteractiveTransition];
        
        if ([self.delegate respondsToSelector:@selector(cancelPresentForInteractive:)]) {
            [self.delegate cancelPresentForInteractive:self];
        }
    }
}

- (void)beginAnimation {
    if ([self.delegate respondsToSelector:@selector(beginPresentViewControllerForInteractive:)]) {
        [self.delegate beginPresentViewControllerForInteractive:self];
    }
}

- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    CGFloat transitionY = [panGesture translationInView:panGesture.view].x;
    _percent = transitionY / (panGesture.view.frame.size.width);
    _speed = [panGesture velocityInView:panGesture.view]; //速度方法
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
            self.interative = YES;
            if (_percent >= 0) {
                [self beginAnimation];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:{
            [self updateInteractiveTransition:_percent];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            self.interative = NO;
            [self endAnimation];
            break;
        }
        default:
            break;
    }
}


@end
