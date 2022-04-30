//
//  CitiesCollectionViewCell.h
//  Stayhopper
//
//  Created by Bryno Baby on 04/10/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CitiesCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *timeSlotLbl;
@property (strong, nonatomic) IBOutlet UIButton *favButtonSlotLbl;

@property (strong, nonatomic) IBOutlet UILabel *priceLbl;
- (IBAction)favAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *addressLbl;
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *unitsLbl;
@property (strong, nonatomic)NSString *propertyID;
@end
