class Repository < ApplicationRecord
    has_many :tasks
    has_many :notes, as: :noteable
end
