//
//  CurrentLocationMapVC.m
//  TravelLog
//
//  Created by Edo/Imju on 10/26/13.
//  Copyright (c) 2013 MyTravel. All rights reserved.
//

#import "CurrentLocationMapVC.h"
#import <MapKit/MKMapView.h>
#import <MapKit/MKUserLocation.h>
#import "VenueCell.h"
#import "CheckInViewController.h"
#import "Travelog.h"
#import "CLPlacemark+AddressDisplay.h"

#define METERS_PER_MILE 1609.344
NSString *const LocationChangedNotification=@"LocationChangedNotification";
CGFloat const kImageOriginHeight = 240.f;

@interface CurrentLocationMapVC ()

@property (retain, nonatomic)CoreLocationController *locationController;
@property (strong, nonatomic)CLLocation *location;
@property (strong, nonatomic)CLLocation *selectedLocation;
@property (strong, nonatomic)Venue *selectedVenue;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSArray *venueArray;
@property (strong, nonatomic) NSArray *prevVenueArray;
//reverse Geo Coding
@property (strong, nonatomic) CLGeocoder *geocoder; //object that performs the geocode


@end



@implementation CurrentLocationMapVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidChange:) name:LocationChangedNotification object:self];
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, -kImageOriginHeight, self.tableView.frame.size.width, kImageOriginHeight)];

    }
    
    return self;
}

//remove the notification observer
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:LocationChangedNotification
     object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = nil;

    [self.tableView addSubview:self.mapView];
    
    self.tableView.contentInset = UIEdgeInsetsMake(kImageOriginHeight,0,0,0);
    
    //setting self as mapview delegate necessary for annotation
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    //register custom cell
    UINib *venueCell = [UINib nibWithNibName:@"VenueCell" bundle:nil];
    [self.tableView registerNib:venueCell forCellReuseIdentifier:@"VenueCell"];
   //kick off location manager
    self.locationController = [[CoreLocationController alloc] init];
	self.locationController.delegate = self;
    self.locationController.isUpdating = YES;
	[self.locationController.locationManager startUpdatingLocation];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset < -kImageOriginHeight){
        CGRect f = self.mapView.frame;
        f.origin.y = yOffset;
        f.size.height = -yOffset;
        self.mapView.frame = f;
    }
    
}

