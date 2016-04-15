//
//  ZZSegmentV.m
//  萌宝派
//
//  Created by zhizhen on 15/8/3.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZSegmentV.h"

@interface ZZSegmentV ()
@property(nonatomic,strong)UILabel*  switchLabel;//segment切换时 选中的类型
@property(nonatomic,strong)UISegmentedControl*  segmentC;
@end
@implementation ZZSegmentV

-(instancetype)initWithItems:(NSArray *)items{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        [self  setChildContol:items];
       
    }
    return self;
}
#pragma  mark -初始化


- (void)setChildContol:(NSArray *)items{
    //label 选中时盖在segment上
    self.segmentC = [[UISegmentedControl alloc]initWithItems:items];
  [self.segmentC  addTarget:self action:@selector(clickAnimation:) forControlEvents:UIControlEventValueChanged];
      self.segmentC.multipleTouchEnabled=NO;
    self.segmentC.selectedSegmentIndex = 0;
    self.segmentC.exclusiveTouch = YES; // 不可多点同时点下
    [self.segmentC  setTintColor:[UIColor  clearColor]];
    [self.segmentC  setTitleTextAttributes:@{NSForegroundColorAttributeName:ZZDarkGrayColor,NSFontAttributeName:[UIFont  systemFontOfSize:13]} forState:UIControlStateNormal];
    [self.segmentC  setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor  clearColor]} forState:UIControlStateSelected];
    //self.segmentC.apportionsSegmentWidthsByContent= YES;
    [self  addSubview:self.segmentC];
    
    self.switchLabel =[[UILabel  alloc]init];
    self.switchLabel.textAlignment = NSTextAlignmentCenter;
    self.switchLabel.font = [UIFont  boldSystemFontOfSize:14];
    self.switchLabel.layer.masksToBounds = YES;
    self.switchLabel.textColor = [UIColor  whiteColor];
    self.switchLabel.backgroundColor = [UIColor  colorWithRed:0.45 green:0.8 blue:0.21 alpha:1];
    [self.segmentC  addSubview:self.switchLabel];
}


#pragma mark -公共方法


-(void)setFrame:(CGRect)frame{
    [super  setFrame:frame];
    CGRect  bounds = self.bounds;
    self.segmentC.frame = bounds;


}

-(void)setDelegate:(id<ZZSegmentVDelegate>)delegate{
    _delegate = delegate;
    self.segmentC.selectedSegmentIndex = 0;
    [self  clickAnimation:self.segmentC];
}

#pragma mark - 响应事件
- (void)clickAnimation:(UISegmentedControl *)seg{
  
    NSUInteger  index = seg.selectedSegmentIndex;
   NSString*  str= [self.segmentC  titleForSegmentAtIndex:index];
    self.switchLabel.text = str;
    CGSize  strSize = [str  sizeWithFont:self.switchLabel.font maxW:200];
    CGFloat  indexWidth = strSize.width+30;
    CGFloat  width = seg.frame.size.width/seg.numberOfSegments;
    if (indexWidth>width) {
        indexWidth = width;
    }
    CGFloat height = 24;
    CGFloat y = (self.frame.size.height - 24)/2;
    if (y<0) {
        y = 0;
        height = self.frame.size.height;
    }

    [UIView  animateWithDuration:0.25 animations:^{
        self.switchLabel.frame=CGRectMake(index *width +(width - indexWidth)/2, y, indexWidth,height);
          self.switchLabel.layer.cornerRadius = self.switchLabel.frame.size.height/2;
    }];
    
    if ([self.delegate   respondsToSelector:@selector(segmentVClicked:item:)]) {
        [self.delegate  segmentVClicked:self item:index];
    }
}
@end
