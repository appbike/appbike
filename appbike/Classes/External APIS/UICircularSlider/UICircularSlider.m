//
//  UICircularSlider.m
//  UICircularSlider
//
//  Created by Zouhair Mahieddine on 02/03/12.
//  Copyright (c) 2012 Zouhair Mahieddine.
//  http://www.zedenem.com
//  
//  This file is part of the UICircularSlider Library, released under the MIT License.
//

#import "UICircularSlider.h"
#import "ConstantList.h"

#define kLineWidth IS_IPHONE_6 ? 16.0 : IS_IPHONE_6_PLUS ? 16 : 10

#define kLineWidthMap IS_IPHONE_6 ? 7.0 : IS_IPHONE_6_PLUS ? 7.0 : 5.0

#define kThumbRadius 12.0
#define kPercentageRatio IS_IPHONE_6 ? 0.075f : IS_IPHONE_6_PLUS ? 0.07f : 0.08f

@interface UICircularSlider()

@property (nonatomic) CGPoint thumbCenterPoint;

#pragma mark - Init and Setup methods
- (void)setup;

#pragma mark - Thumb management methods
- (BOOL)isPointInThumb:(CGPoint)point;

#pragma mark - Drawing methods
- (CGFloat)sliderRadius;
- (void)drawThumbAtPoint:(CGPoint)sliderButtonCenterPoint inContext:(CGContextRef)context;
- (CGPoint)drawCircularTrack:(float)track atPoint:(CGPoint)point withRadius:(CGFloat)radius inContext:(CGContextRef)context;
- (CGPoint)drawPieTrack:(float)track atPoint:(CGPoint)point withRadius:(CGFloat)radius inContext:(CGContextRef)context;

@end

#pragma mark -
@implementation UICircularSlider

@synthesize value = _value;
- (void)setValue:(float)value {
	if (value != _value) {
		if (value > self.maximumValue) { value = self.maximumValue; }
		if (value < self.minimumValue) { value = self.minimumValue; }
		_value = value;
        
        NSLog(@"Update value : %f",value);
//        float diff = self.maximumValue * 0.08f;
//        if(diff >= 1)
//        {
//            float nowvalue = (int)value % (int)diff;
//        
//            self.originalvalue = value + nowvalue;
//        }
        
		[self setNeedsDisplay];
        if (self.isContinuous) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
	}
}
@synthesize minimumValue = _minimumValue;
- (void)setMinimumValue:(float)minimumValue {
	if (minimumValue != _minimumValue) {
		_minimumValue = minimumValue;
		if (self.maximumValue < self.minimumValue)	{ self.maximumValue = self.minimumValue; }
		if (self.value < self.minimumValue)			{ self.value = self.minimumValue;
            float perc = kPercentageRatio;
            self.originalvalue = self.maximumValue * perc;
        }
	}
}
@synthesize maximumValue = _maximumValue;
- (void)setMaximumValue:(float)maximumValue {
	if (maximumValue != _maximumValue) {
		_maximumValue = maximumValue;
		if (self.minimumValue > self.maximumValue)	{ self.minimumValue = self.maximumValue; }
		if (self.value > self.maximumValue)			{ self.value = self.maximumValue;
            float perc = kPercentageRatio;
            self.originalvalue = self.maximumValue * perc;
        }
	}
}

@synthesize minimumTrackTintColor = _minimumTrackTintColor;
- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor {
	if (![minimumTrackTintColor isEqual:_minimumTrackTintColor]) {
		_minimumTrackTintColor = minimumTrackTintColor;
		[self setNeedsDisplay];
	}
}

@synthesize maximumTrackTintColor = _maximumTrackTintColor;
- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor {
	if (![maximumTrackTintColor isEqual:_maximumTrackTintColor]) {
		_maximumTrackTintColor = maximumTrackTintColor;
		[self setNeedsDisplay];
	}
}

@synthesize thumbTintColor = _thumbTintColor;
- (void)setThumbTintColor:(UIColor *)thumbTintColor {
	if (![thumbTintColor isEqual:_thumbTintColor]) {
        if(self.isThumbnailEnabled)
            _thumbTintColor = [UIColor colorWithRed:55/255.0 green:155/255.0 blue:233/255.0 alpha:1.0];//blue color
        else
            _thumbTintColor = [UIColor clearColor];
        
		[self setNeedsDisplay];
	}
    
}

@synthesize continuous = _continuous;

