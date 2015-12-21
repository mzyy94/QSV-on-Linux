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

  1. Download Intel Media Server Studio.
  2. Move it into /tmp directory.
  3. `cd /tmp`
  4. `curl -L http://git.io/vELVS | bash -`
  5. `sudo reboot`

  OR 

  1. Download Intel Media Server Studio.
  2. Move it into /tmp directory.
  3. Copy install-MSS.sh into /tmp directory.
  4. `cd /tmp && ./install-MSS.sh`
  5. `sudo reboot`


## License
MIT
