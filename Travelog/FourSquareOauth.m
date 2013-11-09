//
//  FourSquareOauth.m
//  TravelLog
//
//  Created by bgbb on 10/26/13.
//  Copyright (c) 2013 MyTravel. All rights reserved.
//

#import "FourSquareOauth.h"


// 5. setup some helpers so we don't have to hard-code everything

#define FOURSQUARE_AUTHENTICATE_URL @"https://foursquare.com/oauth2/authenticate"

#define FOURSQUARE_CLIENT_ID @"PL5T1UVUSEHIOS1FSSQBYNIKGUHGIS3ENOJWT1PA2VP0IRDJ"

#define FOURSQUARE_CLIENT_SECRET @"IEZZ0VS1JPPXMXIJCJ3YY4N4HV00HHGRIIZOVKKZQ1FAXW4Q"

#define FOURSQUARE_REDIRECT_URI @"travellog://foursquare"

@interface FourSquareOauth ()

// 1. create webview property

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation FourSquareOauth

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    // initialize the webview and add it to the view
    
    //2. init with the available window dimensions
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    
    //3. set the delegate to self so that we can respond to web activity
    
    self.webView.delegate = self;
    
    //4. add the webview to the view
    
    [self.view addSubview:self.webView];
    
    //6. Create the authenticate string that we will use in our request to foursquare
    
    // we have to provide our client id and the same redirect uri that we used in setting up our app
    
    // The redirect uri can be any scheme we want it to be... it's not actually going anywhere as we plan to
    
    // intercept it and get the access token off of it
    
    NSString *authenticateURLString = [NSString stringWithFormat:@"%@?client_id=%@&response_type=token&redirect_uri=%@", FOURSQUARE_AUTHENTICATE_URL, FOURSQUARE_CLIENT_ID, FOURSQUARE_REDIRECT_URI];
    
    //7. Make the request and load it into the webview
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:authenticateURLString]];
    
    [self.webView loadRequest:request];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Web view delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"request:%@",request.URL.scheme);
    NSLog(@"request url:%@", request.URL.description);
    
    if([request.URL.scheme isEqualToString:@"travellog"]){
        
        // 8. get the url and check for the access token in the callback url
        
        NSString *requestString = [[request URL] absoluteString];
        
        if ([requestString rangeOfString:@"access_token="].location != NSNotFound) {
            
            // 9. Store the access token in the user defaults
            
//            NSString *accessToken = [[URLString componentsSeparatedByString:@"="] lastObject];
//            NSLog(@"accessToken:%@",accessToken);
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            
//            [defaults setObject:accessToken forKey:@"access_token"];
//            
//            [defaults synchronize];
            [User setCurrentUser:requestString];
            
            // 10. dismiss the view controller
            
            //[self dismissViewControllerAnimated:YES completion:nil];
            
        }
        
    }
    
    return YES;
    
}

@end
