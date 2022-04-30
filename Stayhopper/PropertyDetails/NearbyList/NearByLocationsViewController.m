//
//  NearByLocationsViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 23/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "NearByLocationsViewController.h"
#import "UIImageView+WebCache.h"
#import "URLConstants.h"
#import "MKMapDimOverlay.h"
#import "MKMapDimOverlayView.h"
#import <MapKit/MapKit.h>


@interface NearByLocationsViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeaderHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTitleTop;
@end

@implementation NearByLocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text = @"Near by";
    _mapView.delegate =nil;// (id)self;
    _mapView.hidden = TRUE;
    if (_titleString) {
        _lblTitle.text = _titleString;
    }
    if (_shouldHideTopView) {
        _constraintHeaderHeight.constant = 0.;
        _constraintTitleTop.constant = -1* [self getTopSafeArea];
        _constraintTitleTop.constant = 0;
    }
    /*
    if (_dataArray) {
      for (NSDictionary *dict in _dataArray) {
            MKPointAnnotation *mapPin1 = [[MKPointAnnotation alloc] init];
            
            mapPin1.title=[NSString stringWithFormat:@"%@\n%@",dict[@"title"],dict[@"sub"]];

            
            double latitude1 = [[dict objectForKey:@"lat"] doubleValue];
            double longitude1 = [[dict objectForKey:@"long"] doubleValue];
            CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(latitude1, longitude1);
            
            MKCoordinateSpan span;
            span.latitudeDelta = .5f;
            span.longitudeDelta = .5f;
            MKCoordinateRegion region;
            region.center = coordinate1;
            region.span = span;
            //[_mapView setRegion:region animated:TRUE];
            [_mapView setRegion:region];
            // setup the map pin with all data and add to map view
            
            mapPin1.coordinate = coordinate1;
            
            [self.mapView addAnnotation:mapPin1];
        }

    }
   
    
    
    
    
    MKMapDimOverlay *dimOverlay = [[MKMapDimOverlay alloc] initWithMapView:self.mapView];
    
    [self.mapView addOverlay: dimOverlay];

    
    self.mapView.showsUserLocation=YES;
     */
    
    status=YES;
    // Do any additional setup after loading the view.
     self.view.backgroundColor = kColorHotelDetailsBG;
locationListTable.backgroundColor = kColorHotelDetailsBG;

}
-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *pinView = nil;
    if(annotation == _mapView.userLocation)
    {
        return nil;
        //        static NSString *defaultPinID = @"com.iROID.StayHopper";
        //        pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        //        if ( pinView == nil )
        //            pinView = [[MKAnnotationView alloc]
        //                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        //
        //        //pinView.pinColor = MKPinAnnotationColorGreen;
        //        pinView.canShowCallout = NO;
        //        //pinView.animatesDrop = YES;
        //        pinView.image = [UIImage imageNamed:@"close"];    //as suggested by Squatch
    }
    else {
        
        static NSString *defaultPinID = @"com.iROID.sh";
        pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.canShowCallout = NO;
        pinView.userInteractionEnabled=YES;
        pinView.enabled=YES;
        UIImage *annotationImage = [UIImage imageNamed:@"customannotation"];
        pinView.frame = CGRectMake(0, 0, annotationImage.size.width,annotationImage.size.height);
        
        // UIButton* mapButton=[UIButton buttonWithType:UIButtonTypeCustom];
        // [mapButton setBackgroundColor:[UIColor blueColor]];
        UIView*containerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, annotationImage.size.width,annotationImage.size.height)];
      //  containerView.backgroundColor = [UIColor whiteColor];
        containerView.tag=[annotation.title integerValue];
        UILabel *lbltitle =[[UILabel alloc] initWithFrame:CGRectMake(5, 5, containerView.frame.size.width-10, containerView.frame.size.height-20)];
        lbltitle.font =[UIFont fontWithName:FontMedium size:13];
        lbltitle.textAlignment = NSTextAlignmentCenter;
        lbltitle.numberOfLines = 3;
        lbltitle.text = annotation.title;
        [containerView addSubview:lbltitle];
        // mapButton.enabled=YES;
        // mapButton.userInteractionEnabled=YES;
      //  propertyTag++;
      //  [containerView setBackgroundColor:[UIColor clearColor]];
//        UIImageView*imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 40,40)];
//        imgView.image=[UIImage imageNamed:@"annotation"];
//        // UIImageView*hotelImgView=[[UIImageView alloc]initWithFrame:CGRectMake(20,17, 40,40)];
//        // hotelImgView.image=[UIImage imageNamed:@"venice-italy.jpg"];
//        // hotelImgView.layer.cornerRadius=hotelImgView.frame.size.width/2;
//        //  hotelImgView.clipsToBounds=YES;
//        [containerView addSubview:imgView];
        //  [containerView addSubview:hotelImgView];
        // [containerView addSubview:mapButton];
        containerView.userInteractionEnabled=YES;
        // pinView.rightCalloutAccessoryView = mapButton;
        //pinView.annotation.title=@"test";
     pinView.image=annotationImage;
       // pinView.backgroundColor = [UIColor redColor];
      //  pinView
        [pinView addSubview:containerView];
        //[containerView setBackgroundColor:[UIColor blueColor]];
        //[imgView setBackgroundColor:[UIColor yellowColor]];
        //[hotelImgView setBackgroundColor:[UIColor whiteColor]];
        
    }
    return pinView;
}


-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    if([overlay isMemberOfClass:[MKMapDimOverlay class]]) {
        MKMapDimOverlayView *dimOverlayView = [[MKMapDimOverlayView alloc] initWithOverlay:overlay];
        dimOverlayView.overlayColor = kColorDarkBlueThemeColor;
        return dimOverlayView;
    }
    return nil;
}
-(float)getTopSafeArea
{
    float safeAreaTop = 0.0;
    if (@available(iOS 11.0, *)) {
        safeAreaTop = [[UIApplication sharedApplication] keyWindow].safeAreaInsets.top;
    } else {
        // Fallback on earlier versions
    }
    return safeAreaTop;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float width = [UIScreen mainScreen].bounds.size.width - 2*20;
    return  10+width*142.0/335.0;
}
//335*152
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell1=(NearByPropertyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NearByPropertyTableViewCell"];
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;

  //  @property(nonatomic,strong)IBOutlet UILabel* locationNameLBL;
    //@property(nonatomic,strong)IBOutlet UIView* bgView;
    
    //@property(nonatomic,strong)IBOutlet UIImageView* locationImageView;
    UILabel *locationNameLBL = [[cell1.contentView viewWithTag:-10] viewWithTag:2];
    UIImageView *locationImageView = [[cell1.contentView viewWithTag:-10] viewWithTag:1];

    locationNameLBL.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    locationNameLBL.textColor = kColorDarkBlueThemeColor;//CJC

    NSString*imgName=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"image"];
    NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
    [locationImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"NearbyPlaceholder"]];//CJC
    cell1.contentView.backgroundColor = [UIColor whiteColor];
    cell1.backgroundColor = [UIColor whiteColor];

    return cell1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"movetotop" object:nil];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0) {
        if(status)

        [[NSNotificationCenter defaultCenter] postNotificationName:@"movetobottom" object:nil];
        status=YES;
        // Scroll down direction
    } else {
        if(status)
        {
            locationListTable.contentOffset=CGPointMake(0, 0);
        }
        status=NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"movetotop" object:nil];
        // Scroll to up
    }
    // self.lastContentOffset = currentOffset;
}
- (IBAction)backBtnActionnn:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

@end
