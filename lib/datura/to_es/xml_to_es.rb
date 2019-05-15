require "nokogiri"
require_relative "../helpers.rb"
require_relative "../common_xml.rb"
require_relative "xml_to_es_request.rb"

#########################################
# NOTE:  DO NOT EDIT THIS FILE!!!!!!!!! #
#########################################
#   (unless you are a CDRH dev and then you may do so very cautiously)
#   this file provides defaults for ALL of the collections included
#   in the API and changing it could alter dozens of sites unexpectedly!
# PLEASE RUN LOADS OF TESTS AFTER A CHANGE BEFORE PUSHING TO PRODUCTION

# WHAT IS THIS FILE?
#   This file sets up default behavior for working with xpaths
#   for multiple XML file types being transformed to ES
#   For example, TEI and VRA

# Refer to the specific [type]_to_es.rb files for more information
# about altering their behavior, customizing xpaths, etc

class XmlToEs

  attr_reader :json, :xml
  # variables
  # id, xml, parent_xml, options

  # parent_xml is used for parsing things like personographies
  # where a single XML file may represent multiple documents
  # and passing only the child elements through will not be
  # sufficient to populate all of the data from the file in ES
  def initialize(xml, options={}, parent_xml=nil, filename=nil)
    @xml = xml
    @options = options
    @parent_xml = parent_xml
    @filename = filename
    @id = get_id
    @xpaths = xpaths_list

    create_json
  end

  # getter for @json response object
  def create_json
    @json = {}
    # if anything needs to be done before processing
    # do it here (ex: reading in annotations into memory)
    preprocessing
    assemble_json
    postprocessing
  end

  def get_id
    return @filename
  end

  def override_xpaths
    {}
  end

  ###########
  # HELPERS #
  ###########

  # see CommonXml module for methods replicated from common.xsl

  # get the value of one of the xpaths listed at the top
  # Note: if the xpath returns multiple values they will be squished together
  # TODO should we make it so that this can optionally look for more than one
  # result?

  # get_list
  #   can pass it a string xpath or array of xpaths
  # returns an array with the html value in xpath
  def get_list(xpaths, keep_tags=false, xml=nil)
    xpath_array = xpaths.class == Array ? xpaths : [xpaths]
    return get_xpaths(xpath_array, keep_tags, xml)
  end

  # get_text
  #   can pass it a string xpath or array of xpaths
  #   can optionally set a delimiter, otherwise ;
  # returns a STRING
  # if you want a multivalued result, please refer to get_list
  def get_text(xpaths, keep_tags=false, xml=nil, delimiter=";")
    # ensure all xpaths are an array before beginning
    xpath_array = xpaths.class == Array ? xpaths : [xpaths]
    list = get_xpaths(xpath_array, keep_tags, xml)
    sorted = list.sort
    return sorted.join("#{delimiter} ")
  end

  # Note: Recommend that collection team do NOT use this method directly
  #   please use get_list or get_text instead
  # keep_tags true will convert tags like <hi> to <em>
  #   use this wisely, as it causes performance issues
  # keep_tags false removes ALL tags from selected xpath
  def get_xpaths(xpaths, keep_tags=false, xml=nil)
    doc = xml || @xml
    list = []
    xpaths.each do |xpath|
      contents = doc.xpath(xpath)
      contents.each do |content|
        text = ""
        if keep_tags
          converted = CommonXml.convert_tags(content)
          text = converted.inner_html
        else
          # note: not using content.text because
          # some tags should be converted to (), [], etc for display
          text = CommonXml.to_display_text(content)
        end
        # remove whitespace of all kinds from the text
        text = CommonXml.normalize_space(text)
        if text.length > 0
          list << text
        end
      end
    end
    return list.uniq
  end

  def preprocessing
    # copy this in your (type)_to_es collection file to customize
  end

  def postprocessing
    # copy this in your (type)_to_es collection file to customize
  end
end
