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

@interface MDCChipViewTests : XCTestCase

@end

@implementation MDCChipViewTests

- (UIImage *)testImage24Points {
  static UIImage *image;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    CreateImageOfSize(CGSizeMake(24, 24));
  });
  return image;
}

- (UIImage *)testImage18Points {
  static UIImage *image;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    CreateImageOfSize(CGSizeMake(18, 18));
  });
  return image;
}

- (void)assertChip:(MDCChipView *)testChip hasIdenticalLayoutToChip:(MDCChipView *)referenceChip {
  XCTAssertTrue(CGRectEqualToRect(testChip.bounds, referenceChip.bounds),
                @"(%@) is not equal to (%@)", NSStringFromCGRect(testChip.bounds),
                NSStringFromCGRect(referenceChip.bounds));
  XCTAssertTrue(CGRectEqualToRect(testChip.imageView.frame, referenceChip.imageView.frame),
                @"(%@) is not equal to (%@)", NSStringFromCGRect(testChip.imageView.frame),
                NSStringFromCGRect(referenceChip.imageView.frame));
  XCTAssertTrue(CGRectEqualToRect(testChip.selectedImageView.frame, referenceChip.imageView.frame),
                @"(%@) is not equal to (%@)", NSStringFromCGRect(testChip.selectedImageView.frame),
                NSStringFromCGRect(referenceChip.selectedImageView.frame));
  XCTAssertTrue(CGRectEqualToRect(testChip.titleLabel.frame, referenceChip.titleLabel.frame),
                @"(%@) is not equal to (%@)", NSStringFromCGRect(testChip.titleLabel.frame),
                NSStringFromCGRect(referenceChip.titleLabel.frame));
  XCTAssertTrue(CGRectEqualToRect(testChip.accessoryView.frame, referenceChip.accessoryView.frame),
                @"(%@) is not equal to (%@)", NSStringFromCGRect(testChip.accessoryView.frame),
                NSStringFromCGRect(referenceChip.accessoryView.frame));
}

#pragma mark - contentPadding

- (void)testPositiveAccessoryPaddingTopIncreasesChipHeight {
  // Given
  MDCChipView *chipView = [[MDCChipView alloc] init];
  UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  chipView.accessoryView = accessoryView;
  CGSize originalSize = [chipView sizeThatFits:CGRectInfinite.size];

  // When
  chipView.accessoryPadding = UIEdgeInsetsMake(10, 0, 0, 0);
  CGSize fitSize = [chipView sizeThatFits:CGRectInfinite.size];
  CGSize expectedSize =
      CGSizeMake(originalSize.width, originalSize.height + chipView.accessoryPadding.top);

  // Then
  XCTAssertEqualWithAccuracy(fitSize.height, expectedSize.height, 0.001);
}

- (void)testPositiveAccessoryPaddingLeftIncreasesChipWidth {
  // Given
  MDCChipView *chipView = [[MDCChipView alloc] init];
  UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  chipView.accessoryView = accessoryView;
  CGSize originalSize = [chipView sizeThatFits:CGRectInfinite.size];

  // When
  chipView.accessoryPadding = UIEdgeInsetsMake(0, 10, 0, 0);
  CGSize fitSize = [chipView sizeThatFits:CGRectInfinite.size];
  CGSize expectedSize =
      CGSizeMake(originalSize.width + chipView.accessoryPadding.left, originalSize.height);

  // Then
  XCTAssertEqualWithAccuracy(fitSize.width, expectedSize.width, 0.001);
}

- (void)testPositiveAccessoryPaddingBottomIncreasesChipHeight {
  // Given
  MDCChipView *chipView = [[MDCChipView alloc] init];
  UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  chipView.accessoryView = accessoryView;
  CGSize originalSize = [chipView sizeThatFits:CGRectInfinite.size];

  // When
  chipView.accessoryPadding = UIEdgeInsetsMake(0, 0, 10, 0);
  CGSize fitSize = [chipView sizeThatFits:CGRectInfinite.size];
  CGSize expectedSize =
      CGSizeMake(originalSize.width, originalSize.height + chipView.accessoryPadding.bottom);

  // Then
  XCTAssertEqualWithAccuracy(fitSize.height, expectedSize.height, 0.001);
}

- (void)testPositiveAccessoryPaddingRightIncreasesChipWidth {
  // Given
  MDCChipView *chipView = [[MDCChipView alloc] init];
  UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  chipView.accessoryView = accessoryView;
  CGSize originalSize = [chipView sizeThatFits:CGRectInfinite.size];

  // When
  chipView.accessoryPadding = UIEdgeInsetsMake(0, 0, 0, 10);
  CGSize fitSize = [chipView sizeThatFits:CGRectInfinite.size];
  CGSize expectedSize =
      CGSizeMake(originalSize.width + chipView.accessoryPadding.right, originalSize.height);

  // Then
  XCTAssertEqualWithAccuracy(fitSize.width, expectedSize.width, 0.001);
}

