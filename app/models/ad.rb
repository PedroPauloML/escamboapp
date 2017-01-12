class Ad < ApplicationRecord
  # Callback
  before_save :md_to_html

  # Associations
  belongs_to :member
  belongs_to :category, counter_cache: true
  has_many :comments

  # Validates
  validates :title, :description_md, :category, :finish_date, :picture, presence: true
  validates :price, numericality: { greater_than: 0 }
  # Scope
  scope :descending_order, ->(page) {
          order(created_at: :desc).page(page).per(6)
        }

  scope :search, ->(search, page) {
          where("lower(title) LIKE ?", "%#{search.downcase}%").page(page).per(6)
        }

  scope :to_the, ->(member) { where(member: member) }
  scope :by_category, ->(id) { where(category_id: id) }

  # gem papeclip
  has_attached_file :picture, styles: { big: "800x300#", medium: "320x150#",
                                        thumb: "100x100>" },
                                        default_url: "/images/:style/missing.png"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/

  # gem money_rails
  monetize :price_cents

  private

    def md_to_html
      options = {
        filter_html: true,
        link_attributes: {
          rel: "nofollow",
          target: "_blank"
        }
      }

      extensions = {
        space_after_headers: true,
        autolink: true
      }

      renderer = Redcarpet::Render::HTML.new(options)
      markdown = Redcarpet::Markdown.new(renderer, extensions)

      self.description = markdown.render(self.description_md)
    end
end
