//
//  BTViewController.m
//  BTTransition
//
//  Created by 453816118@qq.com on 11/22/2019.
//  Copyright (c) 2019 453816118@qq.com. All rights reserved.
//

#import "BTViewController.h"
#import "BTPresentViewController.h"
#import <BTCoverHorizontalTransition.h>
#import "BTLeftViewController.h"
#import "BTCoverHorizontalPresentInteractive.h"

@interface BTViewController ()<BTInteractiveTransitionDelegate,UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) BTCoverHorizontalPresentInteractive *persentInteractive;
@end

@implementation BTViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    BTCoverHorizontalPresentInteractive * persentInteractive = [[BTCoverHorizontalPresentInteractive alloc]init];
    self.persentInteractive = persentInteractive;
    persentInteractive.delegate = self;
    [persentInteractive addPanGestureToViewController:self];
}

- (IBAction)presentBAction:(id)sender {
    BTPresentViewController * vc = [[BTPresentViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - BTInteractiveTransitionDelegate
- (void)beginPresentViewControllerForInteractive:(UIPercentDrivenInteractiveTransition *)intractive{
    BTLeftViewController * vc = [[BTLeftViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
