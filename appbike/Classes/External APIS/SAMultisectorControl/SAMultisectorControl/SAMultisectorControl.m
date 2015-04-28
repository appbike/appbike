//
//  SAMultisectorControl.m
//  CustomControl
//
//  Created by Snipter on 12/31/13.
//  Copyright (c) 2013 SmartAppStudio. All rights reserved.
//

#import "SAMultisectorControl.h"
#import "AppDelegate.h"

#define saCircleLineWidth 20.0
#define saMarkersLineWidth 2.0

#define IS_OS_LOWER_7    ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)

typedef struct{
    CGPoint circleCenter;
    CGFloat radius;
    
    double fullLine;
    double circleOffset;
    double circleLine;
    double circleEmpty;
    
    double circleOffsetAngle;
    double circleLineAngle;
    double circleEmptyAngle;
    
    CGPoint startMarkerCenter;
    CGPoint endMarkerCenter;
    CGPoint currentMarkerCenter;
    
    CGFloat startMarkerRadius;
    CGFloat endMarkerRadius;
    CGFloat currMarkerRadius;
    
    CGFloat startMarkerFontSize;
    CGFloat endMarkerFontize;
    
    CGFloat startMarkerAlpha;
    CGFloat endMarkerAlpha;
    
    
} SASectorDrawingInformation;


@implementation SAMultisectorControl{
    NSMutableArray *sectorsArray;
    
    SAMultisectorSector *trackingSector;
    SASectorDrawingInformation trackingSectorDrawInf;
    BOOL trackingSectorStartMarker;
}

#pragma mark - Initializators

- (instancetype)init{
    if(self = [super init]){
        [self setupDefaultConfigurations];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setupDefaultConfigurations];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setupDefaultConfigurations];
    }
    return self;
}

- (void) setupDefaultConfigurations
{
    sectorsArray = [NSMutableArray new];
    self.sectorsRadius = 90.0; //45.0
    self.backgroundColor = [UIColor clearColor];
    self.startAngle = toRadians(90);  //270
    self.minCircleMarkerRadius = 10.0; //10.0
    self.maxCircleMarkerRadius = 50.0; //50.0
    self.numbersAfterPoint = 0;
    self.imgProfile = [UIImage imageNamed:@"noimage.png"];
    //self.imgProfile = [UIImage imageNamed:@"loc_user.png"];
    self.imgViewProfile = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.imgViewProfile.image = self.imgProfile;
    [self addSubview:self.imgViewProfile];
}

#pragma mark - Setters

- (void)setSectorsRadius:(double)sectorsRadius{
    _sectorsRadius = sectorsRadius;
    [self setNeedsDisplay];
}

#pragma mark - Sectors manipulations

- (void)setProfileImage:(UIImage *)profile
{
    self.imgViewProfile.image = profile;
}
- (void)addSector:(SAMultisectorSector *)sector{
    [sectorsArray addObject:sector];
    [self setNeedsDisplay];
}

- (void)removeSector:(SAMultisectorSector *)sector{
    [sectorsArray removeObject:sector];
    [self setNeedsDisplay];
}

- (void)removeAllSectors{
    [sectorsArray removeAllObjects];
    [self setNeedsDisplay];
}

- (NSArray *)sectors{
    return sectorsArray;
}

#pragma mark - Events manipulator

- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    [super beginTrackingWithTouch:touch withEvent:event];
    CGPoint touchPoint = [touch locationInView:self];
    
    NSLog(@"Total sectors : %d",sectorsArray.count);
    for(NSUInteger i = 0; i < sectorsArray.count; i++)
    {
        SAMultisectorSector *sector = sectorsArray[i];
        NSUInteger position = i + 1;
        SASectorDrawingInformation drawInf =[self sectorToDrawInf:sector position:position];
        
        if([self touchInCircleWithPoint:touchPoint circleCenter:drawInf.endMarkerCenter]){
            trackingSector = sector;
            trackingSectorDrawInf = drawInf;
            trackingSectorStartMarker = NO;
            return YES;
        }
        
        if([self touchInCircleWithPoint:touchPoint circleCenter:drawInf.startMarkerCenter]){
            trackingSector = sector;
            trackingSectorDrawInf = drawInf;
            trackingSectorStartMarker = YES;
            return YES;
        }
        
    }
    return NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    NSLog(@"we are in SA");
    return YES;
}

