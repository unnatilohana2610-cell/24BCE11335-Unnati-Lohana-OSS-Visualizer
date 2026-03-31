# OSS Audit — Git
### Open Source Software Capstone Project | VITyarthi

---

## Student Information

| Field | Details |
|---|---|
| **Student Name** | *Vedant Singh* |
| **Registration Number** | *24BCE10073* |
| **Chosen Software** | Git |
| **Licence of Software** | GNU General Public License v2 (GPL v2) |
| **Course** | Open Source Software (OSS NGMC) |

---

## About This Project

This repository is the complete submission for the **Open Source Audit** capstone project. The chosen open-source software is **Git** — the distributed version control system created by Linus Torvalds in 2005.

Git was chosen because its origin story is one of the most compelling in open-source history: it was built in direct response to the withdrawal of a proprietary tool's free licence. Its creation is inseparable from the philosophy of software freedom that this course explores.

The repository contains **five shell scripts** and a **written project report** covering Units 1–5 of the course.

---

## Repository Structure

```
oss-audit-24BCE10073/
│
├── README.md                               ← This file
│
├── scripts/
│   ├── script1_system_identity.sh          ← System Identity Report
│   ├── script2_package_inspector.sh        ← FOSS Package Inspector
│   ├── script3_disk_permission_auditor.sh  ← Disk & Permission Auditor
│   ├── script4_log_analyzer.sh             ← Log File Analyzer
│   └── script5_manifesto_generator.sh      ← Open Source Manifesto Generator
│
└── OSS_Audit_Git_Report.pdf                ← Project report (also submitted on portal)
```

---

## Script Descriptions

### Script 1 — System Identity Report
**File:** `script1_system_identity.sh`

Displays a formatted welcome screen showing the current Linux system's identity:
- Linux distribution name and kernel version
- Logged-in user and their home directory
- System uptime and current date/time
- The open-source licence covering the OS (GPL v2)

> **Shell concepts:** Variables, command substitution `$()`, `echo` formatting, `cat /etc/os-release`, `grep`, `cut`

---

### Script 2 — FOSS Package Inspector
**File:** `script2_package_inspector.sh`

Checks whether the `git` package is installed on the system. Supports both RPM-based (Fedora, CentOS, RHEL) and Debian-based (Ubuntu, Debian) distributions. Displays version, licence, and summary. Uses a `case` statement to print a philosophy note about git and other well-known open-source packages.

> **Shell concepts:** `if-then-else`, `case` statement, `rpm -qi`, `dpkg -l`, `grep -E`, `command -v`, pipe chaining

---

### Script 3 — Disk and Permission Auditor
**File:** `script3_disk_permission_auditor.sh`

Loops through an array of important system directories (`/etc`, `/var/log`, `/home`, `/usr/bin`, `/tmp`, `/var`, `/opt`) and reports permissions, owner, group, and disk usage for each. Also audits Git's system-wide and user-level configuration files specifically.

> **Shell concepts:** Array declaration, `for` loop over array, `[ -d ]` directory test, `ls -ld`, `awk`, `du -sh`, `printf` for formatted output, `2>/dev/null`

---

### Script 4 — Log File Analyzer
**File:** `script4_log_analyzer.sh`

Reads a log file line by line and counts how many lines contain a given keyword (default: `error`, case-insensitive). Prints the last 5 matching lines. Implements a do-while style retry mechanism to try fallback log file locations if the specified file does not exist.

> **Shell concepts:** Command-line arguments (`$1`, `$2`), default value assignment (`${2:-"error"}`), `while IFS= read -r` loop, `if-then` inside loop, counter variables `$(( ))`, bash array accumulation, array slicing, do-while simulation, `exit` codes

---

### Script 5 — Open Source Manifesto Generator
**File:** `script5_manifesto_generator.sh`

Interactively asks the user three questions and composes a personalised open-source philosophy statement using their answers. Saves the manifesto to a `.txt` file named after the current user. Demonstrates the alias concept through a helper function pattern.

> **Shell concepts:** `read -p` for interactive input, string interpolation in `echo`, file writing with `>` and `>>`, `date` command, `whoami`, input validation with `[ -z ]`, function definition as alias pattern, `cat` for output display

---

## How to Run the Scripts

### Prerequisites

Before running the scripts, make sure you have the following:

- A Linux system (physical machine, virtual machine, or WSL2)
- Bash shell (version 4.0 or later)
- For Script 2: either `rpm` (RPM-based distros) or `dpkg` (Debian-based distros)
- For Script 4: a readable log file (see note below)

---

### Step 1 — Clone the Repository

```bash
git clone https://github.com/Sarthak50/Open_Source_Project_GIT.git
cd Open_Source_Project_GIT
```

### Step 2 — Make Scripts Executable

```bash
chmod +x scripts/*.sh
```

### Step 3 — Run Each Script

**Script 1 — System Identity Report**
```bash
./scripts/script1_system_identity.sh
```
No arguments required. Displays system information immediately.

---

**Script 2 — FOSS Package Inspector**
```bash
./scripts/script2_package_inspector.sh
```
No arguments required. Checks for `git` package automatically. Ensure git is installed first:
```bash
# Ubuntu/Debian
sudo apt install git

# Fedora/CentOS/RHEL
sudo dnf install git
```

---

**Script 3 — Disk and Permission Auditor**
```bash
./scripts/script3_disk_permission_auditor.sh
```
No arguments required. Audits standard system directories and Git config locations.

> ⚠️ Some directories (like `/var/log`) may require elevated privileges for size reporting:
```bash
sudo ./scripts/script3_disk_permission_auditor.sh
```

---

**Script 4 — Log File Analyzer**
```bash
# Basic usage with default keyword 'error'
./scripts/script4_log_analyzer.sh /var/log/syslog

# With a custom keyword
./scripts/script4_log_analyzer.sh /var/log/syslog WARNING

# On Fedora/CentOS — use messages instead
./scripts/script4_log_analyzer.sh /var/log/messages error
```
> If no log file is accessible, the script will automatically try fallback locations.

---

**Script 5 — Open Source Manifesto Generator**
```bash
./scripts/script5_manifesto_generator.sh
```
Interactive — the script will prompt you for three answers. Your manifesto is saved as `manifesto_[yourusername].txt` in the current directory.

---

## Dependencies

| Dependency | Used In | How to Install |
|---|---|---|
| `bash` (v4+) | All scripts | Pre-installed on all Linux distros |
| `git` | Scripts 2, 3 | `sudo apt install git` or `sudo dnf install git` |
| `rpm` or `dpkg` | Script 2 | Pre-installed on RPM/Debian-based distros |
| `awk`, `grep`, `cut`, `du`, `ls` | Scripts 1, 2, 3, 4 | Part of GNU coreutils — pre-installed everywhere |
| `uname`, `whoami`, `uptime`, `date` | Script 1 | Pre-installed on all POSIX systems |

---

## Tested On

| Distribution | Version | Architecture |
|---|---|---|
| Ubuntu | 22.04 LTS | x86_64 |
| Fedora | 39 | x86_64 |
| Debian | 12 (Bookworm) | x86_64 |

---

## Academic Integrity

All written content in the project report is the original work of the student. Shell scripts were written and tested by the student. Any external references consulted are cited within the report.

---

## Licence

The shell scripts in this repository are released under the **MIT Licence** — in the spirit of the open-source values explored in the project itself.

```
MIT License

Copyright (c) 2026 Nishad Mehta

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```

---

<p align="center">Made with ❤️ for Open Source | VITyarthi | 2026</p>
