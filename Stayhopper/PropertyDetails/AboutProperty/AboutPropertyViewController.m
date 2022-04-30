//
//  AboutPropertyViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 22/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "AboutPropertyViewController.h"
#import "UIImageView+WebCache.h"
#import "URLConstants.h"
#import "AmenitiesViewController.h"

@interface AboutPropertyViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCVFacHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *policyTVWidth;

@end

@implementation AboutPropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    bgScrollView.delegate=self;
    self.view.backgroundColor = kColorCommonBG;

    status=YES;
   // [self.view addSubview:self.mapView];
    // Do any additional setup after loading the view.
    [self loadItems];
    self.view.backgroundColor = kColorHotelDetailsBG;

}
-(void)viewDidAppear:(BOOL)animated
{

//if(status)

//    bgScrollView.layer.borderColor = [UIColor redColor].CGColor;
//    bgScrollView.layer.borderWidth = 3.0;
//    facilitiesEnlargeButton.superview.layer.borderColor = [UIColor greenColor].CGColor;
//    facilitiesEnlargeButton.superview.layer.borderWidth = 1.0;
    status=NO;
   //   bgScrollView.contentSize=CGSizeMake(bgScrollView.frame.size.width, bgScrollView.contentSize.height);

}
- (void)viewDidLayoutSubviews{
    bgScrollView.frame=self.view.frame;

}
-(void)loadItems
{
  if(self.loadedsProperty)  {
       
        
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 1.25;
       
        
        if([self.loadedsProperty objectForKey:@"description"])
        {
            
            if([[self.loadedsProperty objectForKey:@"description"] isKindOfClass:[NSString class]])
            {
                NSString* leng=[NSString stringWithFormat:@"%@",[self.loadedsProperty objectForKey:@"description"]];
                if(leng.length!=0)
                {
          //  descriptionTV.text=[self.selectedProperty objectForKey:@"description"];
    //        descriptionTV.attributedText = [[NSAttributedString alloc]
    //                                        initWithString:[self.selectedProperty objectForKey:@"description"]
    //                                        attributes:@{NSParagraphStyleAttributeName : style}];
            
            NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[self.loadedsProperty objectForKey:@"description"]]];
            NSInteger leng1=str1.length;
            
            [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ProximaNovaA-Regular" size:16.0] range:NSMakeRange(0, leng1)];
            [str1 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, leng1)];
            [str1 addAttribute:NSForegroundColorAttributeName value:descriptionTV.textColor range:NSMakeRange(0, leng1)];
                descriptionTV.attributedText =str1;
                }
                else
                    descriptionTV.text =@"No Description Available";


            }
            else
                descriptionTV.text =@"No Description Available";


    //        [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:20.0] range:NSMakeRange(5, leng1-5)];NSForegroundColorAttributeName
            
        }
        else
        {
          /*  descriptionTV.attributedText = [[NSAttributedString alloc]
                                            initWithString:[self.selectedProperty objectForKey:@"No Description Available"]
                                            attributes:@{NSParagraphStyleAttributeName : style}];
           */
            descriptionTV.text=@"No Description Available";

        }
       // arg.translatesAutoresizingMaskIntoConstraints = true
        
        
        
      //  descriptionTV.translatesAutoresizingMaskIntoConstraints=NO;
      //  [descriptionTV sizeToFit];
        
        
      //  descriptionTV.scrollEnabled=NO;
    //    descriptionTV.translatesAutoresizingMaskIntoConstraints=NO;
    //
    //    descriptionTVWidth.constant=bgScrollView.frame.size.width-10;
    //  //  [descriptionTV sizeToFit];
    //    descriptionTV.scrollEnabled=NO;
    //    descriptionTV.translatesAutoresizingMaskIntoConstraints=NO;
       // [descriptionTV sizeToFit];
      
       
       //   [self.view layoutIfNeeded];

    //    MKPointAnnotation *mapPin1 = [[MKPointAnnotation alloc] init];
    //    mapPin1.title=[NSString stringWithFormat:@"%ld",(long)propertyTag];
    //    propertyTag++;
    //    // clear out any white space
    //
    //    // convert string into actual latitude and longitude values
    //
    //    double latitude1 = [[[[dicValue objectForKey:@"contactinfo"] objectForKey:@"latlng"] objectAtIndex:0] doubleValue];
    //    double longitude1 = [[[[dicValue objectForKey:@"contactinfo"] objectForKey:@"latlng"] objectAtIndex:1] doubleValue];
    //    CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(latitude1, longitude1);
    //
    //    MKCoordinateSpan span;
    //    span.latitudeDelta = .5f;
    //    span.longitudeDelta = .5f;
    //    MKCoordinateRegion region;
    //    region.center = coordinate1;
    //    region.span = span;
    //    //[_mapView setRegion:region animated:TRUE];
    //    [_mapView setRegion:region];
    //    // setup the map pin with all data and add to map view
    //
    //    mapPin1.coordinate = coordinate1;
    //
    //    [self.mapView addAnnotation:mapPin1];
        
        
    //    IBOutlet UIButton* descriptionEnlargeButton;
    //    IBOutlet UIButton* facilitiesEnlargeButton;
    //    IBOutlet UIButton* policiesEnlargeButton;
        
        
        NSString* policyString=@"";
        if([self.loadedsProperty objectForKey:@"policies"])
        {
            for(NSDictionary* dic in [self.loadedsProperty objectForKey:@"policies"])
            {
                
                if([dic objectForKey:@"name"])
                    policyString=[policyString stringByAppendingString:[NSString stringWithFormat:@"%@\n",[dic valueForKey:@"name"]]];//CJC 7 brusted
                
            }
        }
       // pliciesTV.text=policyString;
        
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",policyString]];
        NSInteger leng2=str2.length;
        
        [str2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ProximaNovaA-Regular" size:16.0] range:NSMakeRange(0, leng2)];
        [str2 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, leng2)];
        [str2 addAttribute:NSForegroundColorAttributeName value:descriptionTV.textColor range:NSMakeRange(0, leng2)];
        
        //        [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:20.0] range:NSMakeRange(5, leng1-5)];NSForegroundColorAttributeName
        
        pliciesTV.attributedText =str2;
        
        
       // pliciesTV.scrollEnabled=NO;
    //    pliciesTV.translatesAutoresizingMaskIntoConstraints=NO;
    //
    //    _policyTVWidth.constant=bgScrollView.frame.size.width-10;
    //   // [pliciesTV sizeToFit];
    //    pliciesTV.scrollEnabled=NO;
    //
        if (descriptionTV.frame.size.height<95) {
            descriptionEnlargeButton.alpha=0;
        }
        
        if (pliciesTV.frame.size.height<40) {
            policiesEnlargeButton.alpha=0;
        }
        if(self.availableServices.count==0)
            facilitiesEnlargeButton.alpha=0;
      [facilitiesCollectionView reloadData];
    }
    [self.view layoutIfNeeded];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.availableServices.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    homeCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ServicesCollectionViewCell" forIndexPath:indexPath];
    
    //        NSString*imgName=[imageArray objectAtIndex:indexPath.item];
    //        NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
    //        [homeCell.img sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    if([[self.availableServices objectAtIndex:indexPath.row] objectForKey:@"image"])
    {
        NSString*imgName=[[self.availableServices objectAtIndex:indexPath.row] valueForKey:@"image"];
        NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
        [homeCell.serviceImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@""]];
        
    }
    
    
    return homeCell;
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(40, 40);
    return CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
  //  [[NSNotificationCenter defaultCenter] postNotificationName:@"movetotop" object:nil];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    return;
    if (scrollView.contentOffset.y <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"movetobottom" object:nil];
        
        // Scroll down direction
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"movetotop" object:nil];
        // Scroll to up
    }
    // self.lastContentOffset = currentOffset;
}
-(IBAction)policiesEnlarge:(id)sender
{
    
    NSString* policyString=@"";
    if([self.loadedsProperty objectForKey:@"policies"])
    {
        for(NSDictionary* dic in [self.loadedsProperty objectForKey:@"policies"])
        {
            
            if([dic objectForKey:@"name"])
                policyString=[policyString stringByAppendingString:[NSString stringWithFormat:@"%@, ",[dic valueForKey:@"name"]]];
            
        }
    }
   // pliciesTV.text=policyString;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 2.5;
    style.alignment = NSTextAlignmentLeft;
    
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",policyString]];
    NSInteger leng2=str2.length;
    
    [str2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontRegular size:16.0] range:NSMakeRange(0, leng2)];
    [str2 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, leng2)];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:26./255. green:30./255. blue:102./255. alpha:0.6] range:NSMakeRange(0, leng2)];
    
    
    
    AmenitiesViewController *vc= [[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"AmenitiesViewController"];
    vc.policyString = str2;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:TRUE completion:^{
            
    }];
    return;
    
    if([self.fromString isEqualToString:@"YES"])
        [[NSNotificationCenter defaultCenter] postNotificationName:@"policiesEnlargePD" object:nil];

    else
        [[NSNotificationCenter defaultCenter] postNotificationName:@"policiesEnlarge" object:nil];

};
-(IBAction)descriptionEnlarge:(id)sender
{
    
    return;
    if([self.fromString isEqualToString:@"YES"])
        [[NSNotificationCenter defaultCenter] postNotificationName:@"descriptionEnlargePD" object:nil];
else
    [[NSNotificationCenter defaultCenter] postNotificationName:@"descriptionEnlarge" object:nil];

};
-(IBAction)facilitiesEnlarge:(id)sender
{
    AmenitiesViewController *vc= [[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"AmenitiesViewController"];
    vc.amentiesArray = self.availableServices;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:TRUE completion:^{
            
    }];
    return;
    if([self.fromString isEqualToString:@"YES"])
        [[NSNotificationCenter defaultCenter] postNotificationName:@"facilitiesEnlargePD" object:nil];

    else
        [[NSNotificationCenter defaultCenter] postNotificationName:@"facilitiesEnlarge" object:nil];

};
@end
