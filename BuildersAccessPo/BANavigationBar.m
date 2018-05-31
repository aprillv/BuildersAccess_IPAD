//
//  BANavigationBar.m
//  BuildersAccess_IPAD
//
//  Created by April Lv on 1/6/18.
//  Copyright © 2018 eloveit. All rights reserved.
//

#import "BANavigationBar.h"

@implementation BANavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *view in self.subviews) {
        if([NSStringFromClass([view class]) containsString:@"Background"]) {
            view.frame = self.bounds;
        }
        else if ([NSStringFromClass([view class]) containsString:@"ContentView"]) {
            CGRect frame = view.frame;
            frame.origin.y = 20;
            view.frame = frame;
        }
    }
}

@end
