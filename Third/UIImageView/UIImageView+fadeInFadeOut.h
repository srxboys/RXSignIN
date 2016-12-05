//
//  UIImageView+fadeInFadeOut.h
//  RXSignIN
//
//  Created by srx on 2016/12/1.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//
/*
 https://github.com/srxboys
 
 项目基本框架
 */

//srxboys 淡入淡入效果

#import "UIImageView+WebCache.h"

@interface UIImageView (fadeInFadeOut)

- (void)sd_setImageFIFOWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholde;

- (void)sd_setImageFIFOWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder animateWithDuration:(CGFloat)duration;

- (void)sd_setImageFIFOWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options animateWithDuration:(CGFloat)duration;


- (void)sd_setImageFIFOWithURL:(NSURL *)url completed:( SDExternalCompletionBlock)completedBlock;

- (void)sd_setImageFIFOWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:( SDExternalCompletionBlock)completedBlock;
@end
