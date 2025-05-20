class User < ApplicationRecord
  belongs_to :company
  has_many :tweets

  scope :by_company, -> (identifier) { where(company: identifier) if identifier.present? }
  scope :by_username, -> (username) { where('username LIKE ?', "%#{username}%") if username.present? }

  def self.tweets_for(user_id, cursor: nil, limit: 10)
    user = find_by(id: user_id)
    return Tweet.none unless user
    
    query = user.tweets.order(created_at: :desc)
    query = query.where('created_at < ?', cursor) if cursor.present?
    query.limit(limit)
  end

  after_create :send_welcome_email

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end
end
