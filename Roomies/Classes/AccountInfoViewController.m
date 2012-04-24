//
//  AccountInfoViewController.m
//  Roomies
//
//  Created by Anna Zakharova on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "User.h"
#import "AccountData.h"
#import "RoomiesAppDelegate.h"
#import "InviteViewController.h"

@implementation AccountInfoViewController

@synthesize mapView, forwardGeocoder, roomiesViewController;
@synthesize mkMapView;
@synthesize mapController, inviteController;
@synthesize accountView;
@synthesize name;
@synthesize address1;
@synthesize address2;
@synthesize creator;
@synthesize creator_num;
@synthesize addRommies;
@synthesize viewRoomies;
@synthesize deleteRommies;

@synthesize invitLbl;
@synthesize acceptButton;
@synthesize ignoreButton;
@synthesize mapButton;
@synthesize account_id;
@synthesize invitationAccountsController;
@synthesize account;

@synthesize mode;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	NSLog(@"In ACCOUNT viewDidLoad ");
	
	self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"iROOMIES2.png"]];
	//format phone entry
	
	/* [name resignFirstResponder];
	 [address1 resignFirstResponder];
	 [address2 resignFirstResponder];
	 [creator resignFirstResponder];
	 [creator_num resignFirstResponder]; */
	
	/* view mode */
	if(mode == 0)
	{
		name.enabled = FALSE;
		address1.enabled = FALSE;
		address2.enabled = FALSE;
		creator.enabled = FALSE;
		creator_num.enabled = FALSE;
		
		acceptButton.hidden = TRUE;
		ignoreButton.hidden = TRUE;
		invitLbl.hidden = TRUE;
		mapButton.hidden = FALSE;
		
		[self displayAccountInfo];
		
	}
	/* add mode */
	else if(mode == 1) 
	{
		name.enabled = TRUE;
		address1.enabled = TRUE;
		address2.enabled = TRUE;
		creator.enabled = TRUE;
		creator_num.enabled = TRUE;
		
		UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] init];
		saveButton.title = @"Save";
		saveButton.target = self;
		saveButton.style = UIBarButtonItemStyleBordered;
		//[buttons addObject:saveButton];
		self.navigationItem.rightBarButtonItem = saveButton;
		self.navigationItem.rightBarButtonItem.enabled = TRUE;
		self.navigationItem.rightBarButtonItem.action = @selector(buttonClicked:);
		[saveButton release];
		
		acceptButton.hidden = TRUE;
		ignoreButton.hidden = TRUE;
		invitLbl.hidden = TRUE;
		
		addRommies.hidden = TRUE;
		viewRoomies.hidden = TRUE;
		deleteRommies.hidden = TRUE;
		mapButton.hidden = TRUE;
	}
	/* invitation */
	else if(mode == 2)
	{
		name.enabled = FALSE;
		address1.enabled = FALSE;
		address2.enabled = FALSE;
		creator.enabled = FALSE;
		creator_num.enabled = FALSE;
		
		acceptButton.hidden = FALSE;
		ignoreButton.hidden = FALSE;
		invitLbl.hidden = FALSE;
		
		addRommies.hidden = TRUE;
		viewRoomies.hidden = TRUE;
		deleteRommies.hidden = TRUE;
		mapButton.hidden = TRUE;
	}
	else if(mode == 3) //invitation view
	{
		name.enabled = FALSE;
		address1.enabled = FALSE;
		address2.enabled = FALSE;
		creator.enabled = FALSE;
		creator_num.enabled = FALSE;
		
		acceptButton.hidden = FALSE;
		ignoreButton.hidden = FALSE;
		invitLbl.hidden = FALSE;
		mapButton.hidden = FALSE;
		
		addRommies.hidden = TRUE;
		viewRoomies.hidden = TRUE;
		deleteRommies.hidden = TRUE;
	}
	NSLog(@"ACCOUNT DONE in view load");
}


