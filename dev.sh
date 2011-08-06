#!/bin/sh

coffee --watch --compile  --output test/ test/test.coffee &
coffee --watch --compile --output examples/ examples/example_renderer.coffee &
coffee --watch --compile antigallery.coffee &


