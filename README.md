# Azure Infrastructure-as-Code (IaC) Templates

## Overview 

This repository contains Infrastructure-as-Code (IaC) templates maintained by the ISSE team to enable **consistent, secure, and repeatable deployments** across Azure environments.

The templates in this repository are intended to support:
- Standardized Azure resource deployments
- Security-first configurations
- Automation and operational consistency
- Reuse across projects and teams

This repository serves as a **shared foundation** and is expected to evolve as new standards and use cases are introduced.

---

## Scope
The repository may include (but is not limited to):
- Azure IaC templates (e.g., Bicep / ARM)
- Supporting scripts (PowerShell, Bash)
- Parameter and example files
- Documentation for deployment and usage

> ⚠️ **Note**: Refer to individual folders and files for implementation-specific details and usage instructions.

---

## Design Principles
All templates and assets in this repository should align with the following principles:

- **Security by Default**
  - Secure configurations enabled out-of-the-box
  - No hard-coded secrets or credentials
- **Consistency**
  - Standard naming, tagging, and structure
- **Reusability**
  - Modular and parameter-driven design
- **Automation-Friendly**
  - Designed for CI/CD and pipeline execution
- **Compliance-Aware**
  - Supports organizational security and governance requirements

---

## Usage Guidelines

- Do not commit secrets, keys, or credentials.
- Use secure references (e.g., Key Vault, pipeline secrets).
- Validate templates before deployment.
- Follow the review processes before modifying shared templates.

## Getting Started
1. Clone the repository:
   ```bash
   git clone https://github.com/Arafath-Azeem/azure-iac-templates.git

