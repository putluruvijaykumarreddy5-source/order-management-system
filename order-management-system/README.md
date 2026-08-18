# Order Management System — Eclipse + PostgreSQL

A Java Servlet/JSP + JDBC + PostgreSQL web application.

## Stack
- Java 17
- Eclipse IDE
- Apache Tomcat 10.1+
- Jakarta Servlet 6
- JSP/JSTL
- JDBC
- PostgreSQL
- Maven

## Features
- Login/logout using session
- Dashboard
- Customer CRUD
- Product CRUD
- Create orders with multiple products
- Automatic order total calculation
- Stock reduction when an order is created
- Order status update
- Order cancellation with stock restoration
- Order list and customer order history
- Basic order summary

## 1. Create the PostgreSQL database
Open pgAdmin or psql and run:

```sql
CREATE DATABASE order_management;
```

Connect to that database and run `database/schema.sql`.

## 2. Configure database credentials
Edit:

`src/main/java/com/oms/util/DBConnection.java`

Change:
- URL
- USER
- PASSWORD

Default:
- database: `order_management`
- user: `postgres`
- password: `postgres`

Do NOT commit your real password to Git.

## 3. Import into Eclipse
Recommended:
1. File → Import
2. Maven → Existing Maven Projects
3. Select the extracted project folder
4. Finish
5. Add Apache Tomcat 10.1 to Servers
6. Add this project to the server
7. Run on Server

## 4. Open
`http://localhost:8080/order-management-system/`

Demo login:
- Username: `admin`
- Password: `admin123`

## Notes
This project uses Jakarta packages (`jakarta.servlet.*`) and therefore targets Tomcat 10.1+.
If you are using Tomcat 9, do not mix `javax.servlet.*` and `jakarta.servlet.*`; use Tomcat 10.1+ for this version.
