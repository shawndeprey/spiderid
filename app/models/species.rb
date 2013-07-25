class Species < ActiveRecord::Base
	include Tire::Model::Search
  include Tire::Model::Callbacks
  nilify_blanks
  after_touch() { tire.update_index }
=begin
  settings :analysis => {
             :filter => {
               :substring_filter  => {
                 "type"     => "edgeNGram",
                 "side"     => "front",
                 "max_gram" => 20,
                 "min_gram" => 1 }
             },
             :analyzer => {
               # This is the analyzer that get's run on the search query.
               # For example, if we were to search for "FaCEbOok", this
               # analyzer will automatically lowercase it before performing
               # the actual lookup.
               :typeahead_search => {
                  "tokenizer" => "standard",
                  "filter"    => ["lowercase"]
                },
               # This analyzer automatically lowercases items as they
               # are added to the index, as well as filters them
               # through the "substring_filter", which is a custom
               # filter that tokenizes the items with the type "edgengram".
               # edgeNgram is a tokenizer designed for type-ahead queries.
               # http://www.elasticsearch.org/guide/reference/index-modules/analysis/edgengram-tokenizer/
               :typeahead_index => {
                  "tokenizer"    => "standard",
                  "filter"       => ["substring_filter", "lowercase"],
                  "type"         => "custom" }
             }
           } do
    mapping {
      indexes :id,                  :index => :no
      indexes :permalink,           :index => :no
      indexes :characteristics,     :type => 'string', :boost => 4.0, :search_analyzer => "typeahead_search", :index_analyzer => "typeahead_index"
      indexes :description,         :type => 'string', :boost => 4.0, :search_analyzer => "typeahead_search", :index_analyzer => "typeahead_index"
      indexes :common_name,         :type => 'string', :boost => 2.0, :search_analyzer => "typeahead_search", :index_analyzer => "typeahead_index"
      indexes :scientific_name,     :type => 'string', :analyzer => "simple"
      indexes :genera_name,         :type => 'string', :analyzer => "simple"
      indexes :family_name,         :type => 'string', :analyzer => "simple"
      indexes :other_names,         :type => 'string', :analyzer => "simple"
      indexes :overview,            :type => 'string', :analyzer => "simple"
      indexes :locations_found,     :type => 'string', :analyzer => "simple"
      indexes :additional_info,     :index => :no
      indexes :adult_size,          :index => :no
      indexes :author,              :index => :no
    }
  end
=end
  mapping do
    indexes :id,                  :index => :no
    indexes :permalink,           :index => :no
    indexes :characteristics,     :type => 'string', :boost => 4.0, :analyzer => "standard"
    indexes :description,         :type => 'string', :boost => 4.0, :analyzer => "standard"
    indexes :common_name,         :type => 'string', :boost => 2.0, :analyzer => "standard"
    indexes :scientific_name,     :type => 'string', :analyzer => "simple"
    indexes :genera_name,         :type => 'string', :analyzer => "simple"
    indexes :family_name,         :type => 'string', :analyzer => "simple"
    indexes :other_names,         :type => 'string', :analyzer => "simple"
    indexes :overview,            :type => 'string', :analyzer => "simple"
    indexes :locations_found,     :type => 'string', :analyzer => "simple"
    indexes :additional_info,     :index => :no
    indexes :adult_size,          :index => :no
    indexes :author,              :index => :no
  end


  # The improper singular of species was used here to avoid confusing rails
  # attr_accessible :family_id, :genera_id,
  # :scientific_name, :common_name, :permalink, :description, :characteristics, :other_names, :overview, :locations_found, :adult_size
  # :dangerous_bite, :image_url, :bite_effects, :author, :additional_info

  belongs_to :family
  belongs_to :genera

  before_save :denormalize

  def denormalize
    self.permalink = self.common_name.downcase.parameterize unless self.common_name.blank?
  end

  def to_indexed_json
    SpeciesSearchSerializer.new(self).to_json(:root => false)
  end

  def full_scientific_name
  	return "#{self.genera.name} #{self.scientific_name}"
  end

  def genera_name
  	self.genera.blank? ? nil : self.genera.name
  end

  def family_name
  	self.family.blank? ? nil : self.family.name
  end

  def self.search(term, page)
    return [] if term.blank?
    tire.search page: page, per_page: 20 do
      query do
        match [:characteristics, :description, :common_name, :scientific_name, :genera_name, :family_name,
          :other_names, :overview, :locations_found], term
      end
    end
  end

end