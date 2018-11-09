# frozen_string_literal: true

# represents an experimental condition
class Condition < ApplicationRecord
  attr_writer :label_type

  validates :name, :uuid, presence: true
  validates :name, uniqueness: { scope: :experiment_id }

  belongs_to :experiment
  belongs_to :label, optional: true

  has_many :tag_csv_files
  has_many :product_tags
  has_many :tags, through: :product_tags
  has_many :subtags, through: :product_tags

  accepts_nested_attributes_for :label, :tag_csv_files

  # TODO: update if needed
  def url
    "http://www.howesgrocery.com?condId=#{uuid}"
  end

  def label_type
    return @label_type if @label_type
    return 'none' if label.nil?
    label.built_in? ? 'provided' : 'custom'
  end

  def current_tag_csv_file
    tag_csv_files.active.order(created_at: :desc).first
  end

  def historical_tag_csv_files
    tag_csv_files
      .where(active: false)
      .order(created_at: :desc)
  end
end
