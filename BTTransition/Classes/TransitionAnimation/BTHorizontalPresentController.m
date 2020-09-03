//
//  BTHorizontalPresentController.m
//  BTTransition
//
//  Created by leishen on 2020/2/5.
//

#import "BTHorizontalPresentController.h"


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
        _dimmingView = nil;
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
