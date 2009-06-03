FuturePublishing::PageExt = Proc.new do
  
  class TagError < StandardError; end
  
  def published?
    status == Status[:published] && published_at <= Time.current
  end
  
  private
  
  def children_find_options(tag)
    attr = tag.attr.symbolize_keys

    options = {}

    [:limit, :offset].each do |symbol|
      if number = attr[symbol]
        if number =~ /^\d{1,4}$/
          options[symbol] = number.to_i
        else
          raise TagError.new("`#{symbol}' attribute of `each' tag must be a positive number between 1 and 4 digits")
        end
      end
    end

    by = (attr[:by] || 'published_at').strip
    order = (attr[:order] || 'asc').strip
    order_string = ''
    if self.attributes.keys.include?(by)
      order_string << by
    else
      raise TagError.new("`by' attribute of `each' tag must be set to a valid field name")
    end
    if order =~ /^(asc|desc)$/i
      order_string << " #{$1.upcase}"
    else
      raise TagError.new(%{`order' attribute of `each' tag must be set to either "asc" or "desc"})
    end
    options[:order] = order_string

    status = (attr[:status] || ( dev?(tag.globals.page.request) ? 'all' : 'published')).downcase
    unless status == 'all'
      stat = Status[status]
      unless stat.nil?
        options[:conditions] = ["(virtual = ?) and (status_id = ?) and (published_at <= ?)", false, stat.id, Time.current]
      else
        raise TagError.new(%{`status' attribute of `each' tag must be set to a valid status})
      end
    else
      options[:conditions] = ["(virtual = ?) and (published_at <= ?)", false, Time.current]
    end
    options
  end
  
end