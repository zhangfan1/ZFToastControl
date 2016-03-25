#import "ZFToast.h"

@interface ZFToast ()

/// @brief 存放文本的UILabel
@property (strong,nonatomic) UILabel *textLabel;
@property (strong,nonatomic) ZFToast *toast;
@property (strong,nonatomic) NSTimer *timer;
/// @brief 记录是否移除
@property (assign,nonatomic) NSInteger currentDate;

@end
@implementation ZFToast

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.toast = [[ZFToast alloc] init];
        self.currentDate = 0;
    }
    
    return self;
}

+ (instancetype)shareClient
{
    static ZFToast *zfToast = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        zfToast = [[ZFToast alloc] init];
    });
    
    return zfToast;
}

- (void)popUpToastWithMessage:(NSString *)message
{
    /// @brief 创建定时器
    [self createTimer];
    /// @brief 初始化Label
    [self initLabel:message];
    /// @brief 初始化底层视图
    [self initBottomView];
    
}

#pragma mark - 创建定时器
- (void)createTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
    //暂停定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    
}

#pragma mark - 初始化Label
- (void)initLabel:(NSString *)message
{
    //获取屏幕宽度
    CGFloat screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    //获取屏幕高度
    CGFloat screenHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    /// @brief Label的字号
    UIFont *font = [UIFont systemFontOfSize:15];
    /// @brief 控件的宽
    CGFloat width = screenWidth / 3.0 * 2.0;
    /// @brief Label所需的宽高
    CGSize labelSize = [self calculationTextNeedSize:message andFont:15 andWidth:width];
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, labelSize.width, labelSize.height)];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = font;
    self.textLabel.text = message;
    self.textLabel.numberOfLines = 0;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - 初始化底层视图
- (void)initBottomView
{
    //获取屏幕宽度
    CGFloat screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    //获取屏幕高度
    CGFloat screenHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    self.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.8];
    self.frame = CGRectMake((screenWidth - self.textLabel.frame.size.width)/2.0, (screenHeight - self.textLabel.frame.size.height)/2.0, self.textLabel.frame.size.width + 20, self.textLabel.frame.size.height + 20);
    [self addSubview:self.textLabel];
    //设置ImageView是否可以设为圆角
    self.layer.masksToBounds = YES;
    //设置圆角度数
    self.layer.cornerRadius = 10;
    UIViewController *vc = [self getCurrentVC];
    [vc.view addSubview:self];
    //启动定时器
    [self.timer setFireDate:[NSDate distantPast]];
}

#pragma mark - 取到当前控制器
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (void)onTimer
{
    self.currentDate++;
    if (self.currentDate == 2) {
        //暂停定时器
        [self.timer setFireDate:[NSDate distantFuture]];
        [self removeFromSuperview];
        self.currentDate = 0;
    }
    
}

#pragma mark - 计算文本所需大小
- (CGSize)calculationTextNeedSize:(NSString *)text andFont:(CGFloat)font andWidth:(CGFloat)width
{
    CGSize labelSize = [text sizeWithFont: [UIFont boldSystemFontOfSize:font]
                        constrainedToSize: CGSizeMake(width, MAXFLOAT )
                            lineBreakMode: UILineBreakModeWordWrap];
    
    return labelSize;
}

@end
