//
//  CalendarDiscoverCollectionViewCell.m
//  Stayhopper
//
//  Created by Vh iROID Technologies on 24/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "CalendarDiscoverCollectionViewCell.h"

@implementation CalendarDiscoverCollectionViewCell

-(void)awakeFromNib{
    _cirlceRed.layer.cornerRadius=_selectedDay.frame.size.width/2;
    _cirlceRed.clipsToBounds=YES;
    _cirlceRed.layer.borderWidth=3;
    _cirlceRed.layer.borderColor=[UIColor redColor].CGColor;
}

@end
