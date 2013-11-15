//
//  CurrentLocationMapVC.m
//  TravelLog
//
//  Created by bgbb on 10/26/13.
//  Copyright (c) 2013 MyTravel. All rights reserved.
//

#import "CurrentLocationMapVC.h"
#import <MapKit/MKMapView.h>
#import <MapKit/MKUserLocation.h>
#import "VenueCell.h"
//#import "CheckInVC.h"
#import "CheckInViewController.h"
#import "Travelog.h"

#define METERS_PER_MILE 1609.344
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
NSString *const LocationChangedNotification=@"LocationChangedNotification";

@interface CurrentLocationMapVC ()

@property (retain, nonatomic)CoreLocationController *locationController;
@property (strong, nonatomic)CLLocation *location;
@property (strong, nonatomic)CLLocation *selectedLocation;
@property (strong, nonatomic)Venue *selectedVenue;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *nearbyVenueTableView;
@property (strong, nonatomic) NSArray *venueArray;
@property (strong, nonatomic) NSArray *prevVenueArray;

@end

//reverse Geo Coding
CLGeocoder *geocoder; //object that performs the geocode


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
    self.nearbyVenueTableView.delegate = self;
    self.nearbyVenueTableView.dataSource = self;
    self.nearbyVenueTableView.tableHeaderView = nil;
    
    //setting self as mapview delegate necessary for annotation
    self.mapView.delegate = self;
    
    //register custom cell
    UINib *venueCell = [UINib nibWithNibName:@"VenueCell" bundle:nil];
    [self.nearbyVenueTableView registerNib:venueCell forCellReuseIdentifier:@"VenueCell"];
   //kick off location manager
    self.locationController = [[CoreLocationController alloc] init];
	self.locationController.delegate = self;
	[self.locationController.locationManager startUpdatingLocation];
    
    
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
//    MKCoordinateRegion userLocation = MKCoordinateRegionMakeWithDistance(location.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
//    [self.mapView setRegion:userLocation animated:YES];
    
    NSLog(@"after map update: latitude: %f longitude: %f", [location coordinate].latitude,[location coordinate].longitude);
    
}

-(void)fetchData{

    [[FourSquareClient instance] venueSearchWithLatitude: self.location.coordinate.latitude
                                               longitude: self.location.coordinate.longitude
                                                 success:^(AFHTTPRequestOperation *operation, id response) {
                                                     NSLog(@"success getting venue %@", response);
                                                     NSDictionary *jsonDict = (NSDictionary *) response;
                                                     NSArray *items = [[jsonDict objectForKey:@"response"] objectForKey:@"venues"];
                                                     

                                                     //self.venueArray = [Venue venuesWithArray:items];
                                                     // sort by distance
                                                     NSMutableArray *venues = [Venue venuesWithArray:items];
                                                     BOOL locationMatched = false;
                                                     
                                                     for (Venue *venue in venues) {
                                                         if (venue.distance == 0)
                                                             locationMatched = true;
                                                     }
                                                     
                                                     if (!locationMatched){
                                                         
                                                     }
                                                     
                                                     //if first item 4sq list already has 0 in distance then no sort because
                                                     //the more reliable location is given by 4sq
//                                                     if (((Venue *)venues[0]).distance==0)
//                                                     {
//                                                         self.venueArray = venues;
//                                                    }else{ //otherwise based on distance sort
//                                                       self.venueArray = [[Venue venuesWithArray:items]
//                                                                         sortedArrayUsingComparator:^ NSComparisonResult(id a, id b) {
//                                                                            NSNumber *first = [(Venue *)a distance];
//                                                                            NSNumber *second = [(Venue *)b distance];
//                                                                         return [first compare:second];
//                                                         }];
//                                                     }

                                                     self.venueArray = venues; // no sorting

                                                     //now reloading data
                                                     [self.nearbyVenueTableView reloadData];
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:LocationChangedNotification object:self];

                                                     //add annotation to map
                                                    // [self.mapView addAnnotations:venues];
                                                     
                                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     // Do nothing
                                                     NSLog(@"failure %@", error);

                                                 }];
    

}


