//
//  RangePickerCell.m
//  FSCalendar
//
//  Created by dingwenchao on 02/11/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import "RangePickerCell.h"
#import "FSCalendarExtensions.h"
#import "URLConstants.h"
@implementation RangePickerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CALayer *selectionLayer = [[CALayer alloc] init];
        selectionLayer.backgroundColor = kColorRedThemeColor.CGColor;
        selectionLayer.actions = @{@"hidden":[NSNull null]}; // Remove hiding animation
        self.selectionLayer = selectionLayer;
        self.selectionLayer.cornerRadius = self.selectionLayer.frame.size.width/2.;
        CALayer *middleLayer = [[CALayer alloc] init];
        middleLayer.backgroundColor = [kColorRedThemeColor colorWithAlphaComponent:0.3].CGColor;
        middleLayer.actions = @{@"hidden":[NSNull null]}; // Remove hiding animation
        [self.contentView.layer insertSublayer:middleLayer below:self.titleLabel.layer];
        self.middleLayer = middleLayer;
        [self.contentView.layer insertSublayer:selectionLayer below:self.titleLabel.layer];

        // Hide the default selection layer
        self.shapeLayer.hidden = YES;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.contentView.bounds;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
//    CGRect frame = self.contentView.bounds;
//    frame.origin.x = frame.size.width/2. - frame.size.height/2.;
//
//    frame.size.width = frame.size.height;
//
//    self.selectionLayer.frame = frame;
//    self.selectionLayer.masksToBounds = TRUE;
//     self.selectionLayer.cornerRadius = self.selectionLayer.frame.size.height/2.;
    
    
//    self.selectionLayer.frame = self.contentView.bounds;
//
//    self.middleLayer.frame = self.contentView.bounds;

     
}

@end
