//
//  L1ChooserViewController.m
//  locations1
//
//  Created by Joe Zuntz on 11/04/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1ChooserViewController.h"
#import "locations1AppDelegate.h"

@implementation L1ChooserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        scenarioList = [[NSArray arrayWithObjects: @"Pub Time!", @"Highbrow Literature.", @"Pulp Fiction" ,nil] retain];
        
//        NSArray * pathURLs = [NSArray arrayWithObjects:@"/paths.json",@"lit_url",@"pulp_url" ,nil];
//        NSArray * nodeURLs = [NSArray arrayWithObjects:@"/nodes.json",@"lit_url",@"pulp_url" ,nil];

//        scenarioURLs = [[NSDictionary dictionaryWithObjects:urls forKeys:scenarioList] retain];
        numberOfScenarios = [scenarioList count];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"scenarioCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSUInteger index = [indexPath indexAtPosition:1];
    if (index<numberOfScenarios)  cell.textLabel.text = [scenarioList objectAtIndex:index];
    NSLog(@"Generated cell %d",index);
    return [cell autorelease];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return numberOfScenarios;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [indexPath indexAtPosition:1];
    if (index>0){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Question" message:@"Are you sure you wouldn't prefer to go the pub?" delegate:self cancelButtonTitle:@"Yes." otherButtonTitles: nil];
        [alert show];
        [alert autorelease];
        return;
    }
    locations1AppDelegate * appDelegate = (locations1AppDelegate*)[[UIApplication sharedApplication] delegate];
//    NSString * scenarioName = [scenarioList objectAtIndex:index];
//    NSString * url = [scenarioURLs objectForKey:scenarioName];
    [appDelegate selectScenarioURL:@"dummy"];
    [self dismissModalViewControllerAnimated:YES];
}

@synthesize scenarioList, scenarioTable;

@end
