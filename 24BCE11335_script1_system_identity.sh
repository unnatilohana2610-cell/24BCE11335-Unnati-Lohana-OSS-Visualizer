#!/bin/bash
# ============================================================
# Script 1: System Identity Report
# Author   : Nishad Mehta | Reg No: 24BCE11266
# Course   : Open Source Software (OSS NGMC) | VITyarthi
# Date     : March 2026
# Description:
#   Displays a formatted welcome screen showing the current
#   Linux system's identity and open-source licence details.
#
# Shell Concepts Demonstrated:
#   - Variables and constants
#   - Command substitution with $()
#   - echo with formatted output
#   - cat /etc/os-release with grep and cut
#   - printf for aligned columns
#   - Conditional check for /etc/os-release availability
# ============================================================

# --- Student & Software Constants ---
STUDENT_NAME="Nishad Mehta"
REG_NO="24BCE11266"
SOFTWARE_CHOICE="Git"
COURSE="Open Source Software (OSS NGMC)"

# ────────────────────────────────────────────────────────────
# GATHER SYSTEM INFORMATION using command substitution $()
# Each variable captures live output from a system command.
# ────────────────────────────────────────────────────────────

KERNEL=$(uname -r)                    # Kernel version (e.g. 5.15.0-91-generic)
ARCH=$(uname -m)                      # Architecture   (e.g. x86_64)
HOSTNAME=$(hostname)                  # Machine hostname
USER_NAME=$(whoami)                   # Currently logged-in user
HOME_DIR=$HOME                        # User's home directory (env variable)
UPTIME=$(uptime -p)                   # Human-readable uptime (e.g. up 3 hours)
CURRENT_DATE=$(date '+%A, %d %B %Y')  # e.g. Monday, 25 March 2026
CURRENT_TIME=$(date '+%H:%M:%S %Z')   # e.g. 14:32:07 IST
SHELL_VER=$BASH_VERSION               # Bash version string

# --- Detect Linux distribution name from /etc/os-release ---
# /etc/os-release is the standard cross-distro identification file (FHS).
# PRETTY_NAME holds the human-readable name (e.g. "Ubuntu 22.04.3 LTS").
# grep finds the line, cut -d= -f2 extracts the value, tr removes quotes.
if [ -f /etc/os-release ]; then
    DISTRO=$(grep "^PRETTY_NAME" /etc/os-release | cut -d= -f2 | tr -d '"')
else
    # Fallback: use uname if /etc/os-release does not exist
    DISTRO=$(uname -s)
fi

# --- Determine OS Licence ---
# The Linux kernel (and most Linux distributions) are licensed under GPL v2.
OS_LICENSE="GNU General Public License v2 (GPL v2)"

# ────────────────────────────────────────────────────────────
# DISPLAY: Open Source Audit Welcome Screen
# Using printf for column-aligned key-value output.
# printf "  %-15s: %s\n" "Key" "Value"
#   %-15s = left-aligned string in a 15-character field
#   %s    = plain string (no width constraint)
# ────────────────────────────────────────────────────────────

echo "================================================================"
echo "        OPEN SOURCE AUDIT — System Identity Report              "
echo "================================================================"
echo ""
printf "  %-18s: %s\n" "Student"     "$STUDENT_NAME"
printf "  %-18s: %s\n" "Reg No"      "$REG_NO"
printf "  %-18s: %s\n" "Software"    "$SOFTWARE_CHOICE"
printf "  %-18s: %s\n" "Course"      "$COURSE"
echo ""
echo "----------------------------------------------------------------"
echo "  SYSTEM INFORMATION"
echo "----------------------------------------------------------------"
printf "  %-18s: %s\n" "Distribution"  "$DISTRO"
printf "  %-18s: %s\n" "Kernel"        "$KERNEL"
printf "  %-18s: %s\n" "Architecture"  "$ARCH"
printf "  %-18s: %s\n" "Hostname"      "$HOSTNAME"
printf "  %-18s: %s\n" "Logged User"   "$USER_NAME"
printf "  %-18s: %s\n" "Home Dir"      "$HOME_DIR"
printf "  %-18s: %s\n" "Bash Version"  "$SHELL_VER"
printf "  %-18s: %s\n" "Uptime"        "$UPTIME"
printf "  %-18s: %s\n" "Date"          "$CURRENT_DATE"
printf "  %-18s: %s\n" "Time"          "$CURRENT_TIME"
echo ""
echo "----------------------------------------------------------------"
echo "  LICENCE INFORMATION"
echo "----------------------------------------------------------------"
echo "  This operating system is covered under:"
echo "  $OS_LICENSE"
echo ""
echo "  What GPL v2 means:"
echo "  - You may use, study, modify, and redistribute this OS freely."
echo "  - Any distributed derivative must also be released under GPL v2."
echo "  - Source code must be made available to all recipients."
echo "  - No additional restrictions may be imposed on downstream users."
echo ""
echo "  Chosen software '$SOFTWARE_CHOICE' is also licensed under GPL v2,"
echo "  reflecting the same commitment to software freedom."
echo "================================================================"
echo ""
