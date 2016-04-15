//
//  ZZOutdoorViewController.m
//  萌宝派
//
//  Created by charles on 15/3/16.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZOutdoorViewController.h"
#import <BaiduMapAPI/BMapKit.h>

@interface ZZOutdoorViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate>
@property(nonatomic,strong)BMKMapView*  mapView;
@property(nonatomic,strong)BMKLocationService*  locService;
@property(nonatomic,strong)BMKPoiSearch*  poiSearch;
@property(nonatomic,strong)UIButton*  hospitalButton;//医院
@property(nonatomic,strong)UIButton*  hotelButton;//酒店
@property(nonatomic,strong)UIButton*  playButton;//游乐场

//
//@property(nonatomic,strong)UIButton*   startLocationButton;//开始定位
//@property(nonatomic,strong)UIButton*    stopLoacationButton;//停止定位
@property(nonatomic,strong)UISlider*   zoomSlider;
//
@property(nonatomic,strong)UIButton*   bigZoomButton;//放大
@property(nonatomic,strong)UIButton*   smallZoomButton;//放大

@property(nonatomic,strong)UIButton*    clearButton;//清楚

//
@property(nonatomic,strong)UILabel*  statusTipLabel;
@property(nonatomic,strong)UIView*  bottomToolView;//底部工具栏
@property(nonatomic,strong)UIView*   rightToolView;//右侧工具栏
@end