//calling the updatelocation will thrwo away old pins and make new pins
//for newly fethced travelog objects
- (void)contextDidChange:(NSNotification *)notification
{
    if ([self isViewLoaded]) {
        [self updateLocations];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate

- (void)update:(CLLocation *)location {
    self.location = location;
    
   // NSLog(@"after map update: latitude: %f longitude: %f", [location coordinate].latitude,[location coordinate].longitude);
    
}

-(void)fetchData{

    [[FourSquareClient instance] venueSearchWithLatitude: self.location.coordinate.latitude
                                               longitude: self.location.coordinate.longitude
                                                 success:^(AFHTTPRequestOperation *operation, id response) {
                                                     NSDictionary *jsonDict = (NSDictionary *) response;
                                                     NSArray *items = [[jsonDict objectForKey:@"response"] objectForKey:@"venues"];
                                                     

                                                     //self.venueArray = [Venue venuesWithArray:items];
                                                     // sort by distance
                                                     __block NSArray *venues = [Venue venuesWithArray:items];

                                                     
                                                     // adding current location on top
                                                     BOOL locationMatched = false;
                                                     
                                                     for (Venue *venue in venues) {
                                                         if (venue.distance.doubleValue < 0.0001)
                                                             locationMatched = true;
                                                     }
                                                     
                                                     if (!locationMatched){
                                                         
                                                         if(!self.geocoder)
                                                         {
                                                            self.geocoder = [[CLGeocoder alloc] init];
                                                         }
                                                         [self.geocoder reverseGeocodeLocation:self.location
                                                                        completionHandler:^(NSArray * placemarksArray, NSError *error)
                                                          {
                                                              CLPlacemark *placemark = nil;
                                                              NSString *address = nil;
                                                              
                                                              if (error){
                                                                  NSLog(@"Geocode failed with error: %@", error);
                                                                  return;
                                                                  
                                                              }
                                                              //reverse geocode found and set into placemark array object
                                                              if (error == nil && [placemarksArray count] > 0) {
                                                                  placemark = [placemarksArray lastObject];
                                                                  address = [placemark addressDisplay];
                                                              }
                                                              //if there is an error
                                                              else{
                                                                  placemark = nil;
                                                              }
                                                              
                                                              Venue *venue = [[Venue alloc] initWithPlaceName:placemark.name
                                                                                                      address:address
                                                                                                     latitude:(NSNumber *)[NSNumber numberWithDouble:self.location.coordinate.latitude]
                                                                                                    longitude:(NSNumber *)[NSNumber numberWithDouble:self.location.coordinate.longitude]
                                                                                                     distance:(NSNumber *)[NSNumber numberWithInt:0]
                                                                                                    placemark:placemark];
                                                              NSMutableArray *newVenues= [[NSMutableArray alloc] initWithArray:venues];
                                                              [newVenues insertObject:venue atIndex:0];
                                                              self.venueArray = [[NSArray alloc] initWithArray:newVenues];
                                                              [self.tableView reloadData];
                                                              [[NSNotificationCenter defaultCenter] postNotificationName:LocationChangedNotification object:self];
                                                              int i = 1;
                                                              for (Venue *venue in self.venueArray) {
                                                                  venue.index = [NSNumber numberWithInt:i++];
                                                              }
                                                              
                                                          }];
                                                     }

                                                     self.venueArray = venues; // no sorting

                                                     //now reloading data
                                                     [self.tableView reloadData];
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:LocationChangedNotification object:self];
                                                     //disable location manager monitoring
                                                     self.mapView.showsUserLocation = NO;
                                                     
                                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     // send alert
                                                     [self connectionError:error];
                                                 }];
    }

                                                     
- (IBAction)updateLocationButton:(id)sender
{
    //Enable location manager monitoring
    self.mapView.showsUserLocation = YES;
    self.locationController.isUpdating = YES;
	[self.locationController.locationManager startUpdatingLocation];
}


#pragma mark - Table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.venueArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VenueCell" forIndexPath:indexPath];
    
    Venue *venue = [self.venueArray objectAtIndex:indexPath.row];

    NSString *distanceString = [NSString stringWithFormat:@"%.1f ml", [venue.distance floatValue]];
    
    [cell.distanceLabel  setText:distanceString];
    [cell.venueNameLabel setText:venue.name];
    [cell.indexLabel setText:[NSString stringWithFormat:@"%@.",venue.index]];
    [cell.addressLabel setText:venue.address];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Venue *venue = self.venueArray[indexPath.row];
    self.selectedVenue = venue;
    //NSLog(@"index:%d venue lat:%@, long:%@",indexPath.row, venue.latitude,venue.longitude);
    //get location of selected row
    
    [self performSegueWithIdentifier:@"CheckIn" sender:self];
    

}


//send the long, lat, and address information to CheckInView
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CheckIn"] ) {
        
        CheckInViewController *checkinvc = segue.destinationViewController;


        //pass the core data elements
        checkinvc.managedObjectContext = self.managedObjectContext;
        checkinvc.venue = self.selectedVenue;
        self.selectedLocation = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[self.selectedVenue.latitude doubleValue]
                                                           longitude:(CLLocationDegrees)[self.selectedVenue.longitude doubleValue] ];
        
        //pass variables
        checkinvc.coordinate = self.selectedLocation.coordinate;
        checkinvc.location = self.selectedLocation;
        
        //if placemark exists
        if (!self.selectedVenue.placemark)
            checkinvc.placemark = self.selectedVenue.placemark;
    }
    
}



