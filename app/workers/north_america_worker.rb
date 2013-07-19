# encoding: utf-8
require 'net/http'

class NorthAmericaWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(state)
    html = Net::HTTP.get URI("#{ApplicationHelper::NORTH_AMERICAN}#{state.gsub(/\s/, "%20")}")
    BuildHelper::build_north_american_species(html, state) unless html.blank?
    BuildHelper::say "Resource at #{ApplicationHelper::NORTH_AMERICAN}#{state.gsub(/\s/, "%20")} returned null" if html.blank?
  end
end
