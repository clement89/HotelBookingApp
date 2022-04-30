//
//  SingleRoomViewController.m
//  Stayhopper
//
//  Created by iROID Technologies on 11/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "SingleRoomViewController.h"
#import "UIImageView+WebCache.h"
#import "AvailabilityViewController.h"
#import "UIImageView+WebCache.h"
#import "FinalBookingViewController.h"
#import "MessageViewController.h"
#import "LoginViewController.h"
@interface SingleRoomViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    BOOL isForTitle;
}
@property (weak, nonatomic) IBOutlet UIButton *btnSelectAction;
@end

@implementation SingleRoomViewController

- (void)viewDidLoad {
    
    bookButton.alpha=0;
    bottomImageView.alpha=0;
    self.bottomHeight.constant=0;

    BGVIEW.clipsToBounds=YES;
    BGVIEW.layer.cornerRadius=10;
    
    [super viewDidLoad];
    clickedIndex=0;
 
    imageArray=[[NSMutableArray alloc]init];
    serviceArray=[[NSMutableArray alloc]init];

    self.slideImgWidth.constant=[UIScreen mainScreen].bounds.size.width/3;
    
    if([UIScreen mainScreen].bounds.size.height>=812)
    {
//        self.scrollTop.constant=-40;
//
//        self.navigationTop.constant=-40;
        self.bottomConst.constant=-20;
    }
    else
    {
        //self.navigationTop.constant=-20;
        self.bottomConst.constant=0;
     //   self.scrollTop.constant=-20;
    }
    
    [self loadBasicInfo];
    
    [self roomSelected];

    
}
-(void)loadBasicInfo
{
    
    sloatBL.text=[NSString stringWithFormat:@" %@ ",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]];;
 
        
    roomNameLBL.text=@"";
    if([self.selectedRoomDic objectForKey:@"room_name"])
    {
      if(  [[self.selectedRoomDic objectForKey:@"room_name"] objectForKey:@"name"])
    roomNameLBL.text=[[self.selectedRoomDic objectForKey:@"room_name"] valueForKey:@"name"];
    }
    
    roomsizeLBL.text=@"";
    if([self.selectedRoomDic objectForKey:@"room_size"])
    {
        if(  [self.selectedRoomDic objectForKey:@"room_size"] )
            roomsizeLBL.text=[self.selectedRoomDic valueForKey:@"room_size"];
    }
    guestRoomsLBL.text=@"";
    if([self.selectedRoomDic objectForKey:@"number_guests"])
    {
        if(  [self.selectedRoomDic objectForKey:@"number_guests"] )
            guestRoomsLBL.text=[NSString stringWithFormat:@"%@ Persons",[self.selectedRoomDic valueForKey:@"number_guests"] ];
    }
    
    numberofRoomsLBL.text=@"";
    if([self.selectedRoomDic objectForKey:@"free_rooms"])
    {
        if(  [self.selectedRoomDic objectForKey:@"free_rooms"] )
            numberofRoomsLBL.text=[NSString stringWithFormat:@"%@",[self.selectedRoomDic valueForKey:@"free_rooms"] ];
        
        
    }
    
    
    bedLBL.text=@"";
    if([self.selectedRoomDic objectForKey:@"number_beds"])
    {
        if(  [self.selectedRoomDic objectForKey:@"number_beds"] )
            bedLBL.text=[NSString stringWithFormat:@"%@",[self.selectedRoomDic valueForKey:@"number_beds"] ];
        
        
        if(  [self.selectedRoomDic objectForKey:@"bed_type"] )
        {
            if(  [[self.selectedRoomDic objectForKey:@"bed_type"] objectForKey:@"name"] )
            {
                bedLBL.text=[bedLBL.text stringByAppendingString: @" " ];
                
                bedLBL.text=[bedLBL.text stringByAppendingString: [[self.selectedRoomDic objectForKey:@"bed_type"] valueForKey:@"name"] ];
            }
        }
        
    }
    if([[self.selectedRoomDic valueForKey:@"bed_type"] objectForKey:@"image"])
    {
        NSString*imgName=[[self.selectedRoomDic valueForKey:@"bed_type"] valueForKey:@"image"];
        NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
        [bedTypeImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder"]];
    }
    
    [imageArray removeAllObjects];
    if([self.selectedRoomDic objectForKey:@"images"])
        for(NSString* imageString in [self.selectedRoomDic objectForKey:@"images"])
        {
            [imageArray addObject:imageString];
            //  [imageArray addObject:imageString];
            
        }
    [imageCollectionView reloadData];
    
    
    [serviceArray removeAllObjects];
    if([self.selectedRoomDic objectForKey:@"services"])
        for(NSDictionary* dicv in [self.selectedRoomDic objectForKey:@"services"])
        {
        if([dicv objectForKey:@"image"])
            [serviceArray addObject:[dicv valueForKey:@"image"]];
            //  [imageArray addObject:imageString];
            
        
        }
    [servicesCollectionView reloadData];
    
    
    if(imageArray.count==0)
    {
        countLBL.text=@"0/0";
    }
    else
    {
        countLBL.text=[NSString stringWithFormat:@"1/%lu",(unsigned long)imageArray.count ];
        
    }
    
    
    NSString* price=@"0";
    
    price=@"0.0";
    
    
    /////
    NSDictionary* dic =self.selectedRoomDic;
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
        
    }
    
    
    ///////
    
    
    
    if([dic objectForKey:@"custom_price"])
    {
        if([[dic objectForKey:@"custom_price"] isKindOfClass:[NSDictionary class]])
        {
            
            if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"3H"])
            {
                if([[dic objectForKey:@"custom_price"] objectForKey:@"h3"])
                {
                    price=[[dic objectForKey:@"custom_price"] valueForKey:@"h3"];
                    
                    
                }
            }
            else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"6H"])
            {
                if([[dic objectForKey:@"custom_price"] objectForKey:@"h6"])
                {
                    price=[[dic objectForKey:@"custom_price"] valueForKey:@"h6"];
                    
                    
                }
            }
            else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"12H"])
            {
                if([[dic objectForKey:@"custom_price"] objectForKey:@"h12"])
                {
                    price=[[dic objectForKey:@"custom_price"] valueForKey:@"h12"];
                    
                }
            }
            else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"24H"])
            {
                if([[dic objectForKey:@"custom_price"] objectForKey:@"h24"])
                {
                    price=[[dic objectForKey:@"custom_price"] valueForKey:@"h24"];
                    
                    
                }
            }
            
            ;
        }else
        {
            price=[dic valueForKey:@"custom_price"];
            ;
        }
    }
    
    
    
    ////
    
    
 
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" AED %@ ",price]];
    NSInteger leng=str.length;
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:14.0] range:NSMakeRange(0, 4)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:22.0] range:NSMakeRange(5, leng-5)];
   
    priceLBL.attributedText = str;
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    scrollView.contentSize=CGSizeMake(0,0);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if(collectionView==imageCollectionView)
    return imageArray.count;
    else return serviceArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(collectionView==imageCollectionView)
    {
    homeCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCellRooms" forIndexPath:indexPath];
    
    NSString*imgName=[imageArray objectAtIndex:indexPath.item];
    NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
    [homeCell.img sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"emptyRoom.png"]];
    
    
    
    
    return homeCell;
    
    }
    
        serviceCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ServicesCollectionViewCellRooms" forIndexPath:indexPath];
        
                NSString*imgName=[serviceArray objectAtIndex:indexPath.item];
                NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
                [serviceCell.serviceImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@""]];
    
        
        
        
        return serviceCell;
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView==imageCollectionView)
        return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
    
    return CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //            MallDetailsViewController *menuView=[storyBoard instantiateViewControllerWithIdentifier:@"MallDetailsViewController"];
    //            [self.navigationController pushViewController:menuView animated:YES];
    
    
    
    
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(collectionView==imageCollectionView)
    {
        if(imageArray.count==0)
        {
            countLBL.text=@"0/0";
        }
        else
        {
            countLBL.text=[NSString stringWithFormat:@"%lu/%lu",(unsigned long)indexPath.item+1,(unsigned long)imageArray.count ];
            
        }
    }
}
-(IBAction)backFunction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
};
-(IBAction)shareFunction:(id)sender
{
    
};
-(IBAction)checkFunction:(UIButton*)sender
{
    
}


