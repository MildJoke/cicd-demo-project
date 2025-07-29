#!/bin/bash

# Simple deployment script for CI/CD Demo
echo "Starting deployment..."

# Create backup of existing files
if [ -d "/var/www/html" ]; then
    sudo cp -r /var/www/html /var/www/html.backup.$(date +%Y%m%d_%H%M%S)
fi

# Copy new files
sudo cp -r * /var/www/html/

# Set proper permissions
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

# Restart web server
sudo systemctl restart apache2

echo "Deployment completed successfully!"
echo "Application is now live at: http://$(curl -s http://checkip.amazonaws.com)"
