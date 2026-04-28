# 🛡️ Secure Resource Manager API

An enterprise-ready Spring Boot 4 REST API featuring **Stateless JWT Security**, **AWS Secrets Manager integration**, and fully automated **Dockerized Orchestration**.

## 🚀 One-Command Quick Start (Recommended)
This project is fully containerized. You do not need Java, Maven, or MySQL installed on your host machine to run the full stack.

1. **Configure Environment:**
   ```bash
   cp env.example .env
   # Open .env and add your credentials. AWS is optional for local testing.
   ```

2. **Build and Launch:**
   ```bash
   ./mvnw clean package -DskipTests && docker compose up --build -d
   ```
*The API will be live at `http://localhost:8080` with a pre-seeded database.*

## 🏗️ Architectural Highlights
*   **Infrastructure-as-Code:** Uses **Docker Compose** to orchestrate a MySQL 8.0 instance and the Spring Boot service with private virtual networking.
*   **Hybrid Secret Management:** Integrates with **AWS Secrets Manager** for production keys, with a local `.env` fallback for disconnected development.
*   **Stateless Security:** Implements a custom **JWT Filter Chain** with BCrypt hashing for secure, scalable authentication.
*   **Automated Data Seeding:** Leverages **Spring Deferred Initialization** to ensure Hibernate schema generation completes before executing `data.sql`.

## 📡 Core API Endpoints


| Method | Endpoint | Access | Description |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/auth/login` | Public | Authenticates user and returns JWT |
| `GET` | `/api/employees` | Authenticated | Retrieves seeded employee data |

## 🛠️ Developer Workflow

### Testing with PowerShell
```powershell
# 1. Login to get your Token
$body = @{username="user"; password="your_bcrypt_password"} | ConvertTo-Json
$login = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method Post -Body $body -ContentType "application/json"

# 2. Access Secure Data
$headers = @{ "Authorization" = "Bearer $($login.token)" }
Invoke-RestMethod -Uri "http://localhost:8080/api/employees" -Method Get -Headers $headers
```

## ❓ Troubleshooting

| Issue | Cause | Solution |
| :--- | :--- | :--- |
| **Duplicates in GET** | Data persists in Docker volumes. | Run `docker compose down -v` to wipe the volume. |
| **Connection Refused** | Database is still initializing. | Check logs: `docker compose logs -f db`. |
| **AWS Connection Error** | Missing keys or no internet. | Ensure `resourcemanager.jwt.secret` is set in `.env` for local fallback. |
| **ClassNotFoundException** | Docker is using a stale JAR. | Run `./mvnw clean package` and `docker compose up --build`. |

## 🔒 Security Compliance
*   **No Hardcoded Credentials:** Sensitive data is injected via environment variables or fetched from AWS.
*   **Least Privilege:** Application connects to MySQL via a restricted `springuser` account.
*   **Environment Isolation:** `.env` files are strictly excluded from version control via `.gitignore`.

## License

This project is provided as-is for educational purposes.

## Author

Chris Melius
