//
//  ZZLoadingViewController.m
//  萌宝派
//
//  Created by zhizhen on 14-10-31.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "ZZLoadingViewController.h"
#import "AppDelegate.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZLoginSatus.h"
@interface ZZLoadingViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation ZZLoadingViewController
#pragma mark   life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray*  imagesArray ;
    if(ScreenWidth ==480){
        imagesArray = @[@"home11",@"home22",@"home33"];
    }else{
        imagesArray = @[@"home1",@"home2",@"home3"];
    }
    /*
     张亮亮  0512 更改启动动画，加更新说明
     */
    //创建ScrollView
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.scrollView = scrollView;
    //加入多个子视图(ImageView)
    for(int i=0; i<imagesArray.count; i++){


       UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:imagesArray[i] ofType:@"jpg"]];
//        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:imagesArray[i] ofType:@"jpg" inDirectory:@"ZZMengBaoPai.bundle"]];
       

//        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:imagesArray[i] ofType:nil]];

       // image = [UIImage  imageNamed:imagesArray[i]];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        CGRect frame = CGRectZero;
        frame.origin.x = i * scrollView.frame.size.width;
        frame.size = scrollView.frame.size;
        imageView.frame = frame;
        [scrollView addSubview:imageView];
    }
    //设置相关属性
    CGSize size = CGSizeMake(scrollView.frame.size.width * imagesArray.count, scrollView.frame.size.height );
    scrollView.bounces = NO;
    scrollView.contentSize = size;
    scrollView.showsVerticalScrollIndicator = NO;
    //整页滚动
    scrollView.pagingEnabled = YES;
    //加入到当前视图self.view
    [self.view addSubview:scrollView];
    //id a = @"dsafsdf";
    //NSLog(@"%d",[a length]);
    
    //加入页面指示控件PageControl
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    self.pageControl = pageControl;
    pageControl.frame = CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 20);
    pageControl.numberOfPages = imagesArray.count;
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
    scrollView.delegate = self;
    
    UILabel*   label = [[UILabel  alloc]initWithFrame:CGRectMake(scrollView.frame.size.width * (imagesArray.count - 1)+90, ScreenHeight-165, ScreenWidth-180, 40)];
    label.text = [NSString  stringWithFormat:@"新版升级%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    label.textColor = [UIColor  whiteColor];
    label.font =[UIFont  boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
     [scrollView addSubview:label];
    
    
    
    
    
    
    //加个按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(scrollView.frame.size.width * (imagesArray.count - 1)+95, ScreenHeight-110, ScreenWidth-190, 40);
    
    button.layer.cornerRadius = 20;
    if (ScreenHeight==480) {
        button.frame = CGRectMake(scrollView.frame.size.width * (imagesArray.count - 1)+95, ScreenHeight-90, ScreenWidth-190, 42);
        button.layer.cornerRadius =21;
        label.frame =CGRectMake(scrollView.frame.size.width * (imagesArray.count - 1)+90, ScreenHeight-135, ScreenWidth-180, 40);
    }
    button.backgroundColor = [UIColor  whiteColor];
    button.layer.masksToBounds = YES;
    button.titleLabel.font = [UIFont  boldSystemFontOfSize:20];
    [button  setTitleColor:[UIColor  colorWithRed:40*(1.0)/255 green:140*(1.0)/255 blue:146*(1.0)/255 alpha:1] forState:UIControlStateNormal];
   // button.titleLabel.textColor = [UIColor  colorWithRed:40/255 green:40/255 blue:46/255 alpha:1];
    
    [button  setTitle:@"开始体验" forState:UIControlStateNormal];
    [scrollView addSubview:button];
    [button addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];
    
//    UIView*   view = [[UIView  alloc]initWithFrame:CGRectMake(scrollView.frame.size.width * (imagesArray.count - 1)+78*AutoSizeScalex, ScreenHeight-112*AutoSizeScaley, ScreenWidth-162*AutoSizeScalex, 49*AutoSizeScaley)];
//     view.layer.cornerRadius = 24.5*AutoSizeScaley;
//    
//    view.backgroundColor = [UIColor  redColor];
//    view.alpha = 0.5;
//    [scrollView  addSubview:view];
    
    /*
    int  index =   arc4random()%imagesArray.count;
    
    UIImage* image = [UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:imagesArray[index] ofType:nil]];
    
    //保存本地缓存
    NSString* imageName = imagesArray[index];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:imageName forKey:@"imageName"];
    [userDefaults synchronize];
    
    UIImageView*  iv = [[UIImageView  alloc]initWithFrame:CGRectMake(0,0, [UIScreen  mainScreen].bounds.size.width,[UIScreen  mainScreen].bounds.size.height)];
    
    iv.image = image;
    
    iv.clipsToBounds = YES;
    iv.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [self.view  addSubview:iv];
    
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"线程");
//        [self changeWindowRootVC];
//    });
    
    [NSTimer   scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeWindowRootVC) userInfo:nil repeats:NO];
     */
    
}
#pragma mark  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGPoint offset = scrollView.contentOffset;

    if(offset.x<=0){
        offset.x = 0;
        scrollView.contentOffset = offset;
    }
    
    NSUInteger index = round(offset.x / scrollView.frame.size.width);
    self.pageControl.currentPage = index;
}

