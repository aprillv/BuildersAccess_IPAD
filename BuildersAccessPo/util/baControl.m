//
//  baControl.m
//  BuildersAccess
//
//  Created by roberto ramirez on 9/24/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "baControl.h"
#import "Mysql.h"
#import "NSString+Color.h"
#import <QuartzCore/QuartzCore.h>

@implementation baControl

+ (UIButton *) getGrayButton{
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn1 setTitleColor:[Mysql getBlueTextColor] forState:UIControlStateNormal];
//    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    Mysql *msql =[[Mysql alloc]init];
//    UIImage * u =[msql createImageWithColor:[UIColor lightGrayColor] ];
//    
//    [btn1 setBackgroundImage:u forState:UIControlStateNormal];
//    [btn1 setBackgroundImage:[msql createImageWithColor:[@"007add" toColor] ] forState:UIControlStateHighlighted];
//    btn1.contentMode=UIViewContentModeScaleAspectFill;
//    btn1.clipsToBounds=YES;
//    btn1.layer.cornerRadius = 5.0;
//    
//    btn1.titleLabel.font=[UIFont systemFontOfSize:15.0];
//    return btn1;
    
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"grayButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 5.0;
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return loginButton;
    
}

- (UIButton *) getButton:(UIColor *)co andrect:(CGRect)tttt{
    return [self getButton1:co andrect:tttt andradius:5.0f];
    
}
- (UIImage *) roundCorners:(UIImage*)img withRadius:(float)radius {
	int w = img.size.width;
	int h = img.size.height;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
	
	CGContextBeginPath(context);
	CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
	addRoundedRectToPath(context, rect, radius, radius);
	CGContextClosePath(context);
	CGContextClip(context);
	
	CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
	
	CGImageRef imageMasked = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	
	return [UIImage imageWithCGImage:imageMasked];
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}



-(UIButton *)getButton1:(UIColor *)co andrect:(CGRect)tttt andradius:(float)f{
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    Mysql *mq =[[Mysql alloc]init];
    UIImage *roundedImage = [self roundCorners:[mq createImageWithColor:co withrect:tttt]  withRadius:f];
    [loginButton setBackgroundImage:[roundedImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return loginButton;
}



@end
