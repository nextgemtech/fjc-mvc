# frozen_string_literal: true

if Rails.env.development?
  User.create(name: 'Admin', phone_no: '+639079247641', password: 'password', admin: true)
  User.create(name: 'John Doe', phone_no: '+639012345678', password: 'password')
end
