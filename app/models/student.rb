class Student < ApplicationRecord
  belongs_to :user
  has_many :subjects, through: :enrollments
  has_many :enrollments
end
