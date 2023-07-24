class Collaborator < ApplicationRecord
    has_many :notes, as: :noteable
  end
  