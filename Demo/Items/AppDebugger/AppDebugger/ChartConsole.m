//
//  ChartConsole.m
//  Pods
//
//

#import "ChartConsole.h"

@interface ConsoleView : UIView

@end

@implementation ConsoleView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return nil;
}

@end

@interface Line : NSObject

@property(nonatomic, assign) double start;
@property(nonatomic, assign) double end;

@end

@implementation Line

@end

@interface LineCell : UICollectionViewCell

@property(nonatomic, strong) Line *line;
@property(nonatomic, assign) double reference;

@end

@implementation LineCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    CGContextSetLineWidth(context, 1);
    CGContextSetRGBStrokeColor(context, 70.0 / 255.0, 241.0 / 255.0, 241.0 / 255.0, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, self.frame.size.height - (self.line.start - self.reference));
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height - (self.line.end - self.reference));
    CGContextStrokePath(context);
}

@end


@implementation ChartConsole {
    
    ConsoleView *_consoleView;
    UICollectionView *_collectionView;
    
    NSArray<UILabel *> *_scaleLabels;
    NSMutableArray<Line *> *_lines;
    
    double _reference;
}

+ (instancetype)sharedConsole {
    static id instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    
    return instance;
}

- (BOOL)isShowing {
    return [_consoleView superview] != nil;
}

- (void)hide {
    if ([_consoleView superview]) {
        [_consoleView removeFromSuperview];
    }
    [_lines removeAllObjects];
}

- (void)updateValue:(double)value {
    if (![_consoleView superview]) {
        [[[[UIApplication sharedApplication] delegate] window] addSubview:_consoleView];
    }
    Line *line = [Line new];
    line.end = value;
    if (_lines.count == 0) {
        line.start = 0;
    } else {
        line.start = [_lines lastObject].end;
    }
    
    [_lines addObject:line];
    if (_lines.count > 20) {
        [_lines removeObjectsInRange:NSMakeRange(0, _lines.count-20)];
    }
    _collectionView.reloadData;
    _collectionView.setNeedsLayout;
    [_collectionView layoutIfNeeded];
    [_collectionView setContentOffset:CGPointMake(10 + MAX(0, _lines.count * 40 - _collectionView.frame.size.width), 0)];
    
    _reference = (int)(value / 100) * 100.0;
    
    [self updateScaleLabels];
}

- (void)updateScaleLabels {
    int idx = 0;
    for (UILabel *label in _scaleLabels) {
        label.text = [NSString stringWithFormat:@"%@M", @(_reference + idx * 50)];
        idx ++;
    }
}

- (id)init {
    self = [super init];
    if (self) {
        _lines = [NSMutableArray array];
        
        _consoleView = [[ConsoleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
        _consoleView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        
        CGRect collectionFrame = CGRectMake(30, 0, _consoleView.frame.size.width - 50, _consoleView.frame.size.height);
        
        int y = 0;
        int margin = 50;
        int count = _consoleView.frame.size.height / margin;
        NSMutableArray *labels = [NSMutableArray array];
        for (int i = 0; i < count; i ++) {
            CGFloat currentY = collectionFrame.size.height - (y + i * margin);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, currentY - 12, 30, 12)];
            label.textColor = [UIColor colorWithWhite:1 alpha:0.6];
            label.font = [UIFont systemFontOfSize:10];
            label.textAlignment = NSTextAlignmentCenter;
            [_consoleView addSubview:label];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(collectionFrame.origin.x, currentY - 0.5, collectionFrame.size.width, 0.5)];
            line.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
            [_consoleView addSubview:line];
            
            [labels addObject:label];
            if (i == 0) {
                [line setHidden:YES];
            }
        }
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(40, collectionFrame.size.height);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:layout];
        [_consoleView addSubview:_collectionView];
        _collectionView.dataSource = self;
        [_collectionView registerClass:LineCell.class forCellWithReuseIdentifier:@"indexpath"];
        _collectionView.backgroundColor = [UIColor clearColor];
        
        _scaleLabels = labels;
    }
    return self;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _lines.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"indexpath" forIndexPath:indexPath];
    Line *line = [_lines objectAtIndex:indexPath.item];
    cell.line = line;
    cell.reference = _reference;
    cell.setNeedsDisplay;
    return cell;
}

@end
