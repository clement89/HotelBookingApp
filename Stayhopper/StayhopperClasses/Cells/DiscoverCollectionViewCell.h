//
//  DiscoverCollectionViewCell.h
//  Stayhopper
//
//  Created by Vh iROID Technologies on 24/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverCollectionViewCell : UICollectionViewCell
- (IBAction)slotAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *slotLbl;
@property (strong, nonatomic) IBOutlet UIView *slotView;

@end
