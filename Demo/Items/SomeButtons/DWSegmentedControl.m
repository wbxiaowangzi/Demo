//
//  DWSegmentedControl.m
//  LevelLabel
//
//  Created by admin on 2017/6/22.
//  Copyright © 2017年 com.gz.demo. All rights reserved.
//

#import "DWSegmentedControl.h"
#import "UIView+Frame.h"


@interface DWSegmentedControl()

@property (nonatomic, strong) UIView *frontLabelbgView;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation DWSegmentedControl



-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}




-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self setUpUI];
    }
    return self;
}



-(void)setUpUI{
    
    
    
    
    CGFloat width = self.frame.size.width/self.titles.count;
    CGFloat height = self.frame.size.height;
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = (self.selectedViewColor?self.selectedViewColor:[UIColor grayColor]).CGColor;
    self.layer.cornerRadius =  height/2;
    self.bgView.clipsToBounds = YES;
    
    for (int i = 0;i<self.titles.count; i++) {
        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.userInteractionEnabled = YES;
        titleLb.tag = 1000+i;
        titleLb.text = _titles[i];
        titleLb.backgroundColor = [UIColor clearColor];
        titleLb.textColor = self.normalLabelColor?self.normalLabelColor:[UIColor blackColor];
        titleLb.font = [UIFont systemFontOfSize:14];
        titleLb.frame = CGRectMake(width*i,0, width, height);
        titleLb.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedLabel:)];
         [titleLb addGestureRecognizer:tap];
        [self addSubview:titleLb];
    }
    
    self.bgView.frame = CGRectMake(0, 0, width, height);
    _bgView.backgroundColor = self.selectedViewColor?self.selectedViewColor:[UIColor grayColor];
    self.bgView.layer.cornerRadius = height/2;
    self.bgView.clipsToBounds = YES;
    [self addSubview:self.bgView];
    
    
   UIView *topLabelView = [[UIView alloc]initWithFrame:self.bounds];
    topLabelView.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:topLabelView];
    self.frontLabelbgView = topLabelView;
    
    
    for (int i = 0;i<self.titles.count; i++) {
        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.userInteractionEnabled = YES;
        titleLb.text = _titles[i];
        titleLb.backgroundColor = [UIColor clearColor];
        titleLb.textColor = [UIColor whiteColor];
        titleLb.font = [UIFont systemFontOfSize:14];
        titleLb.frame = CGRectMake(width*i,0, width, height);
        titleLb.textAlignment = NSTextAlignmentCenter;
        [topLabelView addSubview:titleLb];
    }
    
}


-(void)selectedLabel:(UITapGestureRecognizer *)sender{
    
    CGFloat width = self.frame.size.width/self.titles.count;
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.left = (sender.view.tag - 1000)*width;
        self.frontLabelbgView.left = -(sender.view.tag - 1000)*width;
        [self.bgView layoutIfNeeded];
    }];
    
    if ([self respondsToSelector:@selector(selectedLabel:)]) {
        [self.delegate dw_segmentedControl:self didSeletRow:sender.view.tag - 1000];
    }
    
}


-(void)setTitles:(NSArray<NSString *> *)titles{
    if (titles) {
        _titles = titles;
        [self removeFromSuperview];
        [self setUpUI];
    }
}



@end
