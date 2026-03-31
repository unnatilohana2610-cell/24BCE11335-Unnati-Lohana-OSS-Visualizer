#!/bin/bash
# ============================================================
# Script 4: Log File Analyzer
# Author   : Vedant Singh | Reg No: 24BCE10073
# Course   : Open Source Software (OSS NGMC) | VITyarthi
# Date     : March 2026
# Description:
#   Reads a log file line by line, counts keyword matches,
#   prints the last 5 matching lines, and retries with
#   fallback log locations if the file is not found.
#
# Usage:
#   ./script4_log_analyzer.sh /path/to/logfile [KEYWORD]
#   ./script4_log_analyzer.sh /var/log/syslog error
#   ./script4_log_analyzer.sh /var/log/syslog WARNING
#
# Shell Concepts Demonstrated:
#   - Command-line arguments: $1 (file), $2 (keyword)
#   - Default value assignment: ${2:-"error"}
#   - while IFS= read -r loop (safe line-by-line reading)
#   - if-then inside a loop for keyword matching
#   - Counter variable with arithmetic expansion $(( ))
#   - Bash array accumulation: ARRAY+=("element")
#   - Array slicing: ${ARRAY[@]:START:LENGTH}
#   - Do-while simulation using a boolean flag variable
#   - Exit codes: exit 0 (success), exit 1 (error)
# ============================================================

# ────────────────────────────────────────────────────────────
# COMMAND-LINE ARGUMENTS
# $1 = path to log file (required)
# $2 = search keyword (optional; defaults to "error")
#
# ${2:-"error"}: parameter expansion with default value.
# If $2 is unset or empty, use "error" instead.
# ────────────────────────────────────────────────────────────
LOGFILE="$1"
KEYWORD="${2:-"error"}"

# Counter for how many matching lines we find
COUNT=0

# Bash array to store matching lines for later display
# Declared as empty; elements added inside the while loop
MATCH_LINES=()

echo "================================================================"
echo "        Log File Analyzer                                       "
echo "        Author: Vedant Singh | Reg No: 24BCE10073              "
echo "================================================================"
echo ""

# ────────────────────────────────────────────────────────────
# VALIDATE: Was a log file path provided at all?
# [ -z "$LOGFILE" ]: true if LOGFILE is empty (zero length)
# ────────────────────────────────────────────────────────────
if [ -z "$LOGFILE" ]; then
    echo "  ERROR: No log file specified."
    echo ""
    echo "  Usage  : $0 /path/to/logfile [keyword]"
    echo "  Example: $0 /var/log/syslog error"
    echo ""
    echo "  Common log files:"
    echo "    /var/log/syslog   — Ubuntu / Debian"
    echo "    /var/log/messages — Fedora / CentOS / RHEL"
    echo "    /var/log/kern.log — Kernel messages"
    echo "    /var/log/auth.log — Authentication events"
    exit 1   # Exit with code 1 to signal an error to the caller
fi

# ────────────────────────────────────────────────────────────
# VALIDATE: Does the log file exist and is it readable?
# [ ! -f "$LOGFILE" ]: true if file does NOT exist (or is not a regular file)
# ────────────────────────────────────────────────────────────
if [ ! -f "$LOGFILE" ]; then
    echo "  WARNING: File '$LOGFILE' not found."
    echo ""

    # ──────────────────────────────────────────────────────
    # DO-WHILE SIMULATION
    # Bash has no native do-while loop.
    # We simulate it by:
    #   1. Setting RETRY=true before the loop
    #   2. Using  while $RETRY; do ... done
    #   3. Setting RETRY=false inside the loop to stop,
    #      OR letting ATTEMPT reach MAX_ATTEMPTS.
    #
    # This guarantees the loop body runs AT LEAST ONCE —
    # the defining characteristic of a do-while.
    # ──────────────────────────────────────────────────────
    RETRY=true      # Boolean flag (Bash treats any non-empty string as true)
    ATTEMPT=0
    MAX_ATTEMPTS=3

    while $RETRY; do
        ATTEMPT=$(( ATTEMPT + 1 ))   # Arithmetic expansion: increment counter
        echo "  Retry attempt $ATTEMPT of $MAX_ATTEMPTS..."

        # Choose a fallback log file based on the attempt number
        case $ATTEMPT in
            1) FALLBACK="/var/log/syslog"   ;;   # Ubuntu / Debian
            2) FALLBACK="/var/log/messages" ;;   # Fedora / RHEL
            3) FALLBACK="/var/log/kern.log" ;;   # Kernel log
        esac

        if [ -f "$FALLBACK" ]; then
            echo "  Found fallback: $FALLBACK"
            LOGFILE="$FALLBACK"
            RETRY=false   # Stop retrying — we have a valid file
        elif [ "$ATTEMPT" -ge "$MAX_ATTEMPTS" ]; then
            # Reached the maximum number of attempts — give up
            echo ""
            echo "  No fallback log files found after $MAX_ATTEMPTS attempts."
            echo "  Please provide a valid log file path and try again."
            exit 1
        fi
    done

    echo ""
