# encoding: utf-8
require 'net/http'

class EuropeWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(data_id)
    html = Net::HTTP.get URI("#{ApplicationHelper::ARANEAE_DATA}/#{data_id}")
    BuildHelper::build_european_species(html) unless html.blank?
    BuildHelper::say "Resource at #{ApplicationHelper::ARANEAE_DATA}/#{data_id} returned null" if html.blank?
  end
end
