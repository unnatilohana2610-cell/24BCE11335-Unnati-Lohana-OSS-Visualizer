#!/bin/bash
# ============================================================
# Script 5: Open Source Manifesto Generator
# Author   : Vedant Singh | Reg No: 24BCE10073
# Course   : Open Source Software (OSS NGMC) | VITyarthi
# Date     : March 2026
# Description:
#   Interactively asks the user three questions and composes
#   a personalised open-source philosophy statement. Saves
#   the manifesto to a .txt file named after the current user.
#
# Shell Concepts Demonstrated:
#   - read -p for interactive input prompts
#   - String interpolation inside double-quoted echo strings
#   - File writing with > (create/overwrite) and >> (append)
#   - date command for formatted timestamps
#   - whoami for username-based dynamic filename
#   - Input validation with [ -z ] (check for empty input)
#   - Function definition as the shell equivalent of aliases
#   - cat to display the saved file back to the user
#   - Exit codes: exit 1 for validation failure
# ============================================================

# ────────────────────────────────────────────────────────────
# ALIAS CONCEPT — demonstrated through helper functions
#
# In an interactive shell session, you can create shorthand
# commands with 'alias', for example:
#   alias gs='git status'
#   alias ll='ls -la --color=auto'
#
# Shell scripts cannot use alias in the same way (aliases are
# not exported to child processes by default). Instead, we
# define helper functions — these serve the same purpose of
# giving a memorable short name to a longer operation.
#
# Function syntax:
#   function_name() {
#       commands
#   }
# ────────────────────────────────────────────────────────────

# Helper function: print a full-width divider line
print_divider() {
    echo "================================================================"
}

# Helper function: print a named section header
print_section() {
    local TITLE="$1"    # local = variable scoped to this function only
    echo ""
    echo "  ─── $TITLE ───────────────────────────────────────────"
    echo ""
}

# Helper function: print an indented body line
print_line() {
    echo "  $1"
}

# ────────────────────────────────────────────────────────────
# WELCOME SCREEN
# ────────────────────────────────────────────────────────────
clear   # Clear the terminal for a clean, polished start
print_divider
echo "        Open Source Manifesto Generator                        "
echo "        Author: Vedant Singh | Reg No: 24BCE10073              "
print_divider
echo ""
print_line "This script will compose a personalised open-source"
print_line "philosophy statement based on your three answers."
print_line "Your manifesto will be saved as a .txt file."
echo ""
print_divider
echo ""

# ────────────────────────────────────────────────────────────
# INTERACTIVE INPUT using 'read -p'
#
# read -p "prompt" VARIABLE
#   -p: display the prompt string inline (no newline needed)
#   The user's input is stored in VARIABLE.
#
# We use three separate reads to collect three distinct answers,
# each probing a different dimension of the user's relationship
# with open source.
# ────────────────────────────────────────────────────────────

print_section "Question 1 of 3"
print_line "Name ONE open-source tool you rely on every single day."
print_line "(Examples: git, firefox, linux, vscode, python, vlc)"
echo ""
read -p "  Your answer: " TOOL
echo ""

print_section "Question 2 of 3"
print_line "In ONE word, what does 'freedom' mean to you?"
print_line "(Examples: choice, transparency, control, access, autonomy)"
echo ""
read -p "  Your answer: " FREEDOM
echo ""

print_section "Question 3 of 3"
print_line "Name ONE thing you would build and release freely"
print_line "if you had the skills and time."
echo ""
read -p "  Your answer: " BUILD
echo ""

# ────────────────────────────────────────────────────────────
# INPUT VALIDATION
# [ -z "$VAR" ]: true if VAR is empty (zero length)
# We validate all three inputs together and exit with code 1
# if any are blank, giving a clear instruction to the user.
# ────────────────────────────────────────────────────────────
if [ -z "$TOOL" ] || [ -z "$FREEDOM" ] || [ -z "$BUILD" ]; then
    echo ""
    echo "  ERROR: All three questions must be answered."
    echo "  Please run the script again and fill in each response."
    echo ""
    exit 1   # Non-zero exit code signals failure to the caller
fi

