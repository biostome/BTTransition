//
//  BTCoverHorizontalTransition.h
//  MKLotteryTicketSDK
//
//  Created by leishen on 2019/12/20.
//  Copyright © 2019 smoke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTTransitionAnimationDelegate.h"

NS_ASSUME_NONNULL_BEGIN


@interface BTCoverHorizontalDismissInteractive : UIPercentDrivenInteractiveTransition<UIGestureRecognizerDelegate>
@end

@interface BTCoverHorizontalPresentInteractive : UIPercentDrivenInteractiveTransition<UIGestureRecognizerDelegate>
- (void)addPanGestureToViewController:(UIViewController*)viewController;
@property (nonatomic, weak) id<BTInteractiveTransitionDelegate> delegate;
@end

@interface BTCoverHorizontalTransition : NSObject<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>


- (instancetype)initPresentViewController:(UIViewController<BTTransitionAnimationDelegate>*)viewController;

- (instancetype)initPresentViewController:(UIViewController<BTTransitionAnimationDelegate>*)viewController withRragDismissEnabal:(BOOL)enabel;

@property (nonatomic, weak) BTCoverHorizontalPresentInteractive *presentInteractive;

/// 背景是否可交互 默认为YES 修改请重写
@property (nonatomic, assign) BOOL backgroundUserInteractionEnabled;



@end

NS_ASSUME_NONNULL_END
