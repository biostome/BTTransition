//
//  BTCoverVerticalTransitionAnimation.m
//  MKTransitionAnimation
//
//  Created by leishen on 2019/11/21.
//  Copyright © 2019 leishen. All rights reserved.
//

#import "BTCoverVerticalTransition.h"

@interface MKPresentationController : UIPresentationController
@property (nonatomic, strong) UIButton *dimmingView;
@end

@implementation MKPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        [self.containerView addSubview:self.presentedView];
    }
    return self;
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container{
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    
    if (container == self.presentedViewController)
        [self.containerView setNeedsLayout];
}

- (CGRect)frameOfPresentedViewInContainerView{
    CGRect containerViewBounds = self.containerView.bounds;
    CGSize presentedViewContentSize = [self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:containerViewBounds.size];
    
    // The presented view extends presentedViewContentSize.height points from
    // the bottom edge of the screen.
    CGRect presentedViewControllerFrame = containerViewBounds;
    presentedViewControllerFrame.size.height = presentedViewContentSize.height;
    presentedViewControllerFrame.origin.y = CGRectGetHeight(containerViewBounds) - presentedViewContentSize.height;
    return presentedViewControllerFrame;
}

- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize{
    
    if (container == self.presentedViewController){
        CGSize preferredContent = ((UIViewController*)container).preferredContentSize;
        return preferredContent;
    }
    else
        return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
}

- (void)containerViewWillLayoutSubviews{
    [super containerViewWillLayoutSubviews];
    self.dimmingView.frame = self.containerView.bounds;
    self.presentedView.frame = self.frameOfPresentedViewInContainerView;
}


- (UIButton *)dimmingView{
    if (!_dimmingView) {
        _dimmingView = [[UIButton alloc]init];
        _dimmingView.backgroundColor = [UIColor.clearColor colorWithAlphaComponent:0];
        [_dimmingView addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dimmingView;
}

- (void)dismissAction:(UIButton*)sender{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentationTransitionWillBegin{
    [self.containerView insertSubview:self.dimmingView atIndex:0];
    // transitionCoordinator 转场协调器，用于present 或 dissmiss 时协调其他动画
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    }];
    
}

- (void)presentationTransitionDidEnd:(BOOL)completed{
    if (completed == NO){
        self.dimmingView = nil;
    }
}

- (void)dismissalTransitionWillBegin{
    // transitionCoordinator 转场协调器，用于present 或 dissmiss 时协调其他动画
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed{
    if (completed == YES) {
        _dimmingView = nil;
    }
}



@end

@interface MKInteractiveTransition : UIPercentDrivenInteractiveTransition<UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, assign) BOOL interative;
@end

@implementation MKInteractiveTransition
- (instancetype)initWithViewController:(UIViewController*)viewController{
    self = [super init];
    if (self) {
        self.viewController = viewController;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        pan.delegate = self;
        [viewController.view addGestureRecognizer:pan];
    }
    return self;
}



- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
    CGFloat persent = transitionY / (panGesture.view.frame.size.height);
    CGPoint speed = [panGesture velocityInView:panGesture.view]; //速度方法
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.interative = YES;
            [self.viewController dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged:{
            [self updateInteractiveTransition:persent];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            self.interative = NO;
            if (persent > 0.5 || speed.y > 920) {
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}


@end












@interface BTCoverVerticalTransition ()
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) MKInteractiveTransition *interactive;
@end

@implementation BTCoverVerticalTransition
- (instancetype)initPresentViewController:(UIViewController*)viewController{
    self = [super init];
    if (self) {
        self.viewController = viewController;
        viewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (instancetype)initPresentViewController:(UIViewController*)viewController withRragDismissEnabal:(BOOL)enabel{
    self = [super init];
    if (self) {
        self.viewController = viewController;
        viewController.modalPresentationStyle = UIModalPresentationCustom;
        if (enabel == YES) {
            MKInteractiveTransition * interactive = [[MKInteractiveTransition alloc]initWithViewController:viewController];
            self.interactive = interactive;
        }
    }
    return self;
}

- (void)animateTransitionForPresentTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController * to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [transitionContext.containerView addSubview:to.view];
    CGRect finalFrame = [transitionContext finalFrameForViewController:to];
    to.view.frame = finalFrame;
    to.view.transform = CGAffineTransformMakeTranslation(0, finalFrame.size.height);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        to.view.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)animateTransitionForDismiss:(nonnull id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect finalFrame = [transitionContext finalFrameForViewController:from];
    [UIView animateWithDuration:0.25 animations:^{
        from.view.transform = CGAffineTransformMakeTranslation(0, finalFrame.size.height);
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
    return transitionContext.isAnimated ? 0.3 : 0;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return self.interactive.interative ? self.interactive : nil;
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source NS_AVAILABLE_IOS(8_0){
    MKPresentationController * vc = [[MKPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    return vc;
}
@end


