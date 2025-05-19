class Tweet < ApplicationRecord
  belongs_to :user
  
  scope :recent, -> { order(created_at: :desc) }
  scope :before_cursor, ->(cursor) { cursor.present? ? where('created_at < ?', cursor) : all }
  
  def self.paginate(cursor: nil, user_id: nil, limit: 10)
    if user_id.present?
      User.tweets_for(user_id, cursor: cursor, limit: limit)
    else
      recent.before_cursor(cursor).limit(limit)
    end
  end
end
