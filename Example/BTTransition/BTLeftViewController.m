//
//  BTLeftViewController.m
//  BTTransition_Example
//
//  Created by leishen on 2020/1/29.
//  Copyright © 2020 453816118@qq.com. All rights reserved.
//

#import "BTLeftViewController.h"
#import <BTCoverHorizontalTransition.h>
#import <BTCoverHorizontalDismissInteractive.h>
#import "BTHorizontalPresentController.h"
#import "BTViewController.h"
#import "objc/runtime.h"

@interface BTLeftViewController ()<BTTransitionAnimationDelegate,UIViewControllerTransitioningDelegate,UIAdaptivePresentationControllerDelegate>
@property (nonatomic, strong) BTCoverHorizontalDismissInteractive *dismissInteractive;
@end

@implementation BTLeftViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.dismissInteractive = [[BTCoverHorizontalDismissInteractive alloc]initWithViewController:self];
        self.dismissInteractive.delegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor.yellowColor colorWithAlphaComponent:1];
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
}

- (void)dealloc{
    NSLog(@"%@ is %@",NSStringFromClass(self.class),NSStringFromSelector(_cmd));
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection {
    // 适配屏幕，横竖屏
    self.preferredContentSize = CGSizeMake(traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact ? 600 : 300, self.view.bounds.size.height);
}


/// 屏幕旋转时调用的方法
/// @param newCollection 新的方向
/// @param coordinator 动画协调器
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [self updatePreferredContentSizeWithTraitCollection:newCollection];
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    NSLog(@"%@",viewControllerToCommit);;
}


#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    return self.dismissInteractive;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    return self.persentInteractive;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[BTCoverHorizontalTransition alloc]init];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[BTCoverHorizontalTransition alloc]init];
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source API_AVAILABLE(ios(8.0)){
    BTCoverHorizontalPresentInteractive * interactive = [source valueForKeyPath:@"persentInteractive"];
    self.persentInteractive = interactive;
    BTHorizontalPresentController * c = [[BTHorizontalPresentController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    return c;
}


@end
