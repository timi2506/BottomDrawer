
<p align="right">
  <img align="right" height="140" src="https://github.com/timi2506/RAW-files-i-need-for-stuff/blob/main/BottomSheetIcon.png?raw=true" alt="BottomDrawer" style="float: right; border-radius: 10px;"/>
</p>

<h1 align="left">BottomDrawer</h1>

## Showcase
A Showcase of this Package can be seen in Sources/BottomDrawer/Showcase.swift and in this video:

https://raw.githubusercontent.com/timi2506/RAW-files-i-need-for-stuff/refs/heads/main/BottomSheetShowcase.mov

## Installation
### Using Xcode's built-in Package Manager 
Go to File > Add Package Dependencies...

then, in the Search-Bar enter: 

```https://github.com/timi2506/BottomDrawer.git``` 

and press "Add Package" and make sure to link it to your target.
<img width="362" alt="Screenshot 2025-03-04 at 11 16 34" src="https://github.com/user-attachments/assets/8b3672b9-9345-4d6b-9b0d-26d03bd189c7" />

## Usage
### Examples
**.bottomDrawer { ... }** *View Modifier*
```swift
some View {}
  .bottomDrawer(isPresented: Binding<Bool>?, interactiveDismiss: Bool?, dragHandleVisibility: DragHandleVisibility?, height: Binding<CGFloat>, initialHeight: CGFloat, maxHeight: CGFloat?, content: () -> _)
```
- **isPresented** *Optional*
  - Binding Bool that is used to hide/show the Bottom Drawer, defaults to true
- **interactiveDismiss** *Optional*
  - Bool to define whether the Bottom Drawer should be dismissable by swiping it to be bottom of the Screen, defaults to false
- **dragHandleVisibility** *Optional*
  - Defines the Drag Handles Appearance, more info in the DragHandleVisibility section
- **height** *Required*
  - The Height as a Binding, can be updated and read programatically
- **initialHeight** *Required*
  - The Initial and Minimum Height
- **maxHeight** *Optional*
  - The Maximum Height of the Drawer, defaults to 250
- **content** *Required*
  - The View to show inside of the Drawer
  - *This View is wrapped in a VStack by default*
 
***Optional*** means this value can be safely omitted 

***Required*** means you NEED to define this value and it can't be nil

**Recommended Usecases:**
- ✅ on a Root View
- ✅ on a View that will be navigated to
- ❌ on a View contained inside of another View (for example on a TextView inside of a TabView) *¹

*¹ What to do instead: Apply it on the full TabView
  
  
**DragHandleVisibility** *Enum*
- The Drag Handle Visibility Enum has 3 types:
- **visible** 
    - The Default Appearance, Makes the Handle Visible and with Width Animations adapting to the Drag Height
- **static**
    - same as visible with the exception that the handle's width does not adapt
- **hidden**
    - hides the Drag Handle, this is especially useful for Apps that use their own, custom Drag Handle or programmatic height changing logic
    
## Issues or Questions

If you have any issues or questions feel free to open an [issue](https://github.com/timi2506/BottomDrawer/issues/new/choose) or contact me on [Twitter](https://x.com/timi2506)

## Requirements
- iOS 15+
