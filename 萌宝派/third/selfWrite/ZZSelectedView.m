//
//  ZZSelectedTableView.m
//  聪明宝宝
//
//  Created by zhizhen on 14-9-1.
//  Copyright (c) 2014年 zhizhen. All rights reserved.
//

#import "ZZSelectedView.h"

@implementation ZZSelectedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  initUI];
    }
    return self;
}

-(void)initUI{
    
    UITableView*  tableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.showsVerticalScrollIndicator = NO;
    
    tableView.bounces = NO;
    
    tableView.separatorColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
       tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
//    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
//        
//    {
//        
//        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 5, 0, 5)];
//        
//    }
    
//    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
//        
//    {
//        
//        [tableView setLayoutMargins:UIEdgeInsetsMake(0, 5, 0, 5)];
//        
//    }
    
    
    
    [self  addSubview:tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datas.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString*  cellIndentifier = @"Cell";
    
    UITableViewCell*  cell = [tableView   dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (cell  == nil) {
        
        cell = [[UITableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        
        UILabel*  label = [[UILabel  alloc]initWithFrame:CGRectMake(5, 10,self.frame.size.width-10 , 20)];
        label.tag = 667;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:45.0/255 green:45.0/255 blue:45.0/255 alpha:1];
        label.font =[UIFont boldSystemFontOfSize:16];

        [cell.contentView  addSubview:label];
    }
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
//        
//    {
//        
//        [cell setSeparatorInset:UIEdgeInsetsMake(0, 5, 0, 5)];
//        
//    }
    
  //  if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        
//    {
//        
//        [cell setLayoutMargins:UIEdgeInsetsMake(0, 5, 0, 5)];
//        
//    }
    //cell.separatorInset = UIEdgeInsetsZero;
    UILabel*  label = (UILabel*)[cell.contentView   viewWithTag:667];
    label.text = self.datas[indexPath.row];

    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.tag = indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    self.selectedIndex = indexPath.row;
    
    [self.delegate  getString:   self.datas[indexPath.row]];
        
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
