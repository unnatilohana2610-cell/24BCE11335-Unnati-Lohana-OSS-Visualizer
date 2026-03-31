#!/bin/bash
# ============================================================
# Script 3: Disk and Permission Auditor
# Author   : Vedant Singh| Reg No: 24BCE10073
# Course   : Open Source Software (OSS NGMC) | VITyarthi
# Date     : March 2026
# Description:
#   Loops through key system directories, reports permissions,
#   owner, group, and disk usage for each. Also audits Git's
#   config file locations specifically.
#
# Shell Concepts Demonstrated:
#   - Array declaration: DIRS=(...)
#   - for loop over array: for DIR in "${DIRS[@]}"
#   - Directory existence test: [ -d "$DIR" ]
#   - File existence test: [ -f "$FILE" ]
#   - ls -ld piped to awk for permission/owner/group extraction
#   - du -sh for human-readable disk usage
#   - printf for formatted tabular output
#   - 2>/dev/null to suppress permission-denied errors
# ============================================================

# ────────────────────────────────────────────────────────────
# ARRAY: List of important system directories to audit.
# These directories are part of the Linux Filesystem Hierarchy
# Standard (FHS) and each has specific permission conventions.
# ────────────────────────────────────────────────────────────
DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/var" "/opt" "/usr/share" "/root")

# ────────────────────────────────────────────────────────────
# Git-specific configuration paths (our chosen software).
# Git checks these locations in order: system → user → repo.
# ────────────────────────────────────────────────────────────
GIT_SYSTEM_CONFIG="/etc/gitconfig"
GIT_USER_CONFIG="$HOME/.gitconfig"
GIT_USER_ALT="$HOME/.config/git/config"   # Alternative user config location

echo "================================================================"
echo "        Disk and Permission Auditor                             "
echo "        Author: Vedant Singh | Reg No: 24BCE10073              "
echo "================================================================"
echo ""
echo "  Scanning system directories..."
echo ""

# ────────────────────────────────────────────────────────────
# PRINT TABLE HEADER using printf
# Format string: %-22s = left-aligned in 22-char field
# This creates aligned columns across all rows.
# ────────────────────────────────────────────────────────────
printf "  %-22s %-12s %-10s %-10s %-10s %s\n" \
    "Directory" "Permissions" "Owner" "Group" "Size" "Status"
echo "  -----------------------------------------------------------------------"

# ────────────────────────────────────────────────────────────
# FOR LOOP: Iterate over each element in the DIRS array.
# "${DIRS[@]}" expands to all array elements, each quoted.
# Quoting is critical — prevents word splitting on paths
# that contain spaces (e.g. "/home/user name").
# ────────────────────────────────────────────────────────────
for DIR in "${DIRS[@]}"; do

    # [ -d "$DIR" ]: tests if $DIR exists AND is a directory
    if [ -d "$DIR" ]; then

        # Extract permission string (e.g. drwxr-xr-x)
        # ls -ld: long format, list directory itself (not contents)
        # awk '{print $1}': print first whitespace-separated field
        PERMS=$(ls -ld "$DIR" | awk '{print $1}')

        # Extract owner (field 3 of ls -ld output)
        OWNER=$(ls -ld "$DIR" | awk '{print $3}')

        # Extract group (field 4 of ls -ld output)
        GROUP=$(ls -ld "$DIR" | awk '{print $4}')

        # Get human-readable directory size
        # du -sh: disk usage, summarise (-s), human-readable (-h)
        # cut -f1: take only the size field (before the tab)
        # 2>/dev/null: discard "Permission denied" errors silently
        SIZE=$(du -sh "$DIR" 2>/dev/null | cut -f1)

        # Print the formatted row; ${SIZE:-N/A} = SIZE if set, else "N/A"
        printf "  %-22s %-12s %-10s %-10s %-10s %s\n" \
            "$DIR" "$PERMS" "$OWNER" "$GROUP" "${SIZE:-N/A}" "OK"
    else
        # Directory does not exist on this system — print NOT FOUND
        printf "  %-22s %-12s %-10s %-10s %-10s %s\n" \
            "$DIR" "N/A" "N/A" "N/A" "N/A" "NOT FOUND"
    fi
done

