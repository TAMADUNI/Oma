class Line < ApplicationRecord
  belongs_to :site
  has_and_belongs_to_many :tasks
end