- (BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    [super continueTrackingWithTouch:touch withEvent:event];
    NSLog(@"Continue....");
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint ceter = [self multiselectCenter];
    SAPolarCoordinate polar = decartToPolar(ceter, touchPoint);
    
    double correctedAngle;
    if(polar.angle < self.startAngle) correctedAngle = polar.angle + (2 * M_PI - self.startAngle);
    else correctedAngle = polar.angle - self.startAngle;
    
    double procent = correctedAngle / (M_PI * 2);
    
    double newValue = procent * (trackingSector.maxValue - trackingSector.minValue) + trackingSector.minValue;
    
    if(trackingSectorStartMarker){
        
        if(newValue > trackingSector.startValue){
            double diff = newValue - trackingSector.startValue;
            if(diff > ((trackingSector.maxValue - trackingSector.minValue)/2)){
                trackingSector.startValue = trackingSector.minValue;
                [self valueChangedNotification];
                [self setNeedsDisplay];
                return YES;
            }
        }
        if(newValue >= trackingSector.endValue){
            trackingSector.startValue = trackingSector.endValue;
            [self valueChangedNotification];
            [self setNeedsDisplay];
            return YES;
        }
        trackingSector.startValue = newValue;
        [self valueChangedNotification];
    }
    else{
        if(newValue < trackingSector.endValue){
            double diff = trackingSector.endValue - newValue;
            if(diff > ((trackingSector.maxValue - trackingSector.minValue)/2)){
                trackingSector.endValue = trackingSector.maxValue;
                [self valueChangedNotification];
                [self setNeedsDisplay];
                return YES;
            }
        }
        if(newValue <= trackingSector.startValue){
            trackingSector.endValue = trackingSector.startValue;
            [self valueChangedNotification];
            [self setNeedsDisplay];
            return YES;
        }
        trackingSector.endValue = newValue;
        [self valueChangedNotification];
    }
    
    [self setNeedsDisplay];
    
    return YES;
}

- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
     [super endTrackingWithTouch:touch withEvent:event];
    trackingSector = nil;
    trackingSectorStartMarker = NO;
}

