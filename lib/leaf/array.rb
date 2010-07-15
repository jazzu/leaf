require 'leaf/collection'

class Array
  # Paginates a static array (extracting a subset of it). The result is a
  # Leaf::Collection instance, which is an array with a few more
  # properties about its paginated state.
  #
  # Parameters:
  # * <tt>:page</tt> - current page, defaults to 1
  # * <tt>:per_page</tt> - limit of items per page, defaults to 30
  # * <tt>:total_entries</tt> - total number of items in the array, defaults to
  #   <tt>array.length</tt> (obviously)
  #
  # Example:
  #   arr = ['a', 'b', 'c', 'd', 'e']
  #   paged = arr.paginate(:per_page => 2)      #->  ['a', 'b']
  #   paged.total_entries                       #->  5
  #   arr.paginate(:page => 2, :per_page => 2)  #->  ['c', 'd']
  #   arr.paginate(:page => 3, :per_page => 2)  #->  ['e']
  #
  # This method was originally {suggested by Desi
  # McAdam}[http://www.desimcadam.com/archives/8]
  def paginate(options = {})
    raise ArgumentError, "parameter hash expected (got #{options.inspect})" unless Hash === options
      Leaf::Collection.create options[:page] || 1,
                              options[:per_page] || 30,
                              options[:total_entries] || self.length,
                              options[:reverse_content] || false do |pager|
      pager.replace self[pager.offset, pager.per_page].to_a
      pager.reverse! if pager.reverse_content
    end
  end
end
