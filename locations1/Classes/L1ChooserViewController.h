//
//  L1ChooserViewController.h
//  locations1
//
//  Created by Joe Zuntz on 11/04/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface L1ChooserViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    UITableView *scenarioTable;
    NSArray * scenarioList;
    NSDictionary * scenarioURLs;
    NSUInteger numberOfScenarios;

}
@property (retain) NSArray * scenarioList;
@property (nonatomic, retain) IBOutlet UITableView *scenarioTable;

@end
