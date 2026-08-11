# 🏢 EMS – Employee Management System

> **SWP391 – Software Project** | FPT University  
> **Group:** BL5 – Group 1 | **Milestone:** M1

---

## 📌 Table of Contents

- [Overview](#overview)
- [Team Members](#team-members)
- [Tech Stack](#tech-stack)
- [Features](#features)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Database Setup](#database-setup)
- [Running the App](#running-the-app)
- [Pages & URLs](#pages--urls)

---

## Overview

**EMS (Employee Management System)** is a web-based application that helps organizations manage employee data, work schedules, attendance, leave requests, and payroll — all in one place.

The system supports **3 user roles**:

| Role | Description |
|------|-------------|
| 👤 **Employee** | Check in/out, submit leave/exception requests, view schedule & payslip |
| 👔 **Manager** | Approve requests, assign schedules, manage attendance & draft payroll |
| 🔧 **Admin** | Manage employee accounts, roles, permissions & system settings |

---

## Team Members

| # | Name | Student ID | Role |
|---|------|-----------|------|
| 1 | Nguyen Van Thanh | — | — |
| 2 | Do Thanh Son | — | — |
| 3 | Nguyen Anh Quan | — | — |
| 4 | — | — | — |
| 5 | — | — | — |

> ✏️ *Update this table with full team info.*

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Language** | Java 8 |
| **Web** | Java Servlet + JSP |
| **Build Tool** | Apache Maven |
| **Server** | Apache Tomcat 10+ |
| **Database** | MySQL 8 |
| **DB Driver** | mysql-connector-j 8.3.0 |
| **Frontend** | HTML, CSS (Vanilla), JavaScript |

---

## Features

### 👤 Employee
- [x] Login / Logout
- [x] Check In / Check Out
- [x] View Assigned Fixed Schedule
- [x] View Daily Attendance Status
- [x] Submit Leave Request
- [x] Submit Exception Request
- [x] View Request Approval Status
- [x] View Detailed Monthly Payslip
- [x] Change Password

### 👔 Manager
- [x] Login / Logout
- [x] Assign Fixed Schedule to Employee
- [x] View Department Attendance
- [x] Approve / Reject Employee Requests
- [x] View Pending Request List
- [x] Create Draft Branch Payroll Summary
- [x] Calculate Salary
- [x] Change Password

### 🔧 Admin
- [x] Login / Logout
- [x] Manage Employee Profiles & Accounts
- [x] Manage Roles & Permissions
- [x] Manage Payroll Formulas & Allowances
- [x] View HR Overview Reports
- [x] View System Performance Reports
- [x] Manage System Settings
- [x] Change Password

---

## Project Structure

```
EMS/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/ems/
│       │       ├── controller/        # Servlets (request handling)
│       │       │   └── UserServlet.java
│       │       ├── dao/               # Data Access Objects (DB queries)
│       │       │   └── UserDAO.java
│       │       ├── model/             # Entity classes (mapped to DB tables)
│       │       │   ├── Users.java
│       │       │   ├── Accounts.java
│       │       │   ├── Attendance.java
│       │       │   ├── Requests.java
│       │       │   ├── Payslips.java
│       │       │   ├── Shifts.java
│       │       │   ├── Departments.java
│       │       │   └── ... (17 models total)
│       │       └── service/           # Business logic layer
│       └── webapp/
│           ├── WEB-INF/
│           │   └── web.xml            # Servlet configuration
│           ├── home.jsp               # Dashboard (home page)
│           └── index.jsp              # Entry point
├── pom.xml                            # Maven dependencies
└── README.md
```

---

## Getting Started

### Prerequisites

Make sure you have the following installed:

- [JDK 8+](https://www.oracle.com/java/technologies/downloads/)
- [Apache Maven 3.6+](https://maven.apache.org/download.cgi)
- [Apache Tomcat 10+](https://tomcat.apache.org/download-10.cgi)
- [MySQL 8.0+](https://dev.mysql.com/downloads/mysql/)
- [IntelliJ IDEA](https://www.jetbrains.com/idea/) *(recommended)*

### Clone the Repository

```bash
git clone https://github.com/<your-repo>/EMS.git
cd EMS
```

---

## Database Setup

1. Open MySQL and create the database:

```sql
CREATE DATABASE ems_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ems_db;
```

2. Run the SQL script (see `Tạo DB.txt` in the project root):

```bash
mysql -u root -p ems_db < "Tạo DB.txt"
```

3. Update database connection in your project *(e.g. a `DBUtils.java` or context config)*:

```java
String url  = "jdbc:mysql://localhost:3306/ems_db";
String user = "root";
String pass = "your_password";
```

---

## Running the App

### Option 1 – IntelliJ IDEA (Recommended)

1. Open the project: `File → Open → select EMS folder`
2. Configure Tomcat: `Run → Edit Configurations → Add → Tomcat Server → Local`
3. Set deployment artifact: `ems:war exploded`
4. Click ▶ **Run**
5. Open browser: `http://localhost:8080/ems/`

### Option 2 – Maven Build

```bash
mvn clean package
```

Then deploy the generated `.war` file from `target/` to your Tomcat `webapps/` folder.

---

## Pages & URLs

| Page | URL | Description |
|------|-----|-------------|
| Entry Point | `/index.jsp` | Redirect to login |
| **Home / Dashboard** | `/home.jsp` | Main dashboard after login |
| Login | `/login.jsp` | User authentication |
| My Schedule | `/schedule.jsp` | View assigned work schedule |
| Attendance | `/attendance.jsp` | Check in / out history |
| Leave Request | `/leave-request.jsp` | Submit & track leave requests |
| Exception Request | `/exception-request.jsp` | Submit exception requests |
| My Payslip | `/payslip.jsp` | View monthly payslip |

---

## 📄 License

This project is developed for educational purposes as part of **SWP391** at **FPT University**.  
© 2026 BL5 – Group 1. All rights reserved.