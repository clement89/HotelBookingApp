//
//  RoomsListViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 22/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "RoomsListViewController.h"
#import "UIImageView+WebCache.h"
#import "URLConstants.h"
#import "MMPickerView.h"
#import "AppDelegate.h"
@interface RoomsListViewController ()
{
    RoomsTableViewCell* cell;
}
@end

@implementation RoomsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.view.backgroundColor = kColorProfilePages;
  //  self.view.backgroundColor = kColorCommonBG;
    _selectedRooms =[[NSMutableDictionary alloc] init];
    
    roomsCount.text=[NSString stringWithFormat:@"We've founded 0 rooms"];
    status=YES;
    
    NSInteger total=0;
//    for(NSDictionary* dic in self.dataArray)
//    {
//        total=[[dic valueForKey:@"free_rooms"] integerValue]+total;
//    }
    roomsCount.text=[NSString stringWithFormat:@"We've founded %ld rooms",(long)self.dataArray.count];
    roomsCount.backgroundColor = kColorHotelDetailsBG;
  //  self.view.backgroundColor = kColorCommonBG;
    roomsCount.superview.backgroundColor = kColorHotelDetailsBG;
    roomsTableView.backgroundColor = kColorHotelDetailsBG;
    self.view.backgroundColor = kColorHotelDetailsBG;

    // Do any additional setup after loading the view.
    
    if([self.dataArray count]> 0){//CJC 5
        
        [_selectedRooms setValue:@"1" forKey:[[self.dataArray objectAtIndex:0] valueForKey:@"_id"]];
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row%2==0)
//        cell.transform = CGAffineTransformMakeTranslation(0.f, 100);
//    else
//        cell.transform = CGAffineTransformMakeTranslation(0, 100);    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
//    cell.layer.shadowOffset = CGSizeMake(10, 10);
//    cell.alpha = 0;
//    
//    //2. Define the final state (After the animation) and commit the animation
//    [UIView beginAnimations:@"rotation" context:NULL];
//    [UIView setAnimationDuration:0.3];
//    cell.transform = CGAffineTransformMakeTranslation(0.f, 0);
//    cell.alpha = 1;
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    [UIView commitAnimations];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(RoomsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"RoomsTableViewCellNew"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(  [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"services"])
    cell.serviceArray=[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"services"];
    cell.roomNameLBL.text = @"";
    if([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"room_name"] isKindOfClass:[NSDictionary class]])
    {
        cell.roomNameLBL.text=[[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"room_name"] valueForKey:@"name"];
    }
    cell.roomSizeLBL.text=@"";
    if([[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"room_size"] )
    {
        cell.roomSizeLBL.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"room_size"];
    }
    if([[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"images"])
    {
        
        if([[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"images"] count]>0)
        {
    NSString*imgName=[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"images"]objectAtIndex:0];
    NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
    [cell.imgRoomImage sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"Room-Placeholder"]];
        }
    }
    
    //CJC final
    
    
//    roomsizeLBL.text=@"";
//    if([self.selectedRoomDic objectForKey:@"room_size"])
//    {
//        if(  [self.selectedRoomDic objectForKey:@"room_size"] )
//            roomsizeLBL.text=[self.selectedRoomDic valueForKey:@"room_size"];
//    }
    /*
     NSString *roomsString=@"ROOM";
     NSString *adultsString=@"ADULT";
     NSString *childString=@"CHILD";
     
     if(roomsCount>1)
     {
     roomsString=@"ROOMS";
     }
     if([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"] integerValue]>1)
     {
     adultsString=@"ADULTS";
     }
     if([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedChild"] integerValue]>1)
     {
     childString=@"CHILDREN'S";
     }
     */
    
    NSString *roomsString=@"Room";
    NSString *adultsString=@"Adults";
    NSString *children=@"0";
    NSString *adult=@"0";
    cell.maxGueteLBL.text = @"";
    NSDictionary *number_of_guests = [[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"number_of_guests"];
    if([number_of_guests isKindOfClass:[NSDictionary class]])
    {
        if (number_of_guests[@"value"]) {
            adult = number_of_guests[@"value"];

        }
        if (number_of_guests[@"childrenValue"]) {
            children = number_of_guests[@"childrenValue"];

        }
        cell.maxGueteLBL.text=[number_of_guests[@"name"] capitalizedString];

     }
 
    
    
  //  cell.maxGueteLBL.text=[NSString stringWithFormat:@"%@ %@, %@ Children", adult,adultsString,children];

    if([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"bed_type"] isKindOfClass:[NSDictionary class]])
    {
        cell.bedLBL.text=[NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"bed_type"][@"name"]];