- (IBAction)upadateLocationButton:(id)sender
{
    [self updateLocations];
    [self fetchData];
}


#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.venueArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VenueCell" forIndexPath:indexPath];
    
    Venue *venue = [self.venueArray objectAtIndex:indexPath.row];
    NSString *venueString = [NSString stringWithFormat:@"%@. %@", venue.index, venue.name];
    NSString *distanceString = [NSString stringWithFormat:@"%.1f ml", [venue.distance floatValue]];
    
    //[cell.venueNameLabel setText:[NSString stringWithFormat:@"%@. %@", venue.index, venue.name]];
    [cell.distanceLabel  setText:venue.distance.description];

    UIFont *distanceFont = [UIFont fontWithName:@"helvetica" size:11.0 ];
    NSDictionary *distancedict = [NSDictionary dictionaryWithObject: distanceFont forKey:NSFontAttributeName];
    NSMutableAttributedString *distanceAttrString = [[NSMutableAttributedString alloc] initWithString:distanceString attributes:distancedict];
    cell.distanceLabel.attributedText = distanceAttrString;
    [cell.distanceLabel setTextColor:UIColorFromRGB(0x66CCFF)];
    
    UIFont *venueArialFont = [UIFont fontWithName:@"helvetica" size:15.0];
    NSDictionary *venueArialdict = [NSDictionary dictionaryWithObject: venueArialFont forKey:NSFontAttributeName];
    NSMutableAttributedString *venueAttrString = [[NSMutableAttributedString alloc] initWithString:venueString attributes: venueArialdict];
    cell.venueNameLabel.attributedText = venueAttrString;

    return cell;
}

#pragma mark - Table view delegate

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
    }
    
}

//because the segue is not connected to any particular control inteh view controller, we haveto
//trigger manually, we send along teh button as teh sender
- (void)showtagDetails:(UIButton *)button
{
    [self performSegueWithIdentifier:@"MapCheckIn" sender:button];
}



#pragma mark - MKMapviewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
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
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(4, 2, 10, 10)] ;
            lbl.backgroundColor = [UIColor clearColor];
            lbl.textColor = [UIColor blueColor];
            [lbl setFont:[UIFont systemFontOfSize:11]];
            lbl.tag = 42;
            [annotationView addSubview:lbl];
            
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.animatesDrop = YES;
            annotationView.frame = lbl.frame;
            annotationView.pinColor = MKPinAnnotationColorGreen;
            
            //cerate a disclosure button and hook up a touch up inside event with a showtagsdetails method
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
    [[[UIAlertView alloc] initWithTitle:@"Travelog"
                                message:@"Error on Getting Location"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil, nil] show];
}

- (void)updateLocations
{
    
    NSError *error;
    
    //execute fecthed data here
    if (self.prevVenueArray == nil && self.venueArray == nil){
        //do nothing
        return;
    }
    if (self.prevVenueArray!=nil && self.venueArray == nil) {
        NSLog(@"Error: %@", error);
        //abort();
    }
    
    //we adding pins on the map
    if (self.prevVenueArray != nil) {
        [self.mapView removeAnnotations:self.prevVenueArray];
    }
    // now setting new venue array to prev.
    self.prevVenueArray = self.venueArray;
    //NSLog(@"1 venue coord: %@", ((Venue *)[self.venueArray objectAtIndex:0]).coordinate);
    [self.mapView addAnnotations:self.venueArray];
    
    MKCoordinateRegion region = [self regionForAnnotations:self.venueArray];
    [self.mapView setRegion:region animated:YES];
    
    
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	id <MKAnnotation> annotation = [annotationView annotation];
   // NSLog(@"annotation:%@",mp);
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
    NSLog(@"selected venue:%@",view.annotation);
    [self performSegueWithIdentifier:@"CheckIn" sender:self];

}

@end
