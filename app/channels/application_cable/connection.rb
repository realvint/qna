# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    attr_reader :warden

    def connect
      self.current_user = env["warden"].user || reject_unauthorized_connection
      @warden = env["warden"] if current_user
    end
  end
end
