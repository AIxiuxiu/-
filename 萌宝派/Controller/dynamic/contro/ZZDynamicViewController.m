//
//  ZZDynamicViewController.m
//  萌宝派
//
//  Created by charles on 15/3/11.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZDynamicViewController.h"
#import "ZZDynamicCell.h"
#import "ZZContactCell.h"
#import "ZZNewsCell.h"
#import "ZZLastCell.h"

#import "ZZMengBaoPaiRequest.h"
#import "ZZMessage.h"
#import "UIImageView+WebCache.h"
#import "ZZUser.h"
#import "ZZWonderDetailViewController.h"
//
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
//

#import "MBProgressHUD.h"


#import "ZZExpert.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+HM.h"
#import "ZZMyAlertView.h"
#import "ZZLoginSatus.h"
#import "AppDelegate.h"

//
#import "ZZHeadGroup.h"
#import "ZZDynamicHeadView.h"
//rongyun
#import "ZZRongChatViewController.h"
#import "ZZRongChat.h"
#import "ZZChatListViewController.h"
#import "ZZTitleSegV.h"
#import "ZZLoadMoreFooter.h"
@interface ZZDynamicViewController ()<UITableViewDataSource,UITableViewDelegate,ZZDynamicHeadViewDelegate,UIAlertViewDelegate,ZZTitleSegVDelegate,ZZLoadMoreFooterDelegate>
/** //在线小编 */
@property(nonatomic,strong)NSArray*  serveArray;
/** //会话列表 */
@property(nonatomic,strong)NSArray*  chatListArray;
/** //消息 */
@property(nonatomic,strong)NSMutableArray* messageMarray;
/** //好友列表 */
@property(nonatomic,strong)NSArray*   friendArray;
/** //动态对应的tableview */
@property(nonatomic,strong)UITableView*  chatPersonListTableView;
/** //消息对应的tableview */
@property(nonatomic,strong)UITableView*  messageListTableView;
/** //tableview头数组 */
@property(nonatomic,strong)NSArray*  headArray;
///**  聊天室数组 */


/** 选中了那个分区，动态、消息 */
@property (nonatomic)NSUInteger  selectedItem;

/** tableView的footer */
@property (nonatomic, strong)ZZLoadMoreFooter *footer;
@property (nonatomic)BOOL  messageCanRefresh;
@end

@implementation ZZDynamicViewController


#pragma mark   life cycle
/**
 张亮亮  0513 确保创建的时候连接聊天服务器
 */
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if(self.view){
            
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //titleview
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self  initNaviTitleView];
    [self  setUpTableView];
    [self  setupFooter];
    //注册通知
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(appBecomeAvtiveAgain) name:ZZAppDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(receiveNewChat:) name:ZZUpdateRongYunNewMessageInfoNotification object:nil];
    //刷新联系人
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(getAttentionFriendList) name:ZZConnectPersonChangeNotification object:nil];

}
//初始化navi titleView
-(void)initNaviTitleView{
   
    ZZTitleSegV * segment = [[ZZTitleSegV  alloc]initWithItems:@[@"动态",@"消息"]];
    segment.frame = CGRectMake(0, 0, 130, 30);
    segment.delegate = self;
    self.navigationItem.titleView = segment;
}
// tableview
- (void)setUpTableView{
    [self.view addSubview:self.chatPersonListTableView];
    [self.view  addSubview:self.messageListTableView];
    //加载时调用下 初始化
    [self titleSegVClicked:nil item:0 ];
}
-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    [self.messageListTableView  addHeaderWithTarget:self action:@selector(headerRereshing)];
    [[ZZRongChat  sharedZZRongChat] rongMessageCountChangeNoti];


  // [self  getAttentionFriendList];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super  viewWillDisappear:animated];
    [self.messageListTableView  removeHeader];
}

//设置tableview的尾部视图
- (void)setupFooter
{
    self.messageCanRefresh = YES;
    ZZLoadMoreFooter *footer = [ZZLoadMoreFooter footer];
    footer.delegate = self;
    self.messageListTableView.tableFooterView = footer;
    self.footer = footer;
}
#pragma mark private  methods
//刷新头部
- (void)headerRereshing{
    NSUInteger  lastId =0;
    if (self.messageMarray.count) {
        ZZMessage* message = [self.messageMarray firstObject];
        lastId= message.messageId;
    }
    [self   getNetDataWithUpDown:1 andMessageId:lastId];
}
//刷新尾部
- (void)footerRereshing{
    NSUInteger  lastId =0;
    if (self.messageMarray.count) {
        ZZMessage* message = [self.messageMarray lastObject];
        lastId = message.messageId;
    }
    [self   getNetDataWithUpDown:2 andMessageId:lastId];
}

