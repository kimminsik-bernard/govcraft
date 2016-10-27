class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likable, polymorphic: true, counter_cache: true

  validates :user, uniqueness: { scope: :likable }
end