@implementation ZZOutdoorViewController
#pragma mark  lazy load
-(BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView  alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _mapView.zoomLevel =15;
        _mapView.minZoomLevel = 9;
        _mapView.isSelectedAnnotationViewFront = YES;
        _mapView.scrollEnabled = YES;//
        _mapView.rotateEnabled = YES;
    }
    return _mapView;
}
-(BMKLocationService *)locService{
    if (!_locService) {
        _locService = [[BMKLocationService  alloc]init];
    }
    return _locService;
}
-(BMKPoiSearch *)poiSearch{
    if (!_poiSearch ) {
        _poiSearch = [[BMKPoiSearch  alloc]init];
    }
    return _poiSearch;
}
-(UIButton *)hospitalButton{
    if (!_hospitalButton) {
        _hospitalButton = [[UIButton  alloc]initWithFrame:CGRectMake(40, 5, 40, 30)];
        _hospitalButton.titleLabel.font = [UIFont  boldSystemFontOfSize:14];
        [_hospitalButton  addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _hospitalButton.tag = 1;
        [_hospitalButton  setTitle:@"医院" forState:UIControlStateNormal];
    }
    return _hospitalButton;
}
-(UIButton *)playButton{
    if (!_playButton) {
        _playButton = [[UIButton  alloc]initWithFrame:CGRectMake(90, 5, 50, 30)];
        _playButton.tag = 2;
        [_playButton  addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _playButton.titleLabel.font = [UIFont  boldSystemFontOfSize:14];
        [_playButton  setTitle:@"游乐园" forState:UIControlStateNormal];
    }
    return _playButton;
}
-(UIButton *)hotelButton{
    if (!_hotelButton) {
        _hotelButton = [[UIButton  alloc]initWithFrame:CGRectMake(150,5, 40, 30)];

        _hotelButton.tag = 3;
        [_hotelButton  addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _hotelButton.titleLabel.font = [UIFont  boldSystemFontOfSize:14];
        [_hotelButton  setTitle:@"酒店" forState:UIControlStateNormal];
    }
    return _hotelButton;
}
/*
-(UIButton *)startLocationButton{
    if (!_startLocationButton) {
        _startLocationButton = [[UIButton  alloc]initWithFrame:CGRectMake1(50, AutoSizey-330, 60, 30)];
        _startLocationButton.backgroundColor = [UIColor  redColor];
        _startLocationButton.layer.cornerRadius = 5;
        _startLocationButton.layer.masksToBounds = YES;
        _startLocationButton.tag = 4;
        [_startLocationButton  addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _startLocationButton.titleLabel.font = [UIFont  systemFontOfSize:14*AutoSizeScaley];
        [_startLocationButton  setTitle:@"开始定位" forState:UIControlStateNormal];
    }
    return _startLocationButton;
}
-(UIButton *)stopLoacationButton{
    if (!_stopLoacationButton) {
        _stopLoacationButton = [[UIButton  alloc]initWithFrame:CGRectMake1(50, AutoSizey-290, 60, 30)];
        _stopLoacationButton.backgroundColor = [UIColor  redColor];
        _stopLoacationButton.layer.cornerRadius = 5;
        _stopLoacationButton.layer.masksToBounds = YES;
        [_stopLoacationButton  addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _stopLoacationButton.tag = 5;
        [_stopLoacationButton  setTitle:@"结束定位" forState:UIControlStateNormal];
        _stopLoacationButton.titleLabel.font = [UIFont  systemFontOfSize:14*AutoSizeScaley];
    }
    return _stopLoacationButton;
}
 */
-(UIButton *)bigZoomButton{
    if (!_bigZoomButton) {
        _bigZoomButton = [[UIButton  alloc]initWithFrame:CGRectMake(5,5,20, 20)];

        _bigZoomButton.tag = 6;
        [_bigZoomButton  addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _bigZoomButton.titleLabel.font = [UIFont  boldSystemFontOfSize:24];
        [_bigZoomButton  setTitle:@"+" forState:UIControlStateNormal];
    }
    return _bigZoomButton;
}
-(UIButton *)smallZoomButton{
    if (!_smallZoomButton) {
        _smallZoomButton = [[UIButton  alloc]initWithFrame:CGRectMake(5,125, 20, 20)];
        _smallZoomButton.tag = 7;
        [_smallZoomButton  addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _smallZoomButton.titleLabel.font = [UIFont  boldSystemFontOfSize:32];
        [_smallZoomButton  setTitle:@"-" forState:UIControlStateNormal];
    }
    return _smallZoomButton;
}
-(UIButton *)clearButton{
    if (!_clearButton) {
        _clearButton = [[UIButton  alloc]initWithFrame:CGRectMake(10, 3, 30, 30)];
        _clearButton.tag = 8;
        //_clearButton.backgroundColor = [UIColor  redColor];
        [_clearButton  addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _clearButton.titleLabel.font = [UIFont  boldSystemFontOfSize:32];
        [_clearButton  setTitle:@"×" forState:UIControlStateNormal];
    }
    return _clearButton;
}
-(UILabel *)statusTipLabel{
    if (!_statusTipLabel) {
        _statusTipLabel = [[UILabel  alloc]initWithFrame:CGRectMake(ScreenWidth -120, 70, 100, 25)];
         _statusTipLabel.text = @"定位提示";
        _statusTipLabel.layer.cornerRadius =5;
        _statusTipLabel.layer.masksToBounds = YES;
        _statusTipLabel.backgroundColor = [UIColor  blackColor];
        _statusTipLabel.alpha = 0.65;
        _statusTipLabel.textAlignment = NSTextAlignmentCenter;
        _statusTipLabel.textColor= [UIColor  whiteColor];
    }
    return _statusTipLabel;
}
-(UISlider *)zoomSlider{
    if (!_zoomSlider) {
        _zoomSlider = [[UISlider  alloc]initWithFrame:CGRectMake(-26, 73, 80, 4)];
     //   _zoomSlider.backgroundColor = [UIColor redColor];
        _zoomSlider.transform =CGAffineTransformMakeRotation(M_PI_2);
        _zoomSlider.minimumValue = 0.1;
        _zoomSlider.maximumValue = 1.0;
        _zoomSlider.value = 1.0-0.6;
        [_zoomSlider addTarget:self action:@selector(mapZoom:) forControlEvents:UIControlEventValueChanged];
    }
    return _zoomSlider;
}
-(UIView *)bottomToolView{
    if (!_bottomToolView) {
        _bottomToolView = [[UIView  alloc]initWithFrame:CGRectMake(10, ScreenHeight-50, 200, 40)];
        _bottomToolView.layer.cornerRadius = 20;
        _bottomToolView.layer.masksToBounds = YES;
        _bottomToolView.backgroundColor = [UIColor  blackColor];
        _bottomToolView.alpha = 0.65;
    }
    return _bottomToolView;
}
-(UIView *)rightToolView{
    if (!_rightToolView) {
        _rightToolView = [[UIView  alloc]initWithFrame:CGRectMake(ScreenWidth -40, ScreenHeight-160, 30, 150)];
        _rightToolView.layer.cornerRadius = 15;
        _rightToolView.layer.masksToBounds = YES;
        _rightToolView.backgroundColor = [UIColor  blackColor];
        _rightToolView.alpha = 0.65;
    }
    return _rightToolView;
}

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"导航帮助";
    
    CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
    if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization]; // 永久授权
        [locationManager requestWhenInUseAuthorization]; //使用中授权
    }
//    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
//    {
//
//        //获取授权认证
//        [locationManager requestAlwaysAuthorization];
//         [locationManager requestWhenInUseAuthorization];
//    }
   

    [self.view  addSubview:self.mapView];
    [self.locService startUserLocationService];
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    self.mapView.showsUserLocation = YES;//显示定位图层
//    [self.view   addSubview:self.startLocationButton];
//    [self.view   addSubview:self.stopLoacationButton];
//    [self.view   addSubview:self.bigZoomButton];
//    [self.view   addSubview:self.smallZoomButton];
//    [self.view   addSubview:self.statusTipLabel];
    //
    [self.bottomToolView  addSubview:self.clearButton];
    [self.bottomToolView addSubview:self.hospitalButton];
    [self.bottomToolView  addSubview:self.playButton];
    [self.bottomToolView  addSubview:self.hotelButton];
    [self.view  addSubview:self.bottomToolView];
    //
    [self.rightToolView  addSubview:self.zoomSlider];
    [self.rightToolView  addSubview:self.bigZoomButton];
    [self.rightToolView   addSubview:self.smallZoomButton];
    [self.view  addSubview:self.rightToolView];
    [self.view  addSubview:self.statusTipLabel];
   // self.view  = self.mapView;
    //定位中，按钮不可用
    [self.bottomToolView  setUserInteractionEnabled:NO];
    [self.bottomToolView  setAlpha:0.2];
    [self.rightToolView  setUserInteractionEnabled:NO];
    [self.rightToolView  setAlpha:0.2];
//    [self.stopLoacationButton setEnabled:NO];
//    [self.stopLoacationButton setAlpha:0.6];
   
}
-(void)viewWillAppear:(BOOL)animated {
    [super  viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.locService.delegate = self;
    self.poiSearch.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super  viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
   self.mapView.delegate = nil; // 不用时，置nil
    self.locService.delegate = nil;
    self.poiSearch.delegate = nil; // 不用时，置nil
}
#pragma mark event response
//
-(void)mapZoom:(UISlider*)slider{
    self.mapView.zoomLevel = (int)((1-slider.value)*10)+9;
}
//
-(void)buttonAction:(UIButton*)btn{
    switch (btn.tag) {
            //搜索医院
        case 1:
        {
            BMKNearbySearchOption *nearSearchOption = [[BMKNearbySearchOption alloc]init];
            nearSearchOption.pageCapacity = 10;
            nearSearchOption.radius = 30000;
            nearSearchOption.location = self.mapView.centerCoordinate;
            nearSearchOption.keyword = @"医院";
            BOOL flag = [self.poiSearch poiSearchNearBy:nearSearchOption];
            if (flag) {
                
            }
            [self  changeButtonTitleColor];
            [btn  setTitleColor:[UIColor  colorWithRed:0.1 green:0.63 blue:0.96 alpha:0.93] forState:UIControlStateNormal];
            break;
        }
            //搜索游乐园
          case 2:
        {
            BMKNearbySearchOption *nearSearchOption = [[BMKNearbySearchOption alloc]init];
            nearSearchOption.pageCapacity = 10;
            nearSearchOption.radius = 30000;
            nearSearchOption.location = self.mapView.centerCoordinate;
            nearSearchOption.keyword = @"游乐园";
            BOOL flag = [self.poiSearch poiSearchNearBy:nearSearchOption];
            if (flag) {
                
            }
            [self  changeButtonTitleColor];
            [btn  setTitleColor:[UIColor  colorWithRed:0.1 green:0.63 blue:0.96 alpha:0.93] forState:UIControlStateNormal];
            break;
        }
            //搜索酒店
            case 3:
        {
            BMKNearbySearchOption *nearSearchOption = [[BMKNearbySearchOption alloc]init];
            nearSearchOption.pageCapacity = 10;
            nearSearchOption.radius = 30000;
            nearSearchOption.location = self.mapView.centerCoordinate;
            nearSearchOption.keyword = @"酒店";
            BOOL flag = [self.poiSearch poiSearchNearBy:nearSearchOption];
            if (flag) {
                
            }
            [self  changeButtonTitleColor];
            [btn  setTitleColor:[UIColor  colorWithRed:0.1 green:0.63 blue:0.96 alpha:0.93] forState:UIControlStateNormal];
            break;
        }
            //开始定位
            case 4:
        {
            self.statusTipLabel.text = @"定位中";
            [self.locService startUserLocationService];
            self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
            self.mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
            self.mapView.showsUserLocation = YES;//显示定位图层
            //
//            [self.startLocationButton setEnabled:NO];
//            [self.startLocationButton setAlpha:0.6];
//            //
//            [self.stopLoacationButton setEnabled:YES];
//            [self.stopLoacationButton setAlpha:1];
        }
            break;
           //关闭定位
            case 5:
            self.statusTipLabel.text = @"定位停止";
            [self.locService  stopUserLocationService];
            self.mapView.showsUserLocation =NO;
            
            //
//            [self.startLocationButton setEnabled:YES];
//            [self.startLocationButton setAlpha:1];
//            //
//            [self.stopLoacationButton setEnabled:NO];
//            [self.stopLoacationButton setAlpha:0.6];
            break;
            //放大
            case 6:
            [self.mapView  zoomIn];
            self.zoomSlider.value =1.0 -  (self.mapView.zoomLevel -9)/10;
            break;
            //缩小
            case 7:
            [self.mapView  zoomOut];
              self.zoomSlider.value =1.0 -  (self.mapView.zoomLevel -9)/10;
            break;
            
            case 8:
             [self.mapView removeAnnotations:self.mapView.annotations];
           //  self.statusTipLabel.text = nil;
            [self  changeButtonTitleColor];
            self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
           // [btn  setTitleColor:[UIColor  colorWithRed:0.1 green:0.63 blue:0.96 alpha:0.93] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    
}
#pragma mark private methods
-(void)changeButtonTitleColor{
    [self.clearButton   setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
     [self.hospitalButton   setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
     [self.playButton   setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
     [self.hotelButton   setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
}

//定位成功后  view用户交互
-(void)locationSuccessChangeViewUserInteractionEnabled{
    [self.bottomToolView  setUserInteractionEnabled:YES];
    [self.bottomToolView  setAlpha:0.65];
    [self.rightToolView  setUserInteractionEnabled:YES];
    [self.rightToolView  setAlpha:0.65];
}

#pragma mark  BMKLocationServiceDelegate
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    ZZLog(@"start locate");
    self.statusTipLabel.text = @"定位中";
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [self   locationSuccessChangeViewUserInteractionEnabled];
    self.statusTipLabel.text = @"定位成功";
    [self.mapView updateLocationData:userLocation];
//    self.mapView.showsUserLocation = NO;
 //  self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
//    self.mapView.showsUserLocation = YES;
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
 self.statusTipLabel.text = @"定位成功";
    [self  locationSuccessChangeViewUserInteractionEnabled];
    [self.mapView updateLocationData:userLocation];
//    self.mapView.showsUserLocation = NO;
 //  self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
//    self.mapView.showsUserLocation = YES;
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
   
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    self.statusTipLabel.text = @"定位失败";
  
}

#pragma mark implement BMKMapViewDelegate

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
   
}

#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
   
    if (error == BMK_SEARCH_NO_ERROR) {
         self.statusTipLabel.text = @"检索成功";
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [_mapView addAnnotation:item];
            if(i == 0)
            {
                //将第一个点的坐标移到屏幕中央
                _mapView.centerCoordinate = poi.pt;
            }
        }
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        self.statusTipLabel.text = @"起始点有歧义";
        
    } else {
        self.statusTipLabel.text = @"检索失败";
        // 各种情况的判断。。。
    }
}



- (void)dealloc {

        self.mapView = nil;
 
        self.poiSearch = nil;
  
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
