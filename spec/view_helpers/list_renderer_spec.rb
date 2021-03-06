require 'spec_helper'
require 'rack'
require 'leaf/view_helpers/sinatra'
require 'leaf/view_helpers/list_renderer'
require 'leaf/array'

describe Leaf::ViewHelpers::ListRenderer do
  
  before do
    @documents = (1..9).to_a
    @renderer = Leaf::ViewHelpers::ListRenderer.new
    @template = stub('MockedTemplate', {
      :request => stub('MockedRequest', { :url => '/' }) })
  end
  
  it "should render an unordered list with anchor tags containing spans" do
    prepare({ :page => 3, :per_page => 2 }, 
      :inner_window => 1, :outer_window => 1, 
      :previous_label => 'p', :next_label => 'n')
      
    @renderer.send(:to_html).should == <<-HTML
<div class="pagination">
  <ul>
    <li><a class="previous_page" href="/?page=2" rel="prev"><span>p</span></a></li> 
    <li><a href="/" rel="start"><span>1</span></a></li> 
    <li><a href="/?page=2" rel="prev"><span>2</span></a></li> 
    <li><em>3</em></li> 
    <li><a href="/?page=4" rel="next"><span>4</span></a></li> 
    <li><a href="/?page=5"><span>5</span></a></li> 
    <li><a class="next_page" href="/?page=4" rel="next"><span>n</span></a></li>
  </ul>
</div>
    HTML
  end
  
  protected
    def prepare(collection_options, options = {})      
      options = Leaf::ViewHelpers.pagination_options.merge(options)
      collection = @documents.paginate(collection_options)
      @renderer.prepare(collection, options, @template)
    end
end