// set by outside source
- (void) viewAccount:(AccountData *)data
{
	User *user = [User instance];
	NSLog(@"ACCOUNT viewAccount data %p", data);
	if(data == nil)
		return;
	
	NSString *str = [NSString stringWithFormat:@"%d", data.account_id];	
	account_id = data.account_id;
	NSMutableString * query = [[NSMutableString alloc ]initWithFormat:@"&UDID="] ;
	[query appendString:(@"%@", user.UDID)];
	[query appendString:(@"&account_id=")];
	[query appendString:(@"%@", str)];
	[query appendString:@"&request_type=request_creator_info"];
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	@try
	{
		
		NSString *response  = [del remoteRequest:query] ;
		NSLog(@"Reply from request_creator_info %@", response);
		
		NSArray *chunks = [response componentsSeparatedByString: @","];
		NSLog(@"viewAccount size of return  %d ", [chunks count]);
		data.creator_name = [chunks objectAtIndex:0];
		data.phone_number = [chunks objectAtIndex:1];
		
		self.account = [[AccountData alloc] init];
		self.account = data;
	
	}
	@catch (NSException * e) 
	{
		NSLog(@"request_creator_info exception caught");
		//display the reason why server cannot send back correct XML file
		NSLog(@"exception: %@", [e reason]);
		
		// if we can identify the error, we can present a more precise message to the user.
		NSDictionary *userInfo =
		[NSDictionary dictionaryWithObject:
		 NSLocalizedString(@"Error request_creator_info account",
						   @"Error message displayed when have issues to get request_creator_info.")
									forKey:NSLocalizedDescriptionKey];
		
		NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
											 code:kCFURLErrorNotConnectedToInternet
										 userInfo:userInfo];
		[del handleError:error];
	}	
	
	NSLog(@"viewAccount account_id %d name %@", data.account_id, data.account_name);
	NSLog(@"viewAccount address1 %@", data.address1);
	NSLog(@"viewAccount address2 %@", data.address2);
	NSLog(@"viewAccount creator_name %@ phone_number %@", data.creator_name, data.phone_number);
	
	account_id = data.account_id;
	name.text = data.account_name;
	address1.text = data.address1;
	address2.text = data.address2;
	creator.text = data.creator_name;
	creator_num.text = data.phone_number;
}

- (void) displayAccountInfo
{
	User *user = [User instance];
	NSLog(@" IN ACCOUNT VIEW");
	
	NSLog(@"Account name %@ ", user.accountData.account_name);
	NSLog(@"Account address1 %@ ", user.accountData.address1);
	NSLog(@"Account address2 %@ ", user.accountData.address2);
	NSLog(@"Account creator %@ ", user.accountData.creator_name);
	NSLog(@"Account creator %@ ", user.accountData.phone_number);
	
	name.text = user.accountData.account_name;
	address1.text = user.accountData.address1;
	address2.text = user.accountData.address2;
	creator.text = user.accountData.creator_name;
	creator_num.text = user.accountData.phone_number;
}

- (IBAction) editingChanged:(id)sender
{
	NSLog(@" editingChanged ");
	if(sender == creator_num)
	{
		NSLog(@" editingChanged phone number changed %@ ", creator_num.text);
		
		// NSNumberFormatter
		// PhoneNumberFormatter::stringFromPhoneNumber
	}
}

- (IBAction)leaveField:(id) sender
{
	NSLog(@" leaveField ");
	if(sender == name)
	{
		NSLog(@"name");
		[name resignFirstResponder];
	}
	if(sender == address1)
	{
		NSLog(@"address1");
		[address1 resignFirstResponder];
	}
	if(sender == address2)
	{
		NSLog(@"address2");
		[address2 resignFirstResponder];
	}
	if(sender == creator)
	{
		NSLog(@"creator");
		[creator resignFirstResponder];
	}
	if(sender == creator_num)
	{
		NSLog(@"creator_num");
		[creator_num resignFirstResponder];
	}
	
}

