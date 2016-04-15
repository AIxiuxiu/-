//
//  ZZBabyAdviceListVC.m
//  萌宝派
//
//  Created by zhizhen on 15-3-20.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZBabyAdviceListVC.h"
#import "ZZAdviceDetailViewController.h"
#import "ZZBaby.h"
@interface ZZBabyAdviceListVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView*  nursingTableView;
@end

@implementation ZZBabyAdviceListVC
#pragma mark  lazy load
-(UITableView *)nursingTableView{
    if (!_nursingTableView) {
        _nursingTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
        _nursingTableView.rowHeight = 44;
      _nursingTableView.estimatedSectionHeaderHeight = 10;
        _nursingTableView.sectionHeaderHeight =5;
        _nursingTableView.sectionFooterHeight = 5;
        _nursingTableView.delegate = self;
        _nursingTableView.dataSource = self;
        
    }
    return _nursingTableView;
}
#pragma mark  life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"育儿建议";
    [self.view  addSubview:self.nursingTableView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
  
}
#pragma mark  UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section) {
        return 3;
    }
    return 144;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString*  nursingCellIdetifier = @"nursingCell";
    UITableViewCell*  cell = [tableView dequeueReusableCellWithIdentifier:nursingCellIdetifier];
    if (cell ==nil) {
        cell = [[UITableViewCell  alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nursingCellIdetifier];
          cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.textLabel.textColor = ZZLightGrayColor;
        cell.textLabel.font = ZZTitleFont;
    }
    if (indexPath.section) {
         cell.textLabel.text = [NSString  stringWithFormat:@"宝宝第%ld年护理要点",indexPath.row+4];
    }else{
         cell.textLabel.text = [NSString  stringWithFormat:@"宝宝第%ld周护理要点",indexPath.row+1]  ;
    }
   
  
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZAdviceDetailViewController*  adVC = [[ZZAdviceDetailViewController  alloc]init];
     adVC.advices = [ZZBaby   getAdvicesByIndex:indexPath.row+1 andType:indexPath.section+1];
    [self.navigationController  pushViewController:adVC animated:YES];
    [tableView  deselectRowAtIndexPath:indexPath  animated:YES];
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
