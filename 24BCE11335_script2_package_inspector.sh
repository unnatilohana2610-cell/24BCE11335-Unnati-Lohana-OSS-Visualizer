#!/bin/bash
# ============================================================
# Script 2: FOSS Package Inspector
# Author   : Vedant Singh | Reg No: 24BCE10073
# Course   : Open Source Software (OSS NGMC) | VITyarthi
# Date     : March 2026
# Description:
#   Checks if a chosen open-source package (git) is installed,
#   shows its version/licence details, and prints a philosophy
#   note using a case statement.
#
# Shell Concepts Demonstrated:
#   - if-then-else for conditional branching
#   - command -v to test tool availability (portable)
#   - rpm -qi and dpkg -l / dpkg-query for package info
#   - grep -E for multi-field extended pattern matching
#   - case statement with multiple patterns (7 packages)
#   - Pipe chaining: command | while IFS= read -r
#   - Exit code checking with &&  and  &>/dev/null
# ============================================================

# --- Define the package to inspect ---
# Change this variable to inspect any other package.
PACKAGE="git"

echo "================================================================"
echo "        FOSS Package Inspector                                  "
echo "================================================================"
echo ""
echo "  Inspecting package : $PACKAGE"
echo "  Script author      : Vedant Singh (24BCE10073)"
echo ""

# ────────────────────────────────────────────────────────────
# PACKAGE DETECTION using if-then-elif-else
#
# Strategy (in order):
#   1. Check for RPM-based system (Fedora, CentOS, RHEL)
#   2. Check for Debian-based system (Ubuntu, Debian, Mint)
#   3. Fall back to checking if 'git' is callable directly
#      (handles Git installed from source, outside the pkg mgr)
#   4. Report NOT INSTALLED with installation hints
#
# command -v TOOL &>/dev/null
#   Returns 0 (success) if TOOL is found in PATH, 1 if not.
#   &>/dev/null suppresses both stdout and stderr.
#
# rpm -q "$PACKAGE" &>/dev/null
#   Returns 0 if the package is installed in the RPM database.
# ────────────────────────────────────────────────────────────

if command -v rpm &>/dev/null && rpm -q "$PACKAGE" &>/dev/null; then

    # ── Branch 1: RPM-based system ──────────────────────────
    echo "  STATUS   : $PACKAGE is INSTALLED  [RPM-based system]"
    echo ""
    echo "  Package Details:"
    echo "  ----------------------------------------------------------------"
    # rpm -qi: query installed package info (verbose)
    # grep -E "^(Version|License|Summary|URL)" filters relevant fields
    # while IFS=: read KEY VAL: splits each line on the first colon
    rpm -qi "$PACKAGE" | grep -E "^(Version|License|Summary|URL)" | \
        while IFS=: read -r KEY VAL; do
            # printf aligns key in 10-char left-justified field
            printf "  %-10s : %s\n" "$(echo "$KEY" | xargs)" "$(echo "$VAL" | xargs)"
        done

elif command -v dpkg &>/dev/null && dpkg -l "$PACKAGE" 2>/dev/null | grep -q "^ii"; then

    # ── Branch 2: Debian-based system ───────────────────────
    # dpkg -l lists packages; "^ii" means installed and OK
    echo "  STATUS   : $PACKAGE is INSTALLED  [Debian-based system]"
    echo ""
    echo "  Package Details:"
    echo "  ----------------------------------------------------------------"
    # Extract package name and version from dpkg -l output
    dpkg -l "$PACKAGE" | grep "^ii" | \
        awk '{printf "  %-10s : %s\n  %-10s : %s\n", "Package", $2, "Version", $3}'
    # dpkg-query: get description and point to copyright file for licence
    dpkg-query -W -f='  Summary    : ${Description}\n  Licence    : See /usr/share/doc/${Package}/copyright\n' \
        "$PACKAGE" 2>/dev/null

elif command -v git &>/dev/null; then

    # ── Branch 3: Git found in PATH but not in pkg manager ──
    # This covers Git compiled from source or installed by another method.
    GIT_PATH=$(command -v git)         # Full path to the git binary
    GIT_VERSION=$(git --version)       # e.g. "git version 2.43.0"
    echo "  STATUS   : $PACKAGE is INSTALLED  [found in PATH — not via package manager]"
    echo ""
    echo "  Package Details:"
    echo "  ----------------------------------------------------------------"
    printf "  %-10s : %s\n" "Binary"   "$GIT_PATH"
    printf "  %-10s : %s\n" "Version"  "$GIT_VERSION"
    printf "  %-10s : %s\n" "Licence"  "GPL v2 (GNU General Public License version 2)"
    printf "  %-10s : %s\n" "Summary"  "Distributed version control system"
    printf "  %-10s : %s\n" "Source"   "git-scm.com"

