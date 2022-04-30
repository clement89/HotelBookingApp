//
//  AboutTabedViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 28/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeCollectionViewCell.h"

@interface AboutTabedViewController : UIViewController
{
    IBOutlet UIScrollView* bgScrollView;
    IBOutlet UIScrollView*menuListingScrollview;
    IBOutlet UICollectionView* menuCollectionView;
    NSArray* menueArray;
    IBOutlet UIScrollView* menuDetailsScrolView;
    NSInteger clickedIndex;
    TypeCollectionViewCell*typeCell;
    IBOutlet UILabel* selectedPropLBL;
}
@property(nonatomic,retain)NSString* indexString;
@property(nonatomic,retain)NSDictionary* commonDIC;
@property(nonatomic,retain)NSDictionary* loadedDIC;
@property(nonatomic,retain)NSString* selectedPropName;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *slideImgLeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *slideImgWidth;


-(IBAction)backFunction:(id)sender;
@end
