//
//  ZZImageSelect.m
//  萌宝派
//
//  Created by zhizhen on 15/7/20.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZImageSelect.h"
#import "ZLCameraViewController.h"
#import "ZLPhotoPickerBrowserViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZLPhoto.h"
@interface  ZZImageSelect()<ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong,nonatomic) ZLCameraViewController *cameraVc;
@property (nonatomic , strong) NSMutableArray *assets;
@end
@implementation ZZImageSelect

-(NSMutableArray *)assets{
    if (_assets == nil) {
        _assets = [NSMutableArray  array];
    }
    return _assets;
}
#pragma mark - <ZZImageSelectDelegate>
-(void)imageSelectShow{
    if (self.head) {//调用系统的
        [self  callSystemCameraOrPhotos];
    }else{
        ZLCameraViewController *cameraVc = [[ZLCameraViewController alloc] init];
        cameraVc.maxCount = self.maxCount ;
        __weak typeof(self) weakSelf = self;
        __block  NSMutableArray  *marray = [NSMutableArray  array];
        // 多选相册+相机多拍 回调
        [cameraVc startCameraOrPhotoFileWithViewController:self.delegate complate:^(NSArray *object) {
            // 选择完照片、拍照完回调
            [object enumerateObjectsUsingBlock:^(id asset, NSUInteger idx, BOOL *stop) {
                if ([asset isKindOfClass:[ZLCamera class]]) {
                    [weakSelf.assets  addObject:asset];
                    [marray  addObject:[asset thumbImage]];
                }else{
                    [weakSelf.assets  addObject:asset];
                    if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
                        [marray  addObject:[asset originImage]];
                    }else {
                        if (asset){
                           [marray  addObject:asset]; 
                        }
                        
                    }
                }
            }];
            if (marray.count && [weakSelf.delegate  respondsToSelector:@selector(imageSelect:images:)]) {
                [weakSelf.delegate  imageSelect:weakSelf images:marray];
            }
            //[weakSelf  imageSelectOk:marray];
        }];
        self.cameraVc = cameraVc;
    }
}

-(void)imageFullScreen:(NSIndexPath*)indexpath{
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    
    // 数据源/delegate
    // 动画方式
    /*
     *
     UIViewAnimationAnimationStatusZoom = 0, // 放大缩小
     UIViewAnimationAnimationStatusFade , // 淡入淡出
     UIViewAnimationAnimationStatusRotate // 旋转
     pickerBrowser.status = UIViewAnimationAnimationStatusFade;
     */
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    // 是否可以删除照片
    pickerBrowser.editing = YES;
    // 当前分页的值
    // pickerBrowser.currentPage = indexpath.row;
    // 传入组
    pickerBrowser.currentIndexPath = indexpath;
    
    
    // 展示控制器
    [pickerBrowser show];
}
-(void)deleteImage:(NSIndexPath*)indexpath{
    [self  photoBrowser:nil removePhotoAtIndexPath:indexpath];
}


#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>


- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return [self.assets count];
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    if (self.assets.count>indexPath.item) {
        id imageObj = [self.assets objectAtIndex:indexPath.item];
        ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
        // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
        //    Example2CollectionViewCell *cell = (Example2CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        //    // 缩略图
        if ([self.delegate respondsToSelector:@selector(imageSelect:atIndexPath:)]) {
            UIImageView *imageView =  [self.delegate  imageSelect:self atIndexPath:indexPath];
            photo.toView = imageView;
            photo.thumbImage = imageView.image;
        }
        
        return photo;
    }else{
        return nil;
    }

}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDelegate>
#pragma mark 返回自定义View
//- (ZLPhotoPickerCustomToolBarView *)photoBrowserShowToolBarViewWithphotoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser{
//    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [customBtn setTitle:@"实现代理自定义ToolBar" forState:UIControlStateNormal];
//    customBtn.frame = CGRectMake(10, 0, 200, 44);
//    return (ZLPhotoPickerCustomToolBarView *)customBtn;
//}

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > [self.assets count]) return;
    [self.assets removeObjectAtIndex:indexPath.row];
    
    if ([self.delegate  respondsToSelector:@selector(imageSelect:deleteAtIndexPath:)]) {
        [self.delegate  imageSelect:self deleteAtIndexPath:indexPath];
    }
   // [self.collectionView reloadData];
}

#pragma mark   private methods
-(void)callSystemCameraOrPhotos{
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"打开照相机",@"从手机相册获取",nil];
    
    [myActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}
//打开系统自带相册 相机
-(void)openSystemPhotoCameraWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    imagePicker.allowsEditing = self.headEdit;
  
    @try {
        [[[[UIApplication sharedApplication].windows firstObject] rootViewController] presentViewController:imagePicker animated:YES completion:nil];
    }
    @catch (NSException *exception) {
        [[[[UIApplication sharedApplication].windows lastObject] rootViewController] presentViewController:imagePicker animated:YES completion:nil];
    }
}
#warning self write 访问权限提醒
-(void)tipDeviceAccessPermission:(NSString*)deviceType{
    NSString *title  = [NSString  stringWithFormat:@"无法访问%@",deviceType];
    NSString *message = [NSString  stringWithFormat:@"请在设备的\"设置-隐私-%@\"中允许\"萌宝派\"访问%@。",deviceType,deviceType];
    
    UIAlertView  *alert = [[UIAlertView  alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [alert show];
}
//请求相机权限
-(void)requestCaeraAccessPermission{
    [AVCaptureDevice   requestAccessForMediaType:AVMediaTypeVideo    completionHandler:^(BOOL granted) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted)
                
            {
                //打开相机
                [self openSystemPhotoCameraWithSourceType:UIImagePickerControllerSourceTypeCamera];
                
            }else{
                [self  tipDeviceAccessPermission:@"相机"];
            }
        });
    }];
}
#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
        {
            AVAuthorizationStatus  authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo                                                                                                                                                                                                                                                                                                                                                        ];
            if (authStatus == AVAuthorizationStatusAuthorized) {//有访问权限
                
                [self openSystemPhotoCameraWithSourceType:UIImagePickerControllerSourceTypeCamera];
            }else  if(authStatus == AVAuthorizationStatusNotDetermined){//没有授权过
                [self  requestCaeraAccessPermission];
            }else{//没有访问权限
                [self  tipDeviceAccessPermission:@"相机"];
            }
            
        }
            
            
            break;
        case 1:  //打开本地相册
        {
            ALAuthorizationStatus  authStatus = [ALAssetsLibrary authorizationStatus];
            if (authStatus == ALAuthorizationStatusAuthorized || authStatus ==ALAuthorizationStatusNotDetermined ) {// 有访问权限或没有咨询过
                [self  openSystemPhotoCameraWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            }else{//没有访问权限
                [self  tipDeviceAccessPermission:@"照片"];
            }
        }
            
            break;
    }
}


#pragma mark  ---UIImagePickerControllerDelegate
//相册取消按钮的点击事件
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

//相册带回照片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage*image=nil;
    if (self.headEdit) {
        image=   [info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        image=   [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if ([self.delegate  respondsToSelector:@selector(imageSelect:images:)]&&image) {
        [self.delegate  imageSelect:self images:@[image]];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}
@end
