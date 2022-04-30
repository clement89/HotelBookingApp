//
//  PaddingLabel.m
//  Stayhopper
//
//  Created by antony on 12/08/2020.
//  Copyright © 2020 iROID Technologies. All rights reserved.
//

#import "PaddingLabel.h"

@implementation PaddingLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {7.5, 0, 0, 0};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
@end
