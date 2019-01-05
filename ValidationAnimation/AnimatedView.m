//
//  AnimatedView.m
//  ValidationAnimation
//
//  Created by Pulkit Rohilla on 24/11/15.
//  Copyright © 2015 PulkitRohilla. All rights reserved.
//

#import "AnimatedView.h"
#define   DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)

@implementation AnimatedView{
    
    UIColor *fColor,*bColor;
    CAShapeLayer *drawingLayer;
}

const static CGFloat innerMargin = 10;
const static CGFloat lineWidth = 0.5;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGRect innerRect = CGRectMake(rect.origin.x + (innerMargin/2 - lineWidth), rect.origin.y + (innerMargin/2 - lineWidth), rect.size.width - innerMargin, rect.size.height - innerMargin);

    int radius = innerRect.size.width/2;

    CGPoint center = CGPointMake(CGRectGetMidX(innerRect) - radius, CGRectGetMidY(innerRect) - radius);

    CAShapeLayer *shape = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                                    cornerRadius:radius];
    shape.path = path.CGPath;
    shape.position = center;
    shape.fillColor = bColor.CGColor;
    
    [shape setShadowOffset:CGSizeMake(1, 1)];
    [shape setShadowOpacity:0.25];
    [shape setShadowRadius:3];
    
    [self.layer addSublayer:shape];
    
    [self beginDrawingAnimation];
}

-(void)setForeColor:(UIColor *)foreColor{
    
    fColor = foreColor;
}

-(void)setBackColor:(UIColor *)backColor{
    
    bColor = backColor;
}

#pragma mark - Animation

- (void)beginDrawingAnimation{

    CGRect rect = self.bounds;
    
    int radius = rect.size.width/2 - 4.5;
    
    CGPoint centerForArc = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));

    CGPoint lowerPoint = CGPointMake(CGRectGetMinX(rect) + 0.27083 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.54167 * CGRectGetHeight(rect));
    CGPoint middlePoint = CGPointMake(CGRectGetMinX(rect) + 0.41667 * CGRectGetWidth(rect), CGRectGetMinY(rect) + 0.68750 * CGRectGetHeight(rect));
    
    UIBezierPath * circlePath = [UIBezierPath bezierPathWithArcCenter:centerForArc radius:radius startAngle:3*M_PI/2 endAngle:3*M_PI/2 - M_PI_2 clockwise:YES];
    [circlePath addArcWithCenter:centerForArc radius:radius startAngle:3*M_PI/2 - M_PI_2 endAngle:3*M_PI/2 - 2*M_PI_2 clockwise:YES];
    [circlePath addArcWithCenter:centerForArc radius:radius startAngle:3*M_PI/2 - 2*M_PI_2 endAngle:-0.5  clockwise:YES];
    [circlePath addLineToPoint:middlePoint];
    [circlePath addLineToPoint:lowerPoint];
    
    drawingLayer = [CAShapeLayer layer];
    drawingLayer.lineWidth = 3;
    drawingLayer.lineJoin = kCALineJoinBevel;
    drawingLayer.fillColor = [UIColor clearColor].CGColor;
    drawingLayer.strokeColor = fColor.CGColor;
   
    [drawingLayer setPath:circlePath.CGPath];
    [self.layer addSublayer:drawingLayer];

    CABasicAnimation* strokeEndAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnim.fromValue = (id)[NSNumber numberWithFloat:0.0];
    strokeEndAnim.toValue = (id)[NSNumber numberWithFloat:0.1];
    strokeEndAnim.removedOnCompletion = NO;
    strokeEndAnim.fillMode = kCAFillModeForwards;
    strokeEndAnim.duration = 0.25;
    strokeEndAnim.speed = 1;
    
    CABasicAnimation* rotateStrokeStartAnim = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    rotateStrokeStartAnim.toValue = (id)[NSNumber numberWithFloat:0.7];
    
    CABasicAnimation* rotateStrokeEndAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    rotateStrokeEndAnim.toValue = (id)[NSNumber numberWithFloat:0.8];

    CAAnimationGroup *rotateAnimation = [CAAnimationGroup animation];
    rotateAnimation.animations = [NSArray arrayWithObjects: rotateStrokeStartAnim, rotateStrokeEndAnim, nil];
    rotateAnimation.duration = 1.0;
    rotateAnimation.removedOnCompletion = NO;
    rotateAnimation.fillMode = kCAFillModeForwards;
    rotateAnimation.speed = 1;

    
    CABasicAnimation* tickStrokeStartAnim = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    tickStrokeStartAnim.toValue = (id)[NSNumber numberWithFloat:0.905];

    CABasicAnimation* tickStrokeEndAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    tickStrokeEndAnim.toValue = (id)[NSNumber numberWithFloat:1.0];
    
    CAAnimationGroup *tickAnimation = [CAAnimationGroup animation];
    tickAnimation.animations = [NSArray arrayWithObjects: tickStrokeStartAnim, tickStrokeEndAnim, nil];
    tickAnimation.removedOnCompletion = NO;
    tickAnimation.fillMode = kCAFillModeForwards;

    [CATransaction begin]; {
        [CATransaction setCompletionBlock:^{
            
            [CATransaction begin]; {
                [CATransaction setCompletionBlock:^{
                    
                    [CATransaction begin]; {
                        
                        // Demo
                        [CATransaction setCompletionBlock:^{

                            [NSTimer scheduledTimerWithTimeInterval:1.5 target: self
                                                                              selector: @selector(showDemo) userInfo:nil repeats: NO];
                           
                        }];
                        
                        [drawingLayer addAnimation:tickAnimation forKey:@"tickAnimation"];
                    }
                    
                    [CATransaction commit];
                    
                }];
                
                [drawingLayer addAnimation:rotateAnimation forKey:@"rotationAnimation"];
            }
            [CATransaction commit];
        }];
        
        [drawingLayer addAnimation:strokeEndAnim forKey:@"strokeAnimation"];

    }
    [CATransaction commit];
}

-(void)showDemo{
    
    [drawingLayer removeAllAnimations];
    [drawingLayer removeFromSuperlayer];
    [self beginDrawingAnimation];
}

@end