//        if([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"bed_type"] objectForKey:@"image"])
//        {
//            NSString*imgName=[[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"bed_type"] valueForKey:@"image"];
//            NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
//            [cell.bedTypeImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@""]];
//        }
    }
    else
    {
        cell.bedLBL.text=[NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"bed_type"]];
        
       
    }
    // [dic valueForKey:@"number_rooms"]
    
    cell.availableRooms=[NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"numberOfRoomsAvailable"] ];
    cell.sloatLBL.hidden = TRUE;
   // cell.sloatLBL.text=[NSString stringWithFormat:@" %@ ",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]];;
    cell.countTF.text=[[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"count-%@",[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"_id"]]];
    
    cell.roonID=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"_id"];
    cell.selectButton.layer.borderColor = kColorDarkBlueThemeColor.CGColor;
    cell.selectButton.layer.borderWidth = 1.;
    cell.selectButton.layer.cornerRadius = 6.;
    cell.lblRoomCount.text = @"0";
    
    
    

    if([_selectedRooms objectForKey:[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"_id"]])
    {
        cell.lblRoomCount.text = [_selectedRooms objectForKey:[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"_id"]];
        cell.bgView.backgroundColor = [UIColor colorWithRed:0.137 green:0.737 blue:0.976 alpha:0.1];

        cell.selectButton.backgroundColor = kColorDarkBlueThemeColor;
        [cell.selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.selectButton setTitle:@"SELECTED" forState:UIControlStateNormal];//CJC 3.a

    }
    else
    {
        cell.bgView.backgroundColor = [UIColor whiteColor];

        cell.selectButton.backgroundColor = [UIColor whiteColor];
        [cell.selectButton setTitleColor:kColorDarkBlueThemeColor forState:UIControlStateNormal];
        [cell.selectButton setTitle:@"SELECT" forState:UIControlStateNormal];//CJC 3.a

    }
    cell.selectButton.restorationIdentifier = cell.roonID;
    cell.btnRoomCount.restorationIdentifier = cell.roonID;
    cell.btnRoomCount.tag =  [cell.lblRoomCount.text intValue];
    cell.selectButton.tag =    cell.btnRoomCount.tag;
    cell.selectButton.superview.tag = indexPath.row;
    cell.btnRoomCount.superview.tag = indexPath.row;

    [cell.selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnRoomCount addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];

    cell.bgView.layer.cornerRadius = 10;
    
    
    NSString* price=@"0";
    NSString* discountPrice=@"0";

    price=[self.dataArray objectAtIndex:indexPath.row][@"priceSummary"][@"base"][@"amount"];
    
    
    /////
 /*   NSDictionary* dic =[self.dataArray objectAtIndex:indexPath.row];
    if([dic isKindOfClass:[NSDictionary class]])
    {
        
        if([dic objectForKey:@"price"])
        {
            if([[dic objectForKey:@"price"] isKindOfClass:[NSDictionary class]])
            {                    if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"3H"])
            {
                if([[dic objectForKey:@"price"] objectForKey:@"h3"])
                {
                    price=[[dic objectForKey:@"price"] valueForKey:@"h3"];
                    
                }
                
            }
            else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"6H"])
            {
                if([[dic objectForKey:@"price"] objectForKey:@"h6"])
                {                        price=[[dic objectForKey:@"price"] valueForKey:@"h6"];                                                                    }
                
            } else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"12H"])
            {
                if([[dic objectForKey:@"price"] objectForKey:@"h12"])
                {
                    price=[[dic objectForKey:@"price"] valueForKey:@"h12"];
                    
                }
                
            }else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"24H"])
            {
                if([[dic objectForKey:@"price"] objectForKey:@"h24"])
                {
                    price=[[dic objectForKey:@"price"] valueForKey:@"h24"];
                    
                }
                
            }
                
            }
            else
            {
                price=[dic valueForKey:@"price"];
                
            }
            
        }
        BOOL statusValue=NO;
        if([dic objectForKey:@"custom_price"])
        {
            if([[dic objectForKey:@"custom_price"] isKindOfClass:[NSDictionary class]])
            {
                
                if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"3H"])
                {
                    if([[dic objectForKey:@"custom_price"] objectForKey:@"h3"])
                    {
                        price=[[dic objectForKey:@"custom_price"] valueForKey:@"h3"];
                        statusValue=YES;

                        
                    }
                }
                else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"6H"])
                {
                    if([[dic objectForKey:@"custom_price"] objectForKey:@"h6"])
                    {
                        price=[[dic objectForKey:@"custom_price"] valueForKey:@"h6"];
                        
                        statusValue=YES;

                    }
                }
                else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"12H"])
                {
                    if([[dic objectForKey:@"custom_price"] objectForKey:@"h12"])
                    {
                        price=[[dic objectForKey:@"custom_price"] valueForKey:@"h12"];
                        statusValue=YES;

                    }
                }
                else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"24H"])
                {
                    if([[dic objectForKey:@"custom_price"] objectForKey:@"h24"])
                    {
                        price=[[dic objectForKey:@"custom_price"] valueForKey:@"h24"];
                        statusValue=YES;

                        
                    }
                }
                
            }else
            {
                price=[dic valueForKey:@"custom_price"];
                statusValue=YES;

            }
        }
       
        
        ///
        
        
        
        
        
    
        
    }
    */
    
    ///////
    
    
    
    