@synthesize sliderStyle = _sliderStyle;
- (void)setSliderStyle:(UICircularSliderStyle)sliderStyle {
	if (sliderStyle != _sliderStyle) {
		_sliderStyle = sliderStyle;
		[self setNeedsDisplay];
	}
}

@synthesize thumbCenterPoint = _thumbCenterPoint;


- (void)addProfileImage
{
    if(self.isThumbnailEnabled)
    {
        CGRect thumbTouchRect = CGRectMake(self.thumbCenterPoint.x - kThumbRadius, self.thumbCenterPoint.y - kThumbRadius, kThumbRadius*2, kThumbRadius*2);
        //self.thumbImage.frame = thumbTouchRect;
        self.profileImageView = [[UIImageView alloc] initWithFrame:thumbTouchRect];
        self.profileImageView.transform = CGAffineTransformMakeRotation(3.14);
        self.profileImageView.layer.cornerRadius = 9.0;
        self.profileImageView.layer.masksToBounds = YES;
        self.profileImageView.layer.borderColor = [UIColor colorWithRed:23/255.0 green:138/255.0 blue:230/255.0 alpha:1].CGColor;
        self.profileImageView.layer.borderWidth = 3.0;
        self.profileImageView.image = self.thumbImage;
        [self addSubview:self.profileImageView];
    }
}
@synthesize thumbImage = _thumbImage;
-(void)setThumbImage:(UIImage *)thumbImage
{
    if(thumbImage != _thumbImage)
    {
        _thumbImage = thumbImage;
       
        [self setNeedsDisplay];
    }
}
/** @name Init and Setup methods */
#pragma mark - Init and Setup methods
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    } 
    return self;
}
- (void)awakeFromNib {
	[self setup];
}

- (void)setup {
    self.originalvalue = 0.0;
	self.value = 0.0;
	self.minimumValue = 0.0;
	self.maximumValue = 1.0;
    self.minimumTrackTintColor = [UIColor grayColor];
    self.maximumTrackTintColor =  [UIColor colorWithRed:23/255.0 green:138/255.0 blue:230/255.0 alpha:1];//[UIColor yellowColor];
	//self.thumbTintColor = [UIColor darkGrayColor];
    self.thumbTintColor = [UIColor clearColor];
	self.continuous = YES;
	self.thumbCenterPoint = CGPointZero;
	
   
    /**
     * This tapGesture isn't used yet but will allow to jump to a specific location in the circle
     */
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHappened:)];
	[self addGestureRecognizer:tapGestureRecognizer];
	
	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHappened:)];
	panGestureRecognizer.maximumNumberOfTouches = panGestureRecognizer.minimumNumberOfTouches;
	[self addGestureRecognizer:panGestureRecognizer];
}

/** @name Drawing methods */
#pragma mark - Drawing methods

- (CGFloat)sliderRadius {
    
    CGFloat radius = MIN(self.bounds.size.width/2, self.bounds.size.height/2);
    if(self.isMapCircle)
    {
        
        radius -= MAX(kLineWidthMap, kThumbRadius);
    }
    else
    {
        radius -= MAX(kLineWidth, kThumbRadius);
    }
	return radius;
}
- (void)drawThumbAtPoint:(CGPoint)sliderButtonCenterPoint inContext:(CGContextRef)context {
    NSLog(@"Draw thumb");
	UIGraphicsPushContext(context);
	CGContextBeginPath(context);
	
	CGContextMoveToPoint(context, sliderButtonCenterPoint.x, sliderButtonCenterPoint.y);
	CGContextAddArc(context, sliderButtonCenterPoint.x, sliderButtonCenterPoint.y, kThumbRadius, 0.0, 2*M_PI, NO);
	
	CGContextFillPath(context);
	UIGraphicsPopContext();
}

- (CGPoint)drawCircularTrack:(float)track atPoint:(CGPoint)center withRadius:(CGFloat)radius inContext:(CGContextRef)context {
	UIGraphicsPushContext(context);
	CGContextBeginPath(context);
	
	float angleFromTrack = translateValueFromSourceIntervalToDestinationInterval(track, self.minimumValue, self.maximumValue, 0, 2*M_PI);
	
	CGFloat startAngle = -M_PI_2;
	CGFloat endAngle = startAngle + angleFromTrack;
	CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, NO);
	
	CGPoint arcEndPoint = CGContextGetPathCurrentPoint(context);
	
	CGContextStrokePath(context);
	UIGraphicsPopContext();
	
	return arcEndPoint;
}

