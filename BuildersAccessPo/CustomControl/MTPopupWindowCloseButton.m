//
//  MTPopupWindowCloseButton.m
//  BuildersAccess
//
//  Created by roberto ramirez on 1/3/14.
//  Copyright (c) 2014 eloveit. All rights reserved.
//
#define kCloseBtnDiameter 36
#import "MTPopupWindowCloseButton.h"

@implementation MTPopupWindowCloseButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/


- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //    CGContextAddEllipseInRect(ctx, CGRectOffset(rect, 0, 0));
    //    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1] CGColor]));
    //    CGContextFillPath(ctx);
    //
    //    CGContextAddEllipseInRect(ctx, CGRectInset(rect, 1, 1));
    //    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] CGColor]));
    //    CGContextFillPath(ctx);
    //
    //    CGContextAddEllipseInRect(ctx, CGRectInset(rect, 4, 4));
    //    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor colorWithRed:1 green:1 blue:1 alpha:1] CGColor]));
    //    CGContextFillPath(ctx);
    
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1].CGColor);
    CGContextSetLineWidth(ctx, 3.0);
    CGContextMoveToPoint(ctx, kCloseBtnDiameter/4+1,kCloseBtnDiameter/4+1); //start at this point
    CGContextAddLineToPoint(ctx, kCloseBtnDiameter/4*3+1,kCloseBtnDiameter/4*3+1); //draw to this point
    CGContextStrokePath(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1].CGColor);
    CGContextSetLineWidth(ctx, 3.0);
    CGContextMoveToPoint(ctx, kCloseBtnDiameter/4*3+1,kCloseBtnDiameter/4+1); //start at this point
    CGContextAddLineToPoint(ctx, kCloseBtnDiameter/4+1,kCloseBtnDiameter/4*3+1); //draw to this point
    CGContextStrokePath(ctx);

}
@end