else

    # ── Branch 4: Package not found anywhere ────────────────
    echo "  STATUS   : $PACKAGE is NOT INSTALLED"
    echo ""
    echo "  To install $PACKAGE, run one of the following:"
    echo "    RPM-based   : sudo dnf install $PACKAGE"
    echo "    Debian-based: sudo apt install $PACKAGE"
    echo "    Arch Linux  : sudo pacman -S $PACKAGE"
fi

echo ""
echo "================================================================"
echo "  OPEN SOURCE PHILOSOPHY NOTE"
echo "================================================================"
echo ""

# ────────────────────────────────────────────────────────────
# CASE STATEMENT: Print a philosophy note for each package.
#
# Syntax:
#   case $VARIABLE in
#       pattern1)  commands ;; 
#       pattern2 | pattern3)  commands ;;  # pipe = OR
#       *)  default commands ;;
#   esac
#
# The | between patterns acts as OR — matches either string.
# *)  is the default catch-all (equivalent to else in if-then).
# ────────────────────────────────────────────────────────────

case $PACKAGE in
    git)
        echo "  Git — Born from Frustration (2005)"
        echo ""
        echo "  Linus Torvalds built Git in ten days after BitMover revoked"
        echo "  the Linux kernel team's free licence to BitKeeper. Git is now"
        echo "  used by 90%+ of professional developers worldwide. It proves"
        echo "  that open source can outlast any single vendor's business model."
        echo "  Licence: GPL v2"
        ;;
    httpd | apache2)
        echo "  Apache HTTP Server — The Web Server That Built the Open Internet"
        echo ""
        echo "  Running roughly 30% of all websites, Apache showed the world that"
        echo "  community-built software could outperform and outlast corporate"
        echo "  alternatives. First released in 1995, it remains the reference"
        echo "  implementation for web server software."
        echo "  Licence: Apache License 2.0"
        ;;
    mysql | mariadb)
        echo "  MySQL / MariaDB — Open Source at the Heart of the Web"
        echo ""
        echo "  MySQL powered the LAMP stack that ran most of the early web."
        echo "  When Oracle acquired Sun Microsystems (and MySQL with it), the"
        echo "  community forked it into MariaDB — a textbook case of how the"
        echo "  GPL protects community interests even after corporate acquisition."
        echo "  Licence: GPL v2"
        ;;
    vlc)
        echo "  VLC Media Player — Built by Students, Used by Billions"
        echo ""
        echo "  VLC was started in 1996 by students at École Centrale Paris who"
        echo "  simply wanted to stream video over their campus network. No"
        echo "  corporate backing, no venture capital — just a problem, a"
        echo "  community, and a GPL licence. It now runs on virtually every"
        echo "  platform and plays virtually every media format."
        echo "  Licence: LGPL v2.1+"
        ;;
    firefox)
        echo "  Firefox — A Nonprofit Fighting for an Open Web"
        echo ""
        echo "  The Mozilla Foundation exists not to make a profit but to ensure"
        echo "  the internet remains open, accessible, and not controlled by any"
        echo "  single company. Firefox is a reminder that market dominance need"
        echo "  not be the goal — protecting user freedom and privacy can be."
        echo "  Licence: MPL 2.0"
        ;;
    python3 | python)
        echo "  Python — Governed by Community Consensus"
        echo ""
        echo "  Python's development is guided by PEPs (Python Enhancement"
        echo "  Proposals) — a democratic, public process open to anyone. No"
        echo "  feature reaches the language without community discussion and"
        echo "  a BDFL (or Steering Council) decision. Python shows that"
        echo "  governance and democratic process matter as much as code."
        echo "  Licence: PSF Licence (compatible with GPL)"
        ;;
    libreoffice)
        echo "  LibreOffice — Born from a Community Fork"
        echo ""
        echo "  When Oracle acquired Sun Microsystems in 2010, the open-source"
        echo "  community feared for the future of OpenOffice. Rather than wait,"
        echo "  they forked it into LibreOffice under The Document Foundation."
        echo "  Its creation story is a lesson in what happens when a corporate"
        echo "  owner clashes with community values — and the community wins."
        echo "  Licence: MPL 2.0 / LGPL v3+"
        ;;
    *)
        echo "  $PACKAGE — Every Open-Source Tool Carries a Story"
        echo ""
        echo "  Behind every open-source package is a person or community who"
        echo "  decided to share rather than hoard their work. That decision —"
        echo "  repeated millions of times across decades — is the reason the"
        echo "  modern digital world exists. The tools you use daily, from your"
        echo "  browser to your operating system, were built this way."
        ;;
esac

echo ""
echo "================================================================"
