//
//  VenueCell.h
//  
//
//  Created by Edo/Imju on 10/31/13.
//
//

#import <UIKit/UIKit.h>

@interface VenueCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
