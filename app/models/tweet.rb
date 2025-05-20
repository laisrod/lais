class Tweet < ApplicationRecord
  belongs_to :user, optional: true

  def self.paginate(cursor: nil, user_id: nil, limit: 10)
    scope = all
    
    # Filtrar por user_id se fornecido
    scope = scope.where(user_id: user_id) if user_id.present?
    
    # Implementar paginação baseada em cursor
    scope = scope.where("id < ?", cursor) if cursor.present?
    
    # Ordenar e limitar
    scope.order(id: :desc).limit(limit)
  end
end