fi

# ────────────────────────────────────────────────────────────
# VALIDATE: Is the file empty?
# [ ! -s "$LOGFILE" ]: true if file exists but has zero size
# ────────────────────────────────────────────────────────────
if [ ! -s "$LOGFILE" ]; then
    echo "  WARNING: '$LOGFILE' is empty. Nothing to analyse."
    exit 0
fi

echo "  Log File : $LOGFILE"
echo "  Keyword  : '$KEYWORD'  (case-insensitive match)"
echo ""
echo "  Scanning..."
echo ""

# ────────────────────────────────────────────────────────────
# WHILE READ LOOP — safe line-by-line file processing
#
# while IFS= read -r LINE; do ... done < "$LOGFILE"
#
# Key design decisions:
#   IFS=  — set Internal Field Separator to empty.
#           Prevents read from stripping leading/trailing spaces.
#   -r    — raw mode: backslashes are NOT interpreted as escape
#           sequences. Preserves literal backslashes in log lines.
#   < "$LOGFILE" — redirect the file into the loop as stdin.
#           CRITICAL: do NOT use  cat "$LOGFILE" | while read
#           because the pipe creates a subshell; any variable
#           changes (COUNT, MATCH_LINES) would be lost when the
#           subshell exits. The redirect avoids this.
# ────────────────────────────────────────────────────────────
while IFS= read -r LINE; do

    # ── KEYWORD MATCHING ──────────────────────────────────
    # echo "$LINE" | grep -iq "$KEYWORD"
    #   -i: case-insensitive match
    #   -q: quiet — no output, just the exit code (0=found, 1=not found)
    # The if-then checks the exit code of the grep pipeline.
    if echo "$LINE" | grep -iq "$KEYWORD"; then

        # Increment counter using arithmetic expansion
        COUNT=$(( COUNT + 1 ))

        # Append the matching line to our array
        # += is bash array append: MATCH_LINES=("${MATCH_LINES[@]}" "$LINE")
        MATCH_LINES+=("$LINE")
    fi

done < "$LOGFILE"

# ────────────────────────────────────────────────────────────
# DISPLAY RESULTS
# ────────────────────────────────────────────────────────────
echo "  ----------------------------------------------------------------"
echo "  SUMMARY"
echo "  ----------------------------------------------------------------"
echo "  Keyword  : '$KEYWORD'"
echo "  File     : $LOGFILE"
echo "  Matches  : $COUNT line(s) contain '$KEYWORD'"
echo ""

if [ "$COUNT" -gt 0 ]; then

    # ── ARRAY SLICING: show last 5 matching lines ─────────
    # ${#MATCH_LINES[@]} : total number of elements in the array
    # We want the last 5 (or fewer if COUNT < 5).
    #
    # START index calculation:
    #   If TOTAL > 5: start at (TOTAL - 5)
    #   Otherwise   : start at 0 (show everything)
    # The ternary-style expression: $(( TOTAL > 5 ? TOTAL - 5 : 0 ))
    TOTAL=${#MATCH_LINES[@]}
    START=$(( TOTAL > 5 ? TOTAL - 5 : 0 ))
    SHOW=$(( TOTAL - START ))

    echo "  Last $SHOW matching line(s) [of $COUNT total]:"
    echo "  ----------------------------------------------------------------"

    # C-style for loop: iterate from START index to end of array
    for (( i=START; i<TOTAL; i++ )); do

        # Bash string slicing: ${STRING:OFFSET:LENGTH}
        # Truncate lines at 110 characters for clean terminal display
        DISPLAY_LINE="${MATCH_LINES[$i]:0:110}"

        # Print with a sequence number (i - START + 1) gives 1-based index
        printf "  [%d] %s\n" "$(( i - START + 1 ))" "$DISPLAY_LINE"
    done
    echo ""
    echo "  Tip: Pipe through 'less' for scrollable output:"
    echo "       $0 $LOGFILE $KEYWORD | less"

else
    echo "  No lines matched '$KEYWORD' in $LOGFILE."
    echo ""
    echo "  Suggestions:"
    echo "    - Try a different keyword:  $0 $LOGFILE WARNING"
    echo "    - Try a different log file: $0 /var/log/auth.log $KEYWORD"
    echo "    - Keyword matching is case-insensitive, so 'error' = 'ERROR'."
fi

echo ""
echo "================================================================"

# Exit with code 0 to signal success to any calling script or CI system
exit 0