#pragma mark event response
- (void)enter
{
     AppDelegate* app =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app  loginOrHomeByLoginStaus];
   
}

-(void)dealloc{
    self.scrollView.delegate = nil;
}
/*
-(void)changeWindowRootVC{
    AppDelegate* app =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    int  direction =   arc4random()%4;
    
    CATransition*  animation = [self animationWithType:7 direction:direction duration:2.0];
    
    [app.window.layer  addAnimation:animation forKey:@"animation"];
    if ([ZZLoginSatus  sharedZZLoginSatus].loginStatus) {
        [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postLoginUserWithPhoneNumber:nil andPassword:nil andToken:[ZZLoginSatus  sharedZZLoginSatus].token andBack:^(id obj) {
            if ([obj  integerValue]) {
                [app  gotoBWindowAndController:2];
            }else{
                [app  gotoBWindowAndController:1];
            }
        }];
    }else{
        [app  gotoBWindowAndController:1];
    }

}

- (CATransition *)animationWithType:(int)animationType direction:(int)direction   duration:(CGFloat)duration{
    CATransition *animation = [CATransition animation];
    [animation setDuration:duration];
    switch (animationType) {
        case 0:
            animation.type = kCATransitionFade; //淡化
            break;
        case 1:
            animation.type = kCATransitionPush; //推挤
            break;
        case 2:
            animation.type = kCATransitionReveal; //揭开
            break;
        case 3:
            animation.type = kCATransitionMoveIn;//覆盖
            break;
        case 4:
            animation.type = @"cube";   //立方体
            break;
        case 5:
            animation.type = @"suckEffect"; //吸收
            break;
        case 6:
            animation.type = @"oglFlip";    //旋转
            break;
        case 7:
            animation.type = @"rippleEffect";   //波纹
            break;
        case 8:
            animation.type = @"pageCurl";   //翻页
            break;
        case 9:
            animation.type = @"pageUnCurl"; //反翻页
            break;
        case 10:
            animation.type = @"cameraIrisHollowOpen";   //镜头开
            break;
        case 11:
            animation.type = @"cameraIrisHollowClose";  //镜头关
            break;
        default:
            animation.type = kCATransitionPush; //推挤
            break;
    }
    
    switch (direction) {
        case 0:
            animation.subtype = kCATransitionFromLeft;
            break;
        case 1:
            animation.subtype = kCATransitionFromRight;
            break;
        case 2:
            animation.subtype = kCATransitionFromTop;
            break;
        case 3:
            animation.subtype = kCATransitionFromBottom;
            break;
        default:
            animation.subtype = kCATransitionFromRight;
            break;
    }
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    return animation;
}
*/

@end
