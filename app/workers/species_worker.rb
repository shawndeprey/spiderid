# encoding: utf-8
require 'net/http'

class SpeciesWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(genera)
    html = Net::HTTP.get URI("#{ApplicationHelper::SPECIES}?genus=#{genera}")
    BuildHelper::build_species_scientific_names(genera, html) unless html.blank?
    BuildHelper::say "Resource at #{ApplicationHelper::SPECIES}?genus=#{genera} returned null" if html.blank?
  end
end