- (CGPoint) multiselectCenter{
    return CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (BOOL) touchInCircleWithPoint:(CGPoint)touchPoint circleCenter:(CGPoint)circleCenter
{
    SAPolarCoordinate polar = decartToPolar(circleCenter, touchPoint);
    if(polar.radius >= (self.sectorsRadius / 2)) {
        NSLog(@"touch in circle : NO");
            return NO;
    }
    else {
         NSLog(@"touch in circle : YES");
        return YES;
    }
}

- (void) valueChangedNotification{
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    
    for(int i = 0; i < sectorsArray.count; i++)
    {
        SAMultisectorSector *sector = sectorsArray[i];
        
       // if([appDelegate().strComeFromView isEqualToString:@"settingVC"])
        //{
            if(!self.isDisplayCurrentValue)
            {
                //NSLog(@"bound width : %f and height : %f",self.bounds.size.width,self.bounds.size.height);
                
                self.imgViewProfile.hidden = YES;
                [self drawSector_Setting:sector atPosition:i+1];
            }
        //}
        else
        {
            self.imgViewProfile.hidden = NO;
            [self drawSector:sector atPosition:i+1];
        }
        
    }
}


- (void)drawSector_Setting:(SAMultisectorSector *)sector atPosition:(NSUInteger)position{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, saCircleLineWidth);
    
    UIColor *startCircleColor = [sector.color colorWithAlphaComponent:0.3];
//    UIColor *startCircleColor = [sector.color colorWithAlphaComponent:0.0];
    UIColor *circleColor = sector.color;
    UIColor *endCircleColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
    
    SASectorDrawingInformation drawInf = [self sectorToDrawInf:sector position:position];
    
    CGFloat x = drawInf.circleCenter.x;
    CGFloat y = drawInf.circleCenter.y;
    CGFloat r = drawInf.radius;
    
    
    //start circle line
    [startCircleColor setStroke];
    CGContextAddArc(context, x, y, r, self.startAngle, drawInf.circleOffsetAngle, 0);
    CGContextStrokePath(context);
    
    
    //circle line
    [circleColor setStroke];
    CGContextAddArc(context, x, y, r, drawInf.circleOffsetAngle, drawInf.circleLineAngle, 0);
    CGContextStrokePath(context);
    
    
    //end circle line
    [endCircleColor setStroke];
    CGContextAddArc(context, x, y, r, drawInf.circleLineAngle, drawInf.circleEmptyAngle, 0);
    CGContextStrokePath(context);
    
    
    //clearing place for start marker
    CGContextSaveGState(context);
    CGContextAddArc(context, drawInf.startMarkerCenter.x, drawInf.startMarkerCenter.y, drawInf.startMarkerRadius - (saMarkersLineWidth/2.0), 0.0, 6.28, 0);
    CGContextClip(context);
    CGContextClearRect(context, self.bounds);
    CGContextRestoreGState(context);
    
    
    //clearing place for end marker
    CGContextSaveGState(context);
    CGContextAddArc(context, drawInf.endMarkerCenter.x, drawInf.endMarkerCenter.y, drawInf.endMarkerRadius - (saMarkersLineWidth/2.0), 0.0, 6.28, 0);
    CGContextClip(context);
    CGContextClearRect(context, self.bounds);
    CGContextRestoreGState(context);
    
//    //clearing place for current marker
//    CGContextSaveGState(context);
//    CGContextAddArc(context, drawInf.currentMarkerCenter.x, drawInf.currentMarkerCenter.y, drawInf.currMarkerRadius - (saMarkersLineWidth/2.0), 0.0, 6.28, 0);
//    CGContextClip(context);
//    CGContextClearRect(context, self.bounds);
//    CGContextRestoreGState(context);
    
    
    //markers
    CGContextSetLineWidth(context, saMarkersLineWidth);
    
    //drawing start marker
    [[circleColor colorWithAlphaComponent:drawInf.startMarkerAlpha] setStroke];
    //[[UIColor redColor] setFill];
    CGContextAddArc(context, drawInf.startMarkerCenter.x, drawInf.startMarkerCenter.y, drawInf.startMarkerRadius, 0.0, 6.28, 0);
    //New line
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:42.0/255.0 green:133.0/255.0 blue:202/255.0 alpha:1.0].CGColor);
    CGContextFillPath(context);
    //End new line
    CGContextStrokePath(context);
    
   
    
    //drawing end marker
    [[circleColor colorWithAlphaComponent:drawInf.endMarkerAlpha] setStroke];
    CGContextAddArc(context, drawInf.endMarkerCenter.x, drawInf.endMarkerCenter.y, drawInf.endMarkerRadius, 0.0, 6.28, 0);
    //New line
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:42.0/255.0 green:133.0/255.0 blue:202/255.0 alpha:1.0].CGColor);
    CGContextFillPath(context);
    //End new line
    CGContextStrokePath(context);
    
    
    //text on markers
    NSString *markerStrTemplate = [@"%.0f" stringByReplacingOccurrencesOfString:@"0" withString:[NSString stringWithFormat:@"%i", self.numbersAfterPoint]];
    NSString *startMarkerStr = [NSString stringWithFormat:markerStrTemplate, sector.startValue];
    NSString *endMarkerStr = [NSString stringWithFormat:markerStrTemplate, sector.endValue];
    
    //drawing start marker's text
//    [self drawString:startMarkerStr
//            withFont:[UIFont boldSystemFontOfSize:drawInf.startMarkerFontSize]
//               color:[circleColor colorWithAlphaComponent:drawInf.startMarkerAlpha]
//          withCenter:drawInf.startMarkerCenter];
    [self drawString:startMarkerStr
            withFont:[UIFont boldSystemFontOfSize:drawInf.startMarkerFontSize]
               color:[UIColor whiteColor]
          withCenter:drawInf.startMarkerCenter];
    
    //drawing end marker's text
