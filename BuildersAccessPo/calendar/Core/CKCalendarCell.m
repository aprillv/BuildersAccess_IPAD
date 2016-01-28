//
//  CKCalendarCalendarCell.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCalendarCell.h"
#import "CKCalendarCellColors.h"
#import "Mysql.h"
#import "wcfKirbytileItem2.h"
#import "UIView+Border.h"

@interface CKCalendarCell (){
    CGSize _size;
}

@property (nonatomic, strong) UILabel *label;

//@property (nonatomic, strong) UIView *dot;

@end

@implementation CKCalendarCell
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        _state = CKCalendarMonthCellStateNormal;
        
        //  Normal Cell Colors
        _normalBackgroundColor = kCalendarColorLightGray;
        _selectedBackgroundColor = kCalendarColorBlue;
        _inactiveSelectedBackgroundColor = kCalendarColorDarkGray;
        
        //        //  Today Cell Colors
        //        _todayBackgroundColor = kCalendarColorBluishGray;
        //        _todaySelectedBackgroundColor = kCalendarColorBlue;
        //        _todayTextShadowColor = kCalendarColorTodayShadowBlue;
        //        _todayTextColor = [UIColor whiteColor];
        
        //  Text Colors
        _textColor = kCalendarColorDarkTextGradient;
        _textShadowColor = [UIColor whiteColor];
        _textSelectedColor = [UIColor whiteColor];
        _textSelectedShadowColor = kCalendarColorSelectedShadowBlue;
        
        _dotColor = kCalendarColorDarkTextGradient;
        _selectedDotColor = [UIColor whiteColor];
        
        _cellBorderColor = kCalendarColorCellBorder;
        _selectedCellBorderColor = kCalendarColorSelectedCellBorder;
        
        // Label
        _label = [UILabel new];
        
        //  Dot
//        _dot = [UIView new];
//        [_dot setHidden:YES];
//        _showDot = NO;
    }
    return self;
}