# ────────────────────────────────────────────────────────────
# FILE SETUP
# date '+FORMAT': format the current date/time.
#   %d %B %Y  = e.g. 25 March 2026
#   %H:%M     = e.g. 14:32
# whoami: prints the username of the person running the script.
# ────────────────────────────────────────────────────────────
DATE=$(date '+%d %B %Y')       # e.g. 25 March 2026
TIME=$(date '+%H:%M %Z')       # e.g. 14:32 IST
USERNAME=$(whoami)             # The current Linux user's name
OUTPUT="manifesto_${USERNAME}.txt"   # Dynamic filename per user

# ────────────────────────────────────────────────────────────
# WRITE THE MANIFESTO FILE
#
# >  : redirect output, CREATING the file (overwrites if exists)
# >> : append to the file (adds to existing content)
#
# We use > for the first line to ensure a fresh file each run,
# then >> to append every subsequent line.
#
# String interpolation: inside double quotes "...", bash replaces
# $VARIABLE with its value. This is what makes the manifesto
# personalised — the three answers are woven into the text.
# ────────────────────────────────────────────────────────────

# Start fresh — overwrite any existing manifesto file
echo "OPEN SOURCE MANIFESTO"                               >  "$OUTPUT"
echo "Generated: $DATE at $TIME"                          >> "$OUTPUT"
echo "Author   : $USERNAME"                               >> "$OUTPUT"
echo "================================================================" >> "$OUTPUT"
echo ""                                                   >> "$OUTPUT"

# ── PARAGRAPH 1: Daily tool and the debt we owe ──────────
echo "I am a student of open source — not just of its code, but of" >> "$OUTPUT"
echo "its values. Every day, I rely on $TOOL, a tool built by people" >> "$OUTPUT"
echo "I have never met, who chose to share their work with the world." >> "$OUTPUT"
echo "They asked nothing in return except that I carry the same spirit" >> "$OUTPUT"
echo "forward. That choice — to share rather than hoard — is the reason" >> "$OUTPUT"
echo "so much of the modern digital world exists at all."  >> "$OUTPUT"
echo ""                                                   >> "$OUTPUT"

# ── PARAGRAPH 2: Personal definition of freedom ──────────
echo "To me, freedom means $FREEDOM. That is why open source matters" >> "$OUTPUT"
echo "beyond software: it is a commitment to the idea that knowledge" >> "$OUTPUT"
echo "grows stronger when it is shared. The GPL, the MIT licence, and" >> "$OUTPUT"
echo "the Apache licence are not just legal documents — they are"      >> "$OUTPUT"
echo "agreements between strangers to trust one another. Every fork,"  >> "$OUTPUT"
echo "every pull request, every issue filed is an act of that trust."  >> "$OUTPUT"
echo ""                                                   >> "$OUTPUT"

# ── PARAGRAPH 3: Future contribution and the pledge ──────
echo "One day, I intend to build $BUILD and release it freely under" >> "$OUTPUT"
echo "an open licence. I will do this because I understand what it"   >> "$OUTPUT"
echo "means to stand on the shoulders of those who came before. The"  >> "$OUTPUT"
echo "developers who built $TOOL did not hoard their work. The"       >> "$OUTPUT"
echo "engineers who designed Linux did not lock it away. Science,"    >> "$OUTPUT"
echo "mathematics, and the best of human knowledge have always grown" >> "$OUTPUT"
echo "by sharing. I will not break that chain."                       >> "$OUTPUT"
echo ""                                                   >> "$OUTPUT"
echo "This is my commitment to the open-source way."     >> "$OUTPUT"
echo ""                                                   >> "$OUTPUT"
echo "                         — $USERNAME, $DATE"       >> "$OUTPUT"
echo "================================================================" >> "$OUTPUT"

# ────────────────────────────────────────────────────────────
# DISPLAY: Show the finished manifesto on screen
# cat: concatenate file and print to stdout
# ────────────────────────────────────────────────────────────
print_divider
echo ""
print_line "Your manifesto has been generated and saved!"
print_line "File: $OUTPUT"
echo ""
print_divider
echo ""
cat "$OUTPUT"   # Display the saved manifesto back to the user
echo ""
print_divider
print_line "Next steps:"
print_line "  - Commit it to your Git repository:"
print_line "      git add $OUTPUT && git commit -m 'Add open source manifesto'"
print_line "  - Share it with your course instructor."
print_line "  - Let it remind you why open source matters."
print_divider
echo ""

exit 0
