//
//  SPhotoRemoteViewController.h
//  STKitDemo
//
//  Created by SunJiangting on 13-11-13.
//  Copyright (c) 2012年 sun. All rights reserved.
//

@interface STDWaterStreamViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView * photoImageView;

@property (nonatomic, strong) NSDictionary * photoDictionary;

- (id)initWithReuseIdentifier:(NSString *) reuseIdentifier;

@end
