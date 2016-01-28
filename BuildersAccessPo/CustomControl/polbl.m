//
//  polbl.m
//  BuildersAccess
//
//  Created by roberto ramirez on 12/6/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "polbl.h"

@implementation polbl
@synthesize desc, qty, price, total, istwocolomum, isfirst;

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
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)drawRect:(CGRect)rect
{
    int dwidth = rect.size.width;
    int aw;
    aw=dwidth*.58;
    int ax=5;
    
//    CGFloat fontHeight = font.pointSize;
//    CGFloat yOffset = (contextRect.size.height - fontHeight) / 2.0;
//    
//    CGRect textRect = CGRectMake(0, yOffset, contextRect.size.width, fontHeight);
    if (isfirst) {
        [desc drawInRect: CGRectMake(ax, 10, aw-5, 20) withFont: self.font lineBreakMode: NSLineBreakByClipping
               alignment: NSTextAlignmentCenter];
    }else{
        [desc drawInRect: CGRectMake(ax, 10, aw-5, 20) withFont: self.font lineBreakMode: NSLineBreakByClipping
               alignment: NSTextAlignmentLeft];
    }
   

    
    ax =ax+aw-5;
    
//    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(ax, 0, 1, self.frame.size.height)];
//    if (isfirst) {
// 
//        lbl.backgroundColor=[UIColor whiteColor];
//    }else{
//        lbl.backgroundColor=[UIColor lightGrayColor];
//    }
//    
//    [self addSubview:lbl];
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ax, 0, 1, self.frame.size.height)];
//    lineView.backgroundColor = [UIColor blackColor];
//    [self addSubview:lineView];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (isfirst) {
       CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    }else{
       CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    }
    
   
    
//    CGContextMoveToPoint(context, ax,0); //start at this point
//    
//    CGContextAddLineToPoint(context, ax, self.frame.size.height); //draw to this point
//    
//    // and now draw the Path!
//    CGContextStrokePath(context);
    
    if (!istwocolomum) {
         CGContextFillRect(context, CGRectMake(ax, 0, 1,  self.frame.size.height));
    }
   
     CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    ax =ax+1;
    
    aw=dwidth*.14;
    if (isfirst) {
        [qty drawInRect: CGRectMake(ax, 10, aw-1, 20) withFont: self.font lineBreakMode: NSLineBreakByClipping
              alignment: NSTextAlignmentCenter];
    }else{
        [qty drawInRect: CGRectMake(ax, 10, aw-1, 20) withFont: self.font lineBreakMode: NSLineBreakByClipping
              alignment: NSTextAlignmentRight];
    }
    ax =ax+aw-1;
    
//    lbl = [[UILabel alloc]initWithFrame:CGRectMake(ax, 0, 1, self.frame.size.height)];
//    if (isfirst) {
//        lbl.backgroundColor=[UIColor whiteColor];
//    }else{
//        lbl.backgroundColor=[UIColor lightGrayColor];
//    }
    if (!istwocolomum) {
        if (isfirst) {
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        }else{
            CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
        }
        CGContextFillRect(context, CGRectMake(ax, 0, 1,  self.frame.size.height));
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    }
    
    ax=ax+1;
    
   
    aw=dwidth*.14;
    if (isfirst) {
        [price drawInRect: CGRectMake(ax, 10, aw, 20) withFont: self.font lineBreakMode: NSLineBreakByClipping
                alignment: NSTextAlignmentCenter];
    }else{
        [price drawInRect: CGRectMake(ax, 10, aw, 20) withFont: self.font lineBreakMode: NSLineBreakByClipping
                alignment: NSTextAlignmentRight];
    }
   
    
    ax =ax+aw-1;
    
    if (isfirst) {
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    }else{
        CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    }
    CGContextFillRect(context, CGRectMake(ax, 0, 1,  self.frame.size.height));
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    ax=ax+1;
    
    aw=dwidth*.14;
    if (isfirst) {
        [total drawInRect: CGRectMake(ax, 10, aw, 20) withFont: self.font lineBreakMode: NSLineBreakByClipping
                alignment: NSTextAlignmentCenter];
    }else{
        [total drawInRect: CGRectMake(ax, 10, aw, 20) withFont: self.font lineBreakMode: NSLineBreakByClipping
                alignment: NSTextAlignmentRight];
    }
    
    
 
    
}

@end
