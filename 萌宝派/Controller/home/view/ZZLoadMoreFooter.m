//
//  ZZLoadMoreFooter.m
//  萌宝派
//
//  Created by zhizhen on 15/8/4.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZLoadMoreFooter.h"
#import "MBProgressHUD+Add.h"
@interface ZZLoadMoreFooter ()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;

@end
@implementation ZZLoadMoreFooter
+ (instancetype)footer
{

    ZZLoadMoreFooter *loadMoreFooter = [[[NSBundle mainBundle] loadNibNamed:@"ZZLoadMoreFooter" owner:nil options:nil] lastObject];
    
    
    return loadMoreFooter;
}

-(void)awakeFromNib{
    self.canRefresh = YES;
    self.backgroundColor = ZZViewBackColor;
    [self.statusLabel  sizeToFit];
}

- (void)beginRefreshing
{
     weakSelf(footer);
    [MBProgressHUD  hideHUDForView:self animated:NO];
    footer.statusLabel.text = @"正在拼命加载更多数据...";
    [footer.loadingView startAnimating];
    footer.refreshing = YES;
}

- (void)endRefreshing
{
     weakSelf(footer);
   
    footer.statusLabel.text = @"上拉可以加载更多数据";
    [footer.loadingView stopAnimating];
    footer.refreshing = NO;
}

-(void)setCanRefresh:(BOOL)canRefresh{
    _canRefresh = canRefresh;
    weakSelf(footer);
    [MBProgressHUD  hideHUDForView:footer animated:NO];
    if (canRefresh == NO) {
        footer.statusLabel.text = @"没有更多数据";
        [self.loadingView stopAnimating];
        footer.refreshing = NO;
    }
   
}
-(void)requestFailed{
    [self  endRefreshing];
    weakSelf(footer);
    MBProgressHUD *hud =   [MBProgressHUD  showMessage:@"加载失败，点击重新加载" toView:footer isDimback:NO];
    hud.label.textColor = ZZLightGrayColor;
    [hud addTarget:footer action:@selector(loadAgain)];
}

- (void)loadAgain{
    if ([self.delegate  respondsToSelector:@selector(loadMoreFaileClickedRequestAgain:)]) {
        [self.delegate  loadMoreFaileClickedRequestAgain:self];
    }
}
@end
