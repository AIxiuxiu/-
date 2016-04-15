//
//  ASScroll.m
//  ScrollView Source control
//
//  Created by Ahmed Salah on 12/14/13.
//  Copyright (c) 2013 Ahmed Salah. All rights reserved.
//

#import "ASScroll.h"

@implementation ASScroll
@synthesize arrOfImages;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        // Initialization code
    }
    return self;
}

-(void)setArrOfImages:(NSMutableArray *)arr{
    arrOfImages = arr;
        if (arr.count>1) {
            pageControl = [[UIPageControl alloc] init];
            pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
            
            pageControl.frame = CGRectMake(self.frame.size.width- 150,self.frame.size.height-50, 122, 36);
            pageControl.numberOfPages = arrOfImages.count;
            pageControl.currentPage = 0;
            CGPoint  center = self.center;
            center.y+=65;
            pageControl.center = center;
        }
        
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    scrollview.scrollsToTop = NO;
        scrollview.contentSize = CGSizeMake(scrollview.frame.size.width * arrOfImages.count,scrollview.frame.size.height);
    //scrollview.bounces = NO;
        [scrollview setDelegate:self];
        //scrollview.userInteractionEnabled = YES;
        scrollview.showsVerticalScrollIndicator = NO;
        scrollview.showsHorizontalScrollIndicator = NO;
        scrollview.pagingEnabled = YES;
        
        [self performSelector:@selector(startAnimatingScrl) withObject:nil afterDelay:3.0];
        
    
        
        
        for (int i =0; i<arrOfImages.count ; i++) {
            UIImageView * imageview = [arrOfImages objectAtIndex:i];
            imageview.clipsToBounds = YES;
            [imageview setContentMode:UIViewContentModeScaleAspectFill];
            imageview.frame = CGRectMake(i*scrollview.frame.size.width, 0.0,scrollview.frame.size.width , scrollview.frame.size.height);
            //[imageview setTag:i+1];
            imageview.userInteractionEnabled = YES;
//            if (i !=0) {
//                imageview.alpha = 0;
//            }
           [scrollview addSubview:imageview];
          
        }
      [self addSubview:scrollview];
        [self addSubview:pageControl];


}
- (void)startAnimatingScrl
{
    if (arrOfImages.count) {
        
      [scrollview scrollRectToVisible:CGRectMake(((pageControl.currentPage +1)%arrOfImages.count)*scrollview.frame.size.width, 0, scrollview.frame.size.width, scrollview.frame.size.height) animated:YES];
        [pageControl setCurrentPage:((pageControl.currentPage +1)%arrOfImages.count)];
        [self performSelector:@selector(startAnimatingScrl) withObject:nil  afterDelay:3.0];
    }
}
-(void) cancelScrollAnimation{
    didEndAnimate =YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startAnimatingScrl) object:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self cancelScrollAnimation];
}

//- (void)pgCntlChanged:(UIPageControl *)sender {
//    [scrollview scrollRectToVisible:CGRectMake(sender.currentPage*scrollview.frame.size.width, 0, scrollview.frame.size.width, scrollview.frame.size.height) animated:YES];
//    [self cancelScrollAnimation];
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

   [self performSelector:@selector(startAnimatingScrl) withObject:nil afterDelay:3.0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGPoint offset = scrollView.contentOffset;
    if(offset.x<0){
        offset.x = scrollview.frame.size.width * (arrOfImages.count-1);
       scrollView.contentOffset = offset;
        NSUInteger index = round(offset.x / scrollView.frame.size.width);
        pageControl.currentPage = index;
        scrollview.scrollEnabled = NO;
    }
    
    if (offset.x>scrollview.frame.size.width * (arrOfImages.count-1)) {
        
               offset.x = 0;
               scrollView.contentOffset = offset;
        NSUInteger index = round(offset.x / scrollView.frame.size.width);
        pageControl.currentPage = index;
        scrollview.scrollEnabled = NO;
    }
    NSUInteger index = round(offset.x / scrollView.frame.size.width);
    pageControl.currentPage = index;
    scrollview.scrollEnabled = YES;

}

-(void)dealloc{
    scrollview.delegate = nil;
    [self cancelScrollAnimation];
}

@end
