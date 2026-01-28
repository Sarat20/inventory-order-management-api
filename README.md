# 🏢 Inventory Order Management API (Multi-Tenant SaaS)

A **production-style multi-tenant Inventory & Order Management backend system** built using:

- **Ruby on Rails 7**
- **PostgreSQL** (Schema-based multi-tenancy)
- **ros-apartment** (Apartment gem fork)
- **JWT Authentication**
- **Role-based Access Control** (Admin / Staff)
- **Auditing** (audited gem)
- **Background Jobs** (Sidekiq)
- **Policies** (Pundit-style)

---

## 🚀 What is this Project?

This is a **SaaS-style backend system** where:

- Each **Shop = One Tenant**
- Each tenant has **fully isolated data**
- Each tenant has **its own users, products, orders, categories, suppliers**
- Data is **physically separated using PostgreSQL schemas**
- Only the `tenants` table lives in the **public schema**

---

## 🧠 What is Multi-Tenancy?

Multi-tenancy means: One application, one database, but **multiple customers (tenants)** with **isolated data**.

In our case:

| Shop Name | Schema Name |
|----------|-------------|
| Shop One | `shop_one` |
| Shop Two | `shop_two` |

Each schema contains:
- users
- products
- categories
- orders
- suppliers
- stock_movements
- audits

---

--
## DATABASE STRUCTURE


```sql

#Database Structure
One PostgreSQL Database
│
├── public schema
│   ├── tenants
│   └── global tables (if any)
│
├── shop_one schema
│   ├── users
│   ├── products
│   ├── categories
│   ├── orders
│   ├── suppliers
│   └── ...
│
├── shop_two schema
│   ├── users
│   ├── products
│   ├── categories
│   ├── orders
│   ├── suppliers
│   └── ...
│
└── more tenant schemas...
```

## IMPORTANT GEMS

```
gem "ros-apartment"
gem "devise"
gem "jwt"
gem "audited"
gem "sidekiq"
```
--
## REQEST FLOW
```

Postman Request
      ↓
TenantSwitcher Concern
      ↓
Reads X-Tenant Header
      ↓
Apartment::Tenant.switch!
      ↓
Controller Action
      ↓
ActiveRecord talks to correct schema

```

## PROJECT STRUCTURE

```

app/
 ├── controllers/api/v1
 ├── models
 ├── policies
 ├── serializers
 └── jobs

config/
 ├── environments
 ├── initializers
 └── routes.rb

db/
 ├── migrate
 └── schema.rb

spec/
 ├── models
 ├── requests
 ├── jobs
 ├── factories
 └── support

 ```

 ## INSTALLATION STEPS

 ```

 bundle install
 rails db:drop db:create db:migrate
 rails s
 ```
