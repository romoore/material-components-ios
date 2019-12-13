// Copyright 2019-present the Material Components for iOS authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <XCTest/XCTest.h>

#import "MDCChipView.h"

/** A short Chip title in Latin characters. */
static NSString *kShortChipTitleLatin = @"Chip";

/** Creates an all-white image of the specified size. */
static UIImage *CreateImageOfSize(CGSize size) {
  CGSize imageSize = size;
  UIGraphicsBeginImageContext(imageSize);
  [UIColor.whiteColor setFill];
  UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

/** Unit tests for @c MDCChipView layout methods and related APIs. */
@interface MDCChipViewLayoutTests : XCTestCase

/** The Chip being tested. */
@property(nonatomic, strong) MDCChipView *testChip;

/** A Chip used as a reference to compare @c testChip. */
@property(nonatomic, strong) MDCChipView *referenceChip;

@end

@implementation MDCChipViewLayoutTests

- (void)setUp {
  [super setUp];

  self.testChip = [[MDCChipView alloc] init];
  self.testChip.titleLabel.text = kShortChipTitleLatin;
  self.testChip.contentPadding = UIEdgeInsetsZero;
  self.testChip.imagePadding = UIEdgeInsetsZero;
  self.testChip.titlePadding = UIEdgeInsetsZero;
  self.testChip.accessoryPadding = UIEdgeInsetsZero;

  self.referenceChip = [[MDCChipView alloc] init];
  self.referenceChip.titleLabel.text = kShortChipTitleLatin;
  self.referenceChip.contentPadding = UIEdgeInsetsZero;
  self.referenceChip.imagePadding = UIEdgeInsetsZero;
  self.referenceChip.titlePadding = UIEdgeInsetsZero;
  self.referenceChip.accessoryPadding = UIEdgeInsetsZero;
}

- (void)tearDown {
  self.referenceChip = nil;
  self.testChip = nil;

  [super tearDown];
}

- (UIImage *)testImage24Points {
  static UIImage *image;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    image = CreateImageOfSize(CGSizeMake(24, 24));
  });
  return image;
}

- (UIImage *)testImage18Points {
  static UIImage *image;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    image = CreateImageOfSize(CGSizeMake(18, 18));
  });
  return image;
}

- (void)assertChip:(MDCChipView *)testChip
    hasIdenticalLabelAndAccessoryLayoutToChip:(MDCChipView *)referenceChip {
  XCTAssertTrue(CGRectEqualToRect(testChip.bounds, referenceChip.bounds),
                @"(%@) is not equal to (%@)", NSStringFromCGRect(testChip.bounds),
                NSStringFromCGRect(referenceChip.bounds));
  XCTAssertTrue(CGRectEqualToRect(testChip.titleLabel.frame, referenceChip.titleLabel.frame),
                @"(%@) is not equal to (%@)", NSStringFromCGRect(testChip.titleLabel.frame),
                NSStringFromCGRect(referenceChip.titleLabel.frame));
  XCTAssertTrue(CGRectEqualToRect(testChip.accessoryView.frame, referenceChip.accessoryView.frame),
                @"(%@) is not equal to (%@)", NSStringFromCGRect(testChip.accessoryView.frame),
                NSStringFromCGRect(referenceChip.accessoryView.frame));
}

#pragma mark - imagePadding

- (void)testImageEqualSizeToSelectedImagePositionsFramesCorrectlyWithImageInsetsZero {
  // When
  self.referenceChip.imageView.image = [self testImage24Points];
  self.testChip.imageView.image = [self testImage24Points];
  self.testChip.selectedImageView.image = [self testImage24Points];

  // Then
  [self.referenceChip sizeToFit];
  [self.referenceChip layoutIfNeeded];
  [self.testChip sizeToFit];
  [self.testChip layoutIfNeeded];
  [self assertChip:self.testChip hasIdenticalLabelAndAccessoryLayoutToChip:self.referenceChip];
  XCTAssertTrue(CGRectEqualToRect(self.testChip.imageView.frame, self.referenceChip.imageView.frame),
                @"(%@) is not equal to (%@)", NSStringFromCGRect(self.testChip.imageView.frame),
                NSStringFromCGRect(self.referenceChip.imageView.frame));
  XCTAssertTrue(CGRectEqualToRect(self.testChip.selectedImageView.frame, self.referenceChip.imageView.frame),
                @"(%@) is not equal to (%@)", NSStringFromCGRect(self.testChip.selectedImageView.frame),
                NSStringFromCGRect(self.referenceChip.imageView.frame));
}

- (void)testImageLargerThanSelectedImagePositionsFramesCorrectlyWithImageInsetsZero {
  // When
  self.referenceChip.imageView.image = [self testImage24Points];
  self.testChip.imageView.image = [self testImage24Points];
  self.testChip.selectedImageView.image = [self testImage18Points];

  // Then
  [self.referenceChip sizeToFit];
  [self.referenceChip layoutIfNeeded];
  [self.testChip sizeToFit];
  [self.testChip layoutIfNeeded];
  [self assertChip:self.testChip hasIdenticalLabelAndAccessoryLayoutToChip:self.referenceChip];
  XCTAssertTrue(CGRectEqualToRect(self.testChip.imageView.frame, self.referenceChip.imageView.frame),
                @"(%@) is not equal to (%@)", NSStringFromCGRect(self.testChip.imageView.frame),
                NSStringFromCGRect(self.referenceChip.imageView.frame));
  XCTAssertTrue(CGPointEqualToPoint(self.testChip.selectedImageView.frame.origin, self.referenceChip.imageView.frame.origin),
                @"(%@) is not equal to (%@)", NSStringFromCGPoint(self.testChip.selectedImageView.frame.origin),
                NSStringFromCGPoint(self.referenceChip.imageView.frame.origin));
}

- (void)testImageSmallerThanSelectedImagePositionsFramesCorrectlyWithImageInsetsZero {
  // When
  self.referenceChip.imageView.image = [self testImage24Points];
  self.testChip.imageView.image = [self testImage18Points];
  self.testChip.selectedImageView.image = [self testImage24Points];

  // Then
  [self.referenceChip sizeToFit];
  [self.referenceChip layoutIfNeeded];
  [self.testChip sizeToFit];
  [self.testChip layoutIfNeeded];
  [self assertChip:self.testChip hasIdenticalLabelAndAccessoryLayoutToChip:self.referenceChip];
  
}

- (void)testOnlySelectedImagePositionsFramesCorrectlyWithImageInsetsZero {
  // When
  self.referenceChip.imageView.image = [self testImage24Points];
  self.testChip.selectedImageView.image = [self testImage24Points];
  self.testChip.selected = YES;

  // Then
  [self.referenceChip sizeToFit];
  [self.referenceChip layoutIfNeeded];
  [self.testChip sizeToFit];
  [self.testChip layoutIfNeeded];
  [self assertChip:self.testChip hasIdenticalLabelAndAccessoryLayoutToChip:self.referenceChip];
}

@end
