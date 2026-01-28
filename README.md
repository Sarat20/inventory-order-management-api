#  Inventory Order Management API (Multi-Tenant SaaS Backend)

A production-grade, multi-tenant Inventory & Order Management backend built using Ruby on Rails 7.

This project demonstrates real-world backend engineering concepts such as schema-based multi-tenancy, JWT authentication, role-based authorization, order lifecycle management using a state machine, stock-safe order confirmation, background job processing, Redis caching, auditing, rate limiting, and a full RSpec test suite.

## Tech Stack

Ruby 3.2.4  
Rails 7.0.10 (API only)  
PostgreSQL  
Redis + Sidekiq  
Devise + JWT  
Pundit  
Apartment (multi-tenancy)  
Alba (serialization)  
AASM (state machine)  
Audited (audit logs)  
Kaminari (pagination)  
RSpec + FactoryBot  
Lograge  
Rack::Attack  

## 📁 Project Structure

app/  
 ├── controllers/api/v1  
 ├── models  
 ├── policies  
 ├── serializers  
 ├── jobs  
config/  
 ├── environments  
 ├── initializers  
 ├── routes.rb  
db/  
 ├── migrate  
 ├── schema.rb  
spec/  
 ├── models  
 ├── requests  
 ├── jobs  
 ├── factories  
 └── support  

## Setup Instructions

Clone repository:

git clone https://github.com/Sarat20/inventory-order-management-api.git  
cd inventory-order-management-api  

Install dependencies:

bundle install  

Setup database:

rails db:create  
rails db:migrate  
rails db:seed  

Start Redis:

redis-server  

Start Sidekiq:

bundle exec sidekiq  

Start Rails server:

rails s  

## Run Tests

bundle exec rspec  

##  Multi-Tenant Usage

Subdomain mode (recommended):

Add to /etc/hosts:

127.0.0.1 shop_one.localhost  
127.0.0.1 shop_two.localhost  

Access:

http://shop_one.localhost:3000  
http://shop_two.localhost:3000  

Header mode (Postman ):

X-Tenant: shop_one  
X-Tenant: shop_two

## 🔐 Default Admin User

Email: admin@inventory.com  
Password: admin123  

## Postman Collection

https://sarat-110d3064-941488.postman.co/workspace/volopay's-Workspace~b7d41657-6319-443e-8542-befa76036c7e/collection/51439697-5636edcd-1ea0-4144-80dd-4870bafb456c7e?action=share&creator=51439697  

## 📡 Main API Endpoints

Authentication:  
POST /api/v1/auth/login  
POST /api/v1/auth/register  
GET /api/v1/auth/me  
DELETE /api/v1/auth/logout  

Products:  
GET /api/v1/products  
POST /api/v1/products  
GET /api/v1/products/:id  
PUT /api/v1/products/:id  
DELETE /api/v1/products/:id  

Orders:  
POST /api/v1/orders  
POST /api/v1/orders/:id/confirm  
POST /api/v1/orders/:id/ship  
POST /api/v1/orders/:id/cancel  

Categories / Suppliers / Customers:  
Full CRUD APIs  

#important

Multi-tenant SaaS architecture using PostgreSQL schemas  
JWT authentication with role-based authorization  
Order workflow using AASM state machine  
Stock-safe confirmation using transactions and DB locking  
Background job processing using Sidekiq  
Redis caching with proper invalidation  
Auditing for critical models  
Rate limiting using Rack::Attack  
Full RSpec test coverage  
