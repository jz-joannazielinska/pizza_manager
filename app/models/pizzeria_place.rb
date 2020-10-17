# frozen_string_literal: true

class PizzeriaPlace < ApplicationRecord
  validates :name,  presence: true
  validates :opens_at, :closes_at, presence: true
  validates_uniqueness_of :name
  validate :opening_before_closing

  private

  def opening_before_closing
    return if opens_at.blank? || closes_at.blank?

    if opens_at >= closes_at
      errors.add(:opens_at, 'Invalid opening hour')
    end
  end
end
