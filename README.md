# CI/CD Demo Application

A simple web application demonstrating continuous integration and deployment using GitHub, Jenkins, and AWS EC2.

## Project Overview

This project showcases a complete CI/CD pipeline that:
- Fetches source code from GitHub
- Builds and tests the application using Jenkins
- Deploys the application to an AWS EC2 instance
- Performs health checks to ensure successful deployment

## Architecture

```
GitHub Repository → Jenkins Pipeline → AWS EC2 Instance
```

## Files in this Repository

### Application Files
- `index.html` - Main HTML page of the web application
- `deploy.sh` - Deployment script that runs on the EC2 instance
- `Jenkinsfile` - Jenkins pipeline configuration

### Configuration Files
- `README.md` - This documentation file
- `.gitignore` - Files and directories ignored by Git

## Prerequisites

1. **GitHub Account** - For source code repository
2. **AWS EC2 Instance** - Ubuntu-based instance with Apache2 installed
3. **Jenkins Server** - With necessary plugins installed

## Setup Instructions

### 1. AWS EC2 Setup

1. Launch an Ubuntu EC2 instance (t2.micro is sufficient)
2. Configure security group to allow:
   - SSH (port 22) from your Jenkins server
   - HTTP (port 80) from anywhere
3. Install Apache2:
   ```bash
   sudo apt update
   sudo apt install apache2 -y
   sudo systemctl start apache2
   sudo systemctl enable apache2
   ```

### 2. Jenkins Setup

1. Install Jenkins on a server (can be another EC2 instance)
2. Install required plugins:
   - Git Plugin
   - Pipeline Plugin
   - SSH Agent Plugin
3. Configure SSH keys for EC2 access
4. Create a new Pipeline job pointing to this GitHub repository

### 3. GitHub Repository Setup

1. Create a new repository on GitHub
2. Push this code to the repository
3. Configure webhook to trigger Jenkins builds (optional)

## Pipeline Stages

1. **Checkout** - Retrieves latest code from GitHub
2. **Build** - Prepares the application for deployment
3. **Test** - Runs basic validation tests
4. **Deploy** - Copies files to EC2 and executes deployment script
5. **Health Check** - Verifies the application is running correctly

## Deployment Process

1. Code changes are pushed to GitHub
2. Jenkins detects changes (via webhook or polling)
3. Pipeline executes automatically:
   - Downloads latest code
   - Runs tests
   - Deploys to EC2 instance
   - Verifies deployment success

## Files Tracked by Git

The following files are tracked in this repository:
- `index.html` - Application frontend
- `deploy.sh` - Deployment automation script
- `Jenkinsfile` - CI/CD pipeline definition
- `README.md` - Project documentation

## Files Ignored by Git

The following files/directories are ignored (see `.gitignore`):
- `build-info.txt` - Generated during build process
- `*.log` - Log files
- `.DS_Store` - MacOS system files
- `node_modules/` - Dependencies (if using Node.js)
- `*.backup.*` - Backup files created during deployment

## Accessing the Application

Once deployed, the application can be accessed at:
```
http://your-ec2-public-ip
```

## Troubleshooting

### Common Issues

1. **SSH Connection Failed**
   - Verify EC2 security group allows SSH from Jenkins server
   - Check SSH key permissions (should be 600)

2. **Deployment Script Fails**
   - Ensure Apache2 is installed and running on EC2
   - Check file permissions and ownership

3. **Health Check Fails**
   - Verify security group allows HTTP traffic
   - Check Apache2 status on EC2 instance

## Future Enhancements

- Add automated testing with Selenium
- Implement blue-green deployment
- Add monitoring and alerting
- Use Docker containers for better isolation
- Implement rollback functionality

## Contact

For questions or issues, please create an issue in this GitHub repository.
