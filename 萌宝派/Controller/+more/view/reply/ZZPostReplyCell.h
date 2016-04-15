//
//  ZZPostReplyCell.h
//  萌宝派
//
//  Created by zhizhen on 15/8/12.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZReplyFrame.h"

typedef enum {
    ZZPostReplyCellButtonTypeDelete ,
    ZZPostReplyCellButtonTypeReport,
    ZZPostReplyCellButtonTypeReply,
    ZZPostReplyCellButtonTypeImage
}ZZPostReplyCellButtonType;
@class ZZPostReplyCell;
@protocol ZZPostReplyCellDelegate <NSObject>

- (void)postReplyButtonAction:(ZZPostReplyCell *)postReplyCell buttonType:(ZZPostReplyCellButtonType)postReplyType ;

- (void)postReplyCellContentIVTap:(ZZPostReplyCell *)postReplyCell imageView:(UIImageView *)iv;

@end
@interface ZZPostReplyCell : UITableViewCell


@property (nonatomic, strong)ZZReplyFrame  *replyFrame;

@property (nonatomic,weak)id<ZZPostReplyCellDelegate>delegate;

+ (ZZPostReplyCell *)dequeueReusableCellWithTableView:(UITableView *)tableView;
@end
