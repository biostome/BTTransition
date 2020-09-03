//
//  BTCoverHorizontalTransition.m
//  MKLotteryTicketSDK
//
//  Created by leishen on 2019/12/20.
//  Copyright © 2019 smoke. All rights reserved.
//

#import "BTCoverHorizontalTransition.h"


@interface BTCoverHorizontalTransition ()
@end

@implementation BTCoverHorizontalTransition


- (void)animateTransitionForPresentTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController * to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [transitionContext.containerView addSubview:to.view];
    CGRect finalFrame =  CGRectMake(0, 0, to.preferredContentSize.width, to.preferredContentSize.height);;//[transitionContext finalFrameForViewController:to];
    to.view.frame = CGRectMake(-CGRectGetWidth(finalFrame), CGRectGetMinX(finalFrame), CGRectGetWidth(finalFrame), CGRectGetHeight(finalFrame));
//    to.view.transform = CGAffineTransformMakeTranslation(-finalFrame.size.width, 0);
//    to.view.frame = finalFrame;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        to.view.transform = CGAffineTransformMakeTranslation(0, 0);
        to.view.frame = CGRectMake(0, CGRectGetMinX(finalFrame), CGRectGetWidth(finalFrame), CGRectGetHeight(finalFrame));
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)animateTransitionForDismiss:(nonnull id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect finalFrame = CGRectMake(0, 0, from.preferredContentSize.width, from.preferredContentSize.height);//[transitionContext finalFrameForViewController:from];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        from.view.transform = CGAffineTransformMakeTranslation(-finalFrame.size.width, 0);
        from.view.frame = CGRectMake(-CGRectGetWidth(finalFrame), CGRectGetMinX(finalFrame), CGRectGetWidth(finalFrame), CGRectGetHeight(finalFrame));
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController * to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController * from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (to.isBeingPresented) {
        [self animateTransitionForPresentTransition:transitionContext];
    }
    if (from.beingDismissed) {
        [self animateTransitionForDismiss:transitionContext];
    }
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return transitionContext.isAnimated ? 0.5 : 0;
}
@end
