//
//  MPSearchResultDestinationCell.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 06/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPSearchResultDestinationCell.h"
#import "SKSearchResult+MPString.h"

@implementation MPSearchResultDestinationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [Constantes blueBackGround];
    self.imageView.tintColor = self.textLabel.textColor = self.button.tintColor = [UIColor whiteColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.textLabel.font = [UIFont fontWithName:FONT_MEDIUM size:13.0];
    self.textLabel.numberOfLines = 2;
    
    self.button.titleLabel.font = [UIFont fontWithName:FONT_MEDIUM size:16.0];
    [self.button setHidden:YES];
    // Initialization code
}

- (void)setHistory:(MPHistory *)history {
    _stopArea = nil;
    _searchResult = nil;
    _history = history;
    self.textLabel.text = [history name];
    self.imageView.image = [UIImage imageNamed:@"icon-history"];
    [self.button setHidden:NO];
    [self layoutIfNeeded];
}

- (void)setStopArea:(MPStopArea *)stopArea {
    _stopArea = stopArea;
    _searchResult = nil;
    _history = nil;
    self.textLabel.text = [stopArea name];
    self.imageView.image = [UIImage imageNamed:@"icon-metro"];
    [self.button setHidden:NO];
    [self layoutIfNeeded];
}

- (void)setSearchResult:(SKSearchResult *)searchResult {
    _searchResult = searchResult;
    _stopArea = nil;
    _history = nil;
    self.imageView.image = [UIImage imageNamed:@"icon-pin"];
    self.textLabel.text = [searchResult toString];
    [self.button setHidden:NO];
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    self.imageView.frame = CGRectMake(0.0, [self getHeight]/4, [self getHeight], [self getHeight]/2);
    self.textLabel.frame = CGRectMake([self.imageView endOffX], 0, [self getWidth]-([self.imageView endOffX]+[self.button getWidth]), [self getHeight]);
}

- (IBAction)tapOnButton:(id)sender {
    if (self.searchResult != nil && self.delegate && [self.delegate respondsToSelector:@selector(searchResultDestinationCellTapOnSearchResult:)]) {
        [self.delegate searchResultDestinationCellTapOnSearchResult:self.searchResult];
    } else if (self.stopArea != nil && self.delegate && [self.delegate respondsToSelector:@selector(searchResultDestinationCellTapOnStopArea:)]) {
        [self.delegate searchResultDestinationCellTapOnStopArea:self.stopArea];
    } else if (self.history != nil && self.delegate && [self.delegate respondsToSelector:@selector(searchResultDestinationCellTapOnHistory:)]) {
        [self.delegate searchResultDestinationCellTapOnHistory:self.history];
    }
}

@end
