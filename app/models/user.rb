class User < ApplicationRecord
    has_many :repositories
    validates :nickname, presence: true, uniqueness: true
    validates :uid, presence: true, uniqueness: true
    validates :github_access_token, presence: true, uniqueness: true
  end