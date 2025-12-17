# Nginx Proxy Manager & Code Server

## Overview

This project provides a containerized setup to deploy:

- **Nginx Proxy Manager (NPM)**: A reverse proxy with a user-friendly interface for managing access and routing.
- **Code Server**: A browser-accessible VS Code environment for remote development.

It includes a sample Python project (`dash-test`) to validate the deployment and routing setup.

## Project Structure

```
code-server/
├── config/
│   └── code-server/
│       ├── config.yaml        # Main configuration file (includes hashed-password)
│       └── settings.json      # VS Code user settings
├── projects/
│   └── dash-test/
│       ├── app.py             # Sample Dash app
│       └── requirements.txt   # Python dependencies
├── code-server.Dockerfile     # Dockerfile for code-server
└── docker-compose.yml         # Compose file to orchestrate services
```

## Code Server Configuration

The config.yaml file includes a required field:

```yaml
hashed-password: <your_argon2_hash>
```
This must be filled with an Argon2-hashed password to enable authentication.

### How to generate an Argon2 hash

You can use the code-server CLI or Python's argon2-cffi:

Using code-server CLI

```bash
  docker run --rm codercom/code-server:latest code-server hash-password
```

Using Python
```python
from argon2 import PasswordHasher
ph = PasswordHasher()
print(ph.hash("your-password"))
```

## Deployment

### Prerequisites

- Docker & Docker Compose installed
- Domain name (optional, for routing via NPM)

### Launch

```bash
  docker-compose up -d
```

This will start:

nginx-proxy-manager on ports 80, 443, and 81

code-server on port 8080

## Nginx Proxy Manager Setup

NPM allows you to:

Create Access Lists to restrict access to specific web services based on user groups

Route domain names to internal services via reverse proxy

| Field                | Value                          | Notes                                   |
|-----------------------|--------------------------------|-----------------------------------------|
| Domain Names          | `<your-domain>`                | Must be set by the user                 |
| Scheme                | http                           | Fixed value                             |
| Forward Hostname/IP   | code-server                    | Default internal service name           |
| Forward Port          | 8080                           | Default port                            |
| Access List           | `<your-access-list>`           | Must be set by the user (custom policy) |
| Cache Assets          | ✅                             | Recommended                             |
| Block Common Exploits | ✅                             | Recommended                             |
| Websockets Support    | ✅                             | Recommended                             |



## Testing Setup
The projects/dash-test directory contains a minimal Python Dash app to verify that:

Code Server is running correctly

Routing via NPM is functional

Web access restrictions are enforced

## Resources

- [Nginx Proxy Manager Documentation](https://nginxproxymanager.com/)
- [Code Server Documentation](https://coder.com/docs/code-server/latest)

---

## Credits & Copyright

- Project by **Timothé Le Chatelier**
- © 2025 All rights reserved
