# Anti Gallery
The gallery built by a programmer, for programmers. You won't find this on any top 50 jquery gallery lists

## Manifesto
During my career as a web developer I've used dozens of jquery galleries, each one failing in its own special way. I've even had to combine multiple half ass galleries to deliver the necessary features.

### Where they fail
* No separation of concerns, presentation mixed with logic, cant extend
* Hard to customize, no matter how exhaustive their 500 option init hash may be
* Hard to style, markup is generated for you, styles are usually bundled in
* Source code usually looks like 90's php
* Most galleries target ease of installation, and that feature alone

### Where Anti Gallery is different (and a little extremist)
* Anti Gallery has no idea about your DOM, it takes a JSON hash of thumb and full size urls, that's it
* It has no idea how to render or what DOM elements to listen to for events

### Enter the Renderer
Since Anti Gallery only contains the business end of a gallery, it needs to drive something in order to be useful. This lets you **completely** control how the gallery works. No options hash here, this is next level shit.

### How you use it

```
my_renderer = new MyRenderer()
gallery = new AntiGallery([
                            { full: 'path/to/full.jpg', thumb: 'path/to/thumb.jpg' }
                              ...
                            }
                          ]);

$(document).ready(function(){
  gallery.renderWith(my_renderer)
});

```
