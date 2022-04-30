//
//  FAQTableViewCell.h
//  Stayhopper
//
//  Created by Bryno Baby on 29/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAQTableViewCell : UITableViewCell
@property(nonatomic,retain)IBOutlet UILabel* titleLBL;
@property(nonatomic,retain)IBOutlet UIButton* plusButton;
@property(nonatomic,retain)IBOutlet UITextView* desceriptionTV;
@property(nonatomic,retain)IBOutlet UIView* bgView;
@end
