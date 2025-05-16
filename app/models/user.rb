class User < ApplicationRecord
  belongs_to :company

  scope :by_company, -> (identifier) { where(company: identifier) if identifier.present? }
  scope :by_username, -> (username) { where('username LIKE ?', username) if username.present? }
end
