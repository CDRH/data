require 'fileutils'
require 'net/http'
require 'yaml'

module Common

  def self.convert_tags text
    text = text.gsub(/<hi rend=['"]italic['"]>/, "<em>")
    text = text.gsub(/<\/hi>/, "</em>")
    # TODO what other things will probably show up?
    # lists, blockquotes, underlines, etc?
    return text
  end

  # pass in a date and identify whether it should be before or after
  # in order to fill in dates (ex: 2014 => 2014-12-31)

  def self.date_display date, nd_text="N.D."
    date_hyphen = Common.date_standardize(date)
    if date_hyphen
      y, m, d = date_hyphen.split("-").map { |s| s.to_i }
      date_obj = Date.new(y, m, d)
      return date_obj.strftime("%B %-d, %Y")
    else
      return nd_text
    end
  end

  def self.date_standardize date, before=true
    return_date = nil
    if date
      y, m, d = date.split(/-|\//)
      if y && y.length == 4
        # use -1 to indicate that this will be the last possible
        m_default = before ? "01" : "-1"
        d_default = before ? "01" : "-1"
        m = m_default if !m
        d = d_default if !d
        # TODO clean this up because man it sucks
        if Date.valid_date?(y.to_i, m.to_i, d.to_i)
          date = Date.new(y.to_i, m.to_i, d.to_i)
          month = date.month.to_s.rjust(2, "0")
          day = date.day.to_s.rjust(2, "0")
          return_date = "#{date.year}-#{month}-#{day}"
        end
      end
    end
    return_date
  end

  def self.normalize_name abnormal
    # put in lower case
    # remove starting a, an, or the
    down = abnormal.downcase
    normal = down.gsub(/^the |^a |^an /, "")
    return normal
  end

  # replaces normalize-space
  def self.squeeze string
    string.strip.gsub(/\s+/, " ")
  end
end

# get_directory_files
#   Note: do not end with /
#   params: directory (string)
#   returns: returns array of all files found ([] if none),
#     returns nil if no directory by that name exists
def get_directory_files(directory, verbose_flag=false)
  exists = File.directory?(directory)
  if exists
    files = Dir["#{directory}/*"]  # grab all the files inside that directory
    return files
  else
    puts "Unable to find a directory at #{directory}" if verbose_flag
    return nil
  end
end
# end get_directory_files

# get_input
#    gets user input from terminal and won't take
#    no for an answer
def get_input(original_input, msg)
  if original_input.nil?
    puts "#{msg}: \n"
    new_input = STDIN.gets.chomp
    if !new_input.nil? && new_input.length > 0
      return new_input
    else
      # keep bugging the user until they answer or despair
      puts "Please enter a valid response"
      get_input(nil, msg)
    end
  else
    return original_input
  end
end

# get_url
#   sends a request to a given url
def get_url(url)
  url = URI.parse(URI.escape(url))
  res = Net::HTTP.get_response(url)
  return res
end

# regex_files
#   looks through a directory's files for those matching the regex
#   params: files (array of file names), regex (regular expression)
#   returns: array ([] if none matched or if regex is nil)
def regex_files(files, regex=nil)
  array = files.nil? ? [] : files
  if !files.nil? && !regex.nil?
    exp = Regexp.new(regex)
    array = files.select do |file|
      file_name = File.basename(file, ".*")
      match = exp.match(file_name)
      !match.nil?  # return this line
    end
  end
  return array
end

# should_update?
#   determines if a user has changed a file since specified date
#   params: file (string path), since_date (Time format or nil)
#   returns: boolean
def should_update?(file, since_date=nil)
  if since_date.nil?
    # if there is no specified date, then update everything
    return true
  else
    # if a file has been updated since a time specified by user
    file_date = File.mtime(file)
    return file_date > since_date
  end
end
