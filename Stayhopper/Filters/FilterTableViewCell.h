//
//  FilterTableViewCell.h
//  Stayhopper
//
//  Created by iROID Technologies on 10/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *rateLbl;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIButton *radioBtn;

@end
