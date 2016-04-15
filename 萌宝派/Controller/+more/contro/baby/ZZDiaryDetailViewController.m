//
//  ZZDiaryDetailViewController.m
//  萌宝派
//
//  Created by charles on 15/4/1.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZDiaryDetailViewController.h"
#import "ZZDairyCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "ZZMengBaoPaiImageInfo.h"
#import "ZZShowView.h"
static CGFloat const  separMargin = 5;
#define  cellHW  ScreenWidth/5
@interface ZZDiaryDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)UICollectionView* imageCollectCiew;
@property(nonatomic,strong)UIImageView* bigImageview;
@property(nonatomic,strong)UILabel*  separLabel;//分割线
@property(nonatomic,strong)UILabel* whiteLabel;//白线label
@property(nonatomic,strong)ZZShowView* textLabel;//写的语录
@property(nonatomic,strong)UILabel* titleLabel;//寄语
@property(nonatomic,strong)UIView* kuangView;//选中框

@end

@implementation ZZDiaryDetailViewController
#pragma mark --------------------lazy load--------------------
-(UIView *)kuangView{
    if (!_kuangView) {
        _kuangView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellHW, cellHW)];
        _kuangView.backgroundColor = [UIColor clearColor];
        _kuangView.layer.borderWidth = 1;
        _kuangView.layer.borderColor = ZZTextGreenColor.CGColor;
    }
    return _kuangView;
}

-(ZZShowView *)textLabel{
    if (!_textLabel) {
        _textLabel = [[ZZShowView alloc]initWithFrame:CGRectMake(50, CGRectGetMinY(self.imageCollectCiew.frame) -80 -separMargin, ScreenWidth - 65,  80)];
        _textLabel.backgroundColor = [UIColor whiteColor];
        _textLabel.textColor = ZZDarkGrayColor;
        _textLabel.font = ZZContentFont;
    }
    return _textLabel;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(self.textLabel.frame)+separMargin, 45, 20)];
        _titleLabel.textColor = ZZLightGrayColor;
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.text = @"寄语:";
        _titleLabel.font = ZZContentFont;
    }
    return _titleLabel;
}

-(UILabel *)separLabel{
    if (!_separLabel) {
        _separLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(self.textLabel.frame) -0.5 -separMargin, ScreenWidth, 0.5)];
        _separLabel.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    }
    return _separLabel;
}

-(UILabel *)whiteLabel{
    if (!_whiteLabel) {
        _whiteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(self.textLabel.frame) -1 -separMargin, ScreenWidth, 1)];
        _whiteLabel.backgroundColor = [UIColor whiteColor];
    }
    return _whiteLabel;
}


#pragma mark --------------------UIImageView初始化--------------------
-(UIImageView *)bigImageview{
    if (!_bigImageview) {
        _bigImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetMinY(self.separLabel.frame)-separMargin)];

        _bigImageview.contentMode = UIViewContentModeScaleAspectFit;
        _bigImageview.clipsToBounds = YES;
    }
    return _bigImageview;
}

-(UICollectionView *)imageCollectCiew{
    if (!_imageCollectCiew) {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
        //内容大小
        flowLayout.itemSize = CGSizeMake(cellHW, cellHW);
        //横向滑动
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        //相对collectionview的位置
        flowLayout.sectionInset = UIEdgeInsetsMake(separMargin, separMargin, separMargin, separMargin);
        _imageCollectCiew = [[UICollectionView alloc]initWithFrame:CGRectMake(0, ScreenHeight-2*separMargin -cellHW, ScreenWidth, cellHW + 2*separMargin) collectionViewLayout:flowLayout];
        _imageCollectCiew.backgroundColor = [UIColor  clearColor];
        _imageCollectCiew.delegate = self;
        _imageCollectCiew.dataSource = self;
    }
    return _imageCollectCiew;
}


#pragma mark --------------------life cycle--------------------
static  NSString* bigImgCellIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日记详情";
    //加载imageView
    [self.view  addSubview:self.bigImageview];
    //注册collectionViewcell
    [self.imageCollectCiew  registerClass:[ZZDairyCollectionViewCell  class] forCellWithReuseIdentifier:bigImgCellIdentifier];
    //加载collectionView
    [self.view  addSubview:self.imageCollectCiew];
 
    [self.view addSubview:self.whiteLabel];
    [self.view addSubview:self.separLabel];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.textLabel];
    [self collectionView:self.imageCollectCiew didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
//    ZZMengBaoPaiImageInfo* imageInfo = self.diaryInfo.diaryImagesAray[0];
//    [self.bigImageview  sd_setImageWithURL:[NSURL URLWithString:imageInfo.largeImagePath]  placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"head_portrait_55x55.jpg" ofType:nil]]options:SDWebImageRetryFailed | SDWebImageLowPriority ];
//    //图片大小
//    if (imageInfo.largeImageHeight>imageInfo.largeImageWidth) {
//        if (imageInfo.largeImageHeight>260) {
//            self.bigImageview.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-imageInfo.largeImageWidth/imageInfo.largeImageHeight*260)/2, 64, imageInfo.largeImageWidth/imageInfo.largeImageHeight*260, 260);
//        }else{
//            self.bigImageview.frame = CGRectMake(40, 74, 240, 240);
//        }
//    }else{
//        if (imageInfo.largeImageWidth>320){
//            self.bigImageview.frame = CGRectMake(0, 35+(320-imageInfo.largeImageHeight/imageInfo.largeImageWidth*320)/2, 320, imageInfo.largeImageHeight/imageInfo.largeImageWidth*320);
//        }else{
//            self.bigImageview.frame = CGRectMake(40, 74, 240, 240);
//        }
//    }
//    if (imageInfo.descContent.length) {
//        self.textLabel.text = imageInfo.descContent;
//    }else{
//        self.textLabel.text = @"没记录哦！";
//        
//    }
    
    
}

#pragma mark --------------------collection协议方法--------------------
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.diaryInfo.diaryImagesAray.count == 1) {
        return 0;
    }else{
        return self.diaryInfo.diaryImagesAray.count;
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZDairyCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:bigImgCellIdentifier forIndexPath:indexPath];
    if (indexPath.item == 0) {
        [cell.contentView addSubview:self.kuangView];
    }
    
    ZZMengBaoPaiImageInfo* imageInfo = self.diaryInfo.diaryImagesAray[indexPath.item];
    [cell.smallImage  sd_setImageWithURL:[NSURL URLWithString:imageInfo.smallImagePath]  placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"loading_image_1_90x90.jpg" ofType:nil]]options:SDWebImageRetryFailed | SDWebImageLowPriority ];
    return cell;
}

//collectionView点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZDairyCollectionViewCell* collectCell = (ZZDairyCollectionViewCell*)[collectionView  cellForItemAtIndexPath:indexPath];
    [collectCell.contentView addSubview:self.kuangView];
    ZZMengBaoPaiImageInfo* imageInfo = self.diaryInfo.diaryImagesAray[indexPath.item];
    [self.bigImageview  sd_setImageWithURL:[NSURL URLWithString:imageInfo.largeImagePath]  placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"loading_image_2_320x500.jpg" ofType:nil]]options:SDWebImageRetryFailed | SDWebImageLowPriority ];
    
    if (imageInfo.descContent.length) {
        self.textLabel.text = imageInfo.descContent;
        
    }else{
        self.textLabel.text = @"没记录哦！";
    }
    
}

@end