//刷新最近联系人
-(void)updateRecentContact{
    self.chatListArray = [[ZZRongChat  sharedZZRongChat]rongGetConversationListWithSelfConversation];
    
}
#pragma mark  event response


#pragma  mark  -ZZTitleSegVDelegate
-(void)titleSegVClicked:(ZZTitleSegV *)segment item:(NSUInteger)item{
    
    self.selectedItem = item;
    self.chatPersonListTableView.hidden = item ==1;
    self.messageListTableView.hidden = item == 0;
}
#pragma mark --UITableViewDelegate
//tableView协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag==501) {
        return self.headArray.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==501) {
      
        ZZHeadGroup*  headGroup = self.headArray[section];
  
        return headGroup.isOpened ? headGroup.array.count : 0;

    }else{
        return self.messageMarray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView.tag==501) {
        if (indexPath.section == 2) {//最近联系人
            ZZContactCell *cell = [ZZContactCell  dequeueReusableCellWithTableView:tableView];
              ZZHeadGroup*  headGroup = self.headArray[indexPath.section];
            if(headGroup.array.count>indexPath.row){
                cell.conversation = headGroup.array[indexPath.row];
            }else{
                cell.conversation = nil;
            }
            
            return cell;
        }else {//在线小编、我的联系人、育儿QA
            
            ZZDynamicCell *cell = [ZZDynamicCell  dequeueReusableCellWithTableView:tableView];
            ZZHeadGroup*  headGroup = self.headArray[indexPath.section];
            if (headGroup.array.count>indexPath.row) {
                 ZZUser* user = headGroup.array[indexPath.row];
                  cell.user = user;
            }else{
                  cell.user = nil;
            }
          
          
            return cell;
            
        }
    }else{//  右边  消息
  
            //消息cell
        ZZNewsCell *cell = [ZZNewsCell  dequeueReusableCellWithTableView:tableView];
      if (indexPath.row<self.messageMarray.count) {
            ZZMessage* messageInfo = self.messageMarray[indexPath.row];
            cell.message = messageInfo;
        }else{
            cell.message = nil;
        }
//
            return cell;

    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 501) {//左边动态
            return 60;
    }else{
        
        return 120;

    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 501) {
        ZZDynamicHeadView *headView = [ZZDynamicHeadView headViewWithTableView:tableView];
         headView.tag = section;
        headView.delegate = self;
        ZZHeadGroup*  headGroup = self.headArray[section];
        headView.headGroup = headGroup;
    
        return headView;
    }else{
        return nil;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 501) {
        //
        if (![ZZRongChat  sharedZZRongChat].rongConnetSuccess) {
            [self  showAlert:@"已掉线，重新连接"];
           
        }else {
            ZZHeadGroup *headGroup = self.headArray[indexPath.section];
            if (headGroup.array.count>indexPath.row) {
             
                if (indexPath.section==2) {//最近联系人
                    
                    RCConversation*  model =headGroup.array[indexPath.row];

                    
                    ZZRongChatViewController*  chatVC = [[ZZRongChatViewController alloc]init];
                    chatVC.conversationType = model.conversationType;
                    chatVC.targetId = model.targetId;
                    
                    RCUserInfo* userInfo   = [[ZZRongChat  sharedZZRongChat]getZZUserInfoWithUserId:model.targetId];
                    chatVC.userName = userInfo.name;
                    chatVC.title = userInfo.name;
                    [self.navigationController  pushViewController:chatVC animated:YES];
                    
                }
                else  if (indexPath.section == 1) {//好友联系人
                    ZZUser*  user = headGroup.array[indexPath.row];
                
                    ZZRongChatViewController*  chatVC = [[ZZRongChatViewController alloc]init];
                    chatVC.conversationType = ConversationType_PRIVATE;
                    chatVC.targetId = user.uToken;
                    chatVC.userName = user.nick;
                    chatVC.title = user.nick;
                    [self.navigationController  pushViewController:chatVC animated:YES];
                    
                }else{//在线小编
                    ZZExpert*  expert = headGroup.array[indexPath.row];
                    ZZRongChatViewController*  chatVC = [[ZZRongChatViewController alloc]init];
                    chatVC.conversationType = ConversationType_CUSTOMERSERVICE;
                    chatVC.targetId = expert.uToken;
                    chatVC.userName = expert.nick;
                    chatVC.title = expert.nick;
                    [self.navigationController  pushViewController:chatVC animated:YES];
                    
                }

            }
 
        }
        
    }else{
        if (indexPath.row<self.messageMarray.count) {
            ZZWonderDetailViewController* newsView = [[ZZWonderDetailViewController alloc]init];
            ZZMessage* messageInfo = self.messageMarray[indexPath.row];
            newsView.postIncoming = messageInfo.postInfo;
            [self.navigationController pushViewController:newsView animated:YES];
        }
        
    
    }
    
    [tableView  deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - tableView代理方法 --计算拖动刷新
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
       if (self.selectedItem == 0 || self.footer.isRefreshing || self.messageCanRefresh == NO ||scrollView == self.chatPersonListTableView||scrollView.contentOffset.y < self.footer.height) return;
    // 1.差距
    CGFloat delta = scrollView.contentSize.height - scrollView.contentOffset.y;
    // 刚好能完整看到footer的高度
    CGFloat sawFooterH = scrollView.height + self.footer.height;
    
    // 2.如果能看见整个footer
    if (delta <= (sawFooterH - 0)) {
        [self.footer  beginRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ZZNetDely * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self footerRereshing];
        });
  
    }
}

