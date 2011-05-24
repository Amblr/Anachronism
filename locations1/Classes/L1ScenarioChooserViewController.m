//
//  L1ScenarioChooserView.m
//  locations1
//
//  Created by Joe Zuntz on 12/05/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1ScenarioChooserViewController.h"
#import "MainViewController.h"
#import "L1ScenarioList.h"

@implementation L1ScenarioChooserViewController
@synthesize delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        scenarioList = [[L1ScenarioList alloc] initWithURL:@"http://warm-earth-179.heroku.com/scenarios.json"];
//        scenarioList = [[L1ScenarioList alloc] initWithFakeScenario];
        scenarioList.delegate = self;
//        [self scenarioListDidFinishedLoading:scenarioList];
    }
    return self;
}

- (void)dealloc
{
    [scenarioText release];
    [scenarioImageView release];
    [chooserTable release];
    [scenarioTitleBar release];
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
    chooserTable.delegate = self;
    chooserTable.dataSource = scenarioList;
    
    //Set initially chosen item.
//    [chooserTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    
//    [chooserTable  selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition

    // Do any additional setup after loading the view from its nib.
}


-(void) scenarioListDidFinishedLoading:(L1ScenarioList*) completedList
{
    [chooserTable reloadData];
    //- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    NSUInteger paths[2] = {0,0};
    NSIndexPath * indexPath = [NSIndexPath indexPathWithIndexes:paths length:2];
    [chooserTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    //- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    [self tableView:chooserTable didSelectRowAtIndexPath:indexPath];
    //    NSUInteger startIndices[2] = {0,0};
//    NSIndexPath * indexPath = [NSIndexPath indexPathWithIndexes:startIndices length:2];
}


- (void)viewDidUnload
{
    [scenarioImageView release];
    scenarioImageView = nil;
    [chooserTable release];
    chooserTable = nil;
    [scenarioTitleBar release];
    scenarioTitleBar = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)startScenario:(id)sender {
    NSInteger item = [[chooserTable indexPathForSelectedRow]  indexAtPosition:1];
    NSString * ID = [scenarioList.IDs objectAtIndex:item];
    if ([delegate respondsToSelector:@selector(chooseScenario:)]){
        [delegate performSelector:@selector(chooseScenario:) withObject:ID];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger item = [indexPath indexAtPosition:1];
    scenarioImageView.image = [scenarioList.images objectAtIndex:item];
    scenarioText.text = [scenarioList.descriptions objectAtIndex:item];
    scenarioTitleBar.title = [scenarioList.titles objectAtIndex:item];
}

@end
