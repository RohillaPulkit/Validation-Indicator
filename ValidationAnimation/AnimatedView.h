//
//  AnimatedView.h
//  ValidationAnimation
//
//  Created by Pulkit Rohilla on 24/11/15.
//  Copyright © 2015 PulkitRohilla. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface AnimatedView : UIView

@property (strong, nonatomic) IBInspectable UIColor *foreColor;
@property (strong, nonatomic) IBInspectable UIColor *backColor;

@end
