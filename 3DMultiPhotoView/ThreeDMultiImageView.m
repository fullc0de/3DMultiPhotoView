//
//  ThreeDMultiImageView.m
//  3DMultiPhotoView
//
//  Created by kyokook on 13. 10. 1..
//  Copyright (c) 2013년 rhlab. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ThreeDMultiImageView.h"

#define ANG_TO_RAD(ang) ((ang) * (M_PI / 180.0f))
#define RAD_TO_ANG(rad) ((rad) * (180.0f / M_PI))
#define ROT_X(rad, x, y) (cos(rad) * (x) - sin(rad) * (y))
#define ROT_Y(rad, x, y) (sin(rad) * (x) + cos(rad) * (y))


@interface ThreeDMultiImageView ()
{
    float _deltaRadian;
    CGPoint _movingStart;
    CATransform3D _temp;
}

@property (nonatomic, strong) NSMutableArray *octaLayers;
@property (nonatomic, strong) CALayer *rootLayer;

@property (nonatomic, assign) CATransform3D fov;
@property (nonatomic, assign) CATransform3D angle;

@property (nonatomic, assign) NSInteger imagePosition;
@end

@implementation ThreeDMultiImageView

#pragma mark - Life Cycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    _bgColor = [UIColor whiteColor];
    _perspectiveDistance = 700.0f;
    _viewAngle = 0.0f;
    _angle = CATransform3DIdentity;
    _temp = CATransform3DIdentity;
    
    //[self setupLayers];
}

#pragma mark - Property Get / Set
- (void)setImages:(NSArray *)images
{
    _images = images;
    
    self.imagePosition = (NSUInteger)(images.count / 2);
    
    [self updateImageViews];
}

- (void)setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    
    [self setupLayers];
}

- (void)setImagePosition:(NSInteger)imagePosition
{
    int direction = imagePosition - _imagePosition;
    _imagePosition = imagePosition;
    int temp = _imagePosition % 8;
    if (temp < 0)
    {
        temp += 8;
    }
    _selectedImgIndex = temp;
    
    float imageRad = -(ANG_TO_RAD(45.0 * direction));

    [CATransaction begin];
    
    [CATransaction setValue:[NSNumber numberWithFloat:0.3f]
                     forKey:kCATransactionAnimationDuration];
    
    
    self.viewAngle += imageRad;
    
    [CATransaction commit];
}

- (void)setSelectedImgIndex:(NSUInteger)selectedImgIndex
{
    int delta = selectedImgIndex - (_imagePosition % 8);
    self.imagePosition += delta;
    
    _selectedImgIndex = selectedImgIndex;
}

- (void)setPerspectiveDistance:(float)perspectiveDistance
{
    _perspectiveDistance = perspectiveDistance;
    _fov.m34 = -1.0 / _perspectiveDistance;
    
    _rootLayer.sublayerTransform = CATransform3DConcat(_angle, _fov);
}

- (void)setViewAngle:(float)viewAngle
{
    _viewAngle = viewAngle;
    _angle = CATransform3DMakeRotation(_viewAngle, 0.0f, 1.0f, 0.0f);
    
    _rootLayer.sublayerTransform = CATransform3DConcat(_angle, _fov);
}

#pragma mark - Interfaces


