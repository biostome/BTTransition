//
//  BTPresentViewController.m
//  BTTransition_Example
//
//  Created by leishen on 2019/11/22.
//  Copyright © 2019 453816118@qq.com. All rights reserved.
//

#import "BTPresentViewController.h"
#import <BTCoverVerticalTransition.h>


@interface BTPresentViewController ()

@property (nonatomic, strong) BTCoverVerticalTransition *aniamtion;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@end

@implementation BTPresentViewController


- (instancetype)init{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"BTPresentViewController"];;
    if (self) {
        _aniamtion = [[BTCoverVerticalTransition alloc]initPresentViewController:self];
        self.transitioningDelegate = _aniamtion;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _aniamtion = [[BTCoverVerticalTransition alloc]initPresentViewController:self];
        self.transitioningDelegate = _aniamtion;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _aniamtion = [[BTCoverVerticalTransition alloc]initPresentViewController:self];
    self.transitioningDelegate = _aniamtion;
    self.view.backgroundColor = [UIColor.greenColor colorWithAlphaComponent:1];
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
}

- (IBAction)sliderAction:(UISlider *)sender {
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, sender.value);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection {
    // 适配屏幕，横竖屏
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact ? 270 : 420);
    
    self.slider.maximumValue = self.preferredContentSize.height;
    self.slider.minimumValue = 220.f;
    self.slider.value = self.slider.maximumValue;
}


/// 屏幕旋转时调用的方法
/// @param newCollection 新的方向
/// @param coordinator 动画协调器
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [self updatePreferredContentSizeWithTraitCollection:newCollection];
}

- (void)dealloc{
    NSLog(@"!!~~");
}


@end
