//
//  ViewController.m
//  LZQImagePicker
//
//  Created by 龙振旗 on 17/4/8.
//  Copyright © 2017年 www.hongqi.com. All rights reserved.
//

#import "ViewController.h"
#import "LZQCollectionCell.h"
#import "TZImagePickerController.h"



static NSString * const ID = @"cell";


@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate>

//声明属性
@property(nonatomic,strong)UICollectionView *collection;

//声明一个方块的view
@property(nonatomic,strong)UIView * backview;

//声明相册的属性
@property(nonatomic,strong)UIImagePickerController *imagePicker;


//存放图片的数组
@property(nonatomic,strong)NSMutableArray *photoArr;

//图片的名称数组
@property(nonatomic,strong)NSMutableArray *asseTArr;



@end




@implementation ViewController


-(NSMutableArray *)photoArr {
    
    if (_photoArr == nil) {
        _photoArr = [NSMutableArray array];
    }
    
    return _photoArr;

}



-(NSMutableArray *)asseTArr {
    
    if (_asseTArr == nil) {
        _asseTArr = [NSMutableArray array];
    }
    
    return _asseTArr;
    
}




-(UIImagePickerController *)imagePicker {
    
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePicker.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePicker.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePicker;
    
    
    
}


-(UIView *)backview {
    
    
    if (_backview == nil) {
        
        _backview = [[UIView alloc]initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 400)];
        
        _backview.backgroundColor = [UIColor redColor];
    }
    
    return _backview;
    
}


//懒加载
-(UICollectionView *)collection {
    
    
    
    // 懒加载其实质就是getter方法,实例化处理该对象
    
    
    if (_collection == nil) {
        
    
    //设置流水布局的参数
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    //设置间距  以及行数。
    CGFloat margin = 5;
    
    //设置每一个cell的宽高，
    CGFloat itemHW = (self.backview.bounds.size.width - 4 * margin) / 3 - margin;
    
    //设置一些布局的属性；
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    layout.itemSize = CGSizeMake(itemHW, itemHW);
    layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
   
    _collection = [[UICollectionView alloc]initWithFrame:self.backview.bounds collectionViewLayout:layout];
    
    _collection.delegate = self;
        
    _collection.dataSource = self;
       
    _collection.backgroundColor = [UIColor whiteColor];
        
    [_collection registerClass:[LZQCollectionCell class] forCellWithReuseIdentifier:ID]; //注册这个类的cell
        
    }
    
    return _collection;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:self.backview];
    
    //创建点击的按钮
    [self creatButton];
    
    
}



-(void)creatButton {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:@"选择图片" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   
    btn.backgroundColor  = [UIColor orangeColor];
    
    btn.frame = CGRectMake(50, 60, 100, 40);
    
    [self.view addSubview:btn];
  
    [btn addTarget:self action:@selector(chosePickImage) forControlEvents:UIControlEventTouchUpInside];
    
}








#pragma mark =======   按钮的监听方法

-(void)chosePickImage {
    
    //点击按钮弹出系统的相框。但是前提是需要获取用户的许可；  在info.plist文件中配置这个值  NSPhotoLibraryUsageDescription
    
    
    /**
     MaxImagesCount 最多上传的张数 
     columnNumber   最少是多少
     */
    TZImagePickerController *imagePick = [[TZImagePickerController alloc]initWithMaxImagesCount:9 columnNumber:0 delegate:self pushPhotoPickerVc:YES];
    
    
    
    //在这个方法中获得图片  和   图片的名称
    [imagePick setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photo, NSArray *asset, BOOL isSelectOriginalPhoto) {
        
    }];
    
    
    [self presentViewController:imagePick animated:YES completion:nil];
    

   //添加collection
    
   [self.backview addSubview:self.collection];
    
    
}

#pragma mark ======== 完成后获取图片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    
    self.photoArr = photos;
    self.asseTArr = assets;
 
    //刷新collection
    [self.collection reloadData];
    
}



#pragma mark   =====   实现collection的数据源的方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.photoArr.count;
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LZQCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    
    cell.imageView.image = self.photoArr[indexPath.row];
    
    return cell;
}


#pragma mark   =====   实现collection的代理方法；

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //点击单个cell进入相册进行选择
    [self chosePickImage];
    
}





@end
