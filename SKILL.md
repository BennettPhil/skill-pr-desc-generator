---
name: pr-desc-generator
description: A tool that generates structured pull request descriptions by analyzing git diffs.
version: 0.1.0
license: Apache-2.0
---

# PR Description Generator

## Purpose
This skill automates the creation of pull request descriptions. By analyzing a git diff, it identifies changed files and provides a structured Markdown template with summary, file-specific changes, testing checkboxes, and a review checklist.

## Quick Start

```bash
# Generate from a staged diff
$ git diff --staged | ./scripts/run.sh
# PR Description
...
```

## Usage Examples

### Example: From a saved diff file

```bash
$ ./scripts/run.sh changes.diff
```

### Example: Piping git diff

```bash
$ git diff origin/main...HEAD | ./scripts/run.sh
```

## Options Reference
- `DIFF_FILE`: Path to a file containing a git diff (positional argument). If omitted, reads from stdin.

## Validation
This skill's correctness is validated by `scripts/test.sh`, which ensures that file changes are correctly detected from diffs and sections are properly structured.
