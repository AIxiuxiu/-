//
//  ZZInfoDetailCell.m
//  萌宝派
//
//  Created by charles on 15/3/27.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZInfoDetailCell.h"
#import "ZZPost.h"
#import "ZZSIzeFitButton.h"
#import "ZZMyAlertView.h"
@interface ZZInfoDetailCell ()<ZZMyAlertViewDelgate>;
@property (nonatomic, strong)ZZSIzeFitButton *timeButton;
@property (nonatomic, strong)ZZSIzeFitButton *replyButton;
@property (nonatomic, strong)UIButton *deleteButton;
@property (nonatomic) BOOL  canDelete;
@property (nonatomic) id<ZZInfoDetailCellDelegate> delegate;
@end
@implementation ZZInfoDetailCell
-(UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = ZZViewBackColor;
    }
    return _lineLabel;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = ZZTitleFont;
        _titleLabel.textColor = ZZDarkGrayColor;
    }
    return _titleLabel;
}
-(UILabel *)postType{
    if (!_postType) {
        _postType = [[UILabel alloc]init];
        _postType.font = ZZContentFont;
        _postType.textColor = [UIColor redColor];
        _postType.textAlignment = NSTextAlignmentCenter;
    }
    return _postType;
}


-(UIImageView *)image{
    if (!_image) {
        _image = [[UIImageView alloc]init];
        _image.layer.cornerRadius = 5;
        _image.layer.masksToBounds = YES;
        _image.clipsToBounds = YES;
        _image.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _image;
}

-(UIButton *)deleteButton{
    if (_deleteButton == nil) {
        _deleteButton = [[UIButton  alloc]init];
        _deleteButton.layer.cornerRadius = 5;
        _deleteButton.layer.masksToBounds = YES;
        _deleteButton.contentMode = UIViewContentModeCenter;
        [_deleteButton  setImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"delete_40x40.png" ofType:nil] ] forState:UIControlStateNormal];
        [_deleteButton  addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.postType];
        [self.contentView addSubview:self.lineLabel];
        self.timeButton = [self  setUpSizeFitButtonWithTitle:@"" imageName:@"clock_14x14.png"];
 
        //self.timeButton.frame = CGRectMake(10, 30, 100, 20);
        [self.contentView addSubview:self.timeButton];
        self.replyButton = [self  setUpSizeFitButtonWithTitle:@"" imageName:@"replies_14x14.png"];
        //self.replyButton.frame = CGRectMake(240, 30, 100, 20);
        [self.contentView addSubview:self.replyButton];
    }
    return self;
    
}

- (ZZSIzeFitButton *)setUpSizeFitButtonWithTitle:(NSString *)title imageName:(NSString *)imageName{
    ZZSIzeFitButton *button = [[ZZSIzeFitButton alloc]init];
    button.titleLabel.font = ZZTimeFont;
    button.margin = 5;
    button.alpha = 0.7;
    button.userInteractionEnabled = NO;
    [button  setTitleColor:ZZLightGrayColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button  setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imageName ofType:nil]] forState:UIControlStateNormal];
    return button;
}
//
static NSString *cellIden = @"ZZInfoDetailCell";
+ (ZZInfoDetailCell *)dequeueReusableCellWithTableView:(UITableView *)tableView  deleteButton:(BOOL) canDelete  delegate:(id<ZZInfoDetailCellDelegate>) delegate{
    ZZInfoDetailCell*    cell = [tableView  dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[ZZInfoDetailCell  alloc  ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
        cell.delegate = delegate;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.backgroundColor = [UIColor whiteColor];
        if (canDelete) {
         [cell.contentView  addSubview:cell.deleteButton];
        }else{
        [cell.contentView  addSubview:cell.image];
        }
        cell.canDelete = canDelete;
    }
    return cell;
}
-(void)setPost:(ZZPost *)post{
    _post = post;
    self.titleLabel.text = post.postTitle;
    self.postType.text = post.postPlateType.title;
    [self.timeButton setTitle:post.postDateStr forState:UIControlStateNormal];
    [self.replyButton  setTitle:[NSString  stringWithFormat:@"%ld",post.postReplyCount] forState:UIControlStateNormal];
    
    if (post.postUser.isCurrentUser &&post.postImagesArray.count) {
        ZZMengBaoPaiImageInfo *mbp = post.postImagesArray[0];
         [self.image  setImageWithURL:mbp.smallImagePath placeholderImageName:@"loading_image_1_90x90.jpg"];
    }else{
         [self.image  setImageWithURL:post.postUser.mbpImageinfo.smallImagePath placeholderImageName:@"head_portrait_55x55.jpg"];
    }
   
}

-(void)layoutSubviews{
    [super  layoutSubviews];
    CGFloat width = self.width;
    CGFloat height = self.height;
    CGFloat upMargin = 5;
    CGFloat leftMargin = 10;
    //
    CGFloat headH = height- 2*upMargin;
    
    self.titleLabel.frame = CGRectMake(15, 5,width -30 -(headH), 20);
    self.lineLabel.frame = CGRectMake(0, height - 1, width, 1);
    
    CGFloat  twoH = 20;
    CGFloat  twoY = height - twoH -upMargin;
    self.timeButton.x = 10;
    self.postType.frame = CGRectMake(100, twoY, 100, twoH);
    self.replyButton.x = 220;
    self.timeButton.centerY =self.postType.centerY;
    self.replyButton.centerY = self.postType.centerY;
    if (self.canDelete) {
        
        self.deleteButton.frame =  CGRectMake(width - headH- leftMargin, upMargin, headH, headH);
    }else{
         self.image.frame = CGRectMake(width - headH- leftMargin, upMargin, headH, headH);
    }
}
//删除按钮响应事件
- (void)deleteButtonAction{
    if ([self.delegate  respondsToSelector:@selector(infoDetailCellClickedDeleteButton:)]) {
        ZZMyAlertView*  alertView = [[ZZMyAlertView  alloc]initWithMessage:@"你确定要删除这个帖子" delegate:self cancelButtonTitle:@"取消" sureButtonTitle:@"确定"];
        [alertView  show];
    }
}

#pragma mark -ZZMyAlertViewDelgate
-(void)alertView:(ZZMyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        [self.delegate  infoDetailCellClickedDeleteButton:self];
    }
}
@end
