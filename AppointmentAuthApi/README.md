# Appointment Authentication API

A clean, simple, hackathon-ready JWT-based authentication module for the Appointment Booking Backend System built with .NET 8.

## Project Structure

```
AppointmentAuthApi/
├── Controllers/
│   └── AuthController.cs           # Register, Login, Test endpoints
├── Models/
│   └── User.cs                     # User entity
├── DTOs/
│   ├── RegisterDto.cs              # Registration request
│   ├── LoginDto.cs                 # Login request
│   └── AuthResponseDto.cs          # Auth response + User DTO
├── Services/
│   └── AuthService.cs              # Business logic (register, login, password hashing)
├── Repositories/
│   └── UserRepository.cs           # Data access layer
├── Auth/
│   └── JwtTokenGenerator.cs        # JWT token generation
├── Data/
│   └── AppDbContext.cs             # Entity Framework DbContext
├── Middleware/
│   └── ExceptionMiddleware.cs      # Global exception handler
├── Properties/
│   └── launchSettings.json         # Debug configuration
├── Program.cs                      # Main entry point, DI setup, middleware config
├── appsettings.json                # JWT & database configuration
├── AppointmentAuthApi.csproj       # Project file
└── README.md                       # This file
```

## Tech Stack

- **.NET 8** Web API
- **Entity Framework Core 8.0** with SQL Server
- **JWT** Authentication (System.IdentityModel.Tokens.Jwt)
- **Swagger** (Swashbuckle)
- **Dependency Injection** (Built-in)
- **Global Exception Middleware**
- **CORS** enabled for all origins

## Prerequisites

- **.NET 8 SDK** installed ([Download](https://dotnet.microsoft.com/en-us/download/dotnet/8.0))
- **SQL Server LocalDB** (included with Visual Studio or SQL Server Express)
- **Windows Command Prompt / PowerShell** or bash

## Setup & Run Locally

### Step 1: Clone/Navigate to Project

```bash
cd AppointmentAuthApi
```

### Step 2: Restore NuGet Packages

```bash
dotnet restore
```

### Step 3: Create Database & Migrations

```bash
# Create initial migration
dotnet ef migrations add InitialCreate

# Apply migration to database
dotnet ef database update
```

**Note:** If you don't have EF Core tools installed globally:

```bash
dotnet tool install --global dotnet-ef
# Then try the above commands again
```

### Step 4: Run the Application

```bash
dotnet run
```

The API will start at: **http://localhost:5000**

Swagger UI will open automatically at: **http://localhost:5000** (or **http://localhost:5000/swagger**)

## API Endpoints

### 1. Register User

**POST** `/api/auth/register`

Request Body:
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "SecurePassword123"
}
```

Response (Success):
```json
{
  "success": true,
  "message": "Registration successful",
  "token": null,
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "role": "User"
  }
}
```

Response (Error - Email exists):
```json
{
  "success": false,
  "message": "Email already registered",
  "token": null,
  "user": null
}
```

---

### 2. Login User

**POST** `/api/auth/login`

Request Body:
```json
{
  "email": "john@example.com",
  "password": "SecurePassword123"
}
```

Response (Success):
```json
{
  "success": true,
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "role": "User"
  }
}
```

Response (Error - Invalid credentials):
```json
{
  "success": false,
  "message": "Invalid credentials",
  "token": null,
  "user": null
}
```

---

### 3. Test Protected Endpoint (JWT Required)

**GET** `/api/auth/test`

Header:
```
Authorization: Bearer <JWT_TOKEN>
```

Response (Success):
```json
{
  "message": "JWT Token is valid!",
  "user": "john@example.com"
}
```

Response (Unauthorized - no token):
```json
{
  "success": false,
  "message": "Unauthorized"
}
```

---

## Testing with Swagger UI

### 1. Open Swagger UI

Navigate to: **http://localhost:5000**

### 2. Register a User

- Click on **POST /api/auth/register**
- Click **Try it out**
- Enter test data:
  ```json
  {
    "name": "Test User",
    "email": "test@example.com",
    "password": "TestPass123"
  }
  ```
- Click **Execute**
- You should see a 201 response with user details

### 3. Login

- Click on **POST /api/auth/login**
- Click **Try it out**
- Enter login credentials:
  ```json
  {
    "email": "test@example.com",
    "password": "TestPass123"
  }
  ```
- Click **Execute**
- Copy the **token** from the response

### 4. Test JWT Protection

- Click on **GET /api/auth/test**
- Click the **🔒 Authorize** button (top right)
- Paste your JWT token in the "Value" field (without "Bearer " prefix)
- Click **Authorize**, then **Close**
- Now click **Try it out** and **Execute**
- You should see: `"message": "JWT Token is valid!"`

---

## JWT Token Details

### Token Structure

JWT tokens consist of 3 parts separated by dots (`.`):

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

**Header** (decoded): Algorithm and token type
```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

