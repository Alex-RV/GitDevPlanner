class Collaborator < ApplicationRecord
    belongs_to :user
    has_many :notes, as: :notable
end