- (void)Uploadprogress
{
    //  hud.progress = progress=hud.progress+0.05;
    hud.progress=hud.progress+0.05;
    //    if(hud.progress>1)
    //        hud.progress=0;
}

- (IBAction)selectRoomAction:(UIButton*)sender {
    
   
    if(sender.isSelected)
      {
          sender.selected=NO;
          
          [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:[NSString stringWithFormat:@"selectedRoom-%@",[_selectedRoomDic valueForKey:@"_id"]]];
          
              [[NSUserDefaults standardUserDefaults]synchronize];
          [[NSNotificationCenter defaultCenter] postNotificationName:@"roomSelected" object:nil];

      }
      else
      {
          sender.selected=YES;
          [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:[NSString stringWithFormat:@"selectedRoom-%@",[_selectedRoomDic valueForKey:@"_id"]]];
          
          [[NSUserDefaults standardUserDefaults]synchronize];
        //  [[NSNotificationCenter defaultCenter] postNotificationName:@"roomSelected" object:nil];

      }
    [self roomSelected];
}
-(void)setupSelectButton
{}
-(IBAction)bookNowFunction:(UIButton*)sender
{
    NSMutableArray *roomsArray;
     roomsArray = [[NSMutableArray alloc] init];
 
    
    NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    for(NSString* key in keys){
        BOOL status;
        if([key containsString:@"selectedRoom-"] )
        {
            if([[[NSUserDefaults standardUserDefaults] valueForKey:key] isEqualToString:@"YES"])
            {
            NSString* idString=[key stringByReplacingOccurrencesOfString:@"selectedRoom-" withString:@""];
            
            status=NO;

            for(NSString* string in roomsArray)
            {
                if([string isEqualToString:idString])
                    status=YES;
                
            }
            if(!status)
                [roomsArray addObject:idString];
                
            }
              //
             // [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            //[[NSUserDefaults standardUserDefaults]synchronize];
            
        }
        
    }
    
    
    NSUInteger countValue=0;
    NSInteger roomCount=0;

    for(NSString* str in roomsArray)
    {
        for(NSDictionary* dicV in _roomsArrayTemp)
        {
            if([[dicV valueForKey:@"_id"] isEqualToString:str])
            {
                countValue=countValue+  ([[dicV valueForKey:@"number_guests"] integerValue] *[[[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"count-%@",str]] integerValue]);
                
                
                roomCount=roomCount+[[[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"count-%@",str]] integerValue];
                break;
            }
        }
        
        
    }
  if(roomCount<=[[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"] integerValue])  {
   if(roomCount>=[[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedRooms"] integerValue] || countValue>=[[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"] integerValue]) {
     if(roomCount>=[[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedRooms"] integerValue])
    {
    if(countValue>=[[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"] integerValue])
    {
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    {
        if(roomsArray.count!=0)
        {
            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FinalBookingViewController  *finalBookingViewController = [storyBoard instantiateViewControllerWithIdentifier:@"FinalBookingViewController"];
            finalBookingViewController.selectedProperty=self.selectedProperty;
            finalBookingViewController.loadedProperty=self.loadedProperty;
            finalBookingViewController.selectedIDS=roomsArray;
            [self.navigationController pushViewController:finalBookingViewController animated:YES];
        }
        
    }
    else
    {
//        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//        InitialViewController *vc = [y   instantiateViewControllerWithIdentifier:@"InitialViewController"];
//
//        vc.fromString=@"presentView";
//        [self.navigationController pushViewController:vc animated:YES];
        
        
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
        LoginViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.fromString=@"presentView";
        [self.navigationController pushViewController:vc animated:YES];
        
        //        vc.providesPresentationContextTransitionStyle = YES;
        //        vc.definesPresentationContext = YES;
        //        [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
        //        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
    }else
    {
        
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Warning";
        vc.messageString=@"Adult count mismatch";
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
    }
}else
{
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
    vc.imageName=@"Warning";
    vc.messageString=@"Room count mismatch";
    vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
    [self.view addSubview:vc.view];
}
   }else
   {
       UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
       MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
       vc.imageName=@"Warning";
       vc.messageString=@"Room / Adult count mismatch";
       vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
       [self.view addSubview:vc.view];
   }
    }else
    {
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Warning";
        vc.messageString=@"Room / Adult count mismatch";
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
    }
    
    
    
}
-(void)roomSelected
{
    NSMutableArray *roomsArray;
    NSMutableArray *roomsArrayTemp;
    roomsArrayTemp = [[NSMutableArray alloc] init];
    roomsArray = [[NSMutableArray alloc] init];
    [roomsArray removeAllObjects];

    
    BOOL status=NO;
    NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    for(NSString* key in keys){
        if([key containsString:@"selectedRoom-"] )
        {
            if([[[NSUserDefaults standardUserDefaults] valueForKey:key] isEqualToString:@"YES"])
            {
                status=YES;
    bookButton.enabled=YES;
                self.bottomHeight.constant=50;

                ////
                
                [roomsArray removeAllObjects];
                
                
                NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
                for(NSString* key in keys){
                    BOOL status;
                    if([key containsString:@"selectedRoom-"] )
                    {
                        if([[[NSUserDefaults standardUserDefaults] valueForKey:key] isEqualToString:@"YES"])
                        {
                            NSString* idString=[key stringByReplacingOccurrencesOfString:@"selectedRoom-" withString:@""];
                            
                            status=NO;
                            
                            for(NSString* string in roomsArray)
                            {
                                if([string isEqualToString:idString])
                                    status=YES;
                                
                            }
                            if(!status)
                                [roomsArray addObject:idString];
                            
                        }
                        //
                        // [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
                        //[[NSUserDefaults standardUserDefaults]synchronize];
                        
                    }
                    
                }
               float totalPrice=0;
                for(NSString* string in roomsArray)
                {
                    //roomCount=roomCount+[[[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"count-%@",string]] integerValue];
                    
                    totalPrice=totalPrice+([[[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"count-%@",string]] integerValue]*[[[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"pricePerRoom-%@",string]] floatValue]);
                    
                }
                NSString *totalString=[NSString stringWithFormat:@"%.2f",totalPrice];
                
                [roomsArray removeAllObjects];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"BOOK THIS FOR\nAED %@",totalString]];
                NSInteger leng=str.length;

                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ProximaNovaA-Regular" size:11.0] range:NSMakeRange(0, 13)];
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:21.0] range:NSMakeRange(14, leng-14)];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, leng)];

                bookButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                [[bookButton titleLabel] setNumberOfLines:2];
                [[bookButton titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
                
                [bookButton setAttributedTitle:str forState:UIControlStateNormal];
               
                
                ///
                
                
                
                
                break;
            }
        }
    }
    if(status)
    {
        bookButton.alpha=1;
        bottomImageView.alpha=1;
        self.bottomHeight.constant=50;

        bookButton.enabled=YES;
    }
else
{
    bookButton.alpha=0;
    bottomImageView.alpha=0;
    self.bottomHeight.constant=0;

    bookButton.enabled=NO;
}
    
    _btnSelectAction.selected  = bookButton.enabled;
}
@end


