//
//  MediaListViewController.m
//  locations1
//
//  Created by Joe Zuntz on 31/05/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "MediaListViewController.h"


NSString * resourceNodeStringIdentifier = @"resourceNode";

@implementation MediaListViewController
@synthesize node;


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!node) return 0;
    return [node.resources count]+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    - (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:resourceNodeStringIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resourceNodeStringIdentifier];
    }
    
    NSInteger i = [indexPath indexAtPosition:1];
    if (i==0){
            cell.textLabel.text=@"Description";
    }
    else{
        L1Resource * resource = [node.resources objectAtIndex:i-1];
        cell.textLabel.text = resource.name;
        cell.detailTextLabel.text = resource.url;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Node Resources";
}


@end
