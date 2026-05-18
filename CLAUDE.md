# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Business Central (Microsoft Dynamics 365) vacation management project called **RestABit**.

## Business Central Development

This project uses AL (Application Language) for Business Central extensions.

### Key Commands

- **Build/Compile:** Use VS Code with the AL Language extension (`Ctrl+Shift+B`)
- **Publish to sandbox:** `F5` in VS Code (launches BC sandbox and deploys)
- **Run tests:** Use the Test Runner page in Business Central or the AL Test Runner extension
- **Download symbols:** `Alt+A Alt+L` in VS Code

### Project Structure

- `app.json` — Extension manifest (ID, version, dependencies)
- `src/` — AL source files (tables, pages, codeunits, reports, enums)
- `.vscode/launch.json` — BC server/sandbox connection settings
- `.vscode/settings.json` — AL extension settings

### AL Conventions

- Table extensions use suffix `Ext`, e.g., `EmployeeExt`
- Object IDs must stay within the range defined in `app.json`
- Use `OnAfterGetRecord` / `OnAfterGetCurrRecord` for page logic
- Prefer `Codeunit` for business logic over inline page triggers
