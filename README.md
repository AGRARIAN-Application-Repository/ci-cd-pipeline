# Agrarian CI/CD Pipeline

Centralized CI/CD pipeline for the Agrarian organization using GitHub Reusable Workflows.

## 🏆 Professional Approach

This repository contains the **centralized CI/CD pipeline** that all Agrarian applications use. This follows GitHub's best practices for organization-wide CI/CD.

## 🚀 How It Works

### For New Repositories

1. **Create repository** from the Agrarian template
2. **Automatic CI** - The pipeline runs automatically on every push
3. **No configuration needed** - Everything is pre-configured

### For Existing Repositories

1. **Add the workflow file** to `.github/workflows/ci.yml`
2. **Copy the template** from `templates/repo-ci-workflow.yml`
3. **Push to main** - CI runs automatically

## 📁 Repository Structure

```
ci-cd-pipeline/
├── .github/
│   └── workflows/
│       └── agrarian-ci-pipeline.yml    # Reusable workflow (central)
├── templates/
│   └── repo-ci-workflow.yml             # Template for individual repos
└── README.md
```

## 🔧 Usage

### Individual Repository Workflow

Each repository needs only this file:

```yaml
# .github/workflows/ci.yml
name: CI Pipeline

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]
  workflow_dispatch:

permissions:
  contents: read
  packages: write
  id-token: write

jobs:
  ci-pipeline:
    name: Agrarian CI Pipeline
    uses: AGRARIAN-Application-Repository/ci-cd-pipeline/.github/workflows/agrarian-ci-pipeline.yml@main
    with:
      python-version: '3.10'
      app-port: '3000'
    secrets:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## ✅ Benefits

- **Centralized**: One place to maintain CI logic
- **Consistent**: All repos use the same pipeline
- **Maintainable**: Changes apply to all repos automatically
- **Professional**: GitHub's recommended approach
- **Secure**: No hardcoded secrets

## 🔄 Pipeline Steps

1. **Test Application** - Compilation and security checks
2. **Build Docker Image** - Multi-architecture builds
3. **Push to GitHub Packages** - Container registry
4. **Verify Deployment** - Test image functionality

## 📦 Output

- **Docker Images**: `ghcr.io/agrarian-application-repository/{repo-name}:latest`
- **GitHub Packages**: Available in organization packages
- **kube-deploy Integration**: Images appear in deployment UI

## 🛠️ Maintenance

To update the pipeline for all repositories:

1. **Edit** `.github/workflows/agrarian-ci-pipeline.yml`
2. **Commit and push** changes
3. **All repositories** automatically use the updated pipeline

## 🔗 Links

- **Organization**: https://github.com/AGRARIAN-Application-Repository
- **Packages**: https://github.com/orgs/AGRARIAN-Application-Repository/packages
- **kube-deploy**: http://10.222.0.152:8002/
- **kube-dash**: http://10.222.0.152:8001/
