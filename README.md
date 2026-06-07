# 🎓 Alumni Portal — Campus Connect

> A full-featured web application for managing alumni records, enabling multi-role login, OTP-based email verification, and secure data management.

---

## 🌟 Features

- 🔐 **Multi-Role Login** — Separate dashboards for Admin, Alumni, and Students
- 📧 **OTP Email Verification** — Secure registration via Gmail SMTP
- 🔒 **SHA-256 Password Hashing** — Secure credential storage
- 🗃️ **7-Table Database Schema** — Normalized Oracle DB design
- 📋 **Alumni Directory** — Search and filter alumni records
- 🏫 **Placement Tracking** — Manage placement drives and results
- 📊 **Admin Dashboard** — Full control over users and data

---

## 🚀 Tech Stack

| Layer | Technologies |
|-------|-------------|
| Frontend | HTML5, CSS3, JavaScript, JSP |
| Backend | Java Servlets, Apache Tomcat 9 |
| Database | Oracle 21c XE (XEPDB1) |
| Security | SHA-256 Hashing, OTP via Gmail SMTP |
| Tools | IntelliJ IDEA, Maven, VS Code |

---

## 📁 Project Structure

```
AlumniPortal/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/alumni/
│       │       ├── servlet/       # All Java Servlets
│       │       ├── dao/           # Database Access Objects
│       │       ├── model/         # Java Bean classes
│       │       └── util/
│       │           ├── DBUtil.java       # JDBC Connection
│       │           └── EmailUtil.java    # OTP Email via Gmail
│       └── webapp/
│           ├── WEB-INF/
│           │   └── web.xml
│           ├── jsp/               # JSP pages
│           └── css/               # Stylesheets
├── pom.xml                        # Maven dependencies
└── .gitignore
```

---

## 🗄️ Database Schema (Oracle 21c XE)

| Table | Description |
|-------|-------------|
| `users` | Login credentials for all roles |
| `alumni` | Alumni personal & professional info |
| `students` | Current student records |
| `admins` | Admin user details |
| `placements` | Placement drive information |
| `otp_verification` | OTP tokens for email verification |
| `announcements` | Admin announcements/notices |

---

## ⚙️ Local Setup & Running

### Prerequisites
- Java JDK 11+
- Apache Tomcat 9
- Oracle 21c XE (with XEPDB1 pluggable database)
- Maven

### Steps

**1. Clone the repository**
```bash
git clone https://github.com/Shoaib2002k/alumni-portal.git
cd alumni-portal/ALUMNI_PORTAL_DONE/AlumniPortal
```

**2. Configure Database**

Edit `src/main/java/com/alumni/util/DBUtil.java`:
```java
String url = "jdbc:oracle:thin:@localhost:1521/XEPDB1";
String username = "your_db_username";
String password = "your_db_password";
```

**3. Configure Email (OTP)**

Edit `src/main/java/com/alumni/util/EmailUtil.java`:
```java
String senderEmail = "your_email@gmail.com";
String appPassword = "your_gmail_app_password";
```

**4. Build with Maven**
```bash
mvn clean package
```

**5. Deploy to Tomcat**
- Copy the generated `.war` file from `target/` to Tomcat's `webapps/` folder
- Start Tomcat: `bin/startup.bat` (Windows)
- Visit: `http://localhost:8080/AlumniPortal`

---

## 📸 Screenshots

> *(Add screenshots of Login page, Admin Dashboard, Alumni Directory here)*

---

## 🎓 About This Project

This is my **Final Year MCA Capstone Project** developed at MEASI Institute of Information Technology, Madras University, Chennai (Batch 2026).

---

## 👨‍💻 Developer

**Mohammed Shoaib S.**
- 📧 Email: [mdshoaib0505@gmail.com](mailto:mdshoaib0505@gmail.com)
- 💼 LinkedIn: [linkedin.com/in/md-shoaib-2002k](https://linkedin.com/in/md-shoaib-2002k)
- 🐙 GitHub: [github.com/Shoaib2002k](https://github.com/Shoaib2002k)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
