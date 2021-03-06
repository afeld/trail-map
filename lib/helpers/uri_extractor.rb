class URIExtractor
  def initialize(file_name)
    @file_name = file_name
    @json = parse_json
  end

  def each(&block)
    uris.each(&block)
  end

  private

  def extract_uris(source)
    if source.is_a?(Hash)
      extract_uris_from_hash(source)
    elsif source.is_a?(Array)
      extract_uris_from_array(source)
    else
      []
    end
  end

  def extract_uris_from_hash(hash)
    hash.inject([]) do |uris, (key, value)|
      if key == 'uri'
        uris + [value]
      else
        uris + extract_uris(value)
      end
    end
  end

  def extract_uris_from_array(array)
    array.map { |o| extract_uris(o) }.flatten
  end

  def parse_json
    JSON.parse(File.read(@file_name))
  end

  def uris
    @uris ||= extract_uris(@json)
  end
end
