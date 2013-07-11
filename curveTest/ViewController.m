//
//  ViewController.m
//  curveTest
//
//  Created by Gaurav on 6/7/13.
//  Copyright (c) 2013 Gaurav. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    UIImageView *topLeftMarker, *topMiddleMarker, *topRightMarker, *bottomLeftMarker, *bottomMiddleMarker, *bottomRightMarker;
    
    UIBezierPath *bezierPath;
    
    UIView *currentSelectedMarker;
    
    BOOL shouldMovePath;
    
    CGPoint lastPoint;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.imageView];
    
    bezierPath = [UIBezierPath bezierPath];
    
    UIImage *markerImage = [UIImage imageNamed:@"marker"];
    
    topLeftMarker = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self.view addSubview:topLeftMarker];
    topMiddleMarker = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self.view addSubview:topMiddleMarker];
    
    topRightMarker = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self.view addSubview:topRightMarker];
    bottomLeftMarker = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self.view addSubview:bottomLeftMarker];
    bottomMiddleMarker = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self.view addSubview:bottomMiddleMarker];
    bottomRightMarker = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self.view addSubview:bottomRightMarker];
    
    
    topLeftMarker.image = topMiddleMarker.image = topRightMarker.image = bottomLeftMarker.image = bottomMiddleMarker.image = bottomRightMarker.image = markerImage;
    
    CGSize imageSize = self.imageView.bounds.size;
    bottomMiddleMarker.center = CGPointMake(imageSize.width * 0.5f, imageSize.height * 0.5f + 30);;
    bottomLeftMarker.center = CGPointMake(bottomMiddleMarker.center.x - 40, bottomMiddleMarker.center.y - 10);
    bottomRightMarker.center = CGPointMake(bottomMiddleMarker.center.x + 40, bottomLeftMarker.center.y );
    topMiddleMarker.center = CGPointMake(bottomMiddleMarker.center.x, bottomMiddleMarker.center.y - 60);
    topLeftMarker.center = CGPointMake(bottomLeftMarker.center.x, topMiddleMarker.center.y + 10);
    topRightMarker.center = CGPointMake(bottomRightMarker.center.x, topLeftMarker.center.y);
    
    [self createPath];
}



-(void)createPath{
    
    [bezierPath removeAllPoints];
    [bezierPath setLineCapStyle:kCGLineCapRound];
    [bezierPath setLineWidth:2.0f];
    [bezierPath moveToPoint:topLeftMarker.center];
    
    
    CGPoint midPoint = CGPointMake((topLeftMarker.center.x + topRightMarker.center.x) * 0.5f, (topLeftMarker.center.y + topRightMarker.center.y) * 0.5f);
    CGFloat yDiff = topMiddleMarker.center.y - midPoint.y;
    CGFloat xDiff = topMiddleMarker.center.x - midPoint.x;
    
    
    CGPoint controlPoint1 = CGPointMake(topMiddleMarker.center.x + xDiff, topMiddleMarker.center.y + yDiff);
    [bezierPath addQuadCurveToPoint:topRightMarker.center controlPoint:controlPoint1];
    
    
    
    [bezierPath addLineToPoint:bottomRightMarker.center];
    
    
    midPoint = CGPointMake((bottomLeftMarker.center.x + bottomRightMarker.center.x) * 0.5f, (bottomLeftMarker.center.y + bottomRightMarker.center.y) * 0.5f);
    yDiff = bottomMiddleMarker.center.y - midPoint.y;
    xDiff = bottomMiddleMarker.center.x - midPoint.x;
    
    CGPoint controlPoint2 = CGPointMake(bottomMiddleMarker.center.x + xDiff, bottomMiddleMarker.center.y + yDiff);
    
    [bezierPath addQuadCurveToPoint:bottomLeftMarker.center controlPoint:controlPoint2];
    
    [bezierPath closePath];
    
    UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO , 0.f);
    [[UIColor clearColor] setFill];
    UIRectFill(self.imageView.bounds);
    [[UIColor blueColor] setStroke];
    [bezierPath stroke];
    [[UIColor greenColor] setFill];
    [bezierPath fill];
    
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0f);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor redColor].CGColor);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), controlPoint1.x, controlPoint1.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), controlPoint1.x, controlPoint1.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor brownColor].CGColor);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), controlPoint2.x, controlPoint2.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), controlPoint2.x, controlPoint2.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    CGContextFlush(UIGraphicsGetCurrentContext());
    
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([[event allTouches] count]>1) {
        return;
    }

    CGPoint currentPoint = [[touches anyObject] locationInView:self.view];

    currentSelectedMarker = [self markerAtPoint:currentPoint];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([[event allTouches] count]>1) {
        return;
    }

    CGPoint currentPoint = [[touches anyObject] locationInView:self.view];
    CGPoint translation = CGPointMake(currentPoint.x - lastPoint.x, currentPoint.y - lastPoint.y);
    if (currentSelectedMarker) {
        //currentSelectedMarker.center = currentPoint;
        [self moveSelectedMarkerForTranslation:translation withTargetpoint:currentPoint];
        //lastPoint = currentPoint;
        [self createPath];
        

    }
    if (shouldMovePath) {
        
        [self movePathForTranslation:translation];
        [self createPath];
        
    }
    
    lastPoint = currentPoint;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    currentSelectedMarker = nil;
    shouldMovePath = NO;
    //lastPoint = CGPointZero;
}

-(void)movePathForTranslation:(CGPoint )translation{
    CGPoint center = topLeftMarker.center;
    center.x += translation.x;
    center.y += translation.y;
    topLeftMarker.center = center;
    
    center = topMiddleMarker.center;
    center.x += translation.x;
    center.y += translation.y;
    topMiddleMarker.center = center;
    
    center = topRightMarker.center;
    center.x += translation.x;
    center.y += translation.y;
    topRightMarker.center = center;
    
    center = bottomLeftMarker.center;
    center.x += translation.x;
    center.y += translation.y;
    bottomLeftMarker.center = center;
    
    center = bottomMiddleMarker.center;
    center.x += translation.x;
    center.y += translation.y;
    bottomMiddleMarker.center = center;
    
    center = bottomRightMarker.center;
    center.x += translation.x;
    center.y += translation.y;
    bottomRightMarker.center = center;
}

-(void)moveSelectedMarkerForTranslation:(CGPoint)translation withTargetpoint:(CGPoint)target{
        currentSelectedMarker.center = target;
    
}



-(UIView *)markerAtPoint:(CGPoint)point{
    lastPoint = point;
    if (CGRectContainsPoint(topLeftMarker.frame, point)) {
        return topLeftMarker;
    }
    if (CGRectContainsPoint(topMiddleMarker.frame, point)) {
        return topMiddleMarker;
    }
    if (CGRectContainsPoint(topRightMarker.frame, point)) {
        return topRightMarker;
    }
    if (CGRectContainsPoint(bottomLeftMarker.frame, point)) {
            return bottomLeftMarker;
    }
    if (CGRectContainsPoint(bottomMiddleMarker.frame, point)) {
        return bottomMiddleMarker;
    }
    if (CGRectContainsPoint(bottomRightMarker.frame, point)) {
        return bottomRightMarker;
    }
    if([bezierPath containsPoint:point]){
        shouldMovePath = YES;
        
    }
    
    
    return nil;
}

@end
