//
//  ProfileListTableViewCell.m
//  Stayhopper
//
//  Created by Bryno Baby on 04/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "ProfileListTableViewCell.h"

@implementation ProfileListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.bgView.layer.cornerRadius=2;
    
    // Configure the view for the selected state
}

@end
