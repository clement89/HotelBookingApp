//
//  ReviewTableViewCell.m
//  Stayhopper
//
//  Created by Bryno Baby on 23/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "ReviewTableViewCell.h"

@implementation ReviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.proPic.clipsToBounds=YES;
    self.proPic.layer.cornerRadius=self.proPic.frame.size.height/2;
    // Configure the view for the selected state
}
-(IBAction)reportBUtton:(id)sender
{
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:self.commentID forKey:@"commentID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reportAction" object:nil];
}
   //self.commentID
}
@end
