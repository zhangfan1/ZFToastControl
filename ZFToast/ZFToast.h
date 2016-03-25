/**
 *  @file
 *  @author 张凡
 *  @date 2016/3/25
 */
#import <UIKit/UIKit.h>

/**
 *  @class ZFToast
 *  @brief Toast弹窗控件
 *  @author 张凡
 *  @date 2016/3/25
 */

/**
 *  @使用方法
 *  [[ZFToast shareClient] popUpToastWithMessage:@"提示文字"];
 */

@interface ZFToast : UIView

/// @brief 单例
+ (instancetype)shareClient;
/// @brief 文本提示框
- (void)popUpToastWithMessage:(NSString *)message;

@end
