# 🏢 Inventory Order Management API (Multi-Tenant SaaS)

A **production-style multi-tenant Inventory & Order Management system** built using:

- **Ruby on Rails 7**
- **PostgreSQL (Schema-based multi-tenancy)**
- **ros-apartment (Apartment gem fork)**
- **JWT Authentication**
- **Role-based access (Admin / Staff)**
- **Auditing, Background Jobs, Policies**

---

# 🚀 What is this project?

This is a **SaaS-style backend system** where:

- Each **Shop = One Tenant**
- Each tenant has **isolated data**
- Each tenant has **its own users, products, orders**
- Data is **physically separated using PostgreSQL schemas**
- Only the `tenants` table lives in the **public schema**

---

#  What is Multi-Tenancy?

Multi-tenancy means:

 One application, one database, but **multiple customers (tenants)** with **isolated data**.

In our case:

| Shop     | Schema   |
|----------|----------|
| Shop One | shop_one |
| Shop Two | shop_two |

Each schema contains:

- users
- products
- orders
- categories
- suppliers
- audits
  

---

# 🏗️ How Apartment Works (In Simple Words)

- PostgreSQL supports **schemas**
- Apartment switches:
```sql
SET search_path TO shop_one
Now all queries go to that schema

Switching happens:
Per request
Or manually in console
```
#  Architecture

One DB
 ├── public schema
 │    └── tenants
 │
 ├── volopay schema
 │    ├── users
 │    ├── products
 │    ├── orders
 │    └── ...
 │
 └── shop_one schema
      ├── users
      ├── products
      ├── orders
      └── ...

# Important Gems

gem 'ros-apartment'
gem 'devise'
gem 'jwt'
gem 'audited'
gem 'sidekiq'


# Request Flow

Postman Request
   ↓
TenantSwitcher Concern
   ↓
Reads X-Tenant header
   ↓
Apartment::Tenant.switch!
   ↓
Controller Action
   ↓
ActiveRecord talks to correct schema


# Setup Instructions

bundle install
rails db:drop db:create db:migrate
rails s

# Postman Usage

# Headers:

X-Tenant: shop_one
Authorization: Bearer <token>

