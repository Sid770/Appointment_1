# QUICK START (5 MINUTES TO RUNNING API)

## Prerequisites
- ✅ .NET 8 SDK installed
- ✅ SQL Server LocalDB (comes with Visual Studio)

## Step 1: Setup (2 minutes)

```bash
cd AppointmentAuthApi
.\setup.bat
```

That's it! The script will:
- ✓ Restore packages
- ✓ Create database
- ✓ Apply migrations
- ✓ Start API on http://localhost:5000

## Step 2: Test Register (1 minute)

Open Swagger: **http://localhost:5000**

Click **POST /api/auth/register** → **Try it out**

```json
{
  "name": "Test User",
  "email": "test@example.com",
  "password": "TestPass123"
}
```

Click **Execute** → Should see **201 Created**

## Step 3: Test Login (1 minute)

Click **POST /api/auth/login** → **Try it out**

```json
{
  "email": "test@example.com",
  "password": "TestPass123"
}
```

Click **Execute** → Should see **200 OK** with **JWT token**

## Step 4: Test Protected Endpoint (1 minute)

1. **Copy the token** from login response
2. Click 🔒 **Authorize** button (top-right)
3. Paste token
4. Click **Authorize**
5. Click **GET /api/auth/test** → **Try it out** → **Execute**
6. Should see: **"JWT Token is valid!"**

---

## ✅ YOU'RE DONE!

**API is fully functional with:**
- ✅ User registration
- ✅ JWT authentication
- ✅ Password hashing
- ✅ Token validation
- ✅ Database auto-migration

---

## WHAT YOU HAVE

| Endpoint | Method | Auth | Purpose |
|----------|--------|------|---------|
| /api/auth/register | POST | ❌ | Create user account |
| /api/auth/login | POST | ❌ | Get JWT token |
| /api/auth/test | GET | ✅ | Test JWT (protected) |

---

## FILE STRUCTURE

```
AppointmentAuthApi/
├── Controllers/      [API endpoints]
├── Services/         [Business logic]
├── Repositories/     [Database access]
├── Models/           [Data models]
├── DTOs/             [Request/Response]
├── Auth/             [JWT generation]
├── Data/             [Database context]
├── Middleware/       [Error handling]
├── Program.cs        [Setup & config]
├── appsettings.json  [Settings]
└── README.md         [Full docs]
```

---

## TROUBLESHOOTING

| Problem | Solution |
|---------|----------|
| Port 5000 in use | Change in launchSettings.json or kill process |
| Database error | Run: `sqllocaldb start mssqllocaldb` |
| EF command error | Run: `dotnet tool install --global dotnet-ef` |
| Swagger won't load | Clear cache, try incognito, check port |

---

## NEXT STEPS

1. **Understand the code** - Read Program.cs → Auth flow is clear
2. **Build Appointment Module** - Use same pattern
3. **Add more endpoints** - Follow existing examples
4. **Deploy** - Use same structure for production

---

## TESTING WITHOUT SWAGGER

Use **Postman** or **curl**:

```bash
# Register
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test","email":"test@example.com","password":"Pass123"}'

# Login
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"Pass123"}'

# Test (replace TOKEN with actual token)
curl -X GET http://localhost:5000/api/auth/test \
  -H "Authorization: Bearer TOKEN"
```

---

## KEY FILES TO UNDERSTAND

1. **Program.cs** - How everything is wired together
2. **AuthController.cs** - API endpoints
3. **AuthService.cs** - Business logic
4. **JwtTokenGenerator.cs** - Token generation
5. **appsettings.json** - Configuration

**Read these in order to fully understand the flow!**

---

**Questions?** See README.md for full documentation.

**Happy Hacking! 🚀**