**Payload** (decoded): User claims
```json
{
  "nameid": "1",
  "email": "test@example.com",
  "name": "Test User",
  "role": "User",
  "exp": 1695123456,
  "iss": "AppointmentAuthApi",
  "aud": "AppointmentAuthApiUsers"
}
```

**Signature**: HMAC-SHA256 encoded

### JWT Configuration (appsettings.json)

```json
"JwtSettings": {
  "SecretKey": "ThisIsAVerySecureSecretKeyForJwtTokenGenerationWithMinimum32Characters!",
  "Issuer": "AppointmentAuthApi",
  "Audience": "AppointmentAuthApiUsers",
  "ExpiryMinutes": 60
}
```

### How Token is Generated

1. **Claims** extracted from User entity:
   - NameIdentifier (User ID)
   - Email
   - Name
   - Role

2. **Signing Credentials** created using:
   - Secret Key (HS256 symmetric algorithm)
   - Issuer + Audience validation

3. **Expiry** set to 60 minutes from generation time

4. **Token** serialized and returned to client

---

## Password Hashing

Passwords are hashed using **SHA256** with Base64 encoding:

```csharp
var encryptedPassword = SHA256.ComputeHash(UTF8.GetBytes(password));
var hash = Convert.ToBase64String(encryptedPassword);
```

---

## Database

### Connection String

```
Server=(localdb)\mssqllocaldb;Database=AppointmentAuthDb;Trusted_Connection=true;TrustServerCertificate=true
```

### User Table Schema

| Column | Type | Constraints |
|--------|------|-------------|
| Id | int | PRIMARY KEY, IDENTITY |
| Name | nvarchar(max) | NOT NULL |
| Email | nvarchar(max) | NOT NULL, UNIQUE |
| PasswordHash | nvarchar(max) | NOT NULL |
| Role | nvarchar(max) | DEFAULT: "User" |
| CreatedAt | datetime2 | DEFAULT: UTC NOW |

---

## Troubleshooting

### Issue: `dotnet ef` command not found

**Solution:**
```bash
dotnet tool install --global dotnet-ef
```

### Issue: Database connection fails

**Check:**
1. SQL Server LocalDB is running
2. Connection string in `appsettings.json` is correct
3. Firewall allows local SQL Server connections

**Verify LocalDB:**
```bash
sqllocaldb info
sqllocaldb start mssqllocaldb
```

### Issue: Swagger not loading

**Solution:**
- Clear browser cache
- Try incognito/private window
- Check that `UseSwagger()` is called in `Program.cs`

### Issue: JWT token invalid

**Check:**
1. Token hasn't expired (60 minutes default)
2. Secret key in `appsettings.json` matches `JwtTokenGenerator`
3. Bearer prefix is removed when pasting in Swagger

---

## CORS Configuration

All origins allowed (ideal for hackathon/development):

```csharp
options.AddPolicy("AllowAll", builder =>
{
    builder.AllowAnyOrigin()
           .AllowAnyMethod()
           .AllowAnyHeader();
});
```

---

## Logging

Logs are written to **Console**. Configure in `appsettings.json`:

```json
"Logging": {
  "LogLevel": {
    "Default": "Information",
    "Microsoft": "Warning"
  }
}
```

**Example Logs:**
```
info: AppointmentAuthApi.Services.AuthService[0]
      User registered: test@example.com
info: AppointmentAuthApi.Services.AuthService[0]
      User logged in: test@example.com
```

---

## What's Included ✅

- ✅ User registration with email validation
- ✅ Secure password hashing (SHA256)
- ✅ Login with credential verification
- ✅ JWT token generation (60 min expiry)
- ✅ JWT token validation middleware
- ✅ Protected endpoints (@Authorize)
- ✅ DTOs for request/response (no entity exposure)
- ✅ Repository pattern for data access
- ✅ Service layer for business logic
- ✅ Global exception handling
- ✅ Swagger documentation + JWT support
- ✅ CORS enabled
- ✅ Dependency injection
- ✅ Logging
- ✅ SQL Server with LocalDB
- ✅ Clean code structure

---

## What's NOT Included (Separate Module)

- ❌ Appointment/Booking logic
- ❌ Slots management
- ❌ Payment processing
- ❌ Email notifications
- ❌ Frontend UI

---

## Next Steps

Once authentication is working, you can:

1. **Create Appointment Module** with same clean architecture
2. **Add Role-Based Access Control** (Admin, User roles)
3. **Implement Refresh Tokens** for better security
4. **Add Email Verification** for registration
5. **Create API Gateway** to combine Auth + Appointments

---

## License

Open for hackathon use. Modify as needed.

