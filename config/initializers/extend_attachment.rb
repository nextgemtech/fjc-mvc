# frozen_string_literal: true

module ActiveStorageAttachmentExtension
  extend ActiveSupport::Concern

  # re-run the application to make this extension take effect
  included do
    acts_as_list scope: %i[record_id record_type name]

    # Scopes
    scope :sort_by_position, -> { order(position: :asc) }
  end
end

Rails.configuration.to_prepare do
  ActiveSupport.on_load(:active_storage_attachment) { include ActiveStorageAttachmentExtension }
end
