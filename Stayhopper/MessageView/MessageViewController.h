//
//  MessageViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 26/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController
@property(nonatomic,retain)IBOutlet UIImageView* smileyImageView;
@property(nonatomic,retain)IBOutlet UIView* bgView;
@property(nonatomic,retain)IBOutlet UIView* bgView1;

@property(nonatomic,retain)IBOutlet UILabel* messageLBL;

@property(nonatomic,retain)NSString *imageName;
@property(nonatomic,retain)NSString *messageString;
@property(nonatomic,retain)NSString *typeString;


@end
