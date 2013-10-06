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
{
    CALayer *rootLayer;
    CATransform3D fov;
    float angle;
}

@property (assign) IBOutlet ThreeDMultiImageView *imgView;
@property (assign) IBOutlet UIView *testView;


@property (strong) NSMutableArray *images;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _images = [[NSMutableArray alloc] initWithCapacity:5];
    fov = CATransform3DIdentity;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [_images addObject:[UIImage imageNamed:@"IMG_7823.jpg"]];
    [_images addObject:[UIImage imageNamed:@"IMG_7824.jpg"]];
    [_images addObject:[UIImage imageNamed:@"IMG_7825.jpg"]];
    [_images addObject:[UIImage imageNamed:@"IMG_7826.jpg"]];
    [_images addObject:[UIImage imageNamed:@"IMG_7828.jpg"]];
    
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

@end
