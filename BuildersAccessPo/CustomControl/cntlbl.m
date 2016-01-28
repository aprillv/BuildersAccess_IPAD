//
//  cntlbl.m
//  BuildersAccess
//
//  Created by roberto ramirez on 12/17/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "cntlbl.h"

@implementation cntlbl
@synthesize cnt, Cname;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    int dwidth = rect.size.width;
    int aw;
    aw=dwidth*.8;
    int ax=2;
    
    
    UIFont *ft =[UIFont systemFontOfSize:17.0];
    
    [Cname drawInRect: CGRectMake(ax, 10, aw, 20) withFont: ft lineBreakMode: NSLineBreakByClipping
            alignment: NSTextAlignmentLeft];
    
    ax =ax+aw;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    
    CGContextFillRect(context, CGRectMake(ax, 0, 1,  self.frame.size.height));
    
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    ax =ax+1;
    
    aw=dwidth-ax;
    
    [cnt drawInRect: CGRectMake(ax, 10, aw-1, 20) withFont: ft lineBreakMode: NSLineBreakByClipping
          alignment: NSTextAlignmentCenter];

}


@end
