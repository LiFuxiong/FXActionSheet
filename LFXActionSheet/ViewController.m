//
//  ViewController.m
//  LFXActionSheet
//
//  Created by apple on 5/4/16.
//  Copyright © 2016年 LFX. All rights reserved.
//

#import "ViewController.h"
#import "FXActionSheet.h"

@interface ViewController ()<FXActionSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    FXActionSheet *actionSheet = [[FXActionSheet alloc] initWithTitle:@"niahshdishadhjshajdhsjkahdjshajhdjsahdjksajkhdjsahdjhasjhdjhao" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"123" otherButtonTitles:@"234",@"345", nil];
    actionSheet.title = @"测试" ;
    [actionSheet addButtonWithTitle:@"你哈"];
    [actionSheet show];
}

#pragma mark
#pragma mark --- FXActionSheetDelegate
- (void)fxActionSheet:(FXActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%ld---------%@",buttonIndex,[actionSheet buttonTitleAtIndex:buttonIndex]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
