//
//  ZZPostView.m
//  萌宝派
//
//  Created by zhizhen on 15/7/22.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZPostView.h"
#import "ZZPost.h"
#import "TTTAttributedLabel.h"
#import "ZZMengBaoPaiImageInfo.h"
#import "ZZIconView.h"
#import "MWPhotoBrowser.h"
static  const  float  margin = 15.0;
static  const  float  superMargin = 5.0;
#define  selfWidth  (ScreenWidth - 2*superMargin)
static  const  float  middleMargin = 10.0;
static   const  float  minMargin = 5.0;
static  const  NSInteger  tagAdd = 999;
//static  const  float  space = 50;
#define  nickFont  [UIFont systemFontOfSize:14]
#define  timeFont   [UIFont systemFontOfSize:12]
#define  titleFont   [UIFont boldSystemFontOfSize:18]
#define  contentFont   [UIFont systemFontOfSize:16]
#define  descFont   [UIFont systemFontOfSize:14]
#define  nameColor [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]
#define  idenColor  [UIColor colorWithRed:0.97 green:0.71 blue:0.32 alpha:1]
#define   timeColor [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1]
#define  conteColor [UIColor colorWithRed:0.6 green:0.6 blue:0.64 alpha:1]
@interface ZZPostView()<MWPhotoBrowserDelegate>
@property(nonatomic,strong)UIView * backGroundView;
@property(nonatomic,strong)UIButton *supportButton;
@property (nonatomic, strong)MWPhotoBrowser *photoBrowser;
@property(nonatomic,strong)NSMutableArray*  wBrowserPhotos;
@end
@implementation ZZPostView