//    if ([[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"price"])
//        
//    {   price=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"price"];
//        
//    }
//    else
//    {
//        price=@"200";
//        
//    }
    
    
    [[NSUserDefaults standardUserDefaults] setValue:price forKey:[NSString stringWithFormat:@"pricePerRoom-%@",[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"_id"]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    cell.priceLBL.text = [NSString stringWithFormat:@"%@",price];
    cell.sloatLBL.clipsToBounds = TRUE;
    cell.sloatLBL.layer.cornerRadius = 5.0;
    cell.selectButton.layer.cornerRadius = 5.0;
    NSDictionary *item =_selectedProperty;
    cell.sloatLBL.text =@"";
    if ([[item objectForKey:@"stayDuration"] isKindOfClass:[NSDictionary class]])
    {
        cell.sloatLBL.text = [NSString stringWithFormat:@" %@ ",[item objectForKey:@"stayDuration"][@"label"]];
        
    }
else if ([[item objectForKey:@"stayDuration"] isKindOfClass:[NSString class]])
{
cell.sloatLBL.text = [NSString stringWithFormat:@" %@ ",[item objectForKey:@"stayDuration"]];

}
    
    
    if (cell.sloatLBL.text.length>0)
    {
               NSString *hrlbl = cell.sloatLBL.text;
               hrlbl = [NSString stringWithFormat:@".  %@  .",hrlbl];
               NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:hrlbl attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FontMedium size:12]}];
    
               [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(0, 1)];
               [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(hrlbl.length-1, 1)];
                cell.sloatLBL.attributedText = attr;
                cell.sloatLBL.backgroundColor = UIColorFromRGB(0xFF4848);
        cell.sloatLBL.hidden = FALSE;

           }
    else{
        cell.sloatLBL.hidden = TRUE;
    }
    
    return cell;
}
-(void)selectAction:(UIButton*)button
{
    
    int availableroom = [[NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:button.superview.tag] valueForKey:@"numberOfRoomsAvailable"] ] intValue];
    int curINdex = button.tag;
    NSMutableArray *array =[[NSMutableArray alloc] init];
    for (int i=0;i<=availableroom;i++) {//CJC 5
        [array addObject:[NSString stringWithFormat:@"%d",i]];
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSNumber *prev_Sele_index = [NSNumber numberWithInt:curINdex];
    [MMPickerView showPickerViewInView:appDelegate.window
                          withStrings:array
                          withOptions:@{MMbackgroundColor: [UIColor whiteColor],
                                        MMtextColor: [UIColor blackColor],
                                        MMtoolbarColor:kColorDarkBlueThemeColor,
                                        MMselectedIndex:prev_Sele_index,
                                        MMtoolbarTitle:@"Select Rooms",
                                        MMbuttonTextColor: [UIColor whiteColor],
                                        MMtextAlignment:@1}
                           completion:^(NSString *selectedString)
    
    {
        if ([selectedString isEqualToString:@"Cancel"]) {
            
        }
        else
        {
          
            if ([selectedString intValue]==0) {
                if (_selectedRooms[button.restorationIdentifier]) {
                    [_selectedRooms removeObjectForKey:button.restorationIdentifier];
                }
            }
            else{
                _selectedRooms[button.restorationIdentifier] =selectedString;

            }
            [roomsTableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"roomSelected" object:nil];
        }
        

    }];
 
  }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    NSString* selectedString=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:selectedString forKey:@"roomIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"roomDetails" object:nil];

    
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   //
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0) {
        
        if(status)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"movetobottom" object:nil];
        status=YES;
        // Scroll down direction
    } else {
        if(status)
        {
        roomsTableView.contentOffset=CGPointMake(0, 0);
        }
        status=NO;
 [[NSNotificationCenter defaultCenter] postNotificationName:@"movetotop" object:nil];
        // Scroll to up
    }
   // self.lastContentOffset = currentOffset;
}

@end
