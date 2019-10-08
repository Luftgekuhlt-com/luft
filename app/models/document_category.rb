class DocumentCategory < ApplicationRecord
   belongs_to :document, touch: true
   belongs_to :category
end
