//
//  ZZChatListViewController.m
//  萌宝派
//
//  Created by zhizhen on 15/5/26.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZChatListViewController.h"
#import "ZZRongChatViewController.h"
#import "ZZTabBarViewController.h"
@implementation ZZChatListViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super  initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //设置要显示的会话类型
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_CHATROOM), @(ConversationType_CUSTOMERSERVICE), @(ConversationType_SYSTEM)]];
    }
    return self;
}

-(void)viewDidLoad{
    [super  viewDidLoad];
    
   self.title = @"会话列表";
    self.conversationListTableView.tableFooterView = [[UIView alloc]init];
    self.conversationListTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 12)];
    
  
}

-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
   
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
        ZZRongChatViewController *_conversationVC = [[ZZRongChatViewController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.userName = model.conversationTitle;
        _conversationVC.title = model.conversationTitle;
        //_conversationVC.conversationType = model;
        
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
    
    //聚合会话类型，此处自定设置。
    //    if (conversationModelType == ConversationModelType_Collection) {
    //
    //        RCDChatListViewController *temp = [[RCDChatListViewController alloc] init];
    //        NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
    //        [temp setDisplayConversationTypes:array];
    //        [temp setCollectionConversationType:nil];
    //        [self.navigationController pushViewController:temp animated:YES];
    //    }
    

    
}



@end
