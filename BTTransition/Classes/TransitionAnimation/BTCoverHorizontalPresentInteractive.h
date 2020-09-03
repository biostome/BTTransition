//
//  BTCoverHorizontalPresentInteractive.h
//  BTTransition
//
//  Created by leishen on 2020/2/5.
//

#import <UIKit/UIKit.h>
#import "BTTransitionAnimationDelegate.h"

NS_ASSUME_NONNULL_BEGIN


@interface BTCoverHorizontalPresentInteractive : UIPercentDrivenInteractiveTransition<UIGestureRecognizerDelegate>
- (void)addPanGestureToViewController:(UIViewController*)viewController;
@property (nonatomic, weak) id<BTInteractiveTransitionDelegate> delegate;
@property (nonatomic, assign) BOOL interative;
@end

NS_ASSUME_NONNULL_END
