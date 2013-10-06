//
//  ThreeDMultiImageView.h
//  3DMultiPhotoView
//
//  Created by kyokook on 13. 10. 1..
//  Copyright (c) 2013년 rhlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreeDMultiImageView : UIView

@property (nonatomic, assign) NSUInteger selectedImgIndex;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIColor *bgColor;

@property (nonatomic, assign) float perspectiveDistance;
@property (nonatomic, assign) float viewAngle;

@end
