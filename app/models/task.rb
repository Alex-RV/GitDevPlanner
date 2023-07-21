class Task < ApplicationRecord
  belongs_to :repository
  belongs_to :user

  validates :title, presence: true

  before_validation :combine_scheduled_datetime

  def combine_scheduled_datetime
    return unless scheduled_date.present? && scheduled_time.present?

    self.scheduled_at = DateTime.new(
      scheduled_date.to_i,
      scheduled_date.to_date.day,
      scheduled_time.to_time.hour,
      scheduled_time.to_time.min
    )
  end

  # Virtual attributes for handling date and time separately
  attr_accessor :scheduled_date, :scheduled_time
end
