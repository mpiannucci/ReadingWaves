//
//  DetailViewController.m
//  ReadingWaves
//
//  Created by Matthew Iannucci on 1/7/16.
//  Copyright © 2016 Matthew Iannucci. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishersLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageCountLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBook:(Book *)newBook {
    if (_book != newBook) {
        _book = newBook;
        
        // Update the view.
        [self configureView];
    }
}

- (void)setCoverImage {
    if (self.book.coverImage != nil) {
        self.coverImageView.image = self.book.coverImage;
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (!self.book) {
        return;
    }
    
    // Fix the title
    self.navigationItem.title = self.book.title;
        
    // Load the cover image! IF there is not one cached in the book object then load it
    // in asynchronously.
    if (self.book.coverImage == nil) {
        NSURL *coverimageURL = [NSURL URLWithString:self.book.coverArtURL];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Download the image and transform it from NSData to an image we can place in the imageview
            NSData *rawImageData = [NSData dataWithContentsOfURL:coverimageURL];
            if (rawImageData == nil) {
                NSLog(@"Could not download cover art");
                return;
            }
            
            // Transform the data to an image
            self.book.coverImage = [UIImage imageWithData:rawImageData];
            if (self.book.coverImage == nil) {
                NSLog(@"Could not convert data to cover image");
            }
            
            // Switch the the main queue and set the image
            [self performSelectorOnMainThread:@selector(setCoverImage) withObject:nil waitUntilDone:YES];
        });
    } else {
        [self setCoverImage];
    }
    
    // Display the rest of the data from the object
    self.subtitleLabel.text = self.book.subtitle;
    self.authorLabel.text = self.book.author;
    self.publishDateLabel.text = self.book.publishDate;
    self.publishersLabel.text = self.book.publishers;
    if (self.book.pageCount != nil) {
        self.pageCountLabel.text = [NSString stringWithFormat:@"%@ pages", self.book.pageCount];
    }
}

@end
