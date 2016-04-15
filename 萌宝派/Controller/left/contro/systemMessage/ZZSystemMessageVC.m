//
//  ZZSystemMessageVC.m
//  萌宝派
//
//  Created by zhizhen on 15/4/10.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZSystemMessageVC.h"
#import "ZZMessageTableViewCell.h"
#import "ZZSystemMessage.h"
#import "ZZSystemDetailMessageVC.h"
#import "ZZPushMessageFmdb.h"
#import "MJRefresh.h"
@interface ZZSystemMessageVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView* messageTableView;
@property(nonatomic,strong)NSMutableArray*  messagesArray;
@end

@implementation ZZSystemMessageVC
#pragma mark lazy load
-(UITableView *)messageTableView{
    if (!_messageTableView) {
        _messageTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 69, ScreenWidth, ScreenHeight - 74) ];
        _messageTableView.dataSource = self;
        _messageTableView.delegate = self;
        _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _messageTableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
        _messageTableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
        _messageTableView.footerRefreshingText = @"正在加载中";
    }
    return _messageTableView;
}
-(NSMutableArray *)messagesArray{
    if (!_messagesArray) {
        _messagesArray = [NSMutableArray  arrayWithArray:[ZZPushMessageFmdb  sysMessagesWithMessageId:0]];
        
    }
    return _messagesArray;
}
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推送消息";
    self.automaticallyAdjustsScrollViewInsets = NO;
  
    
    if (self.messagesArray.count ==0) {
        UILabel*  label = [[UILabel  alloc]initWithFrame:CGRectMake(ScreenWidth/2-100, 79, 200, 20)];
        label.text = @"你还没有收到推送消息";
        label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor  colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        [self.view  addSubview:label];
    }else {
        
        [self.view  addSubview:self.messageTableView];
    }
    self.view.backgroundColor = ZZViewBackColor;
   // NSLog(@"%ld",[ZZSystemMessageDB    insertRecordWithObject:message]);
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
     [self.messageTableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super  viewWillDisappear:animated];
    [self.messageTableView  removeFooter];
}
#pragma mark private methods
-(void)footerRereshing{
    if (!self.messagesArray.count) {
         [self.messageTableView  footerEndRefreshing];
        return;
    }
    ZZSystemMessage*  message = [self.messagesArray  lastObject];
    NSArray*  backArray = [ZZPushMessageFmdb  sysMessagesWithMessageId:message.sMessageId];
    if (backArray.count) {
        NSMutableArray*  refreshArray = [NSMutableArray  arrayWithCapacity:backArray.count];
        for (ZZSystemMessage*  message in backArray) {
            [refreshArray  addObject:[NSIndexPath  indexPathForRow:self.messagesArray.count inSection:0]];
            [self.messagesArray  addObject:message];
            
        }
        [self.messageTableView  beginUpdates];
        [self.messageTableView  insertRowsAtIndexPaths:refreshArray withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.messageTableView  endUpdates];
    }
    [self.messageTableView  footerEndRefreshing];
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messagesArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString*  messageCellIden = @"MessageCell";
    ZZMessageTableViewCell*  cell = [tableView  dequeueReusableCellWithIdentifier:messageCellIden];
    if (cell==nil) {
        cell = [[ZZMessageTableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageCellIden];
    }
    cell.message = self.messagesArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZSystemMessage* message =self.messagesArray[indexPath.row];
    [ZZPushMessageFmdb  updateBabyRecord:message];
    message.sMessageFlag = 0;
    [self.messageTableView  reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    ZZSystemDetailMessageVC* systemDetailVC = [[ZZSystemDetailMessageVC  alloc]init];
    systemDetailVC.systemMessage = message;
    [self.navigationController  pushViewController:systemDetailVC animated:YES];
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
