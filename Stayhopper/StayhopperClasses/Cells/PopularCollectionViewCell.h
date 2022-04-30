//
//  PopularCollectionViewCell.h
//  Stayhopper
//
//  Created by Vh iROID Technologies on 24/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopularCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *timeSlotLbl;
@property (strong, nonatomic) IBOutlet UILabel *timeSlotBGLbl;
@property (strong, nonatomic) IBOutlet UIImageView *ratingImg;
@property (strong, nonatomic) IBOutlet UIView *viewBG;

@property (strong, nonatomic) IBOutlet UIButton *favButtonSlotLbl;

@property (strong, nonatomic) IBOutlet UILabel *priceLbl;
- (IBAction)favAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *addressLbl;
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *unitsLbl;
@property (strong, nonatomic)NSString *propertyID;

@end