#pragma mark - MKMapviewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation)
    {
        return nil;
    }
    //because MKAnnotation is a protocol, there are many objects it contains
    //ie the blue dot that represent the users current location
    //so we use isKindOdClass to determine whether teh annotation is a location object, if so we continue
    if ([annotation isKindOfClass:[Venue class]]) {
        
        //reuse an annotation view object and create pins
        static NSString *identifier = @"Venue";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        //set some properties to configure the look and feel ofthe annotation view
        //chnage the pins to green
        if (annotationView == nil) {
            
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(6, 3, 11, 11)] ;
            lbl.backgroundColor = [UIColor clearColor];
            lbl.textColor = [UIColor whiteColor];
            [lbl setFont:[UIFont systemFontOfSize:11]];
            lbl.tag = 42;
            [annotationView addSubview:lbl];
            
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"map_pin_home_19.png"];
            //annotationView.frame = lbl.frame;
            //annotationView.pinColor = MKPinAnnotationColorGreen;
            
            //create a disclosure button and hook up a touch up inside event with a showtagsdetails method
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.rightCalloutAccessoryView = rightButton;
        }
        
        else
        {
            annotationView.annotation = annotation;
        }
        
        //now that the annotation is constructed we obtain the refrence to the button so
        //we can find the travelog object array
        //UIButton *button = (UIButton *)annotationView.rightCalloutAccessoryView;
        //button.tag = [travelogs indexOfObject:(Travelog *)annotation];
        
        UILabel *lbl = (UILabel *)[annotationView viewWithTag:42];
        lbl.text = [NSString stringWithFormat:@"%@",((Venue *)annotation).index];

        
        return annotationView;
    }
    
    return nil;
}

- (void)locationError:(NSError *)error {
    NSLog(@"locationError:%@", error);
    [[[UIAlertView alloc] initWithTitle:@"Travelpop"
                                message:@"Error on Getting Location"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil, nil] show];
}

- (void)connectionError:(NSError *)error {
    NSLog(@"connectionError:%@", error);
    [[[UIAlertView alloc] initWithTitle:@"Travelpop"
                                message:@"Error on Connecting to Internet"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil, nil] show];
}

- (void)updateLocations
{
    
   // NSError *error;
    
    //execute fecthed data here
    if (self.prevVenueArray == nil && self.venueArray == nil){
        //do nothing
        return;
    }
    if (self.prevVenueArray!=nil && self.venueArray == nil) {
        return;
    }
    //we adding pins on the map
    if (self.prevVenueArray != nil) {
        [self.mapView removeAnnotations:self.prevVenueArray];
    }
    // now setting new venue array to prev.
    self.prevVenueArray = self.venueArray;
    [self.mapView addAnnotations:self.venueArray];
    
    MKCoordinateRegion region = [self regionForAnnotations:self.venueArray];
    [self.mapView setRegion:region animated:YES];
    
    
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	id <MKAnnotation> annotation = [annotationView annotation];
    //bring up index no. 1
    if ([annotation isKindOfClass:[Venue class]]){
        
        if ([((Venue *)annotation).index intValue] == 1){
            [mv selectAnnotation:annotation animated:YES];
        }
        
    }
    //	[mv selectAnnotation:mp animated:YES];
}


//calculates a reasonable region that fits all location objects
- (MKCoordinateRegion)regionForAnnotations:(NSArray *)annotations
{
    MKCoordinateRegion region;
    
    //there is no annotations, so center map on user's current position
    if ([annotations count] == 0) {
        region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 1000, 1000);
    }
    
    //there is only one annotation, so center map on that one annotation
    else if ([annotations count] == 1)
    {
        id <MKAnnotation> annotation = [annotations lastObject];
        region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000);
    }
    
    //there are two or more annotations, so calculate the extent of their reach and add a little padding
    else
    {
        CLLocationCoordinate2D topLeftCoord;
        topLeftCoord.latitude = -90;
        topLeftCoord.longitude = 180;
        
        CLLocationCoordinate2D bottomRightCoord;
        bottomRightCoord.latitude = 90;
        bottomRightCoord.longitude = -180;
        
        for (id <MKAnnotation> annotation in annotations) {
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        }
        
        const double extraSpace = 1.1;
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2.0;
        region.center.longitude = topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2.0;
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace;
        region.span.longitudeDelta = fabs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace;
    }
    
    return [self.mapView regionThatFits:region];
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
                      calloutAccessoryControlTapped:(UIControl *)control
{
    self.selectedVenue = (Venue *) view.annotation;
    [self performSegueWithIdentifier:@"CheckIn" sender:self];

}
                                                     
                                                     

@end
