//
//  PopularCollectionViewCell.m
//  Stayhopper
//
//  Created by Vh iROID Technologies on 24/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "PopularCollectionViewCell.h"
#import "RequestUtil.h"
@implementation PopularCollectionViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
 
    self.layer.masksToBounds = NO;

    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 2.0;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
  
    self.clipsToBounds=NO;

    self.backgroundColor = [UIColor clearColor];
    self.viewBG.backgroundColor = [UIColor whiteColor];
  
    self.viewBG.clipsToBounds = TRUE;
    self.viewBG.layer.cornerRadius=10;

    
//    self.layer.shadowColor = [UIColor groupTableViewBackgroundColor].CGColor;
//    self.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
//    self.layer.shadowRadius = 1.0f;
//    self.layer.shadowOpacity = 0.4f;
     self.timeSlotBGLbl.layer.cornerRadius=4;
    self.timeSlotBGLbl.clipsToBounds = TRUE;
     //_slotView.layer.borderColor=[UIColor whiteColor].CGColor;
}

-(IBAction)favAction:(UIButton*)sender
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"loadStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        RequestUtil* utilObj=[[RequestUtil alloc]init];
        [utilObj addOrRemoveFavorites:_propertyID userID:@""];
        
        if(sender.isSelected)
        {
            sender.selected=NO;
        }
        else
        {
            sender.selected=YES;
            
        }
    }
    
}
@end
