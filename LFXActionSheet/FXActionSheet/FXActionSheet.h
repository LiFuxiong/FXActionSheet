//
//  FXActionSheet.h
//  text
//
//  Created by 李付雄 on 31/3/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXActionSheet;


@protocol FXActionSheetDelegate <NSObject>

@optional
/**
 *  点击按钮代理方法
 *
 *  @param actionSheet FXActionSheet对象
 *  @param buttonIndex 点击的按钮索引
 */
- (void)fxActionSheet:(FXActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;


@end

@interface FXActionSheet : UIView

@property (weak, nonatomic) id<FXActionSheetDelegate> delegate; //代理

@property(nonatomic,copy) NSString *title;  //标题

/**
 *  初始化方法
 *
 *  @param title                  提示标题
 *  @param delegate               代理对象
 *  @param cancelButtonTitle      取消按钮标题
 *  @param destructiveButtonTitle 按钮标题
 *  @param otherButtonTitles      其他按钮标题
 *
 *  @return FXActionSheet
 */
- (instancetype)initWithTitle:(NSString *)title delegate:(id<FXActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString*)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


/**
 *  视图显示
 */
- (void)show;


/**
 *  添加按钮
 *
 *  @param title 按钮标题
 *
 *  @return 返回tag值
 */
- (NSInteger)addButtonWithTitle:(NSString *)title;


/**
 *  返回标题
 *
 *  @param buttonIndex 索引值
 *
 *  @return 标题
 */
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;


@end
