//
//  ReviewTableViewCell.h
//  Stayhopper
//
//  Created by Bryno Baby on 23/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewTableViewCell : UITableViewCell
{
    
}
@property(nonatomic,retain)NSString* commentID;
@property(nonatomic,retain)IBOutlet UITextView* commentsTV;
@property(nonatomic,retain)IBOutlet UILabel* nameLBL;
@property(nonatomic,retain)IBOutlet UILabel* ratingLBL;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property(nonatomic,retain)IBOutlet UIImageView* proPic;

-(IBAction)reportBUtton:(id)sender;

@end
