//
//  BTCoverHorizontalDismissInteractive.h
//  BTTransition
//
//  Created by leishen on 2020/2/5.
//

#import <UIKit/UIKit.h>
#import "BTTransitionAnimationDelegate.h"

NS_ASSUME_NONNULL_BEGIN


@interface BTCoverHorizontalDismissInteractive : UIPercentDrivenInteractiveTransition<UIGestureRecognizerDelegate>
- (instancetype)initWithViewController:(UIViewController*)viewController;
@property (nonatomic, weak) id<BTInteractiveTransitionDelegate> delegate;
@property (nonatomic, assign) BOOL interative;
@end

NS_ASSUME_NONNULL_END
