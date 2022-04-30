//
//  ProfileViewController.h
//  Stayhopper
//
//  Created by Vh iROID Technologies on 24/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestUtil.h"

@interface ProfileViewController : UIViewController<WebData>
{
    IBOutlet UIImageView* porfilePic;
    IBOutlet UILabel* profileName;
    IBOutlet UILabel* profileEmail;
    IBOutlet UITableView* profileTableView;
    NSArray* listArray;
    NSArray* imageArray;
    IBOutlet UIButton* editButton;
    IBOutlet UIImageView* editPic;

}
@end
