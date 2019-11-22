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

@interface BTCoverVerticalTransition : NSObject<UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>

- (instancetype)initPresentViewController:(UIViewController*)viewController;
@end

NS_ASSUME_NONNULL_END
