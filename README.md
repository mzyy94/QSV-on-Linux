# Intel QSV Linux Env.
Setup scripts of Intel QSV encoding for CentOS 7.1

## Requirements
  * QSV supported Intel CPU
    - Haswell Core i Series
    - Broadwell Core i Series
    - Xeon E3 v3 with iGPU
    - Xeon E3 v4 with iGPU
  * [Intel Media Server Studio 2015 R6 Community Edition](https://software.intel.com/en-us/intel-media-server-studio)
  * CentOS 7.1 x64

## Install QSV libraries and custom kernel

  1. Clone this repository into /tmp/QSV-on-Linux
  2. Change current directory to /tmp/QSV-on-Linux
  3. Download Intel Media Server Studio.
  4. `./install-MSS.sh`
  5. `sudo reboot`


## License
MIT
