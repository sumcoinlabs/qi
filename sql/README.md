# 💼 QI App Database Schema

This database schema powers the backend of a **1031 Exchange Qualified Intermediary (QI)** application. It is designed to handle everything from user management to client records, exchange tracking, IRS compliance, payments, notifications, and document handling.

---

## 🗄️ Overview

| Feature                          | Table(s) Involved                            |
|----------------------------------|----------------------------------------------|
| User Login & Roles               | `users`                                      |
| Client Info                      | `clients`                                    |
| 1031 Exchanges                   | `exchanges`, `properties`, `funds`           |
| IRS Questionnaire & Compliance  | `questionnaire_responses`, `documents`       |
| QI Fees & Payments               | `payments`                                   |
| Notifications & Alerts          | `notifications`                              |
| Audit Logs (internal tracking)  | `audit_logs`                                 |

---

## 📊 Table Descriptions

### `users`
Stores login credentials and user roles (`admin`, `staff`, `client`).

| Column      | Type             | Description                     |
|-------------|------------------|---------------------------------|
| `email`     | `varchar(255)`   | Unique login email              |
| `password`  | `varchar(255)`   | Hashed password                 |
| `role`      | `enum`           | Access level                    |

---

### `clients`
Stores personal and business information for clients initiating 1031 exchanges.

| Column        | Type             | Description                 |
|---------------|------------------|-----------------------------|
| `user_id`     | `int`            | Linked user account         |
| `tax_id`      | `varchar(50)`    | SSN or EIN                  |
| `entity_type` | `enum`           | Individual, LLC, Trust, etc.|

---

### `exchanges`
Central entity representing a 1031 exchange case.

| Column          | Type        | Description                         |
|------------------|-------------|-------------------------------------|
| `exchange_type`  | `enum`      | Delayed, reverse, or build-to-suit  |
| `start_date`     | `date`      | 1031 timeline start                 |
| `intermediary_fee`| `decimal` | QI service fee for the exchange     |
| `status`         | `enum`      | Workflow status                     |

---

### `properties`
Relinquished and replacement properties associated with an exchange.

| Column       | Type             | Description                       |
|--------------|------------------|-----------------------------------|
| `type`       | `enum`           | Relinquished or replacement       |
| `price`      | `decimal(15,2)`  | Sale/purchase price               |
| `escrow_info`| `varchar(255)`   | Optional escrow detail            |

---

### `funds`
Tracks money movement related to an exchange.

| Column       | Type           | Description                     |
|--------------|----------------|---------------------------------|
| `direction`  | `enum`         | Incoming or outgoing funds      |
| `method`     | `enum`         | Wire, check                     |
| `memo`       | `text`         | Notes about the transfer        |

---

### `documents`
Links uploaded files to an exchange (e.g., IRS forms, agreements).

| Column         | Type         | Description                        |
|----------------|--------------|------------------------------------|
| `document_type`| `varchar`    | IRS 8824, Notice, Agreement, etc.  |
| `url`          | `text`       | Link to cloud storage or server    |

---

### `questionnaire_responses`
JSON storage for client-completed IRS questionnaires.

| Column               | Type  | Description                        |
|----------------------|-------|------------------------------------|
| `questionnaire_data` | JSON  | Flexible question/answer storage   |

---

### `payments`
Tracks QI service fees and payment status.

| Column     | Type       | Description                |
|------------|------------|----------------------------|
| `status`   | `enum`     | Pending, completed, failed |
| `method`   | `enum`     | Credit card, wire, check   |

---

### `notifications`
Manages app/email/push alerts to users.

| Column   | Type       | Description                    |
|----------|------------|--------------------------------|
| `message`| `text`     | Notification content           |
| `is_read`| `boolean`  | Seen/unseen flag               |

---

### `audit_logs`
Tracks internal changes for security and compliance.

| Column       | Type       | Description                     |
|--------------|------------|---------------------------------|
| `action`     | `varchar`  | e.g., Created Exchange, Deleted Document |
| `target_table`| `varchar` | Table affected                  |
| `target_id`  | `int`      | Row affected                    |

---

## ✅ Role-Based Access (RBAC)

| Role   | Permissions                                                                 |
|--------|-----------------------------------------------------------------------------|
| Admin  | Full access to all records and system settings                             |
| Staff  | Manage exchanges, documents, funds; limited access to client accounts      |
| Client | Create/view exchanges, fill forms, upload documents, receive notifications |

---

## 🔐 Security Recommendations

- Use hashed passwords (e.g., `bcrypt`)  
- Use JWT for authentication  
- Sanitize and validate all inputs  
- Use HTTPS and secure file storage

---

## 🛠️ Setup & Usage

1. Import `schema.sql` into MySQL  
2. Connect your Flask or Node.js backend  
3. Populate with seed data or connect to front-end app

---

## 💬 Questions?

For help extending or customizing the schema, reach out or open an issue in this repo.

---
