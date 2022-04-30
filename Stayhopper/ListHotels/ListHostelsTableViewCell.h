//
//  ListHostelsTableViewCell.h
//  Stayhopper
//
//  Created by iROID Technologies on 08/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListHostelsTableViewCell : UITableViewCell
{
    
}


@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblSavings;
@property (weak, nonatomic) IBOutlet UILabel *lblAED;
-(IBAction)favoriteFunction:(UIButton*)sender;
@property (strong, nonatomic)NSString *propertyID;
@property (strong, nonatomic) IBOutlet UIImageView* whiteImageView;
@property (strong, nonatomic) IBOutlet UIImageView* featuredImageView;
@property (strong, nonatomic) IBOutlet UIButton* favoriteButton;
@property (strong, nonatomic) IBOutlet UIImageView* propertyImageView;
@property (strong, nonatomic) IBOutlet UIImageView* distanceIMG;

@property (strong, nonatomic) IBOutlet UILabel* distanceLBL;
@property (strong, nonatomic) IBOutlet UILabel* discountPriceLBL;
@property (strong, nonatomic) IBOutlet UILabel* priceLBL;
@property (strong, nonatomic) IBOutlet UILabel* hourLBL;
@property (strong, nonatomic) IBOutlet UILabel* propertyNameLBL;
@property (strong, nonatomic) IBOutlet UILabel* propertyLocationLBL;
@property (strong, nonatomic) IBOutlet UILabel* userReviewLBL;
@property (weak, nonatomic) IBOutlet UIButton *btnDetails;
@property (strong, nonatomic) IBOutlet UILabel* userReviewLBLValue;

@property (strong, nonatomic) IBOutlet UILabel* userRatingValueLBL;
@property (strong, nonatomic) IBOutlet UIImageView* propertyRatingImageview;
@property (strong, nonatomic) IBOutlet UIImageView* timeBgImageview;
@property (weak, nonatomic) IBOutlet UIButton *btnSavingsInfo;
@property (strong, nonatomic) IBOutlet UIImageView* reviewBgImageview;
@property (weak, nonatomic) IBOutlet UILabel *lblGuestCOunt;
@property (strong, nonatomic)NSString *fromValue;
-(void)configureProprtiesCellWithObject:(NSDictionary*)item;
-(void)configurePastBookingCellWithObject:(NSDictionary*)item;
-(void)configureActiveBookingCellWithObject:(NSDictionary*)item;

@end
