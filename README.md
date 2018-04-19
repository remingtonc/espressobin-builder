# espressobin-builder
Dockerized builder for ESPRESSObin board images. Pulled from [ESPRESSObin wiki documentation](http://wiki.espressobin.net/tiki-index.php?page=Software+HowTo). This is incapable of the automatic flashing - this is purely to build the necessary image elements themselves. Currently only builds the 17.10 kernels and images, and OpenWRT.

* `bin/` maps to `/data/`
* `build/` maps to `/build/`
* All generated files in these directories will be ignored in git.
