//
//  DWSegmentedControl.h
//  LevelLabel
//
//  Created by admin on 2017/6/22.
//  Copyright © 2017年 com.gz.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DWSegmentedControl;

@protocol DWSegmentedControlDelegate <NSObject>

@required
-(void)dw_segmentedControl:(DWSegmentedControl *)control didSeletRow:(NSInteger)row;

@end


@interface DWSegmentedControl : UIView



/**
 选中label的背景颜色（默认灰色）
 */
@property (nonatomic, strong) UIColor *selectedViewColor;
/**
 未选中label的颜色（默认黑色）
 */
@property (nonatomic, strong) UIColor *normalLabelColor;
/**
 数据源
 */
@property (nonatomic, strong) NSArray <NSString *>* titles;


@property (nonatomic, weak) id<DWSegmentedControlDelegate> delegate;




@end
