//
//  MasterViewController.m
//  ReadingWaves
//
//  Created by Matthew Iannucci on 1/7/16.
//  Copyright © 2016 Matthew Iannucci. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "BookModel.h"
#import "Book.h"

@interface MasterViewController ()

@property BookModel *bookModel;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set up the child view controller
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // Get the model for the data and fetch all the titles asynchronously.
    self.bookModel = [BookModel sharedModel];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Download the book data using the model
        BOOL successfulFetch = [self.bookModel fetchBooks];
        
        // If the fetch worked, reload the table to show the books we found!
        if (successfulFetch) {
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
    });
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        // Get the selected book object
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Book *selectedBook = [self.bookModel.books objectAtIndex:indexPath.row];
        
        // Set up the back button on the detail controller
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setBook:selectedBook];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bookModel.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Book *thisBook = [self.bookModel.books objectAtIndex:indexPath.row];
    cell.textLabel.text = thisBook.title;
    cell.detailTextLabel.text = thisBook.author;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

@end