- (IBAction) acceptClicked:(id) sender
{
	NSLog(@" acceptClicked ");
	
	//accept_invitation i need :account_id user_phone_num and udid
	
	User *user = [User instance];
	
	NSString *str = [NSString stringWithFormat:@"%d", account_id];
	
	NSLog(@"accept CLICKED 2");
	NSMutableString * query = [[NSMutableString alloc ]initWithFormat:@"UDID="] ;
	[query appendString:(@"%@", user.UDID)];
	[query appendString:(@"&account_id=")];
	[query appendString:(@"%d", str)];
	[query appendString:(@"&user_phone_num=")];
	[query appendString:(@"%@", [User instance].phone_number)];
	[query appendString:@"&request_type=accept_invitation"];
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	//[str release];
	
	@try
	{
		
		NSString *response  = [del remoteRequest:query] ;
		NSLog(@"Reply from accept account <%@>", response);
		
		
		//TEST user.accountData = [[AccountData alloc] init];
		//TEST user.accountData = account;
		
		[del loadAllData];
		
		NSLog(@"**********");
		
		//[del.invitationNavController popViewControllerAnimated:YES];
		[del displayMainApplicationTab];
		NSLog(@"*****&&&&*****");
	}
	@catch (NSException * e) 
	{
		NSLog(@"accept account exception caught");
		//display the reason why server cannot send back correct XML file
		NSLog(@"exception: %@", [e reason]);
		
		// if we can identify the error, we can present a more precise message to the user.
		NSDictionary *userInfo =
		[NSDictionary dictionaryWithObject:
		 NSLocalizedString(@"Error accept account invitation",
						   @"Error message displayed when have issues to accept account invitation.")
									forKey:NSLocalizedDescriptionKey];
		
		NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
											 code:kCFURLErrorNotConnectedToInternet
										 userInfo:userInfo];
		[del handleError:error];
	}
	
}

- (IBAction) ignoreClicked:(id) sender
{
	NSLog(@" ignoreClicked ");
	
	User *user = [User instance];	
	NSString *str = [NSString stringWithFormat:@"%d", account_id ];
	NSMutableString * query = [[NSMutableString alloc ]initWithFormat:@"UDID="] ;
	[query appendString:(@"%@", user.UDID)];
	[query appendString:(@"&account_id=")];
	[query appendString:(@"%d", str)];
	[query appendString:(@"&user_phone_num=")];
	[query appendString:(@"%@", [User instance].phone_number)];
	[query appendString:@"&request_type=ignore_invitation"];
	
	RoomiesAppDelegate *del = (RoomiesAppDelegate *)[[UIApplication sharedApplication] delegate];
	//[str release]; 
	
	@try
	{
		
		NSString *response  = [del remoteRequest:query] ;
		NSLog(@"Reply from ignore account %@", response);
		
		[invitationAccountsController deleteItem];
		
		[del.invitationNavController popViewControllerAnimated:YES];
	}
	@catch (NSException * e) 
	{
		NSLog(@"ignore account exception caught");
		//display the reason why server cannot send back correct XML file
		NSLog(@"exception: %@", [e reason]);
		
		// if we can identify the error, we can present a more precise message to the user.
		NSDictionary *userInfo =
		[NSDictionary dictionaryWithObject:
		 NSLocalizedString(@"Error ignore account invitation",
						   @"Error message displayed when have issues to ignore account invitation.")
									forKey:NSLocalizedDescriptionKey];
		
		NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
											 code:kCFURLErrorNotConnectedToInternet
										 userInfo:userInfo];
		[del handleError:error];
	}	
}

- (IBAction) deleteAccountClicked:(id) sender
{
	NSLog(@" deleteAccountClicked ");
	User *user = [User instance];
	
	NSMutableString * query = [[NSMutableString alloc ]initWithFormat:@"&UDID="] ;
	[query appendString:(@"%@", user.UDID)];
	[query appendString:@"&request_type=account_delete"];
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	@try{
		
		NSString *response  = [del remoteRequest:query] ;
		NSLog(@"Reply from add account %@", response);
		
		[user.accountData release];
		user.accountData = nil;
		[user.billsList release];   // contain list of bills
		user.billsList = nil;
		[user.responsList release]; //contain list of responsibilities
		user.responsList = nil;
		[user.eventsList release];       //list of events
		user.eventsList = nil;
		//[user.eventsResponList release];
		//user.eventsResponList = nil;
		
		NSLog(@"popViewControllerAnimated REMOVE FROM STACK DO I NEED IT ??? MAY CRASH ");
		[del.settingsNavController popViewControllerAnimated:YES];
		[del displayMainSettingView];
	}
	@catch (NSException * e) 
	{
		NSLog(@"delete account exception caught");
		//display the reason why server cannot send back correct XML file
		NSLog(@"exception: %@", [e reason]);
		
		// if we can identify the error, we can present a more precise message to the user.
		NSDictionary *userInfo =
		[NSDictionary dictionaryWithObject:
		 NSLocalizedString(@"Error delete account",
						   @"Error message displayed when have issues to delete account.")
									forKey:NSLocalizedDescriptionKey];
		
		NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
											 code:kCFURLErrorNotConnectedToInternet
										 userInfo:userInfo];
		[del handleError:error];
	}
	
}

