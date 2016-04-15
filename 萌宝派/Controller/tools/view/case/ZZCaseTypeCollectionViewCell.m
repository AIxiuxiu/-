//
//  ZZCaseTypeCollectionViewCell.m
//  萌宝派
//
//  Created by zhizhen on 15/4/13.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZCaseTypeCollectionViewCell.h"

@implementation ZZCaseTypeCollectionViewCell
-(UILabel *)lineLabel{
    if (!_lineLabel ) {
        _lineLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
        _lineLabel.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    }
    return _lineLabel;
}
-(UILabel *)caseTypeNamelabel{
    if (!_caseTypeNamelabel) {
        _caseTypeNamelabel = [[UILabel  alloc ]initWithFrame:CGRectMake(2, self.frame.size.height/2-10, self.frame.size.width-4, 20)];
        _caseTypeNamelabel.textAlignment = NSTextAlignmentCenter;
        _caseTypeNamelabel.font =  [UIFont  systemFontOfSize:12];
        _caseTypeNamelabel.text = @"消化系统";
    }
    return _caseTypeNamelabel;
}
-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView  alloc]init];
        
        UIView*  selectView= [[UIView  alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10)];
        selectView.layer.cornerRadius = (self.frame.size.height-10)/2;
        selectView.layer.masksToBounds = YES;
        selectView.backgroundColor = [UIColor  colorWithRed:0.57 green:0.85 blue:0.37 alpha:1];
        [_backView  addSubview:selectView];
    }
    return _backView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor  whiteColor];
        [self.contentView  addSubview:self.lineLabel];
        [self.contentView  addSubview:self.caseTypeNamelabel];
        
        
        self.selectedBackgroundView = self.backView;
    }
    return self;
}

@end