-(MWPhotoBrowser *)photoBrowser{
    if (_photoBrowser == nil){
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = YES;//  展示操作按钮
//        browser.displayNavArrows = NO;  　//底部显示左右按钮移动
//        browser.displaySelectionButtons = NO;  //显示选择按钮
//        browser.alwaysShowControls = NO; //一直显示返回导航栏
        browser.zoomPhotosToFill = YES; //是否可以缩放
//        browser.enableGrid = NO; //是否可以显示网格状
//        browser.startOnGrid = NO;  //以网格状开始
//        browser.enableSwipeToDismiss = NO;//是否能滑动消失
//        browser.autoPlayOnAppear = NO;   //出现的时候视频播放
        _photoBrowser = browser;
    }
    return _photoBrowser;
}
-(NSMutableArray *)wBrowserPhotos{
    if (!_wBrowserPhotos) {
        _wBrowserPhotos = [NSMutableArray  arrayWithCapacity:self.post.postImagesArray.count];
    }
    return _wBrowserPhotos;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ZZViewBackColor;
       
        self.backGroundView = [[UIView  alloc]init];
        self.backGroundView.backgroundColor = [UIColor  whiteColor];
        self.backGroundView.layer.cornerRadius = 5;
        self.backGroundView.layer.borderWidth = 0.5;
        self.backGroundView.clipsToBounds = YES;
        self.backGroundView.layer.borderColor =[[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]CGColor];
        [self addSubview:self.backGroundView];
    }
    return self;
}
-(void)setPost:(ZZPost *)post{
    _post = post;
    
    ZZUser *user = post.postUser;
    
    CGFloat  headX = margin;
    CGFloat  headY = margin;
    CGFloat   headW = 44;
    CGFloat   headH = 44;
    //头像
    UIImageView*  headImage = [[UIImageView alloc]initWithFrame:CGRectMake(headX, headY, headW, headH)];
    headImage.layer.cornerRadius = 5;
    headImage.layer.masksToBounds = YES;
    headImage.clipsToBounds = YES;
    headImage.contentMode = UIViewContentModeScaleAspectFill;
    headImage.userInteractionEnabled = YES;
    [headImage setImageWithURL:user.mbpImageinfo.smallImagePath placeholderImageName:@"head_portrait_55x55.jpg"];
    [self.backGroundView  addSubview:headImage];
    
    //为头像添加手势
    UITapGestureRecognizer*  headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapAction:)];
    [headImage addGestureRecognizer:headTap];
    //大人标识
    if (user.permissions==3&&user.isSuperStarUser) {
        UIImageView* sLv = [[UIImageView alloc]init];
        CGFloat   sLvW = 16;
        CGFloat   sLvH = 16;
        CGFloat scale = 0.6;
        CGFloat  sLvX = CGRectGetWidth(headImage.frame) - sLvW*scale;
        CGFloat  sLvY = CGRectGetHeight(headImage.frame) - sLvH*scale;
        //sLv.frame = CGRectMake(92+labelSize2.width, 15, 10, 10);
        //达人等级标志加载到头像右下角
        sLv.frame = CGRectMake(sLvX, sLvY, sLvW, sLvH);
        sLv.image =[UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:[user  getClassImagePathWithDaRenLevel:user.superStarLv] ofType:nil]];
        [headImage addSubview:sLv];
    }
    
    //名字label
    TTTAttributedLabel*  nameLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
    nameLabel.font = nickFont;
    nameLabel.textColor = ZZDarkGrayColor;
    
    CGFloat standardHeight = nameLabel.font.pointSize + 1; //标准的名字高
    CGFloat  nameX = CGRectGetMaxX(headImage.frame)+middleMargin;
   CGSize nameSize = [nameLabel  getHeightWithLabelString:user.nick limitSize:CGSizeMake(selfWidth/2, 20) numberOfLines:1];

   CGFloat  nameY = headY +minMargin-nameSize.height+standardHeight;
    nameLabel.frame = (CGRect){{nameX,nameY},nameSize};
    [self.backGroundView addSubview:nameLabel];

    
      //身份标识
    UILabel*  identityLabel = [[UILabel  alloc]init];
    identityLabel.font = timeFont;
    identityLabel.layer.cornerRadius = 3;
    identityLabel.text = [user   getUserIdentify];
    identityLabel.textColor = idenColor;

    identityLabel.textAlignment = NSTextAlignmentLeft;
    identityLabel.layer.masksToBounds = YES;
    identityLabel.clipsToBounds = YES;
    
    CGFloat  identityLvX = CGRectGetMinX(nameLabel.frame) ;
    identityLabel.textColor =[UIColor colorWithRed:0.97 green:0.71 blue:0.32 alpha:1];
    CGSize identitySize = [identityLabel.text  sizeWithFont:identityLabel.font maxW:selfWidth/2];
    CGFloat  identityLvY = CGRectGetMaxY(nameLabel.frame)+minMargin;
    identityLabel.frame = (CGRect){{identityLvX,identityLvY},identitySize};
    [self.backGroundView  addSubview:identityLabel];
   
    //等级标志
    CGFloat  bigLvX = CGRectGetMaxX(identityLabel.frame) + minMargin;
    
    CGFloat  bigLvH = CGRectGetMaxY(identityLabel.frame) - CGRectGetMaxY(nameLabel.frame) -1;
    CGFloat  bigLvW = bigLvH *2;
    CGFloat  bigLvY = CGRectGetMaxY(identityLabel.frame) -bigLvH ;
    ZZIconView*  bigLv = [[ZZIconView alloc]init];
    bigLv.frame = CGRectMake(bigLvX, bigLvY, bigLvW, bigLvH);
    bigLv.user = user;
    [self.backGroundView addSubview:bigLv];
 
     //点赞
    if (![post.postPlateType.areaType  isEqualToString:@"HELP"]) {
      
        CGFloat supportW = 48;
        CGFloat  supportH = 48;
        CGFloat  supportX = selfWidth - supportW;
        CGFloat  supportY = 0;
       UIButton *   supportButton = [[UIButton alloc]initWithFrame:CGRectMake(supportX, supportY, supportW, supportH)];
        [supportButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"support_20x20.png" ofType:nil] ] forState:UIControlStateNormal];
        self.supportButton = supportButton;
        [supportButton addTarget:self action:@selector(supportButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [supportButton  setTitleColor:timeColor forState:UIControlStateNormal];
        [supportButton  setTitleEdgeInsets:UIEdgeInsetsMake(4, 0, 0, 0)];
     
        [self.backGroundView addSubview:supportButton];
        [self  updateSupportButton:self.supportButton];

    }
    //显示内容最大尺寸
    CGSize limitSize = CGSizeMake((selfWidth)-margin -8, MAXFLOAT);
    
    //标题
    TTTAttributedLabel* titleLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
    titleLabel.textColor = ZZDarkGrayColor;
    titleLabel.font = ZZTitleFont;
   CGSize titleSize =  [titleLabel getHeightWithLabelString:post.postTitle limitSize:limitSize numberOfLines:0];

    CGFloat  titleY = middleMargin + MAX(CGRectGetMaxY(headImage.frame), CGRectGetMaxY(bigLv.frame));
    CGFloat  titleX = headX-1;
    titleLabel.frame = (CGRect){{titleX,titleY},titleSize};
    [self.backGroundView addSubview:titleLabel];
    CGFloat   height = CGRectGetMaxY(titleLabel.frame);
    
    //内容
    if (post.postContent.length) {

        TTTAttributedLabel*  contentLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        contentLabel.font = ZZTitleFont;
        contentLabel.textColor = ZZLightGrayColor;
        //根据字符串长度和Label显示的宽度计算出contentLab的高
      CGSize   contentSize =   [contentLabel  getHeightWithLabelString:post.postContent limitSize:limitSize numberOfLines:0];

        CGFloat contentX = headX-1;
        CGFloat contentY = height + margin;
        contentLabel.frame = (CGRect){{contentX,contentY},contentSize};
        [self.backGroundView addSubview:contentLabel];
        height = CGRectGetMaxY(contentLabel.frame);
    }
 
    //图片、内容描述
    NSInteger i =0;
    for (ZZMengBaoPaiImageInfo* imageInfo in post.postImagesArray) {
        UIImageView* imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.tag = i+tagAdd;
        UITapGestureRecognizer*  imageTap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(imageTapAction:)];
        [imageView  addGestureRecognizer:imageTap];
        [imageView  setImageWithURL:imageInfo.largeImagePath placeholderImageName:@"loading_image_2_320x500.jpg"];
        CGFloat imageX = headX;
        CGFloat  imageY = height + middleMargin+minMargin;
        CGFloat  imageW = selfWidth - 2*margin;
        CGFloat imageHeight = imageInfo.largeImageHeight*imageW/imageInfo.largeImageWidth;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageHeight);
        height = CGRectGetMaxY(imageView.frame);
        if (imageInfo.descContent.length) {
            //内容
            TTTAttributedLabel* imageDescLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
            imageDescLabel.font = ZZTitleFont;
            imageDescLabel.textColor = ZZLightGrayColor;
            CGFloat  imageDescX = headX-1;
            CGFloat  imageDescY = height + minMargin;
           CGSize imageDescSize =  [imageDescLabel  getHeightWithLabelString:imageInfo.descContent limitSize:limitSize numberOfLines:0];
 
            //根据字符串长度和Label显示的宽度计算出contentLab的高
            imageDescLabel.frame = (CGRect){{imageDescX,imageDescY},imageDescSize};
            height = CGRectGetMaxY(imageDescLabel.frame);
            [self.backGroundView addSubview:imageDescLabel];
        }
        i++;
        [self.backGroundView addSubview:imageView];
        //相册图片
        [self.wBrowserPhotos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imageInfo.largeImagePath ]]];
    }
    
    //发布时间
    CGFloat  clockX = headX;
    CGFloat  clockY = height + middleMargin;
    CGFloat  clockW = 16;
    CGFloat  clockH = 16;
    UIImageView* clockImage = [[UIImageView alloc]initWithFrame:CGRectMake(clockX, clockY, clockW, clockH)];
    clockImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"clock_14x14" ofType:@"png"]];
    clockImage.alpha = 0.3;
    clockImage.contentMode = UIViewContentModeCenter;
    [self.backGroundView addSubview:clockImage];
    
    //回复时间
    UILabel* timeLabel = [[UILabel alloc]init];
    timeLabel.text = post.postDateStr;
     timeLabel.font = timeFont;
     CGSize timeSize = [timeLabel.text  sizeWithFont:timeLabel.font maxW:selfWidth/2];
    CGFloat  timeX =  CGRectGetMaxX(clockImage.frame)+minMargin;
    CGFloat  timeY = clockY;
    CGFloat  timeW = timeSize.width;
    CGFloat  timeH = clockH;
    timeLabel.frame = CGRectMake(timeX, timeY, timeW, timeH);
    timeLabel.textColor = timeColor;
    [self.backGroundView addSubview:timeLabel];
    
    CGFloat  selfW = selfWidth;
    CGFloat  selfH = MAX(CGRectGetMaxY(clockImage.frame), CGRectGetMaxY(timeLabel.frame))+ middleMargin;
    self.backGroundView.frame = CGRectMake(superMargin, 0, selfW, selfH);
    self.bounds = CGRectMake(0, 0, ScreenWidth, selfH);
   }
