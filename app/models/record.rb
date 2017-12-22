class Record < ApplicationRecord
  belongs_to :zone
  validates :name, presence: true
end
