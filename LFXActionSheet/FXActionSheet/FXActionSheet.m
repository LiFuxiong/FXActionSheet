//
//  FXActionSheet.m
//  text
//
//  Created by 李付雄 on 31/3/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FXActionSheet.h"
#import "UIViewExt.h"


#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define TITLEFONT [UIFont systemFontOfSize:14.0]

#define Margin 10
#define LINEMargin 0.5

static CGFloat const BTNH = 50;
@interface FXActionSheet ()

@property (strong, nonatomic) NSMutableArray *otherButtonTitles;  //otherButtonTitles标题
@property (copy, nonatomic) NSString *cancelButtonTitle ;//取消按钮标题
@property (copy, nonatomic) NSString * destructiveButtonTitle ; // destructive标题
@property (weak, nonatomic) UIView *parentView; //背景视图


@end

@implementation FXActionSheet

- (instancetype)initWithTitle:(NSString *)title delegate:(id<FXActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    if (self = [super init]) {
        //将代理对象保存
        self.delegate = delegate;
        
        //创建一个可变数组，保存所有按钮
        NSMutableArray *btnA = [NSMutableArray array];
        
        //定义一个指向参数的列表指针
        va_list params;
        //开始遍历
        va_start(params, otherButtonTitles);
        if (otherButtonTitles) {
            //把第一个数据放到数组中
            [btnA addObject:otherButtonTitles];
            id arg;
            //指针指向下一个变量
            while ((arg = va_arg(params, id))) {
                if (arg) {
                    [btnA addObject:arg];
                }
            }
            
            //置空
            va_end(params);
        }
        if (title.length != 0) {
            self.title = title;
        }
        
        if (destructiveButtonTitle.length != 0) {
            self.destructiveButtonTitle = destructiveButtonTitle;
        }
        
        if (btnA.count != 0) {
            [self.otherButtonTitles addObjectsFromArray:btnA];
        }
        if (cancelButtonTitle.length != 0) {
            self.cancelButtonTitle = cancelButtonTitle;
        }
    }
    return self;
}

#pragma mark
#pragma mark - 私有方法

/**
 *  初始化子视图
 */
- (void)_initWithSubviews {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    
    //创建所有按钮的父视图
    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
    parentView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:parentView];
    self.parentView = parentView;
    
    
    //创建上面按钮的父视图
    CGFloat bgViewW = parentView.size.width - 2 * Margin;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(Margin, 0, bgViewW, 0)];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.layer.cornerRadius = 5;
    bgView.clipsToBounds = YES;
    [self.parentView addSubview:bgView];
    //创建标题
    CGFloat BgHeight = 0.0;
    
    if (self.title.length != 0) {
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgViewW, [self getLabelText:self.title withFont:TITLEFONT].height + Margin)];
        titleL.font = TITLEFONT;
        titleL.text = self.title;
        titleL.tag = 123;
        titleL.backgroundColor = [UIColor whiteColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.numberOfLines = 0;
        titleL.textColor = [UIColor lightGrayColor];
        [bgView addSubview:titleL];
        BgHeight = BgHeight + titleL.height + LINEMargin;
    }
    
    // 创建destructiveButton
    if (self.destructiveButtonTitle.length != 0) {
        UIButton *btn = [self buttonTitle:self.destructiveButtonTitle titleColor:[UIColor redColor] tag:1];
        btn.frame = CGRectMake(0, BgHeight, bgViewW, BTNH);
        [bgView addSubview:btn];
        BgHeight = BgHeight + btn.height + LINEMargin;
    }
    
    //创建otherButton
    NSUInteger countNum = self.otherButtonTitles.count;
    for (NSUInteger i = 0; i < countNum; i ++) {
        UIButton *btn = [self buttonTitle:self.otherButtonTitles[i] titleColor:[UIColor blackColor] tag:self.destructiveButtonTitle.length != 0 ? i + 2 : i + 1];
        btn.frame = CGRectMake(0, BgHeight, bgViewW, BTNH);
        [bgView addSubview:btn];
        BgHeight = BgHeight + btn.height + .7;
    }
    bgView.height = BgHeight;
    
    //创建cancelButton
    if (self.cancelButtonTitle.length != 0) {
        UIButton *btn = [self buttonTitle:self.cancelButtonTitle titleColor:[UIColor blackColor] tag:countNum + 2];
        btn.frame = CGRectMake(Margin, BgHeight + Margin, bgViewW, BTNH);
        [parentView addSubview:btn];
        BgHeight = BgHeight + btn.height + Margin;
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
    }
    self.parentView.height = BgHeight + Margin;
}

/**
 *   创建按钮
 *
 *  @param title      按钮标题
 *  @param titleColor 标题颜色
 *  @param btnTag     tag值
 *
 *  @return 按钮对象
 */
- (UIButton *)buttonTitle:(NSString *)title titleColor:(UIColor *)titleColor  tag:(NSInteger)btnTag{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (titleColor) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    } else {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [btn setBackgroundColor:[UIColor whiteColor]];
    if (btnTag) {
        btn.tag = btnTag;
    }
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}



/**
 *  文本大小
 *
 *  @param labelString 文本
 *  @param font        Font
 *
 *  @return CGSize
 */
- (CGSize)getLabelText:(NSString *)labelString withFont:(UIFont *)font{
    NSMutableParagraphStyle *labelStyle = [[NSMutableParagraphStyle alloc]init];
    labelStyle.lineSpacing = 1;
    labelStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{ NSFontAttributeName:font,   NSParagraphStyleAttributeName:labelStyle};
    CGSize size = [labelString boundingRectWithSize:CGSizeMake(self.parentView.width - 20, SCREEN_HEIGHT) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading  attributes:attributes context:nil].size;
    return size;
}


#pragma mark
#pragma mark - 懒加载
- (NSMutableArray *)otherButtonTitles {
    if (!_otherButtonTitles) {
        _otherButtonTitles = [NSMutableArray array];
    }
    return _otherButtonTitles;
}


#pragma mark
#pragma mark -- 按钮点击方法
- (void)btnAction:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(fxActionSheet:clickedButtonAtIndex:)]) {
        [self.delegate fxActionSheet:self clickedButtonAtIndex:btn.tag - 1];
    }
    [self hidden];
}

/**
 *  显示视图
 */
- (void)show {
    //初始化子视图
    [self _initWithSubviews];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:.35 animations:^{
        _parentView.top = SCREEN_HEIGHT - _parentView.height;
    }];
}

/**
 *  隐藏视图
 */
- (void)hidden {
    [UIView animateWithDuration:.35 animations:^{
        _parentView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


/**
 *  设置标题
 *
 *  @param title 标题
 */
- (void)setTitle:(NSString *)title {
    _title = title;
    UILabel *label = (UILabel *)[self.parentView viewWithTag:123];
    label.text = title;
}


/**
 *  添加按钮
 *
 *  @param title 按钮标题
 *
 *  @return 返回tag值
 */
- (NSInteger)addButtonWithTitle:(NSString *)title {
    [self.otherButtonTitles addObject:title];
    return self.destructiveButtonTitle.length != 0 ? self.otherButtonTitles.count + 2 : self.otherButtonTitles.count;
}



/**
 *  返回标题
 *
 *  @param buttonIndex 索引值
 *
 *  @return 标题
 */
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex {
    UIButton *btn = (UIButton *)[self.parentView viewWithTag:buttonIndex + 1];
    return btn.titleLabel.text;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hidden];
}


@end
