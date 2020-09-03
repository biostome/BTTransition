//
//  BTHorizontalPresentController.h
//  BTTransition
//
//  Created by leishen on 2020/2/5.
//

#import <UIKit/UIKit.h>
#import "BTTransitionAnimationDelegate.h"

NS_ASSUME_NONNULL_BEGIN


@interface BTHorizontalPresentController : UIPresentationController<UIAdaptivePresentationControllerDelegate>
@property (nonatomic, strong) UIButton *dimmingView;
/// 背景是否可交互 默认为YES 修改请重写
@property (nonatomic, assign) BOOL backgroundUserInteractionEnabled;

@property (nonatomic, weak) id<BTPresentedViewControllerDelegate> preDelegate;
@end




NS_ASSUME_NONNULL_END
