//
//  BTCoverHorizontalDismissInteractive.m
//  BTTransition
//
//  Created by leishen on 2020/2/5.
//

#import "BTCoverHorizontalDismissInteractive.h"



@interface BTCoverHorizontalDismissInteractive ()
@property (nonatomic, weak) UIViewController *viewController;
@end

@implementation BTCoverHorizontalDismissInteractive
- (instancetype)initWithViewController:(UIViewController*)viewController{
    self = [super init];
    if (self) {
        self.viewController = viewController;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        pan.delegate = self;
        [viewController.view addGestureRecognizer:pan];
    }
    return self;
}


- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    CGFloat percent = -[panGesture translationInView:panGesture.view].x / CGRectGetWidth(panGesture.view.frame);
    CGFloat speed = [panGesture velocityInView:panGesture.view].x;; //速度方法
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
            self.interative = YES;
            if (percent >= 0) {
                [self.viewController dismissViewControllerAnimated:YES completion:^{
                    if ([self.delegate respondsToSelector:@selector(dismissFinishForInteractive:)]) {
                        [self.delegate dismissFinishForInteractive:self];
                    }
                }];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:{
            [self updateInteractiveTransition:percent];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            self.interative = NO;
            BOOL should = YES;
            if ([self.delegate respondsToSelector:@selector(shouldDismissForInteractive:)]) {
                should = [self.delegate shouldDismissForInteractive:self];
            }
            if (should==NO) {
                [self cancelInteractiveTransition];
                if ([self.delegate respondsToSelector:@selector(cancelDismissForInteractive:)]) {
                    [self.delegate cancelDismissForInteractive:self];
                }
                return;
            }
            if (percent > 0.1 || speed < -800) {
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
                if ([self.delegate respondsToSelector:@selector(cancelDismissForInteractive:)]) {
                    [self.delegate cancelDismissForInteractive:self];
                }
            }
            break;
        }
        default:
            break;
    }
}


@end
