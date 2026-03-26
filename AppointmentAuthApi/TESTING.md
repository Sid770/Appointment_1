# Quick Testing Guide

## Visual Verification of All Components

### 1. Verify All Files Created

Your project structure should look like:

```
AppointmentAuthApi/
├── Controllers/AuthController.cs
├── Models/User.cs
├── DTOs/
│   ├── RegisterDto.cs
│   ├── LoginDto.cs
│   └── AuthResponseDto.cs
├── Services/AuthService.cs
├── Repositories/UserRepository.cs
├── Auth/JwtTokenGenerator.cs
├── Data/AppDbContext.cs
├── Middleware/ExceptionMiddleware.cs
├── Properties/launchSettings.json
├── Program.cs
├── appsettings.json
├── AppointmentAuthApi.csproj
├── setup.bat (Windows)
├── setup.sh (Linux/macOS)
├── README.md
└── TESTING.md (this file)
```

---

## Step-by-Step Testing Guide

### Phase 1: Setup ✓

**Windows:**
```bash
cd AppointmentAuthApi
.\setup.bat
```

**Linux/macOS:**
```bash
cd AppointmentAuthApi
chmod +x setup.sh
./setup.sh
```

**Manual Setup:**
```bash
dotnet restore
dotnet ef migrations add InitialCreate
dotnet ef database update
dotnet run
```

---

### Phase 2: Swagger Testing

1. **Open Browser:** http://localhost:5000

2. **You should see:**
   - Swagger UI with "Appointment Authentication API v1"
   - Three endpoints listed:
     - POST /api/auth/register
     - POST /api/auth/login
     - GET /api/auth/test

---

### Phase 3: Test Register Endpoint

**Request 1: Successful Registration**

```json
{
  "name": "Alice Johnson",
  "email": "alice@example.com",
  "password": "SecurePass123!"
}
```

**Expected Response (201 Created):**
```json
{
  "success": true,
  "message": "Registration successful",
  "token": null,
  "user": {
    "id": 1,
    "name": "Alice Johnson",
    "email": "alice@example.com",
    "role": "User"
  }
}
```

**Request 2: Duplicate Email**

```json
{
  "name": "Alice Smith",
  "email": "alice@example.com",
  "password": "AnotherPass123!"
}
```

**Expected Response (400 Bad Request):**
```json
{
  "success": false,
  "message": "Email already registered",
  "token": null,
  "user": null
}
```

---

### Phase 4: Test Login Endpoint

**Request 1: Successful Login**

```json
{
  "email": "alice@example.com",
  "password": "SecurePass123!"
}
```

**Expected Response (200 OK):**
```json
{
  "success": true,
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "name": "Alice Johnson",
    "email": "alice@example.com",
    "role": "User"
  }
}
```

**✓ Copy this token for Phase 5**

**Request 2: Wrong Password**

```json
{
  "email": "alice@example.com",
  "password": "WrongPassword123!"
}
```

**Expected Response (401 Unauthorized):**
```json
{
  "success": false,
  "message": "Invalid credentials",
  "token": null,
  "user": null
}
```

**Request 3: Non-existent Email**

```json
{
  "email": "nonexistent@example.com",
  "password": "AnyPassword123!"
}
```

**Expected Response (401 Unauthorized):**
```json
{
  "success": false,
  "message": "Invalid credentials",
  "token": null,
  "user": null
}
```

---

### Phase 5: Test Protected Endpoint (JWT Auth)

1. **Click the 🔒 Authorize button** (top-right in Swagger)

2. **Paste the JWT token** from Phase 4 login response:
   - Do NOT include "Bearer " prefix
   - Just paste the token value

3. **Test GET /api/auth/test**

**Expected Response (200 OK):**
```json
{
  "message": "JWT Token is valid!",
  "user": "alice@example.com"
}
```

---

### Phase 6: Test Error Handling

**Send invalid request to register (missing fields):**

```json
{
  "name": "Bob"
}
```

**Expected Response (400 Bad Request):**
```json
{
  "Email": ["The Email field is required."],
  "Password": ["The Password field is required."]
}
```

---

## Verification Checklist

### ✅ Database
- [ ] `AppointmentAuthDb` database created in LocalDB
- [ ] `Users` table created with all columns
- [ ] Email column is UNIQUE

### ✅ Authentication
- [ ] User registration works
- [ ] Password hashing works (check stored hashes are different for different passwords)
- [ ] Login validates credentials
- [ ] JWT token generated with correct claims
- [ ] Token expiry is set (default 60 minutes)
- [ ] Protected endpoints require token

### ✅ API
- [ ] All 3 endpoints accessible
- [ ] Response DTOs don't expose PasswordHash
- [ ] Proper HTTP status codes (201, 200, 400, 401)
- [ ] Global exception handling catches errors

### ✅ Swagger
- [ ] Swagger UI loads at root
- [ ] JWT Bearer authorization configured
- [ ] Try it out buttons work
- [ ] Response examples are visible

### ✅ CORS
- [ ] API accessible from different origins
- [ ] No CORS errors in browser console

### ✅ Logging
- [ ] Console shows registration/login logs
- [ ] Error logs appear on failures

---

## Common Issues & Solutions

### Issue: "Unable to connect to server... (localdb)\mssqllocaldb"

**Solution:**
```bash
sqllocaldb start mssqllocaldb
# Then retry dotnet ef database update
```

### Issue: "Migrations assembly not found"

**Solution:**
```bash
dotnet ef database update --no-build
```

### Issue: Swagger returns 404

**Solution:**
- Check that Swagger is enabled in `Program.cs`
- Clear browser cache
- Try incognito/private window

### Issue: JWT token validation fails

**Solution:**
- Verify secret key matches in `appsettings.json` and `JwtTokenGenerator`
- Check token hasn't expired
- Ensure "Bearer " prefix is removed when pasting token

---

## Testing with Postman (Alternative)

If you prefer Postman over Swagger:

### 1. Register
```
POST http://localhost:5000/api/auth/register
Content-Type: application/json

{
  "name": "Test User",
  "email": "test@example.com",
  "password": "TestPass123"
}
```

### 2. Login
```
POST http://localhost:5000/api/auth/login
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "TestPass123"
}
```

### 3. Protected Endpoint
```
GET http://localhost:5000/api/auth/test
Authorization: Bearer <TOKEN_FROM_LOGIN>
```

---

## Performance Testing (Load Testing)

For hackathon purposes, you can test concurrency with Apache Bench or similar tools, but the simple setup should handle typical request volumes.

---

## What You've Verified ✓

1. **User Model** - Correct schema with email uniqueness
2. **Register API** - Creates users, validates emails, hashes passwords
3. **Login API** - Authenticates users, generates JWT tokens
4. **JWT Generator** - Secure token creation with claims
5. **Token Validation** - Protected endpoints work correctly
6. **Error Handling** - Global middleware catches exceptions
7. **Database** - AutoMigration works, data persists
8. **API Documentation** - Swagger fully functional
9. **CORS** - Cross-origin requests allowed
10. **Logging** - Console logs for audit trail

---

## Next Phase: Appointment Module

Once auth is verified, follow the same pattern for appointments:
- Same DTOs, Services, Repository structure
- Add AppointmentController
- Reference authenticated User in appointments
- Reuse JWT authentication from this module

**Happy Hackathoning! 🚀**
