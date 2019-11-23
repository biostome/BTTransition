# BTTransition

[![CI Status](https://img.shields.io/travis/453816118@qq.com/BTTransition.svg?style=flat)](https://travis-ci.org/453816118@qq.com/BTTransition)
[![Version](https://img.shields.io/cocoapods/v/BTTransition.svg?style=flat)](https://cocoapods.org/pods/BTTransition)
[![License](https://img.shields.io/cocoapods/l/BTTransition.svg?style=flat)](https://cocoapods.org/pods/BTTransition)
[![Platform](https://img.shields.io/cocoapods/p/BTTransition.svg?style=flat)](https://cocoapods.org/pods/BTTransition)


## Preview
![展示](https://raw.githubusercontent.com/biostome/BTTransition/master/Example/file.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

BTTransition is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BTTransition'
```

## Easy Usg
```objc
- (instancetype)init{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"BTPresentViewController"];;
    if (self) {
        _aniamtion = [[BTCoverVerticalTransition alloc]initPresentViewController:self withRragDismissEnabal:YES];
        self.transitioningDelegate = _aniamtion;
    }
    return self;
}
```

## Author

biostome, 453816118@qq.com

## License

BTTransition is available under the MIT license. See the LICENSE file for more info.
