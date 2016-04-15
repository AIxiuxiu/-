//
//  ZZDynamicHeadView.m
//  萌宝派
//
//  Created by zhizhen on 15/5/26.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZDynamicHeadView.h"
#import "ZZRongChat.h"
@implementation ZZDynamicHeadView
-(UILabel *)numlabel{
    if (!_numlabel) {
        _numlabel = [[UILabel  alloc]init];
          _numlabel.textAlignment = NSTextAlignmentRight;
     
    }
    return _numlabel;
}
-(UIButton *)clickButton{
    if (!_clickButton) {
        _clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clickButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"buddy_header_arrow" ofType:@"png"]] forState:UIControlStateNormal];
     
        [_clickButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _clickButton.imageView.contentMode = UIViewContentModeCenter;
        _clickButton.imageView.clipsToBounds = NO;
        _clickButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _clickButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        _clickButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [_clickButton addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickButton;
}
-(UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0,60, ScreenWidth, 1)];
        _lineLabel.backgroundColor= [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    }
    return _lineLabel;
}
-(UILabel *)unReadCountLabel{
    if (!_unReadCountLabel) {
        _unReadCountLabel = [[UILabel  alloc]initWithFrame:CGRectMake(120, 5, 20, 20)];
        _unReadCountLabel.layer.cornerRadius = 10;
        _unReadCountLabel.adjustsFontSizeToFitWidth = YES;
        _unReadCountLabel.layer.masksToBounds = YES;
        _unReadCountLabel.textAlignment = NSTextAlignmentCenter;
        _unReadCountLabel.textColor = [UIColor  whiteColor];
        _unReadCountLabel.backgroundColor = [UIColor  colorWithRed:1 green:0.1 blue:0.2 alpha:1];
        _unReadCountLabel.font = ZZTimeFont;
    }
    return _unReadCountLabel;
}
+ (instancetype)headViewWithTableView:(UITableView *)tableView
{
    static NSString *headIdentifier = @"header";
    
    ZZDynamicHeadView *headView = [tableView dequeueReusableCellWithIdentifier:headIdentifier];
    if (headView == nil) {
        headView = [[ZZDynamicHeadView alloc] initWithReuseIdentifier:headIdentifier];
    }
    
    return headView;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self.contentView  addSubview:self.numlabel];
        [self.contentView addSubview:self.clickButton];
        [self.contentView  addSubview:self.lineLabel];
        [self.contentView  addSubview:self.unReadCountLabel];
        self.contentView.backgroundColor = [UIColor  whiteColor];
    }
    return self;
}

-(void)headBtnClick{
    
    self.headGroup.opened =!self.headGroup.opened;
    self.clickButton.imageView.transform = self.headGroup.isOpened ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
    if ([_delegate respondsToSelector:@selector(clickHeadViewWithSection:)]) {
        [_delegate clickHeadViewWithSection:self.tag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.clickButton.frame = self.bounds;
    self.numlabel.frame = CGRectMake(self.frame.size.width - 75, 0, 60, self.frame.size.height);
    self.lineLabel.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 0.5);
    [self.clickButton setTitle:self.headGroup.name forState:UIControlStateNormal];
    self.clickButton.imageView.transform = self.headGroup.isOpened ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
    
    self.numlabel.text = [NSString stringWithFormat:@"%ld", self.headGroup.array.count];
    
    if (self.tag == 2) {
        self.unReadCountLabel.hidden = NO;
        NSUInteger  unReadCount =[[ZZRongChat  sharedZZRongChat]rongGetUnreadMessageCountWithSelfConversation];
        if (unReadCount) {
            if (unReadCount<100) {
                self.unReadCountLabel.text = [NSString  stringWithFormat:@"%d",unReadCount];
            }else{
                self.unReadCountLabel.text = [NSString  stringWithFormat:@"%@",@"99+"];
            }
        }else{
            self.unReadCountLabel.hidden = YES;
        }
    }else{
        self.unReadCountLabel.hidden = YES;
    }
}

@end
