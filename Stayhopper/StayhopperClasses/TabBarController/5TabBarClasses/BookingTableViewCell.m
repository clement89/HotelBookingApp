//
//  BookingTableViewCell.m
//  Stayhopper
//
//  Created by iROID Technologies on 21/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "BookingTableViewCell.h"

@implementation BookingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.propertyImageVieww.layer.cornerRadius=2;
    self.contentVieww.layer.cornerRadius=7.0;
    // Configure the view for the selected state
}

@end
