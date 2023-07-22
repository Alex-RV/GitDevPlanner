class Task < ApplicationRecord
  belongs_to :repository
  belongs_to :user
  # validates :title, presence: true
end
