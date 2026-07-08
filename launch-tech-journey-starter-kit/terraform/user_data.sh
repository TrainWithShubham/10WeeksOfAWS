#!/bin/bash
set -e

# Update packages and install Apache
sudo dnf update -y
sudo dnf install -y httpd

# Enable and start Apache
sudo systemctl enable httpd
sudo systemctl start httpd

# Create colorful demo website
cat <<'HTML' | sudo tee /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Launch Your Tech Journey</title>
  <style>
    * { box-sizing: border-box; }
    body {
      margin: 0;
      font-family: Arial, Helvetica, sans-serif;
      background: radial-gradient(circle at top left, #ff2e63, #111 45%, #020202 100%);
      color: white;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      text-align: center;
      padding: 20px;
    }
    .card {
      max-width: 920px;
      padding: 48px 42px;
      border-radius: 28px;
      background: rgba(255,255,255,0.08);
      border: 1px solid rgba(255,255,255,0.18);
      box-shadow: 0 30px 80px rgba(0,0,0,0.5);
      backdrop-filter: blur(12px);
    }
    h1 {
      font-size: clamp(42px, 7vw, 82px);
      margin: 0 0 12px;
      line-height: 1.05;
    }
    h2 {
      font-size: clamp(24px, 4vw, 42px);
      margin: 0 0 24px;
      color: #ffd166;
    }
    .paths {
      display: flex;
      justify-content: center;
      flex-wrap: wrap;
      gap: 12px;
      margin: 28px 0;
    }
    .pill {
      padding: 10px 16px;
      border-radius: 999px;
      background: rgba(255,255,255,0.12);
      border: 1px solid rgba(255,255,255,0.24);
      font-size: 18px;
    }
    .footer {
      margin-top: 28px;
      font-size: 18px;
      color: #e2e8f0;
    }
    .highlight { color: #00f5d4; font-weight: bold; }
  </style>
</head>
<body>
  <div class="card">
    <h1>Welcome to BCA & B.Sc.</h1>
    <h2>Let’s Start Your Tech Journey</h2>
    <p class="footer">Choose the Right Path with Confidence</p>
    <div class="paths">
      <span class="pill">Full-Stack</span>
      <span class="pill">Cloud</span>
      <span class="pill">DevOps</span>
      <span class="pill">AI</span>
      <span class="pill">MLOps</span>
      <span class="pill">Security</span>
    </div>
    <p class="footer">
      Deployed on <span class="highlight">AWS EC2</span> using
      <span class="highlight">Terraform</span> and <span class="highlight">User Data</span>
    </p>
  </div>
</body>
</html>
HTML

# Set permissions
sudo chown -R apache:apache /var/www/html
sudo chmod -R 755 /var/www/html