#pragma mark - UI modification
- (void)setupLayers
{
    _rootLayer = [CALayer layer];
    _rootLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    _rootLayer.frame = self.bounds;
    
    if (_octaLayers)
    {
        for (CALayer *layer in _octaLayers)
        {
            layer.contents = nil;
        }
        [_octaLayers removeAllObjects];
    }
    _octaLayers = [[NSMutableArray alloc] initWithCapacity:8];
    

    float margin = self.bounds.size.width * 0.2;
    float width = self.bounds.size.width - (margin * 2.0);
    float height = self.bounds.size.height;
    float rad = 0.0f;
    CGPoint rotPoint45 = CGPointZero;

    NSLog(@"view width = %f, layer width = %f, layer height = %f, margin = %f", self.bounds.size.width, width, height, margin);
    
    CALayer *firstLayer = [CALayer layer];
    firstLayer.backgroundColor = _bgColor.CGColor;
    firstLayer.frame = CGRectMake(margin, 0, width, height);
    [_octaLayers addObject:firstLayer];
    
    CALayer *secondLayer = [CALayer layer];
    secondLayer.backgroundColor = _bgColor.CGColor;
    secondLayer.frame = CGRectMake(margin, 0, width, height);
    rad = ANG_TO_RAD(45.0);
    rotPoint45.x = ROT_X(rad, width, 0);
    rotPoint45.y = ROT_Y(rad, width, 0);
    CATransform3D rotation = CATransform3DMakeRotation(rad, 0.0, 1.0, 0.0);
    CATransform3D translation = CATransform3DMakeTranslation((width + rotPoint45.x)/2, 0, -(rotPoint45.x/2));
	secondLayer.transform = CATransform3DConcat(rotation, translation);
    [_octaLayers addObject:secondLayer];
    
    CALayer *thirdLayer = [CALayer layer];
    thirdLayer.backgroundColor = _bgColor.CGColor;
    thirdLayer.frame = CGRectMake(margin, 0, width, height);
    rad = ANG_TO_RAD(90.0);
    rotation = CATransform3DMakeRotation(rad, 0.0, 1.0, 0.0);
    translation = CATransform3DMakeTranslation((width + rotPoint45.x * 2)/2, 0, -(width + rotPoint45.x * 2)/2);
	thirdLayer.transform = CATransform3DConcat(rotation, translation);
    [_octaLayers addObject:thirdLayer];
    
    CALayer *forthLayer = [CALayer layer];
    forthLayer.backgroundColor = _bgColor.CGColor;
    forthLayer.frame = CGRectMake(margin, 0, width, height);
    rad = ANG_TO_RAD(135.0);
    rotation = CATransform3DMakeRotation(rad, 0.0, 1.0, 0.0);
    translation = CATransform3DMakeTranslation((width + rotPoint45.x)/2, 0, -(width + rotPoint45.x * 1.5));
	forthLayer.transform = CATransform3DConcat(rotation, translation);
    [_octaLayers addObject:forthLayer];
    
    CALayer *fifthLayer = [CALayer layer];
    fifthLayer.backgroundColor = _bgColor.CGColor;
    fifthLayer.frame = CGRectMake(margin, 0, width, height);
    rad = ANG_TO_RAD(180.0);
    rotation = CATransform3DMakeRotation(rad, 0.0, 1.0, 0.0);
    translation = CATransform3DMakeTranslation(0, 0, -(width + rotPoint45.x * 2));
	fifthLayer.transform = CATransform3DConcat(rotation, translation);
    [_octaLayers addObject:fifthLayer];
    
    CALayer *sixthLayer = [CALayer layer];
    sixthLayer.backgroundColor = _bgColor.CGColor;
    sixthLayer.frame = CGRectMake(margin, 0, width, height);
    rad = ANG_TO_RAD(225.0);
    rotation = CATransform3DMakeRotation(rad, 0.0, 1.0, 0.0);
    translation = CATransform3DMakeTranslation(-(width + rotPoint45.x)/2, 0, -(width + rotPoint45.x * 1.5));
	sixthLayer.transform = CATransform3DConcat(rotation, translation);
    [_octaLayers addObject:sixthLayer];
    
    CALayer *seventhLayer = [CALayer layer];
    seventhLayer.backgroundColor = _bgColor.CGColor;
    seventhLayer.frame = CGRectMake(margin, 0, width, height);
    rad = ANG_TO_RAD(270.0);
    rotation = CATransform3DMakeRotation(rad, 0.0, 1.0, 0.0);
    translation = CATransform3DMakeTranslation(-(width + rotPoint45.x * 2)/2, 0, -(width + rotPoint45.x * 2)/2);
	seventhLayer.transform = CATransform3DConcat(rotation, translation);
    [_octaLayers addObject:seventhLayer];
    
    CALayer *eighthLayer = [CALayer layer];
    eighthLayer.backgroundColor = _bgColor.CGColor;
    eighthLayer.frame = CGRectMake(margin, 0, width, height);
    rad = ANG_TO_RAD(315.0);
    rotation = CATransform3DMakeRotation(rad, 0.0, 1.0, 0.0);
    translation = CATransform3DMakeTranslation(-(width + rotPoint45.x)/2, 0, -(rotPoint45.x/2));
	eighthLayer.transform = CATransform3DConcat(rotation, translation);
    [_octaLayers addObject:eighthLayer];
    
    CATransformLayer *transformLayer = [CATransformLayer layer];
    transformLayer.anchorPointZ = -(width * 0.5 / tan(ANG_TO_RAD(45.0/2.0)));
    [transformLayer addSublayer:firstLayer];
    [transformLayer addSublayer:secondLayer];
    [transformLayer addSublayer:thirdLayer];
    [transformLayer addSublayer:forthLayer];
    [transformLayer addSublayer:fifthLayer];
    [transformLayer addSublayer:sixthLayer];
    [transformLayer addSublayer:seventhLayer];
    [transformLayer addSublayer:eighthLayer];
    
    [_rootLayer addSublayer:transformLayer];
    
    _fov = CATransform3DIdentity;
    _fov.m34 = -1.0 / _perspectiveDistance;
    
    _rootLayer.sublayerTransform = CATransform3DConcat(_angle, _fov);
    
    
    [self.layer addSublayer:_rootLayer];
    
}

