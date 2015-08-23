Hello!

This is just something I made in my spare time. It has a bit of latency, and it does take a CPU hit.
There are definitely advancements to be made! Currently everything is done on the CPU and uses OS X APIs to fetch the screen.
However, this probably involves a few context switches and multiple memory copies, so expect 20-50% of a single CPU core being occupied when using this.


So far, the code is specific to how my screen is laid out, Pixels going up the right side, towards the left, and down on the left side.

The general algorithm is like this:

1. Shrink down the screen by a factor of 8
2. Apply a gaussian blur
3. Shrink it down by another factor of 8 (or 4)
4. Sample pixels along the sides and the top, spaced apart by resized amount divided by the count of pixels.
5. Send the results to the [OPC][] server. (Hardcoded to localhost currently)


[OPC]: http://openpixelcontrol.org


## Possible enhancements

1. Smarter color selection / location selection
2. Sound analysis as well, making horror and action movies more immersive.

## Performance enhancements

Move everything to openGL! 

Though, this requires shrinking down, gaussian blur stuff, and so on. 
As a server programmer, I'm not familiar with this road and getting this to work was an adventure in of itself.

Lesson: Don't code for OS X specifically. The APIs suck, and nearly everything online pertains to iOS and is not available on mac.

Here's some stuff that might help on the openGL front:

* [Grabbing screen pixels on OS X with OpenGL](http://forum.openframeworks.cc/t/programmatic-screen-capture/3017/5)
* [OpenGL Guide for Mac](https://developer.apple.com/library/mac/documentation/GraphicsImaging/Conceptual/OpenGL-MacProgGuide/opengl_texturedata/opengl_texturedata.html)


## Resources I used to stitch this together

Again, I've never done Objective C or any OS X specific code, despite using it as my main OS for years.

* [CIFilter Class Reference](https://developer.apple.com/library/prerelease/ios/documentation/GraphicsImaging/Reference/QuartzCoreFramework/Classes/CIFilter_Class/index.html)
* [Core Image Filter Reference](https://developer.apple.com/library/ios/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIZoomBlur)
* [CGImage Reference](https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CGImage/index.html#//apple_ref/c/func/CGImageGetHeight)
* [CGDirectDisplayID Reference](https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/Quartz_Services_Ref/index.html#//apple_ref/doc/c_ref/CGDirectDisplayID)
* [Getting a CGImage for the screen](http://stackoverflow.com/questions/9482912/programmatically-grab-screenshots-in-osx)
* [Crop and resize](https://gist.github.com/syshen/4516930)
* [Getting Pixel Data](https://developer.apple.com/library/mac/qa/qa1509/_index.html)
* [CGRect in CGGeometry Reference](https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CGGeometry/index.html#//apple_ref/doc/c_ref/CGRect)
* [GaussianBlur and cropping](http://stackoverflow.com/questions/12839729/correct-crop-of-cigaussianblur)
* [Image resizing techniques (swift?)](http://nshipster.com/image-resizing/)

If you plan to use this project or enhance it, perhaps the above resources will help.

 
