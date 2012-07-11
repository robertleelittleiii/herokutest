#class RemoteLinkRenderer < WillPaginate::LinkRenderer
#  def page_link_or_span(page, span_class = 'current', text = nil)
#    text ||= page.to_s
#    if page and page != current_page
#      @template.link_to_remote text, :url => url_for(page), :method => :get
#    else
#      @template.content_tag :span, text, :class => span_class
#    end
#  end
#end
#class RemoteLinkRenderer < WillPaginate::LinkRenderer
#
#  def link(text, target, attributes = {})
#    attributres["data-remote"]=true
#    super
#    
#    
#    
#  end
#end


#class RemoteLinkRenderer < WillPaginate::ViewHelpers::LinkRenderer
#  def prepare(collection, options, template)
#    @remote = options.delete(:remote) || { }
#    super
#  end
#  def link(text, target, attributes = {})
#    page_attr = { :page => target }
#    @template.link_to( text.to_s.html_safe, @remote.merge(page_attr), :remote => true )
#  end
#end