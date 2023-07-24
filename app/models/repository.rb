class Repository < ApplicationRecord
    has_many :tasks
    has_many :notes, as: :noteable
    has_many :collaborators
end