//    [self drawString:endMarkerStr
//            withFont:[UIFont boldSystemFontOfSize:drawInf.endMarkerFontize]
//               color:[circleColor colorWithAlphaComponent:drawInf.endMarkerAlpha]
//          withCenter:drawInf.endMarkerCenter];
    [self drawString:endMarkerStr
            withFont:[UIFont boldSystemFontOfSize:drawInf.endMarkerFontize]
               color:[UIColor whiteColor]
          withCenter:drawInf.endMarkerCenter];
    

}

- (void)drawSector:(SAMultisectorSector *)sector atPosition:(NSUInteger)position{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, saCircleLineWidth);
    
    UIColor *startCircleColor = [sector.color colorWithAlphaComponent:0.0];
    UIColor *circleColor = sector.color;
    //UIColor *circleColor = [UIColor redColor];
    UIColor *endCircleColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1]; //0.1
    
    SASectorDrawingInformation drawInf = [self sectorToDrawInf:sector position:position];

    CGFloat x = drawInf.circleCenter.x;
    CGFloat y = drawInf.circleCenter.y;
    CGFloat r = drawInf.radius;
    
    
    //start circle line
    [startCircleColor setStroke];
    CGContextAddArc(context, x, y, r, self.startAngle, drawInf.circleOffsetAngle, 0);
    CGContextStrokePath(context);
    
    
    //circle line
    [circleColor setStroke];
    CGContextAddArc(context, x, y, r, drawInf.circleOffsetAngle, drawInf.circleLineAngle, 0);
    CGContextStrokePath(context);
    
    
    //end circle line
    [endCircleColor setStroke];
    CGContextAddArc(context, x, y, r, drawInf.circleLineAngle, drawInf.circleEmptyAngle, 0);
    CGContextStrokePath(context);
    
    
    //clearing place for start marker
    CGContextSaveGState(context);
    CGContextAddArc(context, drawInf.startMarkerCenter.x, drawInf.startMarkerCenter.y, drawInf.startMarkerRadius - (saMarkersLineWidth/2.0), 0.0, 6.28, 0);
    CGContextClip(context);
    CGContextClearRect(context, self.bounds);
    CGContextRestoreGState(context);
    
    
    //clearing place for end marker
    CGContextSaveGState(context);
    CGContextAddArc(context, drawInf.endMarkerCenter.x, drawInf.endMarkerCenter.y, drawInf.endMarkerRadius - (saMarkersLineWidth/2.0), 0.0, 6.28, 0);
    CGContextClip(context);
    CGContextClearRect(context, self.bounds);
    CGContextRestoreGState(context);
    
    //clearing place for current marker
//    CGContextSaveGState(context);
//    CGContextAddArc(context, drawInf.currentMarkerCenter.x, drawInf.currentMarkerCenter.y, drawInf.currMarkerRadius - (saMarkersLineWidth/2.0), 0.0, 6.28, 0);
//    CGContextClip(context);
//    CGContextClearRect(context, self.bounds);
//    CGContextRestoreGState(context);
    
    
    //markers
    CGContextSetLineWidth(context, saMarkersLineWidth);
    
    //drawing start marker
   [[circleColor colorWithAlphaComponent:drawInf.startMarkerAlpha] setStroke];
  //  [[UIColor redColor] setStroke];
  //    [[circleColor colorWithAlphaComponent:0.0] setStroke];
    CGContextAddArc(context, drawInf.startMarkerCenter.x, drawInf.startMarkerCenter.y, drawInf.startMarkerRadius, 0.0, 6.28, 0);
    //New line
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:42.0/255.0 green:133.0/255.0 blue:202/255.0 alpha:1.0].CGColor);
    CGContextFillPath(context);
    //end new line
    CGContextStrokePath(context);
    
    //drawing end marker
    [[circleColor colorWithAlphaComponent:drawInf.endMarkerAlpha] setStroke];
    CGContextAddArc(context, drawInf.endMarkerCenter.x, drawInf.endMarkerCenter.y, drawInf.endMarkerRadius, 0.0, 6.28, 0);
    //New line
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:42.0/255.0 green:133.0/255.0 blue:202/255.0 alpha:1.0].CGColor);
    CGContextFillPath(context);
    //New line end
    CGContextStrokePath(context);
    
    //drawing Current marker
