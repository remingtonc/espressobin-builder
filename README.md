# espressobin-builder
Dockerized builder for ESPRESSObin board images. Pulled from [ESPRESSObin wiki documentation](http://wiki.espressobin.net/tiki-index.php?page=Software+HowTo). This is incapable of the automatic flashing - this is purely to build the necessary image elements themselves. Currently only builds the 17.10 kernels and images, and OpenWRT.

## WARNING
This is not verified to correctly build compatible images. Use at your own risk. Documentation does not appear completely reliable. Pre-built images are likely safer - however this is useful for understanding the build process, exposing weakenesses in the documentation, and for those who desire to build from source.

### Current Limitations
* **Only builds for 1GB ESPRESSObin board.**
* **Only builds Bootloader and OpenWRT 17.10.**

## Usage
This script will acquire and build the Bootloader, Kernel, and OpenWRT images. `bin/` will contain the resulting and desired files for flashing.

```bash
./build.sh
```

## Bind Mounts
**Host** : **Container**
* `bin/` : `/data/`  
Contains the desired, built images.
* `build/` : `/build/`  
Contains the files extracted for build process.
* `cache/` : `/cache/`  
Contains cached copies of necessary downloads. Does not check for new versions.
* `config/` : `/config/`  
Contains useful configs referenced in the documentation or to automate builds.

All generated files in these directories will be ignored in git.

## Help
Please open an issue. :)
