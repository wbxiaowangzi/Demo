//
//  AppDebugger.m
//

#import "AppDebugger.h"
#import "SwitchServer.h"
#import "ShowFlex.h"
#import "CheckAnalysis.h"
#import "ShowNavigator.h"
#import "ShowMemory.h"

static const NSInteger tag = 0x8888;
static const CGFloat width = 300;
static const CGFloat height = 170;
static const CGFloat btnWidth = 80;
static const CGFloat btnHeight = 24;
static const NSInteger countPerLine = 3;

#ifdef DEBUG
BOOL needShow = YES;
#else
BOOL needShow = NO;
#endif

@interface AppDebugger ()

@property(nonatomic, strong) UIWindow *debugBar;
@property(nonatomic, strong) UIView *panel;

@end

@implementation AppDebugger {
    UILabel *_fpsLabel;
    UILabel *_idLabel;
    NSTimeInterval _lastTime;
    int _count;
    CADisplayLink *_displayLink;
    BOOL _isShowing;
}

- (NSArray *)buttonTitles {
    NSMutableArray *titles = [NSMutableArray array];
    [titles addObjectsFromArray: [SwitchServer titles]];
    [titles addObjectsFromArray: [ShowFlex titles]];
    [titles addObjectsFromArray: [CheckAnalysis titles]];
    [titles addObjectsFromArray: [ShowNavigator titles]];
    [titles addObjectsFromArray: [ShowMemory titles]];
    return titles;
}

- (NSArray<ClickBlock> *)buttonActions {
    NSMutableArray *actions = [NSMutableArray array];
    [actions addObjectsFromArray: [SwitchServer selectors]];
    [actions addObjectsFromArray: [ShowFlex selectors]];
    [actions addObjectsFromArray: [CheckAnalysis selectors]];
    [actions addObjectsFromArray: [ShowNavigator selectors]];
    [actions addObjectsFromArray: [ShowMemory selectors]];
    return actions;
}

+ (void)load {
    __block __weak NSObject *observer =
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      [[AppDebugger sharedDebugger] show];
                                                      [[NSNotificationCenter defaultCenter] removeObserver:observer];
                                                  }];
}

+ (instancetype)sharedDebugger {
    static id sharedDebugger;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedDebugger = [self new];
    });
    
    return sharedDebugger;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.debugBar = [[UIWindow alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 40, 0, 130, 20)];
        self.debugBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.debugBar.windowLevel = UIWindowLevelAlert;
        self.debugBar.rootViewController = [UIViewController new];
        self.debugBar.hidden = !needShow;
        
        UIGestureRecognizer *gesture = [UITapGestureRecognizer new];
        [gesture addTarget:self action:@selector(showPanel)];
        [self.debugBar addGestureRecognizer:gesture];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 18, 20)];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"🐞";
        [self.debugBar addSubview:label];
        
        _fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 60, 20)];
        _fpsLabel.backgroundColor = [UIColor clearColor];
        _fpsLabel.textAlignment = NSTextAlignmentLeft;
        _fpsLabel.textColor = [UIColor orangeColor];
        _fpsLabel.font = [UIFont systemFontOfSize:12];
        [self.debugBar addSubview:_fpsLabel];
        
        _lastTime = 0;
        _count = 0;
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onTick:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        _displayLink.preferredFramesPerSecond = 1;
        
        _isShowing = NO;
    }
    return self;
}

- (void)onTick:(CADisplayLink *)displayLink {
    if (_lastTime == 0) {
        _lastTime = displayLink.timestamp;
        return;
    }
    _count++;
    NSTimeInterval delta = displayLink.timestamp - _lastTime;
    if (delta < 1) return;
    _fpsLabel.text = [NSString stringWithFormat:@"%.2f", _count / delta];
    _lastTime = displayLink.timestamp;
    _count = 0;
}

- (void)show {
    if (needShow){
        self.debugBar.hidden = NO;
    }
}