- (CGPoint)drawPieTrack:(float)track atPoint:(CGPoint)center withRadius:(CGFloat)radius inContext:(CGContextRef)context {
	UIGraphicsPushContext(context);
	
	float angleFromTrack = translateValueFromSourceIntervalToDestinationInterval(track, self.minimumValue, self.maximumValue, 0, 2*M_PI);
	
	CGFloat startAngle = -M_PI_2;
	CGFloat endAngle = startAngle + angleFromTrack;
	CGContextMoveToPoint(context, center.x, center.y);
	CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, NO);
	
	CGPoint arcEndPoint = CGContextGetPathCurrentPoint(context);
	
	CGContextClosePath(context);
	CGContextFillPath(context);
	UIGraphicsPopContext();
	
	return arcEndPoint;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGPoint middlePoint;
	middlePoint.x = self.bounds.origin.x + self.bounds.size.width/2;
	middlePoint.y = self.bounds.origin.y + self.bounds.size.height/2;
	
    if(self.isMapCircle)
    {
        CGContextSetLineWidth(context, kLineWidthMap);
    }
    else{
        CGContextSetLineWidth(context, kLineWidth);
    }
	
	CGFloat radius = [self sliderRadius];
	switch (self.sliderStyle) {
		case UICircularSliderStylePie:
			[self.maximumTrackTintColor setFill];
			[self drawPieTrack:self.maximumValue atPoint:middlePoint withRadius:radius inContext:context];
			[self.minimumTrackTintColor setStroke];
			[self drawCircularTrack:self.maximumValue atPoint:middlePoint withRadius:radius inContext:context];
			[self.minimumTrackTintColor setFill];
			self.thumbCenterPoint = [self drawPieTrack:self.value atPoint:middlePoint withRadius:radius inContext:context];
			break;
		case UICircularSliderStyleCircle:
		default:
            
			[self.maximumTrackTintColor setStroke];
            if(self.isSkipGoal)
            {
                NSLog(@"Skip Goal");
                [self drawCircularTrack:0 atPoint:middlePoint withRadius:radius inContext:context];
            }
            else
            {
                NSLog(@"Drawing....");
                [self drawCircularTrack:self.maximumValue atPoint:middlePoint withRadius:radius inContext:context];
            }
            
			[self.minimumTrackTintColor setStroke];
            
			self.thumbCenterPoint = [self drawCircularTrack:self.value atPoint:middlePoint withRadius:radius inContext:context];
//            self.thumbCenterPoint = [self drawCircularTrack:self.originalvalue atPoint:middlePoint withRadius:radius inContext:context];
			break;
	}
	
	[self.thumbTintColor setFill];
    
    if(self.isThumbnailEnabled)
    {
        CGRect thumbTouchRect = CGRectMake(self.thumbCenterPoint.x - kThumbRadius, self.thumbCenterPoint.y - kThumbRadius, kThumbRadius*2, kThumbRadius*2);
        self.profileImageView.frame = thumbTouchRect;
    }
//    if(self.isThumbnailEnabled && self.value > 0)
//    {
//        self.profileImageView.hidden = NO;
//    }
//    else{
//        self.profileImageView.hidden = YES;
//    }
    NSLog(@"self.orgi : %f and max : %f",self.originalvalue,self.maximumValue);
    
	[self drawThumbAtPoint:self.thumbCenterPoint inContext:context];
    
}

/** @name Thumb management methods */
#pragma mark - Thumb management methods
- (BOOL)isPointInThumb:(CGPoint)point {
	CGRect thumbTouchRect = CGRectMake(self.thumbCenterPoint.x - kThumbRadius, self.thumbCenterPoint.y - kThumbRadius, kThumbRadius*2, kThumbRadius*2);
    
    
	return CGRectContainsPoint(thumbTouchRect, point);
}

