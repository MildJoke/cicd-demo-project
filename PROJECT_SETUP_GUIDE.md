# CI/CD Pipeline Setup Guide

## Complete Step-by-Step Process

This document provides detailed instructions to set up the entire CI/CD pipeline from scratch.

---

## Phase 1: GitHub Repository Setup ✅ COMPLETED

### Step 1.1: Create GitHub Repository
1. Go to GitHub.com and log in to your account
2. Click "New repository" or go to https://github.com/new
3. Repository name: `cicd-demo-project`
4. Description: `CI/CD demonstration with Jenkins and AWS EC2`
5. Set to Public (for easier webhook setup)
6. Do NOT initialize with README (we already have one)
7. Click "Create repository"

### Step 1.2: Push Local Code to GitHub
```bash
# Add remote origin (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/cicd-demo-project.git

# Push code to GitHub
git branch -M main
git push -u origin main
```

---

## Phase 2: AWS EC2 Instance Setup

### Step 2.1: Launch EC2 Instance
1. Log in to AWS Console
2. Navigate to EC2 Dashboard
3. Click "Launch Instance"
4. **Instance Configuration:**
   - Name: `cicd-demo-server`
   - AMI: Ubuntu Server 22.04 LTS (Free tier eligible)
   - Instance Type: t2.micro (Free tier eligible)
   - Key pair: Create new or use existing (download .pem file)
   - Security Group: Create new with these rules:
     - SSH (22): Your IP or Jenkins server IP
     - HTTP (80): Anywhere (0.0.0.0/0)
     - HTTPS (443): Anywhere (0.0.0.0/0) - Optional

### Step 2.2: Configure EC2 Instance
```bash
# Connect to your EC2 instance
ssh -i your-key.pem ubuntu@your-ec2-public-ip

# Update system
sudo apt update && sudo apt upgrade -y

# Install Apache2
sudo apt install apache2 -y

# Start and enable Apache2
sudo systemctl start apache2
sudo systemctl enable apache2

# Test Apache2 installation
curl localhost
# You should see the Apache2 default welcome page

# Create application directory
sudo mkdir -p /tmp/app
sudo chown ubuntu:ubuntu /tmp/app
```

### Step 2.3: Note Your EC2 Public IP
```bash
# Get your public IP
curl http://checkip.amazonaws.com
```
**Save this IP - you'll need it for Jenkins configuration!**

---

## Phase 3: Jenkins Server Setup

### Step 3.1: Launch Jenkins EC2 Instance (or use existing server)
1. Launch another EC2 instance for Jenkins (t2.medium recommended)
2. Or use your local machine with Jenkins installed

### Step 3.2: Install Jenkins
```bash
# On Ubuntu (for EC2 instance)
sudo apt update
sudo apt install openjdk-11-jdk -y

# Add Jenkins repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt update
sudo apt install jenkins -y

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Get initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### Step 3.3: Configure Jenkins
1. Access Jenkins: `http://your-jenkins-server:8080`
2. Enter initial admin password
3. Install suggested plugins
4. Create admin user
5. Install additional plugins:
   - Pipeline Plugin
   - Git Plugin
   - SSH Agent Plugin
   - Build Pipeline Plugin

### Step 3.4: Configure SSH Keys for EC2 Access
```bash
# On Jenkins server, generate SSH key
ssh-keygen -t rsa -b 4096 -f ~/.ssh/ec2-key

# Copy public key to EC2 instance
ssh-copy-id -i ~/.ssh/ec2-key.pub ubuntu@your-ec2-public-ip

# Test SSH connection
ssh -i ~/.ssh/ec2-key ubuntu@your-ec2-public-ip
```

---

## Phase 4: Jenkins Pipeline Configuration

### Step 4.1: Create Jenkins Pipeline Job
1. In Jenkins Dashboard, click "New Item"
2. Enter name: `cicd-demo-pipeline`
3. Select "Pipeline" and click OK
4. In Configuration:
   - **Description:** CI/CD Demo Pipeline
   - **Pipeline Definition:** Pipeline script from SCM
   - **SCM:** Git
   - **Repository URL:** Your GitHub repository URL
   - **Branch:** `*/main`
   - **Script Path:** `Jenkinsfile`

### Step 4.2: Update Jenkinsfile with Your EC2 IP
1. Edit the Jenkinsfile in your repository
2. Replace `your-ec2-public-ip` with your actual EC2 public IP
3. Commit and push changes:
```bash
git add Jenkinsfile
git commit -m "Update EC2 IP in Jenkinsfile"
git push origin main
```

