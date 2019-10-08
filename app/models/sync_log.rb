class SyncLog < ApplicationRecord
  serialize :additional_info, JSON
  
end
