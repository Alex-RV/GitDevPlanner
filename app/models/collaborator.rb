class Collaborator < ApplicationRecord
    belongs_to :repository
    has_many :notes, as: :noteable
  end
  