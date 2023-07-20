class Owner < ApplicationRecord
    has_many :repositories, class_name: 'Repository', foreign_key: 'owner_login', primary_key: 'login'
    has_many :notes, as: :noteable
  end
  