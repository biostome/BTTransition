//
//  BTCoverVerticalTransitionAnimation.h
//  MKTransitionAnimation
//
//  Created by leishen on 2019/11/21.
//  Copyright © 2019 leishen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface BTCoverVerticalTransition : NSObject<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

- (instancetype)initPresentViewController:(UIViewController*)viewController;

- (instancetype)initPresentViewController:(UIViewController*)viewController withRragDismissEnabal:(BOOL)enabel;

@end

NS_ASSUME_NONNULL_END
