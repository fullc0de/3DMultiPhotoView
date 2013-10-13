//
//  ViewController.m
//  3DMultiPhotoView
//
//  Created by kyokook on 13. 10. 1..
//  Copyright (c) 2013년 rhlab. All rights reserved.
//

#import "ViewController.h"
#import "ThreeDMultiImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
<
    ThreeDMultiImageViewDelegate
>
{
    CALayer *rootLayer;
    CATransform3D fov;
    float angle;
}

@property (assign) IBOutlet ThreeDMultiImageView *imgView;
@property (assign) IBOutlet UILabel *touchMsg;

@property (strong) NSMutableArray *images;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _images = [[NSMutableArray alloc] initWithCapacity:5];
    fov = CATransform3DIdentity;
    
    _touchMsg.alpha = 0.0f;
    _touchMsg.text = @"";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [_images addObject:[UIImage imageNamed:@"IMG_7823.jpg"]];
    [_images addObject:[UIImage imageNamed:@"IMG_7824.jpg"]];
    [_images addObject:[UIImage imageNamed:@"IMG_7828.jpg"]];
    [_images addObject:[UIImage imageNamed:@"IMG_7826.jpg"]];
    [_images addObject:[UIImage imageNamed:@"IMG_7825.jpg"]];
    [_images addObject:[UIImage imageNamed:@"IMG_7836.jpg"]];
    [_images addObject:[UIImage imageNamed:@"IMG_7838.jpg"]];
    [_images addObject:[UIImage imageNamed:@"IMG_7839.jpg"]];
    
    _imgView.delegate = self;
    _imgView.images = _images;
    
    angle = 0.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)expand:(id)sender
{
    CGRect frame = self.imgView.frame;
    frame.size.height += 10;
    self.imgView.frame = frame;
}

- (IBAction)shrink:(id)sender
{
    CGRect frame = self.imgView.frame;
    frame.size.height -= 10;
    self.imgView.frame = frame;
}

#pragma mark - ThreeDMultiImageViewDelegate
- (void)threeDMultiImageView:(ThreeDMultiImageView *)iv didSelectedImage:(UIImage *)image
{
    _touchMsg.text = [NSString stringWithFormat:@"Touched Image: %d", iv.selectedImgIndex];
    
    [UIView animateWithDuration:0.5f animations:^
    {
        _touchMsg.alpha = 1.0;
    }
    completion:^(BOOL finished)
    {
        [UIView animateWithDuration:0.5f delay:2.0f options:UIViewAnimationOptionCurveLinear animations:^
        {
            _touchMsg.alpha = 0.0;
        }
        completion:nil];
    }];
}

@end