/** @name UIGestureRecognizer management methods */
#pragma mark - UIGestureRecognizer management methods
- (void)panGestureHappened:(UIPanGestureRecognizer *)panGestureRecognizer {
	CGPoint tapLocation = [panGestureRecognizer locationInView:self];
	switch (panGestureRecognizer.state) {
		case UIGestureRecognizerStateChanged: {
			CGFloat radius = [self sliderRadius];
			CGPoint sliderCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
			CGPoint sliderStartPoint = CGPointMake(sliderCenter.x, sliderCenter.y - radius);
			CGFloat angle = angleBetweenThreePoints(sliderCenter, sliderStartPoint, tapLocation);
			
			if (angle < 0) {
				angle = -angle;
			}
			else {
				angle = 2*M_PI - angle;
			}
			
            
                    if((self.originalvalue+1) >= self.maximumValue )
                    {
                       
                        //                self.originalvalue = translateValueFromSourceIntervalToDestinationInterval(angle, 0, 2*M_PI, self.minimumValue , self.maximumValue);
                       // self.value = self.originalvalue-1;
        
                        break;
                    }
            NSLog(@"orignial %f and min : %f and angle : %f",self.originalvalue,self.minimumValue,angle);
                if ((self.originalvalue) <= self.minimumValue +1)
                {
                     NSLog(@"orignial %f and min : %f and angle : %f",self.originalvalue,self.minimumValue,angle);
                    break;
                }

            
            //New changes
//            float minusValue = self.maximumValue *0.10f;
//            
//            //Here we need to change
//			self.value = translateValueFromSourceIntervalToDestinationInterval(angle, 0, 2*M_PI, self.minimumValue + minusValue, self.maximumValue - minusValue);
//            
//            
//            self.lastvalue = self.value;
            //NSLog(@"Percentage : %f",kPercentageRatio);
            float perc = kPercentageRatio;
            float minusValue = self.maximumValue * perc;
            
            self.value = translateValueFromSourceIntervalToDestinationInterval(angle, 0, 2*M_PI, self.minimumValue + minusValue, self.maximumValue - minusValue);
            
            self.originalvalue = translateValueFromSourceIntervalToDestinationInterval(angle, 0, 2*M_PI, self.minimumValue , self.maximumValue);
            
            //float halfValue = self.maximumValue / 2;
            
//            if(self.value > halfValue)
//            {
//                self.value = self.value + minusValue;
//            }
//            else
//            {
//                self.value = self.value - minusValue;
//            }
            
            NSLog(@"Origninal value : %f and self.value : %f",self.originalvalue,self.value);
            
            float totalGap = minusValue * 2;
            float totalvaluechange = totalGap * 0.01f;
            
            self.value = self.value + totalvaluechange;
            NSLog(@"Final Self.value : %f",self.value);
            
            
			break;
		}
        case UIGestureRecognizerStateBegan:
            if((self.originalvalue+1) >= self.maximumValue)
            {
                self.value = 0;
                self.originalvalue = 0;
            }
            float perc = kPercentageRatio;
            float minusValue = self.maximumValue * perc;
            self.originalvalue = self.value + minusValue;
            
        break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"END -----");
            
            
            if (!self.isContinuous) {
                NSLog(@"not continous");
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
            if ([self isPointInThumb:tapLocation])
            {
                //if((self.originalvalue + 1) < self.maximumValue)
                //{
                    NSLog(@"touch up inside");
                    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
                //}
                //else
                //{
                  //  NSLog(@"Cancel");
                    //[self sendActionsForControlEvents:UIControlEventTouchUpOutside];
                //}
            }
            else
            {
                NSLog(@"Touch outside");
                //self.value = 0;
                //self.originalvalue = 0;
                [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
            }
            break;
		default:
			break;
	}
}
- (void)tapGestureHappened:(UITapGestureRecognizer *)tapGestureRecognizer {
	if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
		CGPoint tapLocation = [tapGestureRecognizer locationInView:self];
		if ([self isPointInThumb:tapLocation]) {
		}
		else {
		}
	}
}

/** @name Touches Methods */
#pragma mark - Touches Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    if ([self isPointInThumb:touchLocation]) {
        [self sendActionsForControlEvents:UIControlEventTouchDown];
    }
}

@end

/** @name Utility Functions */
#pragma mark - Utility Functions
float translateValueFromSourceIntervalToDestinationInterval(float sourceValue, float sourceIntervalMinimum, float sourceIntervalMaximum, float destinationIntervalMinimum, float destinationIntervalMaximum) {
	float a, b, destinationValue;
	
	a = (destinationIntervalMaximum - destinationIntervalMinimum) / (sourceIntervalMaximum - sourceIntervalMinimum);
	b = destinationIntervalMaximum - a*sourceIntervalMaximum;
	
	destinationValue = a*sourceValue + b;
	
	return destinationValue;
}

CGFloat angleBetweenThreePoints(CGPoint centerPoint, CGPoint p1, CGPoint p2) {
	CGPoint v1 = CGPointMake(p1.x - centerPoint.x, p1.y - centerPoint.y);
	CGPoint v2 = CGPointMake(p2.x - centerPoint.x, p2.y - centerPoint.y);
	
	CGFloat angle = atan2f(v2.x*v1.y - v1.x*v2.y, v1.x*v2.x + v1.y*v2.y);
	
	return angle;
}
