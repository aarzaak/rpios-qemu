#!/bin/bash

# Text Style Reset
NS='\033[0m'              # No Style

# Regular Color
BLACK='\033[0;30m'        # Black
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green
YELLOW='\033[0;33m'       # Yellow
BLUE='\033[0;34m'         # Blue
PURPLE='\033[0;35m'       # Purple
CYAN='\033[0;36m'         # Cyan
WHITE='\033[0;37m'        # White

# Bold or Increased Intensity
BBLACK='\033[1;30m'       # Black
BRED='\033[1;31m'         # Red
BGREEN='\033[1;32m'       # Green
BYELLOW='\033[1;33m'      # Yellow
BBLUE='\033[1;34m'        # Blue
BPURPLE='\033[1;35m'      # Purple
BCYAN='\033[1;36m'        # Cyan
BWHITE='\033[1;37m'       # White

# Faint, Decreased Intensity or Dim
FBLACK='\033[2;30m'       # Black
FRED='\033[2;31m'         # Red
FGREEN='\033[2;32m'       # Green
FYELLOW='\033[2;33m'      # Yellow
FBLUE='\033[2;34m'        # Blue
FPURPLE='\033[2;35m'      # Purple
FCYAN='\033[2;36m'        # Cyan
FWHITE='\033[2;37m'       # White

# Italic
IBLACK='\033[3;30m'       # Black
IRED='\033[3;31m'         # Red
IGREEN='\033[3;32m'       # Green
IYELLOW='\033[3;33m'      # Yellow
IBLUE='\033[3;34m'        # Blue
IPURPLE='\033[3;35m'      # Purple
ICYAN='\033[3;36m'        # Cyan
IWHITE='\033[3;37m'       # White

# Underline
UBLACK='\033[4;30m'       # Black
URED='\033[4;31m'         # Red
UGREEN='\033[4;32m'       # Green
UYELLOW='\033[4;33m'      # Yellow
UBLUE='\033[4;34m'        # Blue
UPURPLE='\033[4;35m'      # Purple
UCYAN='\033[4;36m'        # Cyan
UWHITE='\033[4;37m'       # White

# Slow Blink: sets blinking to less than 150 times per minute
SBBLACK='\033[5;30m'       # Black
SBRED='\033[5;31m'         # Red
SBGREEN='\033[5;32m'       # Green
SBYELLOW='\033[5;33m'      # Yellow
SBBLUE='\033[5;34m'        # Blue
SBPURPLE='\033[5;35m'      # Purple
SBCYAN='\033[5;36m'        # Cyan
SBWHITE='\033[5;37m'       # White

# Rapid Blink: 150+ per minute; not widely supported
RBBLACK='\033[6;30m'       # Black
RBRED='\033[6;31m'         # Red
RBGREEN='\033[6;32m'       # Green
RBYELLOW='\033[6;33m'      # Yellow
RBBLUE='\033[6;34m'        # Blue
RBPURPLE='\033[6;35m'      # Purple
RBCYAN='\033[6;36m'        # Cyan
RBWHITE='\033[6;37m'       # White

# Background
ON_BLACK='\033[40m'       # Black
ON_RED='\033[41m'         # Red
ON_GREEN='\033[42m'       # Green
ON_YELLOW='\033[43m'      # Yellow
ON_BLUE='\033[44m'        # Blue
ON_PURPLE='\033[45m'      # Purple
ON_CYAN='\033[46m'        # Cyan
ON_WHITE='\033[47m'       # White

# High Intensity
HIBLACK='\033[0;90m'       # Black
HIRED='\033[0;91m'         # Red
HIGREEN='\033[0;92m'       # Green
HIYELLOW='\033[0;93m'      # Yellow
HIBLUE='\033[0;94m'        # Blue
HIPURPLE='\033[0;95m'      # Purple
HICYAN='\033[0;96m'        # Cyan
HIWHITE='\033[0;97m'       # White

# High Intensity Bold
HIBBLACK='\033[1;90m'      # Black
HIBRED='\033[1;91m'        # Red
HIBGREEN='\033[1;92m'      # Green
HIBYELLOW='\033[1;93m'     # Yellow
HIBBLUE='\033[1;94m'       # Blue
HIBPURPLE='\033[1;95m'     # Purple
HIBCYAN='\033[1;96m'       # Cyan
HIBWHITE='\033[1;97m'      # White

# High Intensity Background
ON_IBLACK='\033[0;100m'   # Black
ON_IRED='\033[0;101m'     # Red
ON_IGREEN='\033[0;102m'   # Green
ON_IYELLOW='\033[0;103m'  # Yellow
ON_IBLUE='\033[0;104m'    # Blue
ON_IPURPLE='\033[0;105m'  # Purple
ON_ICYAN='\033[0;106m'    # Cyan
ON_IWHITE='\033[0;107m'   # White
