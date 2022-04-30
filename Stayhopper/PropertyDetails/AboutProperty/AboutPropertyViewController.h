//
//  AboutPropertyViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 22/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ServicesCollectionViewCell.h"
@interface AboutPropertyViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet NSLayoutConstraint *descriptionTVWidth;
    IBOutlet UILabel*locationLBL;
    IBOutlet UICollectionView* facilitiesCollectionView;
    __weak IBOutlet UILabel *descriptionTV;
    ServicesCollectionViewCell *homeCell;
    __weak IBOutlet UILabel *pliciesTV;
    IBOutlet UIScrollView* bgScrollView;
    IBOutlet UIButton* descriptionEnlargeButton;
    IBOutlet UIButton* facilitiesEnlargeButton;
    IBOutlet UIButton* policiesEnlargeButton;
    BOOL status;
}
@property (strong, nonatomic)IBOutlet NSLayoutConstraint *descriptionWidth;

@property(strong,nonatomic)NSDictionary* selectedProperty;
@property(strong,nonatomic)NSDictionary* loadedsProperty;

@property(strong,nonatomic)NSMutableArray* availableServices;

@property (strong, nonatomic) IBOutlet UIView *annotaionVieww;
@property (strong, nonatomic)NSString* fromString;
-(IBAction)policiesEnlarge:(id)sender;
-(IBAction)descriptionEnlarge:(id)sender;
-(IBAction)facilitiesEnlarge:(id)sender;
@end