- (void)updateImageViews
{
    [self setupLayers];
    
    CGSize size = CGSizeMake(self.bounds.size.width - (self.bounds.size.width * 0.4), self.bounds.size.height);
    NSLog(@"image size = %@", NSStringFromCGSize(size));
    for (int idx = 0; idx < _images.count; ++idx)
    {
        UIImage *cropped = [self cropImage:_images[idx] toFitIn:size];
        if (cropped)
        {
            CALayer *layer = _octaLayers[idx];
            layer.contentsGravity = kCAGravityResizeAspect;
            layer.contents = (id)cropped.CGImage;
        }
    }
}

- (void)moveImages:(float)distanceX
{
    NSArray *views = [self subviews];
    for (UIView *view in views)
    {
        if ([view isMemberOfClass:[UIImageView class]])
        {
            CGRect frame = view.frame;
            frame.origin.x += distanceX;
            view.frame = frame;
        }
    }
}

#pragma mark - Internal Logics


#pragma mark - Override
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateImageViews];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint location = [[touches anyObject] locationInView:self];
    
    _movingStart = location;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint location = [[touches anyObject] locationInView:self];
    
    float distance = location.x - _movingStart.x;
    float radius = (self.bounds.size.width - (self.bounds.size.width * 0.2)) * 0.5 / tan(ANG_TO_RAD(45.0/2.0));
    float radian = atan2f(distance, radius);
    
    _deltaRadian = radian;
    
    _temp = CATransform3DRotate(_angle, radian, 0.0f, 1.0f, 0.0f);
    _rootLayer.sublayerTransform = CATransform3DConcat(_temp, _fov);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_deltaRadian == 0.0)
    {
        if([_delegate respondsToSelector:@selector(threeDMultiImageView:didSelectedImage:)])
        {
            [_delegate threeDMultiImageView:self didSelectedImage:_images[_selectedImgIndex]];
        }
        return;
    }
    
    if (_deltaRadian > 0.35f &&
        (self.imagePosition > 0 || _images.count == 8))
    {
        self.imagePosition = _imagePosition - 1;
    }
    else if(_deltaRadian < -0.35f &&
            (self.imagePosition < _images.count - 1 || _images.count == 8))
    {
        self.imagePosition = _imagePosition + 1;
    }
    else
    {
        self.imagePosition = _imagePosition;
    }
    
    _deltaRadian = 0.0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Utils
- (UIImage *)cropImage:(UIImage *)target toFitIn:(CGSize)area
{
    float areaRatio = area.width / area.height;
    
    CGRect croppedArea;
    
    if (areaRatio < 0)
    {
        croppedArea.size.width = target.size.width;
        croppedArea.size.height = MIN(target.size.width * areaRatio, target.size.height);
    }
    else
    {
        croppedArea.size.width = MIN(target.size.height * areaRatio, target.size.width);
        croppedArea.size.height = target.size.height;
    }
    
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([target CGImage], croppedArea);
    float scale = target.size.height / area.height;
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:scale orientation:target.imageOrientation];
    CGImageRelease(imageRef);

    return result;
}

@end







