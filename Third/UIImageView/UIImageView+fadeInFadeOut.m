//
//  UIImageView+fadeInFadeOut.m
//  RXSignIN
//
//  Created by srx on 2016/12/1.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//
/*
 https://github.com/srxboys
 
 项目基本框架
 */

#import "UIImageView+fadeInFadeOut.h"

@implementation UIImageView (fadeInFadeOut)

- (void)sd_setImageFIFOWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholde {
    [self sd_setImageFIFOWithURL:url placeholderImage:placeholde  animateWithDuration:0.35f];
}

- (void)sd_setImageFIFOWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder animateWithDuration:(CGFloat)duration {
    
    [self sd_setImageFIFOWithURL:url placeholderImage:placeholder options:SDWebImageCacheMemoryOnly | SDWebImageRetryFailed | SDWebImageLowPriority animateWithDuration:duration];
}

- (void)sd_setImageFIFOWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options animateWithDuration:(CGFloat)duration {
    
    if(url == nil || url.absoluteString.length == 0) {
        self.image = placeholder;
        return; //避免 服务器给nil
    }

    [self sd_setImageWithURL:url  placeholderImage:nil options:options completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)  {
        
         if (image && cacheType == SDImageCacheTypeNone)  {
             CATransition *fadeIn = [CATransition animation];
             fadeIn.duration = duration;
             fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
             fadeIn.subtype = kCATransitionFade;
             [self.layer addAnimation:fadeIn forKey:@"fadeIn"];
         }
         else if(image == nil && cacheType == SDImageCacheTypeNone && error) {
             self.image = placeholder;
         }
        
     }];
}

- (void)sd_setImageFIFOWithURL:(NSURL *)url completed:( SDExternalCompletionBlock)completedBlock {
    
    [self sd_setImageFIFOWithURL:url placeholderImage:nil completed:completedBlock];
}

- (void)sd_setImageFIFOWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:( SDExternalCompletionBlock)completedBlock {
    if(url == nil || url.absoluteString.length == 0) {
        self.image = placeholder;
        return; //避免 服务器给nil
    }
    
    [self sd_setImageWithURL:url  placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageCacheMemoryOnly | SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageAllowInvalidSSLCertificates completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)  {
        
        if (image && cacheType == SDImageCacheTypeNone)  {
            CATransition *fadeIn = [CATransition animation];
            fadeIn.duration = 0.35;
            fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            fadeIn.subtype = kCATransitionFade;
            [self.layer addAnimation:fadeIn forKey:@"fadeIn"];
        }
        else if(image == nil && cacheType == SDImageCacheTypeNone && error) {
            self.image = placeholder;
        }
        
        completedBlock(image, error, cacheType, imageURL);
    }];
}

@end
