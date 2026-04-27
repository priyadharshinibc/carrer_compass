CREATE DATABASE IF NOT EXISTS carrer_guide;
USE carrer_guide;

CREATE TABLE IF NOT EXISTS users (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  email VARCHAR(191) NOT NULL,
  full_name VARCHAR(120) NOT NULL,
  phone_number VARCHAR(30) NULL,
  profile_photo_url TEXT NULL,
  bio TEXT NULL,
  date_of_birth DATE NULL,
  location VARCHAR(120) NULL,
  skills JSON NULL,
  interests JSON NULL,
  hobbies JSON NULL,
  education_history JSON NULL,
  career_goals JSON NULL,
  preferred_job_title VARCHAR(120) NULL,
  employment_type VARCHAR(50) NULL,
  preferred_industries JSON NULL,
  languages JSON NULL,
  is_profile_complete BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY users_email_unique (email)
);
