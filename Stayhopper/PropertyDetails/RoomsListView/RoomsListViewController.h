//
//  RoomsListViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 22/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomsTableViewCell.h"
@interface RoomsListViewController : UIViewController
{
    IBOutlet UITableView *roomsTableView;
    IBOutlet UILabel *roomsCount;
    BOOL status;
    
}
@property(nonatomic,retain)NSArray* dataArray;
@property(nonatomic,retain)NSMutableDictionary* selectedRooms;
@property (strong, nonatomic) NSDictionary* selectedProperty;

@end
