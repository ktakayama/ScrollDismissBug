# Scroll dismiss bug

EventViewController doesn't close on scroll down in iOS 17 beta8.

## Problem Description:

In the `EventViewController` on iOS 17 beta8 and Xcode 15 beta8, scrolling down doesn't close the view. This is unlike the behavior in regular UIViewControllers. In a standard UIViewController, scrolling down will close the view. I would like to have the same functionality implemented in the `EventViewController`. 

Note: This issue doesn't occur in iOS 16; it behaves as expected there.

## Steps to Reproduce:

1. Open the sample project in Xcode 15 beta8 on an iOS 17 beta8 device or simulator.
2. Navigate and click on `NormalViewControllerWrapper`. The view behaves as expected and closes upon scrolling down.
3. Navigate and click on `EventViewControllerWrapper`. Here the bug is reproduced; the view doesn't close when scrolled down.

## Expected Results:

Scrolling down in the `EventViewController` should close the view, aligning with the behavior seen in normal UIViewControllers.

## Actual Results:

Scrolling down in the `EventViewController` doesn't close the view.

## Additional Information:

- Tested on Xcode 15 beta8 and iOS 17 beta8.
- Behavior is as expected on iOS 16.


## Screen Recording:

### iOS17

https://github.com/ktakayama/ScrollDismissBug/assets/42468/282cbd09-b818-4168-acce-75634582c611

### iOS16

https://github.com/ktakayama/ScrollDismissBug/assets/42468/d3561daf-ed98-42d9-ab43-ca0cde001cea

