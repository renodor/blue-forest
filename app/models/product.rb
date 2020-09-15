class Product < ApplicationRecord
  scope :ordered, -> { order order: :asc }
  scope :published, -> { where published: true }

  has_many :product_variations, dependent: :destroy
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :product_photos, dependent: :destroy
  has_many :product_favorites, dependent: :destroy

  validates :name, presence: true
  validates :published, inclusion: { in: [true, false] }

  before_save :convert_long_description_to_html, if: :will_save_change_to_long_description?
  before_save :define_main_color

  private

  # convert long_description (pseudo) markdown to html
  def convert_long_description_to_html
    return unless long_description

    # convert bold text
    long_description.gsub!(/\*\*(.+)\*\*/, '<strong>\1</strong>')

    # convert unordered lists
    long_description.gsub!(/(\*.+(\r|\n|\r\n))+/) do |list|
      items = "<ul>\n"
      list.gsub(/\*.+/) do |li|
        items << "<li>#{li.sub(/^\*/, '').strip}</li>\n"
      end
      items << "</ul>\n"
    end

    # convert break lines
    long_description.gsub!(/\r\n/, '<br>')
  end

  def define_main_color
    main_photo = product_photos.find_by(main: true)
    self.main_color = main_photo.color if main_photo
  end
end
