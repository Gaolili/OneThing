 

#import "ListViewController.h"
#import "ListItemLayout.h"
#import "ItemCell.h"

@interface ListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView * collecitonView;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.view.backgroundColor = [UIColor whiteColor];
   ListItemLayout * layout = [[ListItemLayout alloc]init];

   _collecitonView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
   _collecitonView.backgroundColor = [UIColor whiteColor];
   _collecitonView.delegate = self;
   _collecitonView.dataSource = self;
   [_collecitonView registerNib:[UINib nibWithNibName:@"ItemCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ItemCell"];
   [self.view addSubview:_collecitonView];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
     return 50;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ItemCell  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCell" forIndexPath:indexPath];
    return cell;
}


@end