#pragma mark   ZZLoadMoreFooterDelegate
-(void)loadMoreFaileClickedRequestAgain:(ZZLoadMoreFooter *)footer{
    [self  footerRereshing];
}
#pragma mark   UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 303 && buttonIndex) {
        //连接容云
        
        [[ZZRongChat  sharedZZRongChat]rongChatConnectServerWithToken:[ZZLoginSatus sharedZZLoginSatus].rongToken andCallback:^(id obj) {
            if (obj) {
               [[ZZRongChat  sharedZZRongChat] rongMessageCountChangeNoti];
            }
            
        }];
        
    }
}
#pragma mark ZZDynamicHeadViewDelegate
-(void)clickHeadViewWithSection:(NSUInteger)section{
    [self.chatPersonListTableView  beginUpdates];
    [self.chatPersonListTableView   reloadSections:[NSIndexSet  indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.chatPersonListTableView  endUpdates];
}

#pragma mark//网络请求
-(void)getNetDataWithUpDown:(int)upDown  andMessageId:(NSUInteger)messageId{
    [self.footer  beginRefreshing];
    __weak  ZZDynamicViewController*  dynamicVC = self;
    [[ZZMengBaoPaiRequest shareMengBaoPaiRequest] postFindMessageByMessageId:messageId andUpDown:upDown andBack:^(id obj) {
        [dynamicVC.messageListTableView  headerEndRefreshing];
        [dynamicVC.footer  endRefreshing];
        NSArray*  array = obj;
        if (array) {
            if (array.count) {
                if (upDown == 1) {
                    NSRange range = NSMakeRange(0, array.count);
                    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                    [dynamicVC.messageMarray insertObjects:array atIndexes:indexSet];
                    [dynamicVC.messageListTableView  reloadData];
                }else{
                    [dynamicVC.messageMarray addObjectsFromArray:array];
                    [dynamicVC.messageListTableView  reloadData];
                }
               
            }else{
                if (upDown == 2) {
                    dynamicVC.messageCanRefresh = NO;
                    dynamicVC.footer.canRefresh = NO;
                }
               
            }
        }else{
            if (upDown == 2) {
                [dynamicVC.footer  requestFailed];
            }
            
        }
    }];
}

//在线小编和专家
-(void)getOnLineExpert{
    /**
     *  聊天室假数据
     */
   
   __weak typeof(self) selfVc = self;
    [[ZZMengBaoPaiRequest shareMengBaoPaiRequest]postfindOnLineAndCallBack:^(id obj) {
        NSDictionary*  backDic = obj;
        if (backDic.count) {
            selfVc.serveArray = [backDic  objectForKey:@"serveList"];
        }
    }];
}
//我的关注人
-(void)getAttentionFriendList{
      __weak typeof(self) selfVc = self;
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postFindMyAttentionByUserId:0 andUpDown:0 andBack:^(id obj) {
       
        NSArray*  array = obj;
        if (array.count) {
            selfVc.friendArray = array;
        }
    }];
}
#pragma mark  NSNotification
//app又进入前台  通知响应方法
-(void)appBecomeAvtiveAgain{

    //刷新在线专家
    [self  getOnLineExpert];
    [self  getAttentionFriendList];
    //请求消息
    [self.messageMarray   removeAllObjects];
    [self.messageListTableView reloadData];
    [self  headerRereshing];
    //连接容云

    [[ZZRongChat  sharedZZRongChat]rongChatConnectServerWithToken:[ZZLoginSatus sharedZZLoginSatus].rongToken     andCallback:^(id obj) {
        if (obj&&[ZZRongChat  sharedZZRongChat].rongConnetSuccess) {
            [[ZZRongChat  sharedZZRongChat] rongMessageCountChangeNoti];
        }
    }];
  

}

