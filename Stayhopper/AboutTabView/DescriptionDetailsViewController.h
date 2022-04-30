//
//  DescriptionDetailsViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 28/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescriptionDetailsViewController : UIViewController
{
    IBOutlet UITextView* descriptionTV;
}
@property(nonatomic,retain)NSDictionary* dataDIC;
@end