- (IBAction) viewRoomiesClicked:(id) sender
{
	NSLog(@" viewRoomiesClicked display all roomies");
	
	if(self.roomiesViewController == nil)
	{
		RoomiesViewController *details = [[RoomiesViewController alloc] initWithNibName:@"RoomiesView" bundle:nil];
		self.roomiesViewController = details;
		[details release];
	}
	roomiesViewController.title = [NSString stringWithFormat:@"Roomies"];
	
	// push on navigation stack 
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	[del.settingsNavController pushViewController:roomiesViewController animated:YES];
	NSLog(@"finish of roomoiesViewController");
	
}

// display address book
- (IBAction) inviteRoomiesClicked:(id) sender
{
	NSLog(@" inviteRoomiesClicked load contacts");
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	[del.settingsNavController pushViewController:inviteController animated:YES];
}

- (IBAction)buttonClicked:(id)sender
{
	NSLog(@" save buttonClicked ");
	NSLog(@"save button in accountinfoviewcontroller clicked connection status %d ", [User instance].connect_status);
	
	/* if([User instance].connect_status == FAILED)
	 {
	 NSLog(@"Please check connection ");
	 UIAlertView *alert = [[UIAlertView alloc]
	 initWithTitle: @"Error Adding Account "
	 message: @"Please check internet connection !"
	 delegate: nil
	 cancelButtonTitle:@"OK"
	 otherButtonTitles:nil];
	 [alert show];
	 [alert release];
	 return;
	 } */
	
	NSLog(@"trying to create account");
	NSLog(@" name %@", name.text);
	NSLog(@" address1 %@ ", address1.text);
	NSLog(@" address2  %@ ", address2.text);
	NSLog(@" creator name  %@ ", creator.text);
	NSLog(@" creator phone number  %@ ", creator_num.text);
	NSLog(@" Creator UDID %@ ", [User instance].UDID);
	
	[name resignFirstResponder];
	[address1 resignFirstResponder];
	[address2 resignFirstResponder];
	[creator resignFirstResponder];
	[creator_num resignFirstResponder];
	NSLog(@"validation for buttonClicked");
	
	if(name.text.length == 0 ||
	   address1.text.length == 0 ||
	   address2.text.length == 0 ||
	   creator.text.length == 0 ||
	   creator_num.text.length == 0)
	{
		
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle: @"Error Adding Account "
							  message: @"Please enter all required fields !"
							  delegate: nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	// Creation of the query string containing all the variables including UDID
	NSMutableString * query = [[NSMutableString alloc ]initWithFormat:@"account_name="] ;
	[query appendString:(@"%@",name.text)];
	[query appendString:@"&account_address1="];
	[query appendString:(@"%@",address1.text)];
	[query appendString:@"&account_address2="];
	[query appendString:(@"%@",address2.text)];
	[query appendString:@"&creator_name="];
	[query appendString:(@"%@",creator.text)];
	[query appendString:@"&creator_num="];
	[query appendString:(@"%@",creator_num.text)];
	[query appendString:@"&UDID="];
	[query appendString:(@"%@",[User instance].UDID)];
	[query appendString:@"&request_type=creation"];
	
	User *user = [User instance];
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	@try{
		NSString *response  = [del remoteRequest:query] ;
		NSLog(@"Reply from add account %@", response);
		
	    //save data
		user.accountData = [[AccountData alloc] init];
		user.accountData.account_name = name.text;
		user.accountData.address1 = address1.text;
		user.accountData.address2 = address2.text;
		user.accountData.creator_name = creator.text;
		user.accountData.phone_number = creator_num.text;
		user.accountData.account_id = [response intValue];
		user.accountData.active_roomies_number = 1;
		
		[del displayMainApplicationTab];
		[del loadRoomiesData];
		
	}
	@catch (NSException * e) 
	{
		NSLog(@"adding account exception caught");
		//display the reason why server cannot send back correct XML file
		NSLog(@"exception: %@", [e reason]);
		
		// if we can identify the error, we can present a more precise message to the user.
		NSDictionary *userInfo =
		[NSDictionary dictionaryWithObject:
		 NSLocalizedString(@"Error adding account",
						   @"Error message displayed when have issues to add account.")
									forKey:NSLocalizedDescriptionKey];
		
		NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
											 code:kCFURLErrorNotConnectedToInternet
										 userInfo:userInfo];
		
		[del handleError:error];
	}
	//handle fail for account creation.........
	
	// check response 
	/* mode = 0;
	 
	 addRommies.hidden = FALSE;
	 viewRoomies.hidden = FALSE;
	 deleteRommies.hidden = FALSE;
	 mapButton.hidden = FALSE;
	 
	 name.enabled = FALSE;
	 address1.enabled = FALSE;
	 address2.enabled = FALSE;
	 creator.enabled = FALSE;
	 creator_num.enabled = FALSE;
	 
	 self.navigationItem.rightBarButtonItem.enabled = FALSE; */
	
	/* save data
	 user.accountData = [[AccountData alloc] init];
	 user.accountData.account_name = name.text;
	 user.accountData.address1 = address1.text;
	 user.accountData.address2 = address2.text;
	 user.accountData.creator_name = creator.text;
	 user.accountData.phone_number = creator_num.text;
	 
	 RoomiesAppDelegate *del = [[UIApplication sharedApplication] delegate];
	 [del displayMainApplicationTab]; */
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
	NSLog(@"ACCOUNT receive reply from add account, didReceiveResponse");
	
}	

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
	//[responseData appendData:data];
	
	NSLog(@"ACCOUNT didReceiveData ");
} 