//接收到新消息
-(void)receiveNewChat:(NSNotification *)notification{
    //[self.chatPersonListTableView  reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self  updateRecentContact];
    });
    
}
#pragma mark 提醒显示
-(void)showAlert:(NSString *)msg{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 303;
    [alert show];
}

-(void)dealloc{
    [[NSNotificationCenter  defaultCenter]removeObserver:self];
    self.messageListTableView.delegate = nil;
}


#pragma mark   lazy load
-(NSMutableArray *)messageMarray{
    if (!_messageMarray) {
        _messageMarray  = [NSMutableArray  array];
    }
    return _messageMarray;
}

-(UITableView *)chatPersonListTableView{
    if (!_chatPersonListTableView) {
        _chatPersonListTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-49-64)];
        _chatPersonListTableView.backgroundColor = [UIColor clearColor];
        _chatPersonListTableView.tag = 501;
        //空出下方空白   tabbar
        
        _chatPersonListTableView.sectionHeaderHeight = 48;
        _chatPersonListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatPersonListTableView.delegate = self;
        _chatPersonListTableView.dataSource = self;
    }
    return _chatPersonListTableView;
}
-(UITableView *)messageListTableView{
    if (!_messageListTableView) {
        _messageListTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-49-64)];
        _messageListTableView.sectionHeaderHeight = 0;
        _messageListTableView.backgroundColor = [UIColor clearColor];
        _messageListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _messageListTableView.tag = 511;
        //空出下方空白   tabbar
        _messageListTableView.delegate = self;
        _messageListTableView.dataSource = self;
        _messageListTableView.headerPullToRefreshText = @"下拉可以刷新了";
        _messageListTableView.headerReleaseToRefreshText = @"松开马上刷新了";
        _messageListTableView.headerRefreshingText = @"正在刷新中";
        
    }
    return _messageListTableView;
}
-(void)setServeArray:(NSArray *)serveArray{
    _serveArray =serveArray;
    if (self.headArray.count>0) {//在线小编更新时，数组也更新
        ZZHeadGroup* head = self.headArray[0];
        head.array = serveArray;
        [self  clickHeadViewWithSection:0];
    }
    
}

-(void)setFriendArray:(NSArray *)friendArray{
    _friendArray = friendArray;
    if (self.headArray.count>1) {//在线小编更新时，数组也更新
        ZZHeadGroup* head = self.headArray[1];
        head.array = friendArray;
        [self  clickHeadViewWithSection:1];
    }
}

-(void)setChatListArray:(NSArray *)chatListArray{
    _chatListArray = chatListArray;
    if (self.headArray.count>2) {//在线小编更新时，数组也更新
        ZZHeadGroup* head = self.headArray[2];
        head.array = chatListArray;
        [self  clickHeadViewWithSection:2];
        
    }
}

-(NSArray *)headArray{
    if (!_headArray) {
        ZZHeadGroup*  headGroup2 = [[ZZHeadGroup  alloc]init];
        headGroup2.name  = @"萌宝在线";
        headGroup2.array =self.serveArray;
        ZZHeadGroup*  headGroup3 = [[ZZHeadGroup  alloc]init];
        headGroup3.name  = @"我的联系人";
        headGroup3.array = self.friendArray;
        ZZHeadGroup*  headGroup4 = [[ZZHeadGroup  alloc]init];
        headGroup4.name  = @"最近联系人";
        headGroup4.array = self.chatListArray;
        _headArray = @[headGroup2,headGroup3,headGroup4];
    }
    return _headArray;
}

@end
