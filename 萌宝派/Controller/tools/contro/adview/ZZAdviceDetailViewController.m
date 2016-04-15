//
//  ZZAdviceDetailViewController.m
//  萌宝派
//
//  Created by zhizhen on 15-3-22.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZAdviceDetailViewController.h"

#import "ZZAdviceTableViewCell.h"
@interface ZZAdviceDetailViewController ()<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)UITableView*  adviceTableView;
@end

@implementation ZZAdviceDetailViewController
#pragma mark  lazy load
-(UITableView *)adviceTableView{
    if (!_adviceTableView) {
        _adviceTableView = [[UITableView  alloc]initWithFrame:CGRectMake(10,ZZNaviHeight,ScreenWidth-20, ScreenHeight -ZZNaviHeight) style:UITableViewStylePlain];
        _adviceTableView.layer.cornerRadius =5;
        _adviceTableView.layer.masksToBounds = YES;
        _adviceTableView.delegate =self;
        _adviceTableView.dataSource = self;
        _adviceTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _adviceTableView.showsVerticalScrollIndicator = NO;
       _adviceTableView.backgroundColor = [UIColor  colorWithRed:0 green:0 blue:0 alpha:0.68];
  
    }
    return _adviceTableView;
}
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.title = @"详细建议";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view  addSubview:self.adviceTableView];
 

       // Do any additional setup after loading the view.
}
#pragma mark  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.advices.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString*  adviceCellInden = @"adviceCell";
    ZZAdviceTableViewCell*  cell = [tableView   dequeueReusableCellWithIdentifier:adviceCellInden];
    if (cell == nil) {
        cell = [[ZZAdviceTableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adviceCellInden];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    NSDictionary*  dic = self.advices[indexPath.row];
    
    NSString*  title = [[dic allKeys]  firstObject];
    
    NSString*  content = dic[title];
    cell.titleLable.text = title;
    cell.contentLabel.text = content;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary*  dic = self.advices[indexPath.row];
    
    NSString*  title = [[dic allKeys]  firstObject];
    
    NSString*  content = dic[title];
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(ScreenWidth -60, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont  systemFontOfSize:14]} context:nil];
    
    return rect.size.height+40;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
