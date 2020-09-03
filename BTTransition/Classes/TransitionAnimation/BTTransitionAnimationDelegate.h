//
//  BTTransitionAnimationDelegate.h
//  MKLotteryTicketSDK
//
//  Created by leishen on 2019/12/23.
//  Copyright © 2019 smoke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BTPresentedViewControllerDelegate <UIAdaptivePresentationControllerDelegate>
@optional

/// 点击背景视图关闭前代理方法 默认YES，返回NO则点击不会关闭视图
- (BOOL)shouldDismissForClickDimmingBackgoundViewOfPresentedViewController;

/// 点击背景视图关闭成功回调方法
- (void)completionDismissForClickDimmingBackgroundOfPresentedViewController;
@end

@protocol BTInteractiveTransitionDelegate <NSObject>
@optional

/// 手势关闭控制器前的方法，返回YES则可直接关闭，返回NO则会取消动画返回原位置
/// @param intractive 驱动手势
- (BOOL)shouldDismissForInteractive:(UIPercentDrivenInteractiveTransition*)intractive;

/// 手势关闭控制器完成后的方法
/// @param intractive 驱动手势
- (void)dismissFinishForInteractive:(UIPercentDrivenInteractiveTransition*)intractive;

/// 呈现手势在Begin时的方法
/// @param intractive 呈现时的驱动手势
- (void)beginPresentViewControllerForInteractive:(UIPercentDrivenInteractiveTransition*)intractive;

/// 取消呈现时的代理方法
/// @param interactive 呈现时的驱动手势
- (void)cancelPresentForInteractive:(UIPercentDrivenInteractiveTransition*)interactive;

/// 取消退场动画时的代理方法
/// @param interactive 关闭时的驱动手势
- (void)cancelDismissForInteractive:(UIPercentDrivenInteractiveTransition*)interactive;
@end

@protocol BTTransitionAnimationDelegate <BTInteractiveTransitionDelegate,BTPresentedViewControllerDelegate>

@end

NS_ASSUME_NONNULL_END