#pragma mark - imagePadding

- (void)testImageEqualSizeToSelectedImagePositionsFramesCorrectlyWithImageInsetsZero {
  // Given
  MDCChipView *referenceChip = [[MDCChipView alloc] init];
  MDCChipView *testChip = [[MDCChipView alloc] init];
  referenceChip.titleLabel.text = kShortChipTitleLatin;
  testChip.titleLabel.text = kShortChipTitleLatin;

  // When
  referenceChip.imageView.image = [self testImage24Points];
  testChip.imageView.image = [self testImage24Points];
  testChip.selectedImageView.image = [self testImage24Points];
  [referenceChip sizeToFit];
  [testChip sizeToFit];

  // Then
  [self assertChip:testChip hasIdenticalLayoutToChip:referenceChip];
}

- (void)testImageLargerThanSelectedImagePositionsFramesCorrectlyWithImageInsetsZero {
  // Given
  MDCChipView *referenceChip = [[MDCChipView alloc] init];
  MDCChipView *testChip = [[MDCChipView alloc] init];
  referenceChip.titleLabel.text = kShortChipTitleLatin;
  testChip.titleLabel.text = kShortChipTitleLatin;

  // When
  referenceChip.imageView.image = [self testImage24Points];
  testChip.imageView.image = [self testImage24Points];
  testChip.selectedImageView.image = [self testImage24Points];
  [referenceChip sizeToFit];
  [testChip sizeToFit];

  // Then
  [self assertChip:testChip hasIdenticalLayoutToChip:referenceChip];
}


#pragma mark - MaterialElevation

- (void)testDefaultValueForOverrideBaseElevationIsNegative {
  // Given
  MDCChipView *chip = [[MDCChipView alloc] init];

  // Then
  XCTAssertLessThan(chip.mdc_overrideBaseElevation, 0);
}

- (void)testSettingOverrideBaseElevationReturnsSetValue {
  // Given
  MDCChipView *chip = [[MDCChipView alloc] init];
  CGFloat expectedBaseElevation = 99;

  // When
  chip.mdc_overrideBaseElevation = expectedBaseElevation;

  // Then
  XCTAssertEqualWithAccuracy(chip.mdc_overrideBaseElevation, expectedBaseElevation, 0.001);
}

- (void)testCurrentElevationMatchesElevationForState {
  // Given
  MDCChipView *chip = [[MDCChipView alloc] init];

  // When
  UIControlState allStatesCombined = UIControlStateNormal | UIControlStateDisabled |
                                     UIControlStateSelected | UIControlStateHighlighted;
  MDCShadowElevation startingElevation = 100;

  for (NSUInteger state = 0; state <= allStatesCombined; ++state) {
    [chip setElevation:startingElevation + state forState:state];
  }

  // Then
  for (NSUInteger state = 0; state <= allStatesCombined; ++state) {
    if (state & (UIControlStateDisabled | UIControlStateHighlighted)) {
      continue;
    }
    chip.enabled = (state & UIControlStateDisabled) == UIControlStateDisabled ? NO : YES;
    chip.selected = (state & UIControlStateSelected) == UIControlStateSelected ? YES : NO;
    chip.highlighted = (state & UIControlStateHighlighted) == UIControlStateHighlighted ? YES : NO;
    XCTAssertEqualWithAccuracy(chip.mdc_currentElevation, [chip elevationForState:state], 0.001);
  }
}

- (void)testElevationDidChangeBlockCalledWhenStateChangeCausesElevationChange {
  // Given
  MDCChipView *chip = [[MDCChipView alloc] init];
  [chip setElevation:1 forState:UIControlStateNormal];
  [chip setElevation:9 forState:UIControlStateSelected];
  __block CGFloat newElevation = 0;
  chip.mdc_elevationDidChangeBlock = ^(MDCChipView *object, CGFloat elevation) {
    newElevation = elevation;
  };

  // When
  chip.selected = YES;

  // Then
  XCTAssertEqualWithAccuracy(newElevation, [chip elevationForState:UIControlStateSelected], 0.001);
}

- (void)testElevationDidChangeBlockNotCalledWhenStateChangeDoesNotCauseElevationChange {
  // Given
  MDCChipView *chip = [[MDCChipView alloc] init];
  [chip setElevation:1 forState:UIControlStateNormal];
  [chip setElevation:1 forState:UIControlStateHighlighted];
  __block BOOL blockCalled = NO;
  chip.mdc_elevationDidChangeBlock = ^(MDCChipView *object, CGFloat elevation) {
    blockCalled = YES;
  };

  // When
  chip.highlighted = YES;

  // Then
  XCTAssertFalse(blockCalled);
}

@end
