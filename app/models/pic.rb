class Pic < ApplicationRecord
  attr_accessor :file

  validates :title, presence: true
  validates :title, length: { maximum: 30 }
  validates :file, presence: { message: I18n.t('errors.messages.select') }
  validate :valid_file_fmt

  private

  def valid_file_fmt
    if file.present? && !file.original_filename.downcase.match(/(\.jpg|\.jpeg|\.png|\.gif)\z/)
      errors.add(:file, I18n.t('errors.messages.file_fmt'))
    end
  end
end
