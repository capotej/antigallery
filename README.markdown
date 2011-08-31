# Anti Gallery
The gallery built by a programmer, for programmers. You won't find this on any of the top 50 jquery gallery lists.

## Version/Changelog
* 1.1.4 Yet another typo, everything works again now, promise
* 1.1.3 Typo was causing prevItem to do nextItem instead, doh!
* 1.1.2 Next and Previous buttons no longer renderThumbs every time
* 1.1.1 Going to a page directly now sets the proper animation direction
* 1.1.0 Fixes broken 1.0.9 release
* 1.0.9 (BROKEN) Fixed bug causing nextItem to not turn the page if needed
* 1.0.8 Sets up keyboard events for first rendered gallery, hides direct page links if needed
* 1.0.7 100% docs and namespaced keyboard events, avoids clashing with other events
* 1.0.6 Keyboard support for multiple galleries using mouseover/out
* 1.0.5 Direction added to renderThumbs callback for animation support
* 1.0.4 Hides page navigation based on page count
* 1.0.3 SetActivePage renderer callback
* 1.0.2 Bugfix in Paginator
* 1.0.1 Preloading working
* 1.0.0 Initial Release

## Manifesto
During my career as a web developer I've used dozens of jquery galleries, each one failing in its own special way. I've even had to combine multiple half-assed galleries to deliver the necessary feature set.

### Why they fail
* No separation of concerns, presentation mixed with logic, cant extend
* Hard to customize, no matter how exhaustive their 500 option init hash may be
* Hard to style, markup is generated for you, styles are usually bundled in
* Source code usually looks like 90's php
* Most galleries target ease of installation, and that feature alone

### Where Anti Gallery is different (and a little extremist)
* Anti Gallery has no idea about your DOM, it takes a JSON hash of thumb/full urls, and a renderer.
* It has no idea how to render or what DOM elements to listen to for events, simply fires callback on the provided renderer.

### Enter the Renderer
Since Anti Gallery only contains the business end of a gallery, it needs to drive something in order to be useful. So you create a renderer. A renderer is just an object that responds to certain methods which Anti Gallery calls at different times. Since it's 100% callback based, this lets you **completely** control how the gallery works.

### How you use it
```javascript
    // Instantiate the gallery with a renderer
    gallery = new AntiGallery([
        {thumb: '/path/to/thumb.jpg', full: '/path/to/full.jpg'}
    ], new ExampleRenderer());
  
    // Render on document.ready
    $(document).ready(function(){
      gallery.render();
    });
```

## Examples
Check out the examples/ folder for an example_renderer that responds to all callbacks.

## Test Suite
The test suite is located in test/index.html

## Docs
There are coffeedocs in the docs/ folder, look in ExampleRenderer for callback documentation.

## License
Anti Gallery is released under the MIT license.
