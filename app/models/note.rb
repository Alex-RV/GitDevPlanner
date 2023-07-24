class Note < ApplicationRecord
  belongs_to :user
  belongs_to :collaborator
  belongs_to :owner
  belongs_to :noteable, polymorphic: true
end
