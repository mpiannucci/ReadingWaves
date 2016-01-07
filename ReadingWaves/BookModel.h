//
//  BookModel.h
//  ReadingWaves
//
//  Created by Matthew Iannucci on 1/7/16.
//  Copyright © 2016 Matthew Iannucci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookModel : NSObject

@property (strong, readonly, nonatomic) NSMutableArray *books;

- (BOOL) fetchBooks;
+ (instancetype) sharedModel;

@end
