class Repository < ApplicationRecord
    has_many :tasks
    has_many :notes, as: :noteable
    has_many :collaborators
    # belongs_to :owner, class_name: 'Owner', foreign_key: 'owner_login', primary_key: 'login'
  end
  