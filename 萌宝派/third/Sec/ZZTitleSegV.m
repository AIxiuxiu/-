//
//  ZZTitleSegV.m
//  萌宝派
//
//  Created by zhizhen on 15/8/3.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZTitleSegV.h"

@interface ZZTitleSegV ()
@property(nonatomic,strong)UISegmentedControl*  segCon;
@property(nonatomic,strong)UILabel*  titleLabel;

@end
@implementation ZZTitleSegV


-(instancetype)initWithItems:(NSArray *)items{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self  setChildContol:items];
        
    }
    return self;
}
#pragma  mark -初始化


- (void)setChildContol:(NSArray *)items{
    self.segCon = [[UISegmentedControl alloc]initWithItems:items];
//    self.segCon.frame = CGRectMake(10, 5, 130, 30);
    self.segCon.tintColor = [UIColor clearColor];
    [self.segCon setBackgroundColor:[UIColor colorWithRed:0.28 green:0.6 blue:0.79 alpha:1]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.22 green:0.47 blue:0.61 alpha:1],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:16],NSFontAttributeName ,nil];
    self.segCon.exclusiveTouch = YES; //不可多点同时点下
    [self.segCon setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.segCon.layer.cornerRadius = 15;
    self.segCon.selectedSegmentIndex = 0;
    [self.segCon addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    //label 选中时盖在segment
    [self  addSubview:self.segCon];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.backgroundColor = [UIColor colorWithRed:0.35 green:0.75 blue:0.99 alpha:1];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.layer.cornerRadius = 12 ;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
   self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self  addSubview:self.titleLabel];
}

#pragma mark -公共方法


-(void)setFrame:(CGRect)frame{
    [super  setFrame:frame];
    self.segCon.frame = self.bounds;
}
-(void)setDelegate:(id<ZZTitleSegVDelegate>)delegate{
    _delegate = delegate;
    self.segCon.selectedSegmentIndex = 0;
    [self  change:self.segCon];
}

#pragma mark - 响应事件
- (void)change:(UISegmentedControl *)seg{
    NSUInteger  index = seg.selectedSegmentIndex;
    NSString*  str= [self.segCon  titleForSegmentAtIndex:index];
    self.titleLabel.text = str;
    CGFloat  x = 3;
    CGFloat  y = 3;
    CGFloat  width = seg.frame.size.width/seg.numberOfSegments;
     CGFloat  indexWidth = width -3*2;
    if (indexWidth > width) {
        indexWidth = width;
    }
    CGFloat height = self.frame.size.height - 3*2;
 
    [UIView  animateWithDuration:0.25 animations:^{
        self.titleLabel.frame=CGRectMake(index *width +x, y, indexWidth,height);
        self.titleLabel.layer.cornerRadius = self.titleLabel.frame.size.height/2;
    }];
    
    if ([self.delegate   respondsToSelector:@selector(titleSegVClicked:item:)]) {
        [self.delegate  titleSegVClicked:self item:index];
    }
}

@end
