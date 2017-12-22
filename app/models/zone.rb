class Zone < ApplicationRecord
  has_many :records, dependent: :destroy
  validates :zone, presence: true
end