- (id)initWithSize:(CGSize)size
{
    self = [self init];
    if (self) {
        _size = size;
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    CGPoint origin = [self frame].origin;
    [self setFrame:CGRectMake(origin.x, origin.y, _size.width, _size.height)];
    [self layoutSubviews];
    [self applyColors];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [self configureLabel];
//    [self configureDot];
    
    [self addSubview:[self label]];
//    [self addSubview:[self dot]];
}

#pragma mark - Setters

- (void)setState:(CKCalendarMonthCellState)state
{
    if (state > CKCalendarMonthCellStateOutOfRange || state < CKCalendarMonthCellStateTodaySelected) {
        return;
    }
    
    _state = state;
    
    [self applyColorsForState:_state];
}

- (void)setNumber:(NSNumber *)number
{
    _number = number;
    
    //  TODO: Locale support?
    NSString *stringVal = [number stringValue];
    if([self state] == CKCalendarMonthCellStateTodayDeselected){
        self.label.text=[NSString stringWithFormat:@"Today %@", number];
    }else{
        [[self label] setText:stringVal];
    }
    
}

- (void)setShowDot:(NSMutableArray*)showDot
{
    _showDot = showDot;
//    [[self dot] setHidden:!showDot];
//     [[self dot] setHidden:YES];
    
    CGFloat selfWidth = [self frame].size.width;
    //
    //    [[dot layer] setCornerRadius:dotRadius/2];
    //
    //    CGRect dotFrame = CGRectMake(selfWidth/2 - dotRadius/2, (selfHeight - (selfHeight/5)) - dotRadius/2, dotRadius, dotRadius);
    //    [[self dot] setFrame:dotFrame];
    Mysql *mysql =[[Mysql alloc]init];
    for (UIView *tt in self.subviews) {
        if (tt!=self.label ) {
            [tt removeFromSuperview];
        }
    }
    
    UIView *ueeee;
     int y;
    if (showDot.count<6) {
        ueeee=self;
        y=20;
        
    }else{
        UIScrollView *us =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, selfWidth, [self frame].size.height-20)];
        us.contentSize= CGSizeMake(selfWidth, [showDot count]*32);
        [self addSubview:us];
        ueeee=us;
        y=0;
    }
    
    UIButton* loginButton;
   
    
    for (wcfKirbytileItem2 *me in showDot) {
        loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [loginButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        loginButton.frame=CGRectMake(1, y, selfWidth-2, 30);
        
        UIImage *image ;
        if ([me.Color isEqualToString:@"Red"]) {
            image =[mysql createImageWithColor:[UIColor redColor]] ;
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else if([me.Color isEqualToString:@"Blue"]){
            image =[mysql createImageWithColor:[UIColor blueColor]] ;
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else if([me.Color isEqualToString:@"Green"]){
            image =[mysql createImageWithColor:[UIColor colorWithRed:0.1953125 green:0.80078125 blue:0.1953125 alpha:1]];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else if([me.Color isEqualToString:@"Yellow"]){
            image =[mysql createImageWithColor:[UIColor colorWithRed:0.8515625 green:0.64453125 blue:0.125 alpha:1]];
            [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else if([me.Color isEqualToString:@"Orange"]){
            image =[mysql createImageWithColor:[UIColor orangeColor]] ;
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else if([me.Color isEqualToString:@"Brown"]){
            image =[mysql createImageWithColor:[UIColor brownColor]] ;
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else if([me.Color isEqualToString:@"Gray"]){
            image =[mysql createImageWithColor:[UIColor grayColor]] ;
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            image =[mysql createImageWithColor:[UIColor whiteColor]] ;
            [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        
//        CALayer *imageLayer = [CALayer layer];
//        imageLayer.frame = CGRectMake(0, 0, loginButton.frame.size.width, loginButton.frame.size.height);
//        imageLayer.contents = (id) image.CGImage;
//        
//        imageLayer.masksToBounds = YES;
//        imageLayer.cornerRadius = 10;
//        
//        UIGraphicsBeginImageContext(loginButton.frame.size);
//        [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
//        UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
        
        [loginButton setBackgroundImage:image forState:UIControlStateNormal];
        
        
        
        //        loginButton.layer.cornerRadius = 5.0;
        [loginButton setTitle:me.Name forState:UIControlStateNormal];
        loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        loginButton.tag=[me.Idnumber intValue];
        loginButton.contentEdgeInsets = UIEdgeInsetsMake(0, 1, 0, 0);
        //        [loginButton addTarget:self action:@selector(openevent:) forControlEvents:UIControlEventTouchDown];
        
        [ueeee addSubview:loginButton];
        
        y=y+32;
    }
    
}




#pragma mark - Recycling Behavior

-(void)prepareForReuse
{
    //  Alpha, by default, is 1.0
    [[self label]setAlpha:1.0];
    
    [self setState:CKCalendarMonthCellStateNormal];
    
    [self applyColors];
}

#pragma mark - Label

- (void)configureLabel
{
    UILabel *label = [self label];
    
    [label setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [label setTextAlignment:NSTextAlignmentRight];
    
    [label setBackgroundColor:[UIColor clearColor]];
    //    NSLog(@"%f", [self frame].size.width);
    [label setFrame:CGRectMake(1, 0, 144, 20)];
}

#pragma mark - Dot

//- (void)configureDot
//{
//    UIView *dot = [self dot];
//    
//    CGFloat dotRadius = 4;
//    CGFloat selfHeight = [self frame].size.height;
//    
//    CGFloat selfWidth = [self frame].size.width;
//    
//    [[dot layer] setCornerRadius:dotRadius/2];
//    
//    CGRect dotFrame = CGRectMake(selfWidth/2 - dotRadius/2, (selfHeight - (selfHeight/5)) - dotRadius/2, dotRadius, dotRadius);
//    [[self dot] setFrame:dotFrame];
//    
//}



#pragma mark - UI Coloring

- (void)applyColors
{
    [self applyColorsForState:[self state]];
    [self showBorder];
}

//  TODO: Make the cell states bitwise, so we can use masks and clean this up a bit
- (void)applyColorsForState:(CKCalendarMonthCellState)state
{
    //  Default colors and shadows
    [[self label] setTextColor:[self textColor]];
    [[self label] setShadowColor:[self textShadowColor]];
    [[self label] setShadowOffset:CGSizeMake(0, 0.5)];
    
    [self setBorderColor:[self cellBorderColor]];
    [self setBorderWidth:0.5];
    [self setBackgroundColor:[self normalBackgroundColor]];
    
    //  Today cell
    //    if(state == CKCalendarMonthCellStateTodaySelected)
    //    {
    //        [self setBackgroundColor:[self todaySelectedBackgroundColor]];
    //        [[self label] setShadowColor:[self todayTextShadowColor]];
    //        [[self label] setTextColor:[self todayTextColor]];
    //        [self setBorderColor:[self backgroundColor]];
    //
    //    }
    
    //  Today cell, selected
    //    else if(state == CKCalendarMonthCellStateTodayDeselected)
    //    {
    //        [self setBackgroundColor:[self todayBackgroundColor]];
    //        [[self label] setShadowColor:[self todayTextShadowColor]];
    //        [[self label] setTextColor:[self todayTextColor]];
    //        [self setBorderColor:[self backgroundColor]];
    //        [self showBorder];
    //    }
    
    //  Selected cells in the active month have a special background color
    //    else if(state == CKCalendarMonthCellStateSelected)
    //    {
    //        [self setBackgroundColor:[self selectedBackgroundColor]];
    //        [self setBorderColor:[self selectedCellBorderColor]];
    //        [[self label] setTextColor:[self textSelectedColor]];
    //        [[self label] setShadowColor:[self textSelectedShadowColor]];
    //        [[self label] setShadowOffset:CGSizeMake(0, -0.5)];
    //    }
    
    if (state == CKCalendarMonthCellStateInactive) {
        [[self label] setAlpha:0.5];    //  Label alpha needs to be lowered
        [[self label] setShadowOffset:CGSizeZero];
    }
    else if (state == CKCalendarMonthCellStateInactiveSelected)
    {
        [[self label] setAlpha:0.5];    //  Label alpha needs to be lowered
        [[self label] setShadowOffset:CGSizeZero];
        [self setBackgroundColor:[self inactiveSelectedBackgroundColor]];
    }
    else if(state == CKCalendarMonthCellStateOutOfRange)
    {
        [[self label] setAlpha:0.01];    //  Label alpha needs to be lowered
        [[self label] setShadowOffset:CGSizeZero];
    }
    
    //  Make the dot follow the label's style
//    [[self dot] setBackgroundColor:[[self label] textColor]];
//    [[self dot] setAlpha:[[self label] alpha]];
}

#pragma mark - Selection State

- (void)setSelected
{
    
    //    CKCalendarMonthCellState state = [self state];
    //
    //    if (state == CKCalendarMonthCellStateInactive) {
    //        [self setState:CKCalendarMonthCellStateInactiveSelected];
    //    }
    //    else if(state == CKCalendarMonthCellStateNormal)
    //    {
    //        [self setState:CKCalendarMonthCellStateSelected];
    //    }
    //    else if(state == CKCalendarMonthCellStateTodayDeselected)
    //    {
    //        [self setState:CKCalendarMonthCellStateTodaySelected];
    //    }
}

- (void)setDeselected
{
    //    CKCalendarMonthCellState state = [self state];
    //
    //    if (state == CKCalendarMonthCellStateInactiveSelected) {
    //        [self setState:CKCalendarMonthCellStateInactive];
    //    }
    //    else if(state == CKCalendarMonthCellStateSelected)
    //    {
    //        [self setState:CKCalendarMonthCellStateNormal];
    //    }
    //    else if(state == CKCalendarMonthCellStateTodaySelected)
    //    {
    //        [self setState:CKCalendarMonthCellStateTodayDeselected];
    //    }
}

- (void)setOutOfRange
{
    [self setState:CKCalendarMonthCellStateOutOfRange];
}

@end
