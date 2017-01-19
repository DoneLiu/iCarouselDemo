//
//  ViewController.m
//  iCarouselDemo
//
//  Created by Done.L (liudongdong@qiyoukeji.com) on 2017/1/19.
//  Copyright © 2017年 Done.L (liudongdong@qiyoukeji.com). All rights reserved.
//

#import "ViewController.h"

#import "iCarousel.h"

#import "EAIntroPage.h"
#import "EAIntroView.h"
#import "SMPageControl.h"

@interface ViewController () <iCarouselDataSource, iCarouselDelegate, EAIntroDelegate>

@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, assign) CGSize cardSize;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"introduction_bg@3x.png"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"introduction_1@3x.png"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"introduction_bg@3x.png"];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"introduction_2@3x.png"]];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"introduction_bg@3x.png"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"introduction_3@3x.png"]];
    
    EAIntroView *introView = [[EAIntroView alloc] initWithFrame:[UIScreen mainScreen].bounds andPages:@[page1, page2, page3]];
    introView.delegate = self;
    introView.pageControl = (UIPageControl *)[[SMPageControl alloc] init];
    
    // show skipButton only on 3rd page + animation
    introView.skipButton.alpha = 0.f;
    introView.skipButton.enabled = NO;
    page3.onPageDidAppear = ^{
        introView.skipButton.enabled = YES;
        [UIView animateWithDuration:0.3f animations:^{
            introView.skipButton.alpha = 1.f;
        }];
    };
    page3.onPageDidDisappear = ^{
        introView.skipButton.enabled = NO;
        [UIView animateWithDuration:0.3f animations:^{
            introView.skipButton.alpha = 0.f;
        }];
    };
    
    [introView showInView:self.view animateDuration:0.3f];
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return 15;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    return self.cardSize.width;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    UIView *cardView = view;
    if (!cardView) {
        cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cardSize.width, self.cardSize.height)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cardView.bounds];
        [cardView addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor whiteColor];
        
        cardView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:imageView.frame cornerRadius:5.0f].CGPath;
        cardView.layer.shadowRadius = 3.0f;
        cardView.layer.shadowColor = [UIColor blackColor].CGColor;
        cardView.layer.shadowOpacity = 0.5f;
        cardView.layer.shadowOffset = CGSizeMake(0, 0);
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = imageView.bounds;
        layer.path = [UIBezierPath bezierPathWithRoundedRect:imageView.frame cornerRadius:5.0f].CGPath;
        imageView.layer.mask = layer;
        
        //添加一个lable
        UILabel *lbl = [[UILabel alloc] initWithFrame:cardView.bounds];
        lbl.text = [@(index) stringValue];
        [cardView addSubview:lbl];
        lbl.font = [UIFont boldSystemFontOfSize:200];
        lbl.textAlignment = NSTextAlignmentCenter;
    }
    
    return cardView;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"index = %ld", index);
    [carousel removeItemAtIndex:index animated:YES];
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    NSLog(@"%f",offset);
    
    CGFloat scale = [self scaleByOffset:offset];
    CGFloat translation = [self translationByOffset:offset];
    
    return CATransform3DScale(CATransform3DTranslate(transform, translation * self.cardSize.width, 0, offset), scale, scale, 1.0f);
}

- (CGFloat)scaleByOffset:(CGFloat)offset {
    return offset * 0.04f + 1.0f;
}

- (CGFloat)translationByOffset:(CGFloat)offset {
    CGFloat z = 5.0 / 4.0f;
    CGFloat n = 5.0 / 8.0f;
    
    if (offset >= z / n) {
        return 2.0f;
    }
    
    return 1 / (z - n * offset) - 1 / z;
}

- (void)introDidFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped {
    CGFloat cardWidth = [UIScreen mainScreen].bounds.size.width * 5.0 / 7.0;
    self.cardSize = CGSizeMake(cardWidth, cardWidth * 16.0f / 9.0f);
    self.view.backgroundColor = [UIColor blackColor];
    
    self.carousel = [[iCarousel alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.carousel];
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.type = iCarouselTypeCustom;
    self.carousel.bounceDistance = 0.2f;
    self.carousel.scrollSpeed = 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
