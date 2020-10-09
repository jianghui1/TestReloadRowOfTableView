#### UITableView 在 iOS14 上又遇到坑了

之前项目中有使用到 `UITableView` `reloadRowsAtIndexPaths:withRowAnimation:` 方法刷新列表，而且实际效果也一直很正常。但是，自从升级了 **Xcode12** 并在 **iOS14** 设备上运行之后，发现闪退了。

经过了一番调试，发现最后的问题在于 `[NSIndexPath indexPathForRow:-1 inSection:0]`。当使用 `-1` 初始化时，就会出现闪退，闪退日志如下：
    
    2020-10-09 17:18:18.443449+0800 TestReloadRowOfTableView[7447:586166] *** Assertion failure in void _UIAssertValidUpdateIndexPath(NSIndexPath * _Nullable __strong)(), UITableViewSupport.m:2736
    2020-10-09 17:18:18.447428+0800 TestReloadRowOfTableView[7447:586166] *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Attempted to perform update with invalid index path: <NSIndexPath: 0x281952700> {length = 2, path = 0 - 18446744073709551615}'
    
那这里的 **18446744073709551615** 是什么呢？

先看一下 **API**

    
    + (instancetype)indexPathForRow:(NSInteger)row inSection:(NSInteger)section;

注意，这里的参数 `row` `section` 都是 `NSInteger` 类型，那我使用 `-1` 也没有什么问题，但是在实际情况下，展示出来的不会出现负数的情况。而且，使用负数初始化会自动转换成正数(**iOS13** **iOS14** 都是一样)。

    
    NSInteger row = -1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    NSLog(@"todo --- %ld ---- %@", (long)row, indexPath);
    
    2020-10-09 17:38:18.842176+0800 TestReloadRowOfTableView[7482:593029] todo --- -1 ---- <NSIndexPath: 0x2809ac740> {length = 2, path = 0 - 18446744073709551615}
    
也就是说，在 **iOS14** 上增加了一层判断，当遇到不符合实际的索引时，就会抛出异常。

所以正常开发中，如果已知某些情况不会出现，就不要再去使用了，防止后面的更新维护出现新的坑。

测试代码在[这里](https://github.com/jianghui1/TestReloadRowOfTableView)。
