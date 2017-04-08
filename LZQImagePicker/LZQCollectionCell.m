//
//  LZQCollectionCell.m
//  LZQImagePicker
//
//  Created by 龙振旗 on 17/4/8.
//  Copyright © 2017年 www.hongqi.com. All rights reserved.
//

#import "LZQCollectionCell.h"

@implementation LZQCollectionCell


-(UIImageView *)imageView {
    
    if (_imageView == nil) {
        
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = self.bounds;
        _imageView.backgroundColor = [UIColor orangeColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    
    return _imageView;

}

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.imageView];
        self.clipsToBounds = YES;
    }
    
    return self;
    
    
    
}






@end
