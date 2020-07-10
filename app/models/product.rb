class Product < ApplicationRecord
  has_many :product_variations, dependent: :destroy
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :product_photos, dependent: :destroy

  validates :name, presence: true
  validates :published, inclusion: { in: [true, false] }

  before_save :convert_long_description_to_html, if: :will_save_change_to_long_description?

  private

  # convert long_description (pseudo) markdown to html
  def convert_long_description_to_html
    if self.long_description
      # convert bold text
      self.long_description.gsub!(/\*\*(.+)\*\*/, '<strong>\1</strong>')

      # convert unordered lists
      self.long_description.gsub!(/(\*.+(\r|\n|\r\n))+/) do |list|
        items = "<ul>\n"
        list.gsub(/\*.+/) do |li|
          items << "<li>#{li.sub(/^\*/, '').strip}</li>\n"
        end
        items << "</ul>\n"
      end

      # convert break lines
      self.long_description.gsub!(/\r\n/, '<br>')
    end
  end
end
