//
//  L1ScenarioChooserView.h
//  locations1
//
//  Created by Joe Zuntz on 12/05/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L1ScenarioList.h"


@interface L1ScenarioChooserViewController : UIViewController<UITableViewDelegate> {
    NSObject * delegate;
    IBOutlet UINavigationItem *scenarioTitleBar;
    IBOutlet UIImageView *scenarioImageView;
    IBOutlet UITextView *scenarioText;
    IBOutlet UITableView *chooserTable;
    L1ScenarioList *scenarioList;
    IBOutlet UIButton *goButton;
    
}
@property (retain) NSObject * delegate;
- (IBAction)startScenario:(id)sender;
-(void) scenarioListDidFinishedLoading:(L1ScenarioList*) completedList;
@end
