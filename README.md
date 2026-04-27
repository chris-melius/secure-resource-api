# Secure Resource API

A Spring Boot REST API that demonstrates JWT-based authentication and secure resource access to a MySQL database.

## Features

- **JWT Authentication**: Token-based authentication for secure API access
- **Spring Security Integration**: Role-based access control and stateless session management
- **MySQL Database**: Persistent storage of employee resources
- **BCrypt Password Encoding**: Secure password hashing
- **AWS Secrets Manager Support**: Production-ready secret management

## Prerequisites

- Java 21 or higher
- MySQL 8.0 or higher
- Maven 3.9.14 or higher (or use the included Maven wrapper)

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd secure-resource-api
```

### 2. Configure Environment Variables

Create a `.env.local` file in the project root (copy from `env.example`):

```bash
cp env.example .env.local
```

Edit `.env.local` and set your values:

```properties
DB_PASSWORD=your_mysql_password_here
BCRYPT_PASSWORD=your_bcrypt_test_password_here
```

**Note**: The `.env.local` file is ignored by git and should never be committed.

### 3. Set Up MySQL Database

#### Option A: Using MySQL CLI

```bash
# Connect to MySQL as root
mysql -u root -p

# Create the database
CREATE DATABASE resource_db;

# Create a user for the application
CREATE USER 'springuser'@'localhost' IDENTIFIED BY 'your_mysql_password_here';

# Grant privileges
GRANT ALL PRIVILEGES ON resource_db.* TO 'springuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

#### Option B: Using MySQL Workbench

1. Open MySQL Workbench
2. Create a new schema named `resource_db`
3. Create a new user `springuser` with your chosen password
4. Grant all privileges on `resource_db` to `springuser`

### 4. Create the Employee Table

The application will automatically create the `Employee` table on startup due to `spring.jpa.hibernate.ddl-auto=update` in `application.properties`.

**Manual SQL (if needed)**:

```sql
USE resource_db;

CREATE TABLE employee (
  id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);
```

### 5. Update Application Configuration

The application uses environment variables to configure the database and JWT secrets:

- `DB_PASSWORD`: MySQL password for the `springuser` account
- `BCRYPT_PASSWORD`: Password for the in-memory test user (username: `user`)

These are loaded from `.env.local` via Spring's configuration import system.

## Running the Application

### Using Maven Wrapper

**On Windows**:
```bash
mvnw.cmd spring-boot:run
```

**On Linux/Mac**:
```bash
./mvnw spring-boot:run
```

### Using Maven

```bash
mvn spring-boot:run
```

The application will start on `http://localhost:8080`

## API Endpoints

### 1. Authentication

**Login and get JWT token**

```http
POST /api/auth/login
Content-Type: application/json

{
  "username": "user",
  "password": "your_bcrypt_test_password_here"
}
```

**Response**:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### 2. Employees

**Get all employees**

```http
GET /api/employees
Authorization: Bearer <your_jwt_token>
```

**Response**:
```json
[
  {
    "id": 1,
    "name": "John Doe"
  },
  {
    "id": 2,
    "name": "Jane Smith"
  }
]
```

**Create a new employee**

```http
POST /api/employees
Authorization: Bearer <your_jwt_token>
Content-Type: application/json

{
  "name": "Alice Johnson"
}
```

**Response**:
```json
{
  "id": 3,
  "name": "Alice Johnson"
}
```

## Testing the API

### 1. Get a JWT Token

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"user","password":"your_bcrypt_test_password_here"}'
```

### 2. Use the Token to Access Resources

```bash
curl -X GET http://localhost:8080/api/employees \
  -H "Authorization: Bearer <your_jwt_token>"
```

### 3. Create an Employee

```bash
curl -X POST http://localhost:8080/api/employees \
  -H "Authorization: Bearer <your_jwt_token>" \
  -H "Content-Type: application/json" \
  -d '{"name":"Bob Wilson"}'
```

## Project Structure

```
src/main/java/com/chrismelius/resourcemanager/
├── SecureResourceApiApplication.java      # Spring Boot entry point
├── controller/
│   ├── AuthController.java                # JWT login endpoint
│   └── EmployeeController.java            # Employee CRUD endpoints
├── model/
│   └── Employee.java                      # JPA Entity
├── repository/
│   └── EmployeeRepository.java            # JPA Repository
├── security/
│   ├── ApplicationConfig.java             # Spring Security configuration
│   ├── JwtFilter.java                     # JWT validation filter
│   ├── SecurityConfig.java                # HTTP security configuration
│   └── JwtService.java                    # JWT token generation/validation
└── service/
    └── JwtService.java                    # JWT operations

src/main/resources/
├── application.properties                 # Application configuration
└── META-INF/spring-configuration-metadata.json

env.example                               # Template for environment variables
.env.local                                 # Local environment variables (git-ignored)
```

## Security Features

- **Stateless Authentication**: No server-side sessions; uses JWT tokens
- **Password Encryption**: Passwords are hashed with BCrypt
- **CSRF Protection**: Disabled for stateless REST APIs (safe when using JWT)
- **Role-Based Access**: The `/api/auth/**` endpoints are public; all others require authentication
- **Token Expiration**: JWT tokens expire after 1 hour

## Configuration Files

### application.properties

Located in `src/main/resources/application.properties`:

- **Database Configuration**: MySQL connection details
- **Hibernate Settings**: Automatic schema updates (`ddl-auto=update`)
- **JWT Secret**: Loaded from environment variables
- **Logging**: Debug-level logging for Spring Security
- **AWS Integration**: Optional AWS Secrets Manager support

### env.example

Template file showing required environment variables:

```properties
DB_PASSWORD=
BCRYPT_PASSWORD=
```

## Troubleshooting

### Issue: "Access denied for user 'springuser'@'localhost'"

**Solution**: Verify the MySQL password in `.env.local` matches the password set for the `springuser` account.

### Issue: "Table 'resource_db.employee' doesn't exist"

**Solution**: Ensure the `resource_db` database exists and the application has permissions to create tables. Check that `spring.jpa.hibernate.ddl-auto=update` is set in `application.properties`.

### Issue: "Invalid JWT token"

**Solution**: Ensure you're using a valid token from the login endpoint. Tokens expire after 1 hour.

### Issue: "401 Unauthorized" on protected endpoints

**Solution**: 
1. Include the `Authorization: Bearer <token>` header
2. Use a token obtained from the `/api/auth/login` endpoint
3. Use the correct username/password credentials

## Production Considerations

- Use AWS Secrets Manager or a similar service for managing secrets
- Configure `spring.jpa.hibernate.ddl-auto=validate` in production (don't auto-update schema)
- Use HTTPS instead of HTTP
- Implement rate limiting and request throttling
- Add request validation and error handling
- Use a proper database user with minimal privileges
- Rotate JWT secrets regularly
- Monitor and log authentication attempts

## License

This project is provided as-is for educational purposes.

## Author

Chris Melius