/* NOT USED */
- (IBAction) mapClicked:(id) sender
{
	NSLog(@" mapClicked ");
	
	if(forwardGeocoder == nil)
	{
		forwardGeocoder = [[BSForwardGeocoder alloc] initWithDelegate:self];
	}
	
	// Forward geocode!
	User *user = [User instance];
	NSMutableString *address_str = [[NSMutableString alloc] init];
	[address_str appendString:[user.accountData.address1 mutableCopy]]; 
	[address_str appendString:[@" " mutableCopy]]; 
	[address_str appendString:[user.accountData.address2 mutableCopy]]; 
	
	//NSString *address_str = user.accountData.address1 + @" " + user.accountData.address2;
	NSLog(@" address %@ ", address_str);
	[forwardGeocoder findLocation:address_str];
	[address_str release];
}

-(void)displayLocationOnMap:(MKCoordinateRegion)region
{
	NSLog(@" displayLocationOnMap is called ");
	mapView.hidden = FALSE;
	
	//MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.2;
	span.longitudeDelta=0.2;
	
	/*CLLocationCoordinate2D currentLocation;
	 location.latitude = 70;
	 location.longitude = 30;*/
	
	//CLLocationCoordinate2D currentLocation = [self getCurrentLocation];
	/*NSString* address = @"123 Main St., New York, NY, 10001";
	 NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%@",
	 currentLocation.latitude, currentLocation.longitude,
	 [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	 [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];*/
	
	
	
	/*region.span=span;
	 region.center=location;
	 if(addAnnotation != nil) 
	 {
	 [mapView removeAnnotation:addAnnotation];
	 [addAnnotation release];
	 addAnnotation = nil;
	 }
	 addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
	 
	 [mkMapView addAnnotation:addAnnotation];*/
	
	[mkMapView setRegion:region animated:TRUE];
	[mkMapView regionThatFits:region]; 
	
	mkMapView.showsUserLocation=TRUE;
	mkMapView.delegate=self;
	
	//[self.accountView addSubview:mapView];
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	[del.settingsNavController pushViewController:mapController animated:YES];	
}

/* MAP */
/*- (MKAnnotationView *) mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>) annotation
 {
 NSLog(@"here in viewForAnnotation");
 MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
 annView.pinColor = MKPinAnnotationColorGreen;
 annView.animatesDrop=TRUE;
 annView.canShowCallout = YES;
 annView.calloutOffset = CGPointMake(-5, 5);
 return annView;
 }*/


-(void)forwardGeocoderError:(NSString *)errorMessage
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" 
													message:errorMessage
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
	
}

