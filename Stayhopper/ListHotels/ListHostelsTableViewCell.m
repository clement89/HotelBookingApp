//
//  ListHostelsTableViewCell.m
//  Stayhopper
//
//  Created by iROID Technologies on 08/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "ListHostelsTableViewCell.h"
#import "RequestUtil.h"
#import "UIImageView+WebCache.h"
#import "Commons.h"
@implementation ListHostelsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (_viewContainer) {
       //  self.viewContainer.layer.masksToBounds = false;
         self.viewContainer.layer.shadowRadius = 4;
         self.viewContainer.layer.shadowOpacity = 0.5;
         self.viewContainer.layer.shadowColor = [UIColor grayColor].CGColor;
         self.viewContainer.layer.shadowOffset = CGSizeMake(0, 3);
         self.viewContainer.layer.cornerRadius  = 10;

    }
    _hourLBL.layer.cornerRadius = 5.;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.whiteImageView.layer.cornerRadius=4;
    self.timeBgImageview.clipsToBounds=YES;
    
    self.timeBgImageview.layer.cornerRadius=2;
    self.reviewBgImageview.clipsToBounds=YES;
    
    self.reviewBgImageview.layer.cornerRadius=2;
    [self.favoriteButton setImage:[UIImage imageNamed:@"FavoriteNormal"] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"FavoriteActive"] forState:UIControlStateSelected];

    // Configure the view for the selected state
}
-(IBAction)favoriteFunction:(UIButton*)sender
{
    return;
if([self.fromValue isEqualToString:@"YES"])
{
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"loadStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"loadStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    {
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
-(void)configureActiveBookingCellWithObject:(NSDictionary*)item;
{
    {
         ListHostelsTableViewCell *cell=(id)self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

       
        cell.propertyImageView.image = [UIImage imageNamed:@"QOMPlaceholder1"];
        if([item[@"property"] objectForKey:@"images"])
        {
            
            if([[item[@"property"] objectForKey:@"images"] count]>0)
            {
        NSString*imgName=[[item[@"property"] objectForKey:@"images"]objectAtIndex:0];
        NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
        [cell.propertyImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder1"]];
            }
        }
        // cell.userReviewLBL.text=@"No Review";

        cell.propertyNameLBL.text = @"";
        cell.propertyLocationLBL.text = @"";
         if([item objectForKey:@"property"])
        {
            cell.propertyNameLBL.text = [NSString stringWithFormat:@"%@",[item objectForKey:@"property"][@"name"]];
           
            
            if([item objectForKey:@"property"][@"location"][@"address"])//CJC 21
           {
               cell.propertyLocationLBL.text=[NSString stringWithFormat:@"%@",[item objectForKey:@"property"][@"location"][@"address"]];
           }
            
            //coordinates
            //[item objectForKey:@"property"][@"location"][@"coordinates"]
        }
        /*"checkin_date": "2020-11-18",
         "checkin_time": "23:55",
         "checkout_date": "2020-11-20",
         "checkout_time": "10:00",
         "stayDuration": "1 Days, 10 Hours and 5 Minutes",
         "date_checkin": "2020-11-19T04:55:00.000Z",
         "date_checkout": "2020-11-20T15:00:00.000Z",
         */
        NSDate *chekindt = [Commons getDateFromString:[NSString stringWithFormat:@"%@ %@",item[@"checkin_date"],item[@"checkin_time"]] Format:@"yyyy-MM-dd HH:mm"];
        NSDate *chekoutdt = [Commons getDateFromString:[NSString stringWithFormat:@"%@ %@",item[@"checkout_date"],item[@"checkout_time"]] Format:@"yyyy-MM-dd HH:mm"];
        //datestr=[NSString stringWithFormat:@"%@",[Commons stringFromDate:chekindt Format:@"MMM dd, yyyy hh:mm"]];

        cell.userReviewLBL.text=[NSString stringWithFormat:@"%@ - %@,%@ %@",[Commons stringFromDate:chekindt Format:@"MMM dd hh:mm"],[Commons stringFromDate:chekoutdt Format:@"MMM dd hh:mm"],item[@"total_amt"],item[@"currencyCode"]];

        NSNumber * sum = [[[item objectForKey:@"room"] valueForKeyPath:@"number"] valueForKeyPath:@"@sum.self"];

        cell.priceLBL.text = item[@"book_id"];
        
        cell.lblGuestCOunt.text = [NSString stringWithFormat:@"%@ Rooms %d Guests",sum,([item[@"no_of_adults"] intValue])];
        
        
     }
}
-(void)configurePastBookingCellWithObject:(NSDictionary*)item;
{
    //[item objectForKey:@"latlng"]
    {
         ListHostelsTableViewCell *cell=(id)self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

       
        cell.propertyImageView.image = [UIImage imageNamed:@"QOMPlaceholder1"];
        if([item[@"propertyInfo"] objectForKey:@"images"])
        {
            
            if([[item[@"propertyInfo"] objectForKey:@"images"] count]>0)
            {
        NSString*imgName=[[item[@"propertyInfo"] objectForKey:@"images"]objectAtIndex:0];
        NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
        [cell.propertyImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder1"]];
            }
        }
        // cell.userReviewLBL.text=@"No Review";

        cell.propertyNameLBL.text = @"";
        cell.propertyLocationLBL.text = @"";
        
        if([item objectForKey:@"propertyInfo"])
        {
            cell.propertyNameLBL.text = [NSString stringWithFormat:@"%@",[item objectForKey:@"propertyInfo"][@"name"]];
            if([item objectForKey:@"propertyInfo"][@"location"] != NULL){//CJC 21
                cell.propertyLocationLBL.text=[NSString stringWithFormat:@"%@",[item objectForKey:@"propertyInfo"][@"location"]];
                
                
                NSLog(@"ok 1-- %@",[NSString stringWithFormat:@"%@",[item objectForKey:@"propertyInfo"][@"location"]]);
            }
            

        }
        NSDate *chekindt = [Commons getDateFromString:[NSString stringWithFormat:@"%@ %@",item[@"checkin_date"],item[@"checkin_time"]] Format:@"yyyy-MM-dd HH:mm"];
        NSDate *chekoutdt = [Commons getDateFromString:[NSString stringWithFormat:@"%@ %@",item[@"checkout_date"],item[@"checkout_time"]] Format:@"yyyy-MM-dd HH:mm"];
        
        cell.userReviewLBL.text=[NSString stringWithFormat:@"%@ - %@,%@ %@",[Commons stringFromDate:chekindt Format:@"MMM dd hh:mm"],[Commons stringFromDate:chekoutdt Format:@"MMM dd hh:mm"],item[@"total_amt"],item[@"currencyCode"]];

        NSNumber * sum = [[[item objectForKey:@"roomsInfo"] valueForKeyPath:@"number"] valueForKeyPath:@"@sum.self"];

        cell.priceLBL.text = item[@"book_id"];
        
        cell.lblGuestCOunt.text = [NSString stringWithFormat:@"%@ Rooms %d Guests",sum,([item[@"no_of_adults"] intValue])];
        
        
     }
}
-(void)configureProprtiesCellWithObject:(NSDictionary*)item
{
    {
         ListHostelsTableViewCell *cell=(id)self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
       // tableLoaded=YES;

        NSString* price=@"0";
        NSString* discountPrice=@"0";
        cell.propertyLocationLBL.text=@"";
        cell.userRatingValueLBL.text=@"0";
        cell.userReviewLBLValue.text=@"0";
        cell.userReviewLBL.text=@"0";

        cell.distanceLBL.hidden=YES;
        cell.distanceIMG.hidden=YES;
      if([item objectForKey:@"distance"])
        {
            
            
         //   float distance=[[item objectForKey:@"distance"] floatValue];
    //        cell.distanceLBL.hidden=NO;
    //        cell.distanceIMG.hidden=TRUE;
            cell.distanceLBL.text=@"";
           
            
            
        }
       
        cell.propertyImageView.image = [UIImage imageNamed:@"QOMPlaceholder1"];
        if([item objectForKey:@"images"])
        {
            
            if([[item objectForKey:@"images"] count]>0)
            {
        NSString*imgName=[[item objectForKey:@"images"]objectAtIndex:0];
        NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
        [cell.propertyImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder1"]];
            }
        }
        cell.propertyID=[item objectForKey:@"_id"];
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
        {
            cell.favoriteButton.hidden=NO;

        }else
        {
            cell.favoriteButton.hidden=YES;

        }
        
      
    //    if([[self.selectedProperty objectForKey:@"rating"] isKindOfClass:[NSDictionary class]])
    //    {
    //        ratingImageView.image=[UIImage imageNamed:[utilObj checkRating:[[self.selectedProperty objectForKey:@"rating"] objectForKey:@"value"] ]];
    //    }
    //    else
    //        ratingImageView.image=[UIImage imageNamed:[utilObj checkRating:[self.selectedProperty objectForKey:@"rating"] ]];
        //    else
        //        cell.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[item objectForKey:@"rating"] ]];
         //   cell.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[item objectForKey:@"rating"] ]];
        //    if([utilObj checkRating:[[popularByArray objectAtIndex:indexPath.row] objectForKey:@"rating"] ])
        //    {
        //        popularCell.favButtonSlotLbl.selected=YES;
        //    }
        //    else
        //    {
        //        popularCell.favButtonSlotLbl.selected=NO;
        //
          //  }
        
        if([[item objectForKey:@"rating"] isKindOfClass:[NSDictionary class]])
        {
            cell.userRatingValueLBL.text=[NSString stringWithFormat:@"%@",[[item objectForKey:@"rating"] objectForKey:@"value"] ];

    //        cell.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[[item objectForKey:@"rating"] objectForKey:@"value"] ]];
        }

        
        if([item objectForKey:@"userRating"])
        {
            cell.userReviewLBLValue.text=[NSString stringWithFormat:@"%0.2f",[[item  valueForKey:@"userRating"] floatValue] ];

    //        cell.userRatingValueLBL.text=[NSString stringWithFormat:@"%@",[item  valueForKey:@"userRating"] ];
        }
        
        if([cell.userReviewLBLValue.text floatValue]<=0)
        {
            cell.userReviewLBLValue.text = @"";
            cell.userReviewLBLValue.hidden = YES;
            cell.userReviewLBL.text=@"";//CJC 3
        }else if([cell.userReviewLBLValue.text floatValue]<=2.0)
        {
            cell.userReviewLBL.text=@"Poor";
        }
        else if([cell.userReviewLBLValue.text floatValue]<=4.0)
        {
            cell.userReviewLBL.text=@"Average";
        }
        else if([cell.userReviewLBLValue.text floatValue]<=6.0)
        {
            cell.userReviewLBL.text=@"Good";
        }else if([cell.userReviewLBLValue.text floatValue]<8.0)
        {
            cell.userReviewLBL.text=@"Very Good";
        }
        else
            cell.userReviewLBL.text=@"Excellent";

        cell.userRatingValueLBL.superview.layer.cornerRadius= 2.5;
       // cell.userReviewLBLValue.layer.cornerRadius= cell.userRatingValueLBL.superview.layer.cornerRadius;
        if([item objectForKey:@"location"]&&[item objectForKey:@"location"][@"address"])
        {
            cell.propertyLocationLBL.text = [item objectForKey:@"location"][@"address"];

        }
        else if([item objectForKey:@"contactinfo"])
        {

            if([[item objectForKey:@"contactinfo"] objectForKey:@"city"])
            {
                if([[item objectForKey:@"contactinfo"] objectForKey:@"city"][@"name"])

                    cell.propertyLocationLBL.text=[[item objectForKey:@"contactinfo"] valueForKey:@"city"][@"name"];
            }
            else if([[item objectForKey:@"contactinfo"] objectForKey:@"country"])
            {
                if([[item objectForKey:@"contactinfo"] objectForKey:@"country"][@"name"])

                    cell.propertyLocationLBL.text=[[item objectForKey:@"contactinfo"] valueForKey:@"country"][@"name"];
            }
            
        }
        else
            cell.propertyLocationLBL.text=@"";
        if([item objectForKey:@"name"])
        cell.propertyNameLBL.text=[item valueForKey:@"name"];
        else
            cell.propertyNameLBL.text=@"";

        price=@"0";

     //_hourLBL.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"];
     //   cell.hourLBL.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"];
        cell.hourLBL.text=@"";
                   if ([[item objectForKey:@"stayDuration"] isKindOfClass:[NSDictionary class]])
                   {
                       cell.hourLBL.text = [NSString stringWithFormat:@" %@ ",[item objectForKey:@"stayDuration"][@"label"]];
                       
                   }
        else if ([[item objectForKey:@"stayDuration"] isKindOfClass:[NSString class]])
        {
            cell.hourLBL.text = [NSString stringWithFormat:@" %@ ",[item objectForKey:@"stayDuration"]];

        }

    //    if([self.selectionString isEqualToString:@"Near"])
    //    {
    //        //distanceLBL
    //       cell.hourLBL.text= [NSString stringWithFormat:@"%@h",@"3" ];
    //    }
        BOOL statusValue=NO;
    // if ([item objectForKey:@"minprice"])
    // {
    //     price=[item objectForKey:@"minprice"];
    // }
        
        price = [NSString stringWithFormat:@"%@",[item objectForKey:@"priceSummary"][@"base"][@"amount"]];
        cell.priceLBL.text = price;
        NSString *savings = [NSString stringWithFormat:@"%@",[item objectForKey:@"priceSummary"][@"base"][@"savings"]];
        if (!savings || savings.length==0) {
            savings = @"0";
        }
        int tot = [savings intValue]+[price intValue];
        NSString *total = [NSString stringWithFormat:@"%d",tot];
        if ([savings intValue]==0) {
            cell.lblSavings.superview.hidden = TRUE;

        }
        else {
        cell.lblSavings.superview.hidden = FALSE;
        }
        cell.lblSavings.text = [NSString stringWithFormat:@"Saving AED %@",savings];
        cell.btnSavingsInfo.restorationIdentifier = savings;
        [cell.btnSavingsInfo addTarget:self action:@selector(savingsBtnClikd:) forControlEvents:UIControlEventTouchUpInside];
        
        if (cell.lblSavings.superview.hidden) {
            cell.lblAED.text = @"AED";

        }
        else{
            NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"AED %@ ",total]];
            
                                            //  [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0] range:NSMakeRange(0, 3)];
            

           
            
            @try {
                [str1 addAttribute:NSFontAttributeName value:cell.lblAED.font range:NSMakeRange(0, str1.length)];
                    [str1 addAttribute:NSForegroundColorAttributeName value:cell.userReviewLBL.textColor range:NSMakeRange(0, str1.length)];
                    
                [str1 addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:2] range:NSMakeRange(str1.length-total.length, total.length)];

             }
             @catch (NSException * e) {
                NSLog(@"Exception: %@", e);
             }
             @finally {
                NSLog(@"finally");
             }

            cell.lblAED.attributedText = str1;
        }
        cell.lblAED.textColor =  cell.userReviewLBL.textColor;
        cell.lblAED.hidden = FALSE;

        cell.featuredImageView.hidden=YES;
//        cell.userReviewLBL.font =[UIFont fontWithName:Fontme size:10];
//        cell.userRatingValueLBL.font = [UIFont fontWithName:FontRegular size:10];
    //    cell.hourLBL.hidden = TRUE;
    //     cell.hourLBL.text=[NSString stringWithFormat:@"%@ H",[[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]] componentsSeparatedByString:@"h"] firstObject]] ;
        if (cell.userReviewLBLValue.text.length>0) {
            NSString *hrlbl = cell.userReviewLBLValue.text;
            
            hrlbl = [NSString stringWithFormat:@" %@.",hrlbl];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:hrlbl attributes:@{NSForegroundColorAttributeName:cell.userReviewLBLValue.textColor,NSFontAttributeName:cell.userReviewLBL.font}];
 
            [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(0, 1)];
            [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(hrlbl.length-1, 1)];
            cell.userReviewLBLValue.attributedText = attr;
           cell.userReviewLBLValue.backgroundColor = [UIColor colorWithRed:0.757 green:0.784 blue:0.859 alpha:0.3];
            cell.userReviewLBLValue.clipsToBounds = TRUE;
            cell.userReviewLBLValue.layer.cornerRadius = 2.;
            
        }
        if (cell.hourLBL.text.length>0) {
            NSString *hrlbl = cell.hourLBL.text;
            
            hrlbl = [NSString stringWithFormat:@".  %@  .",hrlbl];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:hrlbl attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FontMedium size:12]}];
 
            [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(0, 1)];
            [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(hrlbl.length-1, 1)];
            cell.hourLBL.attributedText = attr;
            cell.hourLBL.backgroundColor = UIColorFromRGB(0xFF4848);
            
        }
     }
   
}
-(void)savingsBtnClikd:(UIButton*)btn
{
    [Commons showAlertWithMessage:[NSString stringWithFormat:@"You are saving AED %@ from the market price",btn.restorationIdentifier]];
}
@end