//头像点击事件
-(void)headTapAction:(UITapGestureRecognizer*)tap{
    if ([self.delegate  respondsToSelector:@selector(postViewTapHeadImage:)]) {
        [self.delegate  postViewTapHeadImage:self];
    }
}

-(void)imageTapAction:(UITapGestureRecognizer*)tap{
    
  
    [self.photoBrowser setCurrentPhotoIndex:tap.view.tag - tagAdd];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[UIApplication  sharedApplication].keyWindow.rootViewController presentViewController:nc animated:YES completion:nil];
//    MJPhotoBrowser*  wPhotoBrowser = [[MJPhotoBrowser alloc] init];
//    wPhotoBrowser.photos = self.wBrowserPhotos;
//    wPhotoBrowser.currentPhotoIndex = tap.view.tag - tagAdd ; // 弹出相册时显示的第一张图片是？
//    [ wPhotoBrowser show];
}
//点赞按钮响应事件
-(void)supportButtonAction{

  
    self.post.postSportCount+= self.post.postCurrentUserSpot ?-1:1;
    self.post.postCurrentUserSpot = !self.post.postCurrentUserSpot;
    [self  updateSupportButton:self.supportButton];
    if ([self.delegate respondsToSelector:@selector(postViewClickSpotButton:)]) {
        [self.delegate  postViewClickSpotButton:self];
    }
}

-(void)updateSupportButton:(UIButton*)btn{
    ZZPost *post = self.post;
    if (post.postSportCount < 0) {
        post.postSportCount = 0;
    }

    NSString *buttonTitle = [NSString  stringWithFormat:@"%ld",post.postSportCount];
    CGSize titleSize = [buttonTitle  sizeWithFont:btn.titleLabel.font maxW:selfWidth/3];
    CGRect frame = btn.frame;
    frame.size.width = titleSize.width + 44;
    frame.origin.x = selfWidth-frame.size.width;
    btn.frame = frame;
    [btn setTitle:buttonTitle forState:UIControlStateNormal];
    if (post.postCurrentUserSpot) {
        [btn setImage:[UIImage imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"supported_20x20.png" ofType:nil] ] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"support_20x20.png" ofType:nil] ] forState:UIControlStateNormal];
    }
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.wBrowserPhotos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.wBrowserPhotos.count)
        return [self.wBrowserPhotos objectAtIndex:index];
    return nil;
}
@end