-(void)forwardGeocoderFoundLocation
{
	if(forwardGeocoder.status == G_GEO_SUCCESS)
	{
		int searchResults = [forwardGeocoder.results count];
		
		// Add placemarks for each result
		for(int i = 0; i < searchResults; i++)
		{
			BSKmlResult *place = [forwardGeocoder.results objectAtIndex:i];
			
			// Add a placemark on the map
			CustomPlacemark *placemark = [[[CustomPlacemark alloc] initWithRegion:place.coordinateRegion] autorelease];
			placemark.title = place.address;
			[mkMapView addAnnotation:placemark];	
			
			NSArray *countryName = [place findAddressComponent:@"country"];
			if([countryName count] > 0)
			{
				NSLog(@"Country: %@", ((BSAddressComponent*)[countryName objectAtIndex:0]).longName );
			}
		}
		
		NSLog(@"forwardGeocoderFoundLocation result count = %d", [forwardGeocoder.results count]);
		if([forwardGeocoder.results count] == 1)
		{
			BSKmlResult *place = [forwardGeocoder.results objectAtIndex:0];
			MKCoordinateRegion region = place.coordinateRegion;
			// Zoom into the location		
			//[mapView setRegion:place.coordinateRegion animated:TRUE];
			[self displayLocationOnMap:region];
		}
		
	}
	else {
		NSString *message = @"";
		
		switch (forwardGeocoder.status) {
			case G_GEO_BAD_KEY:
				message = @"The API key is invalid.";
				break;
				
			case G_GEO_UNKNOWN_ADDRESS:
				message = [NSString stringWithFormat:@"Could not find %@", forwardGeocoder.searchQuery];
				break;
				
			case G_GEO_TOO_MANY_QUERIES:
				message = @"Too many queries has been made for this API key.";
				break;
				
			case G_GEO_SERVER_ERROR:
				message = @"Server error, please try again.";
				break;
				
				
			default:
				break;
		}
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" 
														message:message
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}


- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
	
	if([annotation isKindOfClass:[CustomPlacemark class]])
	{
		MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[annotation title]];
		newAnnotation.pinColor = MKPinAnnotationColorGreen;
		newAnnotation.animatesDrop = YES; 
		newAnnotation.canShowCallout = FALSE;
		newAnnotation.enabled = YES;
		
		
		NSLog(@"Created annotation at: %f", ((CustomPlacemark*)annotation).coordinate.latitude);
		
		[newAnnotation addObserver:self
						   forKeyPath:@"selected"
						   options:NSKeyValueObservingOptionNew
						   context:@"GMAP_ANNOTATION_SELECTED"];
		
		[newAnnotation autorelease];
		
		return newAnnotation;
	}
	
	return nil;
}


- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context{
	
	NSString *action = (NSString*)context;
	
	
	if([action isEqualToString:@"GMAP_ANNOTATION_SELECTED"]) 
	{
		if([((MKAnnotationView*) object).annotation isKindOfClass:[CustomPlacemark class]])
		{
			CustomPlacemark *place = ((MKAnnotationView*) object).annotation;
			
			// Zoom into the location		
			[mkMapView setRegion:place.coordinateRegion animated:TRUE];
			NSLog(@"annotation selected %f, %f", 
				  ((MKAnnotationView*) object).annotation.coordinate.latitude, 
				  ((MKAnnotationView*) object).annotation.coordinate.longitude);
		}
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
	NSLog(@"APP didFailWithError: code=%d domain=%@ userInfo=%@ ", error.code, error.domain, error.userInfo );
	
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
    if (error.code == kCFURLErrorNotConnectedToInternet) 
	{
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:
         NSLocalizedString(@"No Connection Error",
                           @"Error message displayed when not connected to the Internet.")
                                    forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
														 code:kCFURLErrorNotConnectedToInternet
													 userInfo:userInfo];
		
        [del handleError:noConnectionError];
    } 
	else 
	{
        // otherwise handle the error generically
        [del handleError:error];
    }
} 

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
	NSLog(@"APP connectionDidFinishLoading");
} 


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	NSLog(@"Leaving .....account");
}


- (void)dealloc 
{
	NSLog(@"dealloc called");
	[name release];
	[address1 release];
	[address2 release];
	[creator release];
	[creator_num release];
	[addRommies release];
	[viewRoomies release];
	[deleteRommies release];
	
	[invitLbl release];
	[acceptButton release];
	[ignoreButton release];
	[mapButton release];
	[mapView release];
	[accountView release];
	[mapController release];
	[roomiesViewController release];
	[inviteController release];
	[account release];
	
    [super dealloc];
	NSLog(@"dealloc leaving");
}


@end
