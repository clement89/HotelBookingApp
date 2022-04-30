//
//  NearByPropertyTableViewCell.m
//  Stayhopper
//
//  Created by Bryno Baby on 23/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "NearByPropertyTableViewCell.h"

@implementation NearByPropertyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _bgView.layer.cornerRadius=4;
    // Configure the view for the selected state
}

@end
