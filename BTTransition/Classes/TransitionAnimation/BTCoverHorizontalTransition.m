//
//  BTCoverHorizontalTransition.m
//  MKLotteryTicketSDK
//
//  Created by leishen on 2019/12/20.
//  Copyright © 2019 smoke. All rights reserved.
//

#import "BTCoverHorizontalTransition.h"

@interface BTHorizontalPresentController : UIPresentationController
@property (nonatomic, strong) UIButton *dimmingView;
/// 背景是否可交互 默认为YES 修改请重写
@property (nonatomic, assign) BOOL backgroundUserInteractionEnabled;

@property (nonatomic, weak) id<BTPresentedViewControllerDelegate> preDelegate;
@end

@implementation BTHorizontalPresentController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        [self.containerView addSubview:self.presentedView];
        self.backgroundUserInteractionEnabled = YES;
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
    presentedViewControllerFrame.size.width = presentedViewContentSize.width;
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
        _dimmingView.userInteractionEnabled = self.backgroundUserInteractionEnabled;
    }
    return _dimmingView;
}

- (void)dismissAction:(UIButton*)sender{
    BOOL should = YES;
    if ([self.preDelegate respondsToSelector:@selector(shouldDismissForClickDimmingBackgoundViewOfPresentedViewController)]) {
        should = [self.preDelegate shouldDismissForClickDimmingBackgoundViewOfPresentedViewController];
    }
    if (should == NO) {
        return;
    }
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
        if ([self.preDelegate respondsToSelector:@selector(completionDismissForClickDimmingBackgroundOfPresentedViewController)]) {
            [self.preDelegate completionDismissForClickDimmingBackgroundOfPresentedViewController];
        }
    }];
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

@interface BTCoverHorizontalPresentInteractive ()
@property (nonatomic, assign) BOOL interative;
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
    CGFloat percent = transitionY / (panGesture.view.frame.size.width);
    _speed = [panGesture velocityInView:panGesture.view]; //速度方法
    _percent = MAX(0.0, MIN(percent, 1.0));
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

@interface BTCoverHorizontalDismissInteractive ()
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, assign) BOOL interative;
@property (nonatomic, weak) id<BTInteractiveTransitionDelegate> delegate;
@property (nonatomic, assign) BOOL beCancel;
@end

@implementation BTCoverHorizontalDismissInteractive
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
    CGFloat percent = -[panGesture translationInView:panGesture.view].x / CGRectGetWidth(panGesture.view.frame);
    CGFloat speed = [panGesture velocityInView:panGesture.view].x;; //速度方法
    percent = MAX(0.0, MIN(percent, 1.0));
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
            self.interative = YES;
            if (percent >= 0) {
                [self.viewController dismissViewControllerAnimated:YES completion:^{
                    if ([self.delegate respondsToSelector:@selector(dismissFinishForInteractive:)]) {
                        [self.delegate dismissFinishForInteractive:self];
                    }
                }];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:{
            [self updateInteractiveTransition:percent];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            self.interative = NO;
            BOOL should = YES;
            if ([self.delegate respondsToSelector:@selector(shouldDismissForInteractive:)]) {
                should = [self.delegate shouldDismissForInteractive:self];
            }
            if (should==NO) {
                [self cancelInteractiveTransition];
                if ([self.delegate respondsToSelector:@selector(cancelDismissForInteractive:)]) {
                    [self.delegate cancelDismissForInteractive:self];
                }
                return;
            }
            if (percent > 0.1 || speed < -800) {
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
                if ([self.delegate respondsToSelector:@selector(cancelDismissForInteractive:)]) {
                    [self.delegate cancelDismissForInteractive:self];
                }
            }
            break;
        }
        default:
            break;
    }
}


@end



@interface BTCoverHorizontalTransition ()<BTTransitionAnimationDelegate>
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) BTCoverHorizontalDismissInteractive *dismissInteractive;
@property (nonatomic, weak) id<BTTransitionAnimationDelegate> delegate;
@end

@implementation BTCoverHorizontalTransition

- (instancetype)initPresentViewController:(__weak UIViewController<BTTransitionAnimationDelegate>*)viewController{
    self = [super init];
    if (self) {
        self.viewController = viewController;
        self.delegate = viewController;
        viewController.modalPresentationStyle = UIModalPresentationCustom;
        self.backgroundUserInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initPresentViewController:(__weak UIViewController<BTTransitionAnimationDelegate>*)viewController withRragDismissEnabal:(BOOL)enabel{
    self = [super init];
    if (self) {
        self.viewController = viewController;
        self.delegate = viewController;
        viewController.modalPresentationStyle = UIModalPresentationCustom;
        if (enabel == YES) {
            BTCoverHorizontalDismissInteractive * interactive = [[BTCoverHorizontalDismissInteractive alloc]initWithViewController:viewController];
            self.dismissInteractive = interactive;
            interactive.delegate = self;
        }
        self.backgroundUserInteractionEnabled = YES;
    }
    return self;
}


- (void)animateTransitionForPresentTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController * to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [transitionContext.containerView addSubview:to.view];
    CGRect finalFrame = [transitionContext finalFrameForViewController:to];
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
    CGRect finalFrame = [transitionContext finalFrameForViewController:from];
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
    return _dismissInteractive.interative ? _dismissInteractive : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    return _presentInteractive.interative ? _presentInteractive : nil;
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source NS_AVAILABLE_IOS(8_0){
    BTHorizontalPresentController * vc = [[BTHorizontalPresentController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    vc.preDelegate = self;
    vc.backgroundUserInteractionEnabled = self.backgroundUserInteractionEnabled;
    return vc;
}

#pragma mark - BTTransitionAnimationDelegate
- (BOOL)shouldDismissForClickDimmingBackgoundViewOfPresentedViewController{
    BOOL should = YES;
    if ([self.delegate respondsToSelector:@selector(shouldDismissForClickDimmingBackgoundViewOfPresentedViewController)]) {
        should = [self.delegate shouldDismissForClickDimmingBackgoundViewOfPresentedViewController];
    }
    return should;
}

- (void)completionDismissForClickDimmingBackgroundOfPresentedViewController{
    if ([self.delegate respondsToSelector:@selector(completionDismissForClickDimmingBackgroundOfPresentedViewController)]) {
        [self.delegate completionDismissForClickDimmingBackgroundOfPresentedViewController];
    }
}

- (BOOL)shouldDismissForInteractive:(UIPercentDrivenInteractiveTransition *)intractive{
    BOOL should = YES;
    if ([self.delegate respondsToSelector:@selector(shouldDismissForInteractive:)]) {
        should = [self.delegate shouldDismissForInteractive:intractive];
    }
    return should;
}

- (void)dismissFinishForInteractive:(UIPercentDrivenInteractiveTransition *)intractive{
    if ([self.delegate respondsToSelector:@selector(dismissFinishForInteractive:)]) {
        [self.delegate dismissFinishForInteractive:intractive];
    }
}

- (void)cancelDismissForInteractive:(UIPercentDrivenInteractiveTransition *)interactive{
    if ([self.delegate respondsToSelector:@selector(cancelDismissForInteractive:)]) {
        [self.delegate cancelDismissForInteractive:interactive];
    }
}

@end
