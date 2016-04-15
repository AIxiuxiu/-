//
//  ZZGoldListTableViewCell.m
//  萌宝派
//
//  Created by charles on 15/4/16.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZGoldListTableViewCell.h"

@interface ZZGoldListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end
@implementation ZZGoldListTableViewCell
static  NSString *cellIden = @"ZZGoldListTableViewCell";
+ (ZZGoldListTableViewCell *)dequeueReusableCellWithTableView:(UITableView *)tableView{
    ZZGoldListTableViewCell*    cell = [tableView  dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ZZGoldListTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell  setUpChilds];
        
    }
    return cell;
}

- (void)setUpChilds{
    self.contentLabel.textColor = ZZDarkGrayColor;
    self.timeLabel.textColor = ZZLightGrayColor;
    self.scoreLabel.textColor = ZZGoldYellowColor;
}

-(void)setGoldRecord:(ZZGoldRecord *)goldRecord{
    _goldRecord = goldRecord;
    self.contentLabel.text = goldRecord.goldContext;
    if (self.goldRecord.goldNum>0) {
        self.scoreLabel.text = [NSString stringWithFormat:@"%+ld",goldRecord.goldNum];
    }else{
        self.scoreLabel.text = [NSString stringWithFormat:@"%ld",goldRecord.goldNum];
    }
    
    self.timeLabel.text = goldRecord.goldDate;
}
@end
