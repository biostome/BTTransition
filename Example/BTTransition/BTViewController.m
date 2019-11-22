//
//  BTViewController.m
//  BTTransition
//
//  Created by 453816118@qq.com on 11/22/2019.
//  Copyright (c) 2019 453816118@qq.com. All rights reserved.
//

#import "BTViewController.h"
#import "BTPresentViewController.h"

@interface BTViewController ()

@end

@implementation BTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    BTPresentViewController * vc = [[BTPresentViewController alloc]init];;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
}
@end
