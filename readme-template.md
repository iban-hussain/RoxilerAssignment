# Store Rating System

A web application built with Ruby on Rails that enables users to submit and manage ratings for registered stores. The system supports multiple user roles including System Admins, Normal Users, and Store Owners.

## 🌟 Features

### System Admin
- User management (add/view/edit users)
- Store management
- Dashboard with analytics
  - Total Users
  - Total Stores
  - Total Submitted Ratings
- Advanced filtering and sorting capabilities

### Normal User
- User registration and authentication
- Store search and discovery
- Rating submission (1-5 stars)
- Rating modification
- Password management

### Store Owner
- Store performance dashboard
- Rating analytics
- User feedback monitoring
- Password management

## 🛠 Technologies

- Ruby 3.2.2
- Rails 7.1.0
- PostgreSQL
- Devise (Authentication)
- Pundit (Authorization)
- RSpec (Testing)
- Bootstrap 5 (Frontend)

## 💻 Prerequisites

Before you begin, ensure you have installed:
- Ruby (3.2.2 or higher)
- Rails (7.1.0 or higher)
- PostgreSQL
- Node.js
- Yarn

## 🚀 Installation

1. **Clone the repository**
```bash
git clone https://github.com/your-username/store-rating-system.git
cd store-rating-system
```

2. **Install dependencies**
```bash
bundle install
yarn install
```

3. **Setup database**
```bash
# Create and setup database
rails db:create
rails db:migrate

# (Optional) Load sample data
rails db:seed
```

4. **Set environment variables**
```bash
# Copy the example environment file
cp .env.example .env

# Update .env with your configurations
POSTGRES_USER=your_username
POSTGRES_PASSWORD=your_password
```

5. **Start the server**
```bash
rails server
```

The application will be available at `http://localhost:3000`

## 📝 Database Schema

```ruby
# Users
- name:string
- email:string
- address:string
- role:integer
- password:string

# Stores
- name:string
- email:string
- address:string
- owner_id:integer

# Ratings
- user_id:integer
- store_id:integer
- value:integer
```

## 🔒 Authentication & Authorization

- Authentication is handled by Devise
- Authorization is managed through Pundit policies
- Three user roles: system_admin, normal_user, store_owner

## 🧪 Testing

The application uses RSpec for testing. To run the test suite:

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/user_spec.rb
```

## 🔍 Code Quality

Maintain code quality by running:

```bash
# Run Rubocop
bundle exec rubocop

# Run Security checks
bundle exec brakeman
```

## 📊 API Documentation

### Authentication Endpoints

```
POST /users/sign_in
POST /users/sign_up
DELETE /users/sign_out
```

### Store Endpoints

```
GET /stores
GET /stores/:id
POST /stores
PUT /stores/:id
```

### Rating Endpoints

```
POST /stores/:store_id/ratings
PUT /stores/:store_id/ratings/:id
```

## 🚦 System Requirements

- Ruby version: 3.2.2 or higher
- Rails version: 7.1.0 or higher
- PostgreSQL: 12 or higher
- Node.js: 14 or higher
- Memory: 512MB minimum
- Storage: 1GB minimum

## 🔐 Security

- Password requirements:
  - Minimum 8 characters
  - Maximum 16 characters
  - At least one uppercase letter
  - At least one special character
- Email validation
- CSRF protection enabled
- SQL injection prevention
- XSS protection

## 🌐 Deployment

### Heroku Deployment

```bash
# Login to Heroku
heroku login

# Create Heroku app
heroku create store-rating-system

# Push to Heroku
git push heroku main

# Run migrations
heroku run rails db:migrate
```

### Manual Deployment

1. Set up production server
2. Configure Nginx/Apache
3. Set up SSL certificate
4. Configure environment variables
5. Deploy using Capistrano

## 📈 Performance Optimization

- Database indexing on frequently queried columns
- Query optimization
- Asset compression and minification
- Caching strategy implementation

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## 👥 Authors

- Your Name - Initial work - [YourGithub](https://github.com/yourusername)

## 🙏 Acknowledgments

- Hat tip to anyone whose code was used
- Inspiration
- etc

## 📞 Support

For support, email your-email@example.com or create an issue in the GitHub repository.