//    [[circleColor colorWithAlphaComponent:drawInf.endMarkerAlpha] setStroke];
//   
//    CGContextAddArc(context,drawInf.currentMarkerCenter.x, drawInf.currentMarkerCenter.y, drawInf.currMarkerRadius, 0.0, 6.28, 0);
//    
//    
//    CGContextStrokePath(context);
    
    self.imgViewProfile.frame = CGRectMake(drawInf.currentMarkerCenter.x-15,drawInf.currentMarkerCenter.y-15,self.imgViewProfile.frame.size.width,self.imgViewProfile.frame.size.height);
   
    
    
    //text on markers
    NSString *markerStrTemplate = [@"%.0f" stringByReplacingOccurrencesOfString:@"0" withString:[NSString stringWithFormat:@"%i", self.numbersAfterPoint]];
    NSString *startMarkerStr = [NSString stringWithFormat:markerStrTemplate, sector.startValue];
    NSString *endMarkerStr = [NSString stringWithFormat:markerStrTemplate, sector.endValue];
    NSString *currentMarkerStr = [NSString stringWithFormat:markerStrTemplate, sector.currValue];
    
    //drawing start marker's text
//    [self drawString:startMarkerStr
//            withFont:[UIFont boldSystemFontOfSize:drawInf.startMarkerFontSize]
//               color:[circleColor colorWithAlphaComponent:drawInf.startMarkerAlpha]
//          withCenter:drawInf.startMarkerCenter];
    [self drawString:startMarkerStr
            withFont:[UIFont boldSystemFontOfSize:drawInf.startMarkerFontSize]
               color:[UIColor whiteColor]
          withCenter:drawInf.startMarkerCenter];
    
    //drawing end marker's text
//    [self drawString:endMarkerStr
//            withFont:[UIFont boldSystemFontOfSize:drawInf.endMarkerFontize]
//               color:[circleColor colorWithAlphaComponent:drawInf.endMarkerAlpha]
//          withCenter:drawInf.endMarkerCenter];
    [self drawString:endMarkerStr
            withFont:[UIFont boldSystemFontOfSize:drawInf.endMarkerFontize]
               color:[UIColor whiteColor]
          withCenter:drawInf.endMarkerCenter];
    
    //drawing current marker's text
//    [self drawString:currentMarkerStr
//            withFont:[UIFont boldSystemFontOfSize:drawInf.endMarkerFontize]
//               color:[circleColor colorWithAlphaComponent:drawInf.endMarkerAlpha]
//          withCenter:drawInf.currentMarkerCenter];
    
}


- (SASectorDrawingInformation) sectorToDrawInf:(SAMultisectorSector *)sector position:(NSInteger)position{
    
    SASectorDrawingInformation drawInf;
    
    drawInf.circleCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height /2);
    drawInf.radius = self.sectorsRadius * position;
    
    drawInf.fullLine = sector.maxValue - sector.minValue;
    NSLog(@"min val = %f ",sector.minValue);

    drawInf.circleOffset = sector.startValue - sector.minValue;
    drawInf.circleLine = sector.endValue - sector.startValue;
    drawInf.circleEmpty = sector.currValue - sector.startValue;
    
    NSLog(@"min val = %f %f %f ",drawInf.circleOffset, drawInf.circleLine, drawInf.circleEmpty);
    
    NSLog(@"angles %f", self.startAngle);
    
    
    drawInf.circleOffsetAngle = (drawInf.circleOffset/drawInf.fullLine) * M_PI * 2 + self.startAngle;
    
    NSLog(@"angles %f", drawInf.circleOffsetAngle);

    drawInf.circleLineAngle = (drawInf.circleLine/drawInf.fullLine) * M_PI * 2 + drawInf.circleOffsetAngle;
    
    drawInf.circleEmptyAngle = (drawInf.circleEmpty/drawInf.fullLine) * M_PI * 2 + drawInf.circleOffsetAngle;
    
    NSLog(@"start Angle = %f %f", drawInf.circleLineAngle, drawInf.circleEmptyAngle);
    
    
    drawInf.startMarkerCenter = polarToDecart(drawInf.circleCenter, drawInf.radius, drawInf.circleOffsetAngle);
    drawInf.endMarkerCenter = polarToDecart(drawInf.circleCenter, drawInf.radius, drawInf.circleLineAngle);
    
    
    drawInf.currentMarkerCenter = polarToDecart(drawInf.circleCenter, drawInf.radius, drawInf.circleEmptyAngle);
    
    
    CGFloat minMarkerRadius = self.sectorsRadius / 4.0;
    CGFloat maxMarkerRadius = self.sectorsRadius / 2.0;
    
