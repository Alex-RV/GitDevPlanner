class User < ApplicationRecord
    has_many :repositories
    has_many :tasks
    has_many :collaborators
    has_many :owners
    validates :nickname, presence: true, uniqueness: true
    validates :uid, presence: true, uniqueness: true
    validates :github_access_token, presence: true, uniqueness: true
  end