class DocumentSection < ApplicationRecord
  include StoreNestedAttributes
  include StoreWithType
  
  belongs_to :document, touch: true
  
  store :additional_data, accessors: [:mobile_content], coder: JSON
  has_many :parts, class_name: "DocumentPart", dependent: :delete_all
  
  before_create :set_creator
  before_create :set_order
  
  def search_text
    [parts.map(&:search_text)].flatten.select{|x| !x.nil? && !x.gsub("\n", "").blank?}.join("\n")
  end
  
  def panes
    @panes ||= begin
      cols = {main: []}
      cols[:right] = [] if %w[halves right-pane thirds].include?(layout)
      cols[:left] = [] if %w[left-pane thirds].include?(layout)
      parts.order(:display_order).each do |part|
        if part.section_pane.to_s == "right" && cols.key?(:right)
          cols[:right] << part
        elsif part.section_pane.to_s == "left" && cols.key?(:left)
          cols[:left] << part
        else
          cols[:main] << part
        end
      end
      cols
    end
  end
  
  private
  
  def set_creator
    self.created_by = current_user.try(:id) rescue nil unless created_by.present?
  end
  
  def set_order
    self.display_order = [document.sections.maximum(:display_order) || 0, document.sections.count].max unless display_order.present?
  end
end