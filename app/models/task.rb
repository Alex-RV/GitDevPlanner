class Task < ApplicationRecord
  belongs_to :user
  belongs_to :repository
  # validates :title, presence: true
end
