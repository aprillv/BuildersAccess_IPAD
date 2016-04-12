//
//  BAUITableView.m
//  BuildersAccess
//
//  Created by April on 4/12/16.
//  Copyright © 2016 eloveit. All rights reserved.
//

#import "BAUITableView.h"

@implementation BAUITableView
- (void) layoutSubviews {
    [super layoutSubviews];
    self.separatorInset = UIEdgeInsetsMake(0, -100, 0, 100);
    
}
@end
