//
//  OptionsUITableViewCell.m
//  BuildersAccess
//
//  Created by April Lv on 2/16/17.
//  Copyright © 2017 eloveit. All rights reserved.
//

#import "OptionsUITableViewCell.h"

@implementation OptionsUITableViewCell
@synthesize TLabel;
- (void)drawRect:(CGRect)rect{
        
        TLabel = [[UILabel alloc] initWithFrame: CGRectMake( 0, 0, self.frame.size.width, 43)];
//        TLabel.backgroundColor=[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        //    label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    [TLabel setAdjustsFontSizeToFitWidth:YES];
    TLabel.minimumScaleFactor = 0.5;
        [self.contentView addSubview: TLabel];
        
    
}

@end
