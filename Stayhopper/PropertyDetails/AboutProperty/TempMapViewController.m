//
//  TempMapViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 22/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "TempMapViewController.h"

@interface TempMapViewController ()

@end

@implementation TempMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    
   // let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
    
    
    
    // locationString=@"25.2048,55.2708";
    
    self.latitudeValue=[[NSUserDefaults standardUserDefaults] valueForKey:@"mapLatitude"];
    self.longitudeValue=[[NSUserDefaults standardUserDefaults] valueForKey:@"mapLongitude"];

    GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:[self.latitudeValue floatValue] longitude:[self.longitudeValue floatValue] zoom:12.0];
    mapView=[[GMSMapView alloc]initWithFrame:self.view.frame];
    mapView.userInteractionEnabled=NO;

    mapView.camera=cameraPosition;
  //  mapView.myLocationEnabled=YES;
    [self.view addSubview:mapView];
  //  self.view.userInteractionEnabled=NO;
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

@end
