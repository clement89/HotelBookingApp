//
//  RoomsTableViewCell.h
//  Stayhopper
//
//  Created by Bryno Baby on 22/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServicesCollectionViewCell.h"
@interface RoomsTableViewCell : UITableViewCell
{
    ServicesCollectionViewCell *homeCell;

}
@property (weak, nonatomic) IBOutlet UILabel *lblRoomCount;
@property (weak, nonatomic) IBOutlet UIButton *btnRoomCount;
@property(nonatomic,retain)IBOutlet UILabel *roomNameLBL;
@property(nonatomic,retain)IBOutlet UILabel *maxGueteLBL;
@property(nonatomic,retain)IBOutlet UILabel *bedLBL;
@property(nonatomic,retain)IBOutlet UILabel *roomSizeLBL;
@property(nonatomic,retain)IBOutlet UILabel *sloatLBL;
@property(nonatomic,retain)IBOutlet UILabel *priceLBL;
@property(nonatomic,retain)IBOutlet UICollectionView* facilitiesCollectionView;
@property(nonatomic,retain)IBOutlet UIButton* selectButton;
@property(nonatomic,retain)IBOutlet UITextField* countTF;
@property(nonatomic,retain)IBOutlet UIButton* plusButton;
@property(nonatomic,retain)IBOutlet UIButton* minusButton;
@property(nonatomic,retain)IBOutlet UIView* bgView;
@property(nonatomic,retain)NSString* roonID;
@property(nonatomic,retain)NSString* availableRooms;
@property(nonatomic,retain)NSArray* serviceArray;
@property(nonatomic,retain)IBOutlet UIImageView* bedTypeImageView;
@property (strong, nonatomic) IBOutlet UIImageView* timeBgImageview;
@property (strong, nonatomic) IBOutlet UIImageView* imgRoomImage;



-(IBAction)plusAction:(id)sender;
-(IBAction)minusAction:(id)sender;
-(IBAction)selectAction:(id)sender;

@end
