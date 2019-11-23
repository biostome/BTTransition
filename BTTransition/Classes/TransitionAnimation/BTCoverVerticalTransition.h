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

- (instancetype)initPresentViewController:(UIViewController*)viewController withRragDismissEnabal:(BOOL)enabel;

/// 背景是否可交互 默认为YES 修改请重写
@property (nonatomic, assign,readonly) BOOL backgroundUserInteractionEnabled;
@end

NS_ASSUME_NONNULL_END
