//
//  ReadingWavesTests.m
//  ReadingWavesTests
//
//  Created by Matthew Iannucci on 1/7/16.
//  Copyright © 2016 Matthew Iannucci. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BookModel.h"
#import "Book.h"

@interface ReadingWavesTests : XCTestCase

@end

@implementation ReadingWavesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testBookModelFetch {
    BookModel *bookModel = [BookModel sharedModel];
    XCTAssert([bookModel fetchBooks]);
    
    for (Book* book in bookModel.books) {
        XCTAssert([book fetchDetails]);
    }
}

@end
