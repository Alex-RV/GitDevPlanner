class User < ApplicationRecord
    validates :nickname, presence: true, uniqueness: true
    validates :uid, presence: true, uniqueness: true
  end