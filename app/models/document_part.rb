class DocumentPart < ApplicationRecord
  include StoreNestedAttributes
  include StoreWithType

  has_many :images, class_name: "DocumentPartImage", dependent: :delete_all
  belongs_to :document_section, touch: true
  belongs_to :document, touch: true

  store :additional_data, accessors: [:mobile_content, :section_pane, :keywords], coder: JSON
  validates_presence_of :type
  before_create :set_creator
  before_create :set_order


  def partial_name(admin=false)
    return "admin/document_parts/#{self.class.name.split("::").last.underscore}" if admin
    return "/documents/#{self.class.name.split("::").last.underscore}"
  end

  def part_type
    self.class.name.split("::").last.underscore
  end

  def friendly_type
    self.class.name.split("::").last.underscore.humanize.titleize
  end

  def search_text
    [title, content, images.map(&:search_text)].flatten.select{|x| !x.nil? && !x.gsub("\n", "").blank?}.join("\n")
  end

  def full_width?
      document_section.layout == 'full'
  end

  def half_width?
      document_section.layout == 'halves'
  end

  def third_width?
      document_section.layout == 'thirds' || (document_section.layout == 'right-pane' && pane == 'right') || (document_section.layout == 'left-pane' && pane == 'left')
  end

  def two_third_width?
      (document_section.layout == 'right-pane' && pane == 'main') || (document_section.layout == 'left-pane' && pane == 'main')
  end

  private

  def set_creator
    self.created_by = current_user.try(:id) rescue nil unless created_by.present?
  end

  def set_order
    self.display_order = [document_section.parts.maximum(:display_order) || 0, document_section.parts.count].max + 1 unless display_order.present? || document_section.blank?
  end
end
