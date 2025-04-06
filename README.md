
<p align="right">
  <img align="right" height="140" src="https://github.com/timi2506/RAW-files-i-need-for-stuff/blob/main/TouchPadExample.png?raw=true" alt="BottomSheet" style="float: right; border-radius: 10px;"/>
</p>

<h1 align="left">BottomSheet</h1>

## Showcase
A Showcase of this Package can be seen in Sources/BottomSheet/Showcase.swift

## Installation
### Using Xcode's built-in Package Manager 
Go to File > Add Package Dependencies...

then, in the Search-Bar enter: 

```https://github.com/timi2506/BottomSheet.git``` 

and press "Add Package" and make sure to link it to your target.
<img width="362" alt="Screenshot 2025-03-04 at 11 16 34" src="https://github.com/user-attachments/assets/8b3672b9-9345-4d6b-9b0d-26d03bd189c7" />

## Usage
### Examples
**.bottomSheet { ... }** *View Modifier*
```swift
some View {}
  .bottomSheet(isPresented: Binding<Bool>?, interactiveDismiss: Bool?, height: CGFloat,   maxHeight: CGFloat?, content: () -> _)
```
- **isPresented** *Optional*
  - Binding Bool that is used to hide/show the Bottom Sheet, defaults to true
- **interactiveDismiss** *Optional*
  - Bool to define whether the Bottom Sheet should be dismissable by swiping it to be bottom of the Screen, defaults to false
- **height** *Required*
  - The Initial and Minimum Height of the Bottom Sheet (keeping this at at least 75 is recommended)
- **maxHeight** *Optional*
  - The Maximum Height of the BottomSheet, defaults to 250
- **content** *Required*
  - The View to show inside of the BottomSheet
  - *This View is wrapped in a ScrollView by default and if used on iOS 16+ the ScrollView won't scroll until the Bottom Sheet is Expanded to a height higher than the minimum height*
 
***Optional*** means this value can be safely omitted 

***Required*** means you NEED to define this value and it can't be nil

**Recommended Usecases:**
- ✅ on a Root View
- ✅ on a View that will be navigated to
- ❌ on a View contained inside of another View (for example on a TextView inside of a TabView) *¹
v
*¹ What to do instead: Apply it on the full TabView
  
## Issues or Questions

If you have any issues or questions feel free to open an [issue](https://github.com/timi2506/BottomSheet/issues/new/choose) or contact me on [Twitter](https://x.com/timi2506)

## Requirements
- iOS 14+