### Step 4.3: Configure Jenkins Credentials
1. Go to Jenkins Dashboard → Manage Jenkins → Manage Credentials
2. Add SSH private key:
   - Kind: SSH Username with private key
   - ID: `ec2-ssh-key`
   - Username: `ubuntu`
   - Private Key: Paste contents of `~/.ssh/ec2-key`

---

## Phase 5: Testing the Pipeline

### Step 5.1: Manual Pipeline Execution
1. Go to your pipeline job in Jenkins
2. Click "Build Now"
3. Monitor the build progress
4. Check console output for any errors

### Step 5.2: Verify Deployment
1. Open browser and go to: `http://your-ec2-public-ip`
2. You should see the "Hi, I'm Here!" application
3. Check that the build timestamp is updated

### Step 5.3: Test Automated Triggers (Optional)
1. Configure GitHub webhook:
   - Go to your GitHub repository
   - Settings → Webhooks → Add webhook
   - Payload URL: `http://your-jenkins-server:8080/github-webhook/`
   - Content type: `application/json`
   - Events: Push events

2. Make a change to `index.html` and push:
```bash
# Edit index.html to change version or content
git add index.html
git commit -m "Update application content"
git push origin main
```

3. Verify that Jenkins automatically starts a new build

---

## Phase 6: Documentation and Submission

### Step 6.1: Document Tracked and Ignored Files
**Files tracked by Git:**
- `index.html` - Main application file
- `deploy.sh` - Deployment script
- `Jenkinsfile` - CI/CD pipeline configuration
- `README.md` - Project documentation
- `.gitignore` - Git ignore rules
- `PROJECT_SETUP_GUIDE.md` - This setup guide

**Files ignored by Git (.gitignore):**
- `build-info.txt` - Generated during build
- `*.log` - Log files
- `.DS_Store` - System files
- `*.pem`, `*.key` - SSH keys (security)
- `node_modules/` - Dependencies
- `*.backup.*` - Backup files

### Step 6.2: Final Verification Checklist
- [ ] GitHub repository is public and accessible
- [ ] EC2 instance is running and accessible via HTTP
- [ ] Jenkins pipeline executes successfully
- [ ] Application deploys and shows "Hi, I'm Here!" message
- [ ] All files are properly tracked/ignored in Git
- [ ] Documentation is complete

---

## Troubleshooting Common Issues

### Issue 1: SSH Connection Failed
**Solution:**
```bash
# Check security group allows SSH from Jenkins server
# Verify SSH key permissions
chmod 600 ~/.ssh/ec2-key
```

### Issue 2: Apache2 Not Starting
**Solution:**
```bash
# Check Apache2 status
sudo systemctl status apache2

# Restart if needed
sudo systemctl restart apache2
```

### Issue 3: Jenkins Build Fails
**Solution:**
1. Check Jenkins console output
2. Verify GitHub repository URL is correct
3. Ensure SSH keys are properly configured
4. Check EC2 instance is running

### Issue 4: Website Not Accessible
**Solution:**
1. Check EC2 security group allows HTTP (port 80)
2. Verify Apache2 is running: `sudo systemctl status apache2`
3. Check if deployment script ran successfully

---

## Project Submission Checklist

✅ **GitHub Repository:**
- Repository created and code pushed
- Repository URL: `https://github.com/YOUR_USERNAME/cicd-demo-project`

✅ **CI/CD Pipeline:**
- Jenkins server configured and running
- Pipeline successfully builds and deploys
- Automated deployment to EC2 instance

✅ **Documentation:**
- README.md with complete project overview
- PROJECT_SETUP_GUIDE.md with step-by-step instructions
- Tracked and ignored files documented

✅ **Live Application:**
- Application accessible at: `http://your-ec2-public-ip`
- Shows "Hi, I'm Here!" message
- Displays build timestamp

---

## Next Steps for Enhancement

1. **Add Automated Testing:**
   - Unit tests for application logic
   - Integration tests for deployment process

2. **Implement Blue-Green Deployment:**
   - Zero-downtime deployments
   - Automatic rollback on failure

3. **Add Monitoring:**
   - Application health monitoring
   - Deployment notifications (Slack, email)

4. **Security Improvements:**
   - HTTPS configuration
   - Secrets management
   - Security scanning in pipeline

---

**Repository URL to Submit:** `https://github.com/YOUR_USERNAME/cicd-demo-project`

Replace `YOUR_USERNAME` with your actual GitHub username.