//    drawInf.startMarkerRadius = ((drawInf.circleOffsetAngle/(self.startAngle + 2*M_PI)) * (maxMarkerRadius - minMarkerRadius)) + minMarkerRadius;
//    drawInf.endMarkerRadius = ((drawInf.circleLineAngle/(self.startAngle + 2*M_PI)) * (maxMarkerRadius - minMarkerRadius)) + minMarkerRadius;
//    drawInf.currMarkerRadius = ((drawInf.circleEmptyAngle/(self.startAngle + 2*M_PI)) * (maxMarkerRadius - minMarkerRadius)) + minMarkerRadius;
    
    
    drawInf.startMarkerRadius = 20;
    drawInf.endMarkerRadius = 20;
    drawInf.currMarkerRadius = 20;
    
    CGFloat minFontSize = 12.0;
    CGFloat maxFontSize = 18.0;
    
    drawInf.startMarkerFontSize = ((drawInf.circleOffset/drawInf.fullLine) * (maxFontSize - minFontSize)) + minFontSize;
    drawInf.endMarkerFontize = ((drawInf.circleLine/drawInf.fullLine) * (maxFontSize - minFontSize)) + minFontSize;
    
    CGFloat markersCentresSegmentLength = segmentLength(drawInf.startMarkerCenter, drawInf.endMarkerCenter);
    CGFloat markersRadiusSumm = drawInf.startMarkerRadius + drawInf.endMarkerRadius;
    
    if(markersCentresSegmentLength < markersRadiusSumm){
        
        drawInf.startMarkerAlpha = markersCentresSegmentLength / markersRadiusSumm;
        //drawInf.startMarkerAlpha = 1.0;
    }else{
        drawInf.startMarkerAlpha = 1.0;
    }
    
    drawInf.endMarkerAlpha = 1.0;

    return drawInf;
}

- (void) drawString:(NSString *)s withFont:(UIFont *)font color:(UIColor *)color withCenter:(CGPoint)center{
    CGSize size = [s sizeWithFont:font];
    CGFloat x = center.x - (size.width / 2);
    CGFloat y = center.y - (size.height / 2);
    CGRect textRect = CGRectMake(x, y, size.width, size.height);
    
    if(IS_OS_LOWER_7){
        [color set];
        [s drawInRect:textRect withFont:font];
    }else{
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[UITextAttributeFont] = font;
        attr[UITextAttributeTextColor] = color;
        [s drawInRect:textRect withAttributes:attr];
    }
}


@end





@implementation SAMultisectorSector

- (instancetype)init{
    if(self = [super init]){
        self.minValue = 0.0; //0.0
        self.maxValue = 100.0; //100.0
        self.startValue = 0.0;
        self.endValue = 50.0;
        self.tag = 0;
        self.color = [UIColor greenColor];
    }
    return self;
}

+ (instancetype) sector{
    return [[SAMultisectorSector alloc] init];
}

+ (instancetype) sectorWithColor:(UIColor *)color{
    SAMultisectorSector *sector = [self sector];
    sector.color = color;
    return sector;
}

+ (instancetype) sectorWithColor:(UIColor *)color maxValue:(double)maxValue{
    SAMultisectorSector *sector = [self sectorWithColor:color];
    sector.maxValue = maxValue;
    return sector;
}

+ (instancetype) sectorWithColor:(UIColor *)color minValue:(double)minValue maxValue:(double)maxValue{
    SAMultisectorSector *sector = [self sectorWithColor:color maxValue:maxValue];
    sector.minValue = minValue;
    return sector;
}

@end