echo ""
echo "================================================================"
echo "  GIT-SPECIFIC CONFIGURATION FILE AUDIT"
echo "  (Chosen Software: Git — GPL v2)"
echo "================================================================"
echo ""
echo "  Git reads configuration in this priority order:"
echo "    1. Repository config  : .git/config  (highest priority)"
echo "    2. User config        : ~/.gitconfig  or  ~/.config/git/config"
echo "    3. System config      : /etc/gitconfig  (lowest priority)"
echo ""

# ────────────────────────────────────────────────────────────
# CHECK SYSTEM-WIDE GIT CONFIG
# [ -f "$FILE" ]: tests if $FILE exists AND is a regular file
# ls -l "$FILE": long listing (includes permissions, owner, group)
# ────────────────────────────────────────────────────────────
echo "  [1] System-wide config : $GIT_SYSTEM_CONFIG"
if [ -f "$GIT_SYSTEM_CONFIG" ]; then
    PERMS=$(ls -l "$GIT_SYSTEM_CONFIG" | awk '{print $1}')
    OWNER=$(ls -l "$GIT_SYSTEM_CONFIG" | awk '{print $3}')
    GROUP=$(ls -l "$GIT_SYSTEM_CONFIG" | awk '{print $4}')
    SIZE=$(du -sh "$GIT_SYSTEM_CONFIG" 2>/dev/null | cut -f1)
    printf "       %-14s : %s\n" "Permissions"  "$PERMS  ($OWNER:$GROUP)"
    printf "       %-14s : %s\n" "Size"          "${SIZE:-< 1K}"
    # Display contents if non-empty
    if [ -s "$GIT_SYSTEM_CONFIG" ]; then
        echo "       Contents      :"
        while IFS= read -r LINE; do
            echo "         $LINE"
        done < "$GIT_SYSTEM_CONFIG"
    fi
else
    echo "       NOT FOUND — Git installed but no system config set yet."
    echo "       (This is normal; system config is optional.)"
fi

echo ""

# ────────────────────────────────────────────────────────────
# CHECK USER-LEVEL GIT CONFIG (~/.gitconfig)
# ────────────────────────────────────────────────────────────
echo "  [2] User config        : $GIT_USER_CONFIG"
if [ -f "$GIT_USER_CONFIG" ]; then
    PERMS=$(ls -l "$GIT_USER_CONFIG" | awk '{print $1}')
    OWNER=$(ls -l "$GIT_USER_CONFIG" | awk '{print $3}')
    SIZE=$(du -sh "$GIT_USER_CONFIG" 2>/dev/null | cut -f1)
    printf "       %-14s : %s\n" "Permissions"  "$PERMS  (owner: $OWNER)"
    printf "       %-14s : %s\n" "Size"          "${SIZE:-< 1K}"
    echo "       Contents      :"
    while IFS= read -r LINE; do
        echo "         $LINE"
    done < "$GIT_USER_CONFIG"
elif [ -f "$GIT_USER_ALT" ]; then
    # Check the alternative location ~/.config/git/config
    echo "       NOT FOUND at ~/.gitconfig"
    echo "       Found at alternative location: $GIT_USER_ALT"
    PERMS=$(ls -l "$GIT_USER_ALT" | awk '{print $1}')
    printf "       %-14s : %s\n" "Permissions"  "$PERMS"
else
    echo "       NOT FOUND — run the following to create it:"
    echo "         git config --global user.name  'Nishad Mehta'"
    echo "         git config --global user.email 'your@email.com'"
fi

echo ""
echo "================================================================"
echo "  WHY LINUX PERMISSIONS EMBODY OPEN-SOURCE VALUES"
echo "================================================================"
echo ""
echo "  /etc          (755) — Readable by all users. Transparency in"
echo "                        system configuration; nothing is hidden."
echo ""
echo "  /var/log      (755) — Logs visible to admins. Auditability:"
echo "                        a core principle of trustworthy systems."
echo ""
echo "  /home         (755) — Each user owns their space. Personal"
echo "                        freedom and privacy within a shared system."
echo ""
echo "  /usr/bin      (755) — Executables readable by all. Programs"
echo "                        are not locked away from inspection."
echo ""
echo "  /tmp         (1777) — Sticky bit: shared but owner-protected."
echo "                        Collaboration without trampling on others."
echo ""
echo "  /opt          (755) — Optional third-party software. An open"
echo "                        slot for the community to add to the system."
echo ""
echo "================================================================"
