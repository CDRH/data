require_relative "xml_to_es.rb"
require_relative "webs_to_es/fields.rb"
require_relative "webs_to_es/request.rb"
require_relative "webs_to_es/xpaths.rb"

##########################################################
# NOTE:  DO NOT EDIT WEBS_TO_ES FILES IN TO_ES DIRECTORY #
##########################################################

#   (unless you are a CDRH dev and then you may do so very cautiously)
#   this file provides defaults for ALL of the collections included
#   in the API and changing it could alter dozens of sites unexpectedly!
# PLEASE RUN LOADS OF TESTS AFTER A CHANGE BEFORE PUSHING TO PRODUCTION

# HOW DO I CHANGE XPATHS?
#   You may add or modify xpaths in each collection's webs_to_es.rb file
#   located in the collections/<collection>/scripts directory

# HOW DO I CHANGE FIELD CONTENT?
#   You may need to alter an xpath, but otherwise you may also
#   copy paste the field defined in webs_to_es/fields.rb and change
#   it as needed. If you are dealing with something particularly complex
#   you may need to consult with a CDRH dev for help

# HOW DO I CUSTOMIZE THE FIELDS BEING SENT TO ELASTICSEARCH?
#   You will need to look in the webs_to_es/request.rb file, which has
#   collections of fields being sent to elasticsearch
#   you can override individual chunks of fields in your collection

class WebsToEs < XmlToEs
  # Override XmlToEs methods that need to be customized for WEBS here
  # rather than in one of the files in webs_to_es/
end