- (UIView *)panel {
    if (!_panel) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        panel.backgroundColor = [UIColor clearColor];
        
        UIGestureRecognizer *gesture = [UITapGestureRecognizer new];
        [gesture addTarget:self action:@selector(closePanel)];
        [panel addGestureRecognizer:gesture];
        
        UIView *content = [[UIView alloc] initWithFrame:CGRectMake(size.width / 2 - width/2, -height, width, height)];
        content.backgroundColor = [UIColor colorWithRed:0xd8/255.f
                                                  green:0xd8/255.f
                                                   blue:0xd8/255.f
                                                  alpha:1];
        content.layer.cornerRadius = 2;
        content.layer.masksToBounds = YES;
        content.layer.borderWidth = 0.5;
        content.layer.borderColor = [UIColor colorWithRed:0xb0/255.f
                                                    green:0xb0/255.f
                                                     blue:0xb0/255.f
                                                    alpha:1].CGColor;
        
        [panel addSubview:content];
        content.tag = tag;
        
        CGFloat marginX = (width - countPerLine * btnWidth) / (countPerLine + 1);
        CGFloat marginY = 15;
        CGFloat y0 = 25;
        
        UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, y0, width - marginX * 2, 15)];
        idLabel.font = [UIFont systemFontOfSize:13];
        [content addSubview:idLabel];
        _idLabel = idLabel;
        
        UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, y0, width - marginX * 2, 15)];
        versionLabel.text = [NSString stringWithFormat:@"Build: %@", [self buildVersion]];
        versionLabel.font = [UIFont systemFontOfSize:11];
        versionLabel.textAlignment = NSTextAlignmentRight;
        [content addSubview:versionLabel];
        
        y0 = 52;
        CGFloat x = 0;
        CGFloat y = 0;
        
        NSMutableArray *buttons = [NSMutableArray array];
        for (int i = 0; i < [self buttonTitles].count; i ++) {
            x = marginX + (i % 3) * (btnWidth + marginX);
            y = y0 + (i / 3) * (btnHeight + marginY);
            
            NSArray *titles = [[self buttonTitles] objectAtIndex:i];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, btnWidth, btnHeight)];
            button.backgroundColor = [UIColor whiteColor];
            button.layer.cornerRadius = 3;
            button.layer.masksToBounds = YES;
            button.layer.borderWidth = 0.5;
            button.tag = i;
            button.layer.borderColor = [UIColor colorWithRed:0xb0/255.f
                                                       green:0xb0/255.f
                                                        blue:0xb0/255.f
                                                       alpha:1].CGColor;
            
            NSMutableAttributedString *title1 = (NSMutableAttributedString *)[self attributedTitle:[titles objectAtIndex:0] forState:UIControlStateNormal];
            NSMutableAttributedString *title2 = (NSMutableAttributedString *)[self attributedTitle:[titles objectAtIndex:1] forState:UIControlStateSelected];
            [button setAttributedTitle:title1 forState:UIControlStateNormal];
            [button setAttributedTitle:title2 forState:UIControlStateSelected];
            [button addTarget:self
                       action:@selector(clickButton:)
             forControlEvents:UIControlEventTouchUpInside];
            [content addSubview:button];
            [buttons addObject:button];
        }
        NSInteger server = [[NSUserDefaults standardUserDefaults] integerForKey:@"debugServerTypeKey"];
        [[buttons objectAtIndex:server] setSelected:YES];
        _panel = panel;
    }
    
    return _panel;
}

- (void)closePanel {
    _isShowing = NO;
    
    if (self.panel.superview) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.panel viewWithTag:tag].frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - width/2,
                                                            -height,
                                                            width,
                                                            height);
        } completion:^(BOOL finished) {
            [self.panel removeFromSuperview];
        }];
    }
}

- (void)showPanel {
    if (_isShowing) return;
    
    _isShowing = YES;
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self.panel];
    [UIView animateWithDuration:0.3 animations:^{
        [self.panel viewWithTag:tag].frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - width/2,
                                                        0,
                                                        width,
                                                        height);
    }];
    _idLabel.text = [NSString stringWithFormat:@"ID: %@", [self userID]];
}

- (void)clickButton: (UIButton *)sender {
    [self closePanel];
    NSString *normal = [[sender attributedTitleForState:UIControlStateNormal] string];
    NSString *selected = [[sender attributedTitleForState:UIControlStateSelected] string];
    if (![normal isEqualToString:selected]) {
        [sender setSelected:!sender.isSelected];
    }
    NSInteger tag = sender.tag;
    NSArray *actions = [self buttonActions];
    if (tag < [actions count]) {
        ClickBlock block = actions[tag];
        block();
    }
}

- (NSAttributedString *)attributedTitle: (NSString *)title forState:(UIControlState)state {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:title];
    UIFont *font = nil;
    if ([title length] > 5) {
        font = [UIFont systemFontOfSize:10];
    } else {
        font = [UIFont systemFontOfSize:12];
    }
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    switch (state) {
        case UIControlStateNormal:
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.length)];
            break;
            
        case UIControlStateHighlighted:
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, string.length)];
            break;
        case UIControlStateSelected:
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, string.length)];
            break;
        default:
            break;
    }
    
    return string;
}

- (NSString *)buildVersion {
    NSString *buildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"%@(%@)", version, buildVersion];
}

- (NSString *)userID {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = @"";
    if ([paths count] > 0) {
        path = [NSString stringWithFormat:@"%@/com.haomaiyi.M.Session.User", paths[0]];
    }
    
    NSString *jsonString = [NSKeyedUnarchiver unarchiveObjectWithFile: path];
    NSString *message = @"xxx";
    if (jsonString) {
        NSError *error = [NSError new];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                            options:NSJSONReadingMutableContainers
                                                              error:&error];
        if ([[dic allKeys] containsObject: @"user_id"]) {
            message = [NSString stringWithFormat:@"%@", @([[dic objectForKey:@"user_id"] integerValue])];
        }
    }
    return message;
}

@end
