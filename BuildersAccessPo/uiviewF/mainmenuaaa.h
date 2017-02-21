//
//  mainmenuaaa.h
//  BuildersAccess
//
//  Created by amy zhao on 13-6-4.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "fathercontroller.h"

@interface mainmenuaaa : fathercontroller<UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>{
    
    UITabBar *ntabbar;
    UITabBarItem *pintab;
    UITableView *ciatbview1;
}
@property (nonatomic, retain) NSMutableArray  *menulist;
@property (nonatomic, retain) NSMutableArray  *detailstrarr;
@property (nonatomic, retain)  UIView *uw;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property int tbindex;
@property(retain, nonatomic) NSString * xget;

- (void)orientationChanged;
-(void)gootoonextPage:(mainmenuaaa *)ma;
-(IBAction)gobig:(id)sender;
-(IBAction)gosmall:(id)sender;
-(NSString *)getTitle;
-(BOOL)getIsTwoPart;
-(void)setIsTwoPart:(BOOL)bl;
@end
