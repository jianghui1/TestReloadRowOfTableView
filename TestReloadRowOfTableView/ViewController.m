//
//  ViewController.m
//  TestReloadRowOfTableView
//
//  Created by jzh on 2020/10/9.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)buttonAction:(id)sender {
    NSInteger row = -1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    NSLog(@"todo --- %ld ---- %@", (long)row, indexPath);
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 个", indexPath.row];
    
    return cell;
}

@end